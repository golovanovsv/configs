# Работа со стейтом

terraform state rm 'aws_instance.jumphost'
terraform state mv aws_ebs_volume.mongo-hidden aws_ebs_volume.mongo-hidden-test
terraform import aws_instance.jumphost i-01a1227613a8f1c1a
terraform import aws_ebs_volume.shared-mongo-hidden-0 vol-064cc7e5c497bf269
terraform import aws_volume_attachment.shared-mongo-hidden-0 /dev/xvde:vol-064cc7e5c497bf269:i-01215e2a1c756c6fb
terraform import aws_route53_record.shared-mongo-hidden-old Z631F8O6ASJBS_hidden-mongo.domain.com_A
