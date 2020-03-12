# elasticsearch

GET _cat/indices?v - список индексов
GET _cluster/health

DELETE /index

# curator
[config.yml](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/configfile.html)
[action.yml](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/examples.html)

curator --config config.yml [--dry-run] action.yml

# curator_cli
curator_cli --host 192.168.10.101 show_indices \
  --filter_list '[{"filtertype":"age","source":"creation_date","direction":"older","unit":"days","unit_count":28},{"filtertype":"pattern","kind":"prefix","value":"logstash"}]'
