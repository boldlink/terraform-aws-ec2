output "outputs" {
  sensitive = true
  value = [
    module.ec2_instance_windows
  ]
}
