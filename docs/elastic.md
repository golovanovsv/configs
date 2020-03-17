# elasticsearch

GET _cat/indices?v - список индексов
GET _cluster/health

DELETE /index

PUT /<index>/_settings
{
    "index" : {
        "number_of_replicas" : 1
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
