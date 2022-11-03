# Dry
## Чтобы не копировать везде одинаковый backend.tf
ln -s ../lib/backend.tf backend.tf

# Start
terraform init \
  -backend-config="bucket=${S3BUCKET_NAME} \
  -backend-config="region=${S3BUCKET_REGION} \
  -backend-config="key=${BACKEND_CONFIG} \
  -get=true \
  -get-plugins=true \
  -force-copy

# autoformatting
terraform fmt [file-name]
terraform validate

# Работа со стейтом
terraform state rm 'aws_instance.jumphost'
terraform state mv aws_ebs_volume.mongo-hidden aws_ebs_volume.mongo-hidden-test
terraform import aws_instance.jumphost i-01a1227613a8f1c1a
terraform import aws_ebs_volume.shared-mongo-hidden-0 vol-064cc7e5c497bf269
terraform import aws_volume_attachment.shared-mongo-hidden-0 /dev/xvde:vol-064cc7e5c497bf269:i-01215e2a1c756c6fb
terraform import aws_route53_record.shared-mongo-hidden-old Z631F8O6ASJBS_hidden-mongo.domain.com_A

terraform plan --refresh=false # Не ходить в облако за подтверждением стейта. Просто верить скаченному стейту

# DataSources
data "aws_ami" "ubuntu" {
  owners = ["099720109477"] # Canonical
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Force replacement
# Пересоздать ресурс при следующем apply
terraform taint oci_core_instance.x0
terraform untaint oci_core_instance.x0

# modules
module "example" {
  source = "../lib/example
  settings = module.settings.values
}

module "settings" {
  ami = 
  subnet_id = 
  region = 
  ...
}