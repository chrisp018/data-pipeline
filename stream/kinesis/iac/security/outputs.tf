# --- security/outputs.tf --- 

output "iam_role_out" {
  value = {for i in aws_iam_role.iam_role : i.name =>  i.arn}
}