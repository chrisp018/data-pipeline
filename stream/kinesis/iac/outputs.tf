# --- root/outputs.tf ---

# output "iam_role_out" {
#   value = module.security.iam_role_out
# }

# output "instances" {
#   value = {for i in module.compute.instance : i.tags.Name =>  "${i.public_ip}"}
#   sensitive = true
# }