### gcloud

gcloud auth list
gcloud projects list
gcloud config set account 'account'
gcloud config set project my-project

gcloud compute instances list

gcloud compute project-info add-metadata \
    --metadata google-compute-default-region=us-central1,google-compute-default-zone=us-central1-f

### cloud_sql_prosy
# project:zone:instance
./cloud_sql_proxy -instances=carix-184611:europe-west3:usdx-dbs -dir /tmp
psql "sslmode=disable host=/tmp/carix-184611:europe-west3:usdx-dbs/ user=usdxuser-prod dbname=postgres"