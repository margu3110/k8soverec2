output "Master_Private_Ip" {
  value = module.master.private_ip
}

output "Master_PublicIp" {
  value = module.master.public_ip
}

output "Worker1_Private_Ip" {
  value = module.worker1.private_ip
}

output "Worker1_PublicIp" {
  value = module.worker1.public_ip
}

output "Worker2_Private_Ip" {
  value = module.worker2.private_ip
}

output "Worker2_PublicIp" {
  value = module.worker2.public_ip
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}


output "master_ssh" {
  value = "ssh -i ~/pem/isildur.pem ubuntu@${module.master.public_ip}"
}
output "worker1_ssh" {
  value = "ssh -i ~/pem/isildur.pem ubuntu@${module.worker1.public_ip}"
}
output "worker2_ssh" {
  value = "ssh -i ~/pem/isildur.pem ubuntu@${module.worker2.public_ip}"
}
