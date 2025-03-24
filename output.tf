output "server" {
  description = "AWS Instance ID : "
  value       = aws_instance.instance.id

}

output "public" {
  description = "public IP : "
  value       = aws_instance.instance.public_ip
}

output "sg-name" {
  description = "Security Group Name : "
  value       = aws_security_group.sg_grp.id
}

/*
output "private-key" {
  description = "Private Key Pair :"
  value = aws_key_pair.key.priva
  sensitive = true
}*/

output "public-key" {
  description = "Public Key Value"
  value       = aws_key_pair.key.public_key
}