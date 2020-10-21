# elasticsearch

GET _cat/indices?v - список индексов
GET _cat/shards - список шардов
GET _cat/nodes
GET _cluster/health
GET _cluster/stats
GET _cluster/settings?include_defaults&flat_settings&local&filter_path=defaults.indices*
curl "localhost:9200/_cluster/settings?include_defaults" | jq '.defaults.indices.breaker'
curl "localhost:9200/_cluster/settings?include_defaults" | jq '.persistent'

DELETE /index

# Write
curl -H "Content-Type: application/json" -XPOST "http://localhost:9200/indexname/typename/optionalUniqueId" \
  -d '{ "field" : "value" }'

# Delete
POST /<index>/_delete_by_query {
  "query": {
    "match: {
      "user.id": "reptile"
    }
  }
}

# Templates
PUT _template/default
{
  "template": "*",
  "settings": {
    "number_of_shards": "2",
    "number_of_replicas": "0"
  }
}

# Indexes
GET /<index>/_mapping
GET /<index>/<type>/_search

GET /<index>/<type>_search -d 
{
  "filter": {
    "range": {
      "published_at": { "gte": "2020-01-01" }
    }
  }
}
{
  "_source": ["title", "tags"],
  "filter": {
    "term": { tags: "word1" }
  }
}
{
  "query": {
    "match": { "content": "word2" }
  }
}

## Число реплик
PUT /<index>/_settings
{
    "index" : {
        "number_of_replicas" : 1
    }
}

## Read-only
PUT weblogs-2018.09.10/_settings
{
  "index": {
    "blocks": {
      "read_only_allow_delete": "false"
    }
  }
}

# Index Lifecycle management
GET _ilm/policy/<index>

PUT _ilm/policy/prod_retention
{
  "policy" : {
    "phases" : {
      "delete" : {
        "min_age" : "90d",
        "actions" : {
          "delete" : { }
        }
      }
    }
  }
}

PUT _template/log_prod_template
{
  "index_patterns": ["log-prod-*"],                 
  "settings": {
    "index.lifecycle.name": "prod_retention",        
  }
}

# ReIndex
POST _reindex
{
  "source": {
    "index": "logstash-2019.10.24",
    "query": {
      "match": {
        "kubernetes.namespace_name": "production"
      }
    }
  },
  "dest": {
    "index": "log-prod-2019.10.24"
  }
}

POST _reindex
{
  "source": {
    "index": "logstash-2019.10.24"
    "query": {
      "bool": { 
        "must_not": {
          "match": {
            "kubernetes.namespace_name": "production"
           }
        }
      }
    }
  },
  "dest": {
    "index": "logstash-2019.10.24-ri"
  }
}

# Snapshots
bin/elasticsearch-plugin install repository-s3
bin/elasticsearch-keystore add s3.client.default.access_key
bin/elasticsearch-keystore add s3.client.default.secret_key

elasticsearch.yml:
Repositories.url.allowed_urls:
- "https://example.com/*"

PUT /_snapshot/es_s3_repository
{
  "type": "s3",
  "settings": {
    "bucket": "es-snapshot",
    "region": "us-east-1",
    "endpoint": "https://example.com"
  }
}

# curator
[config.yml](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/configfile.html)
[action.yml](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/examples.html)

curator --config config.yml [--dry-run] action.yml

# curator_cli
curator_cli --host 192.168.10.101 show_indices \
  --filter_list '[{"filtertype":"age","source":"creation_date","direction":"older","unit":"days","unit_count":28},{"filtertype":"pattern","kind":"prefix","value":"logstash"}]'

# Mass operations
curl --silent localhost:9200/_cat/indices?v | grep yellow | awk '{ print "curl -XPUT 192.168.10.101:9200/"$3"/_settings -d\"{\"index\":{\"number_of_replicas\": \"0\"}}\"" }' > change_replicas.sh

sed -i change_replicas.sh -e 's/-d"/-d\x27/'
sed -i change_replicas.sh -e 's/}}"/}}\x27/'

bash change_replicas.sh
