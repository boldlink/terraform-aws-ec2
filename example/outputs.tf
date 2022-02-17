output "outputs" {
  sensitive = true
  value = [
    module.ec2_instance_minimum,
    module.ec2_instance_complete,
    module.ec2_instance_windows,
    module.ec2_instance_t3
  ]
}
