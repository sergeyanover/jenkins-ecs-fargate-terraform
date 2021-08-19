
output "ec2_public_ip" {
  value = aws_instance.ecs_bastion.public_ip
}

output "alb_hostname" {
  value = aws_lb.albdev.dns_name
}