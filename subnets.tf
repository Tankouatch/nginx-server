resource "null_resource" "subnet_identification" {
  triggers = {
    vpc_id     = "your-vpc-id"
    subnet_ids = jsonencode(["subnet-id-1", "subnet-id-2", "subnet-id-3", "subnet-id-4"])
  }

  provisioner "local-exec" {
    command = "chmod +x identification_script.sh && ./identification_script.sh ${self.triggers.vpc_id} ${self.triggers.subnet_ids}"
  }
}