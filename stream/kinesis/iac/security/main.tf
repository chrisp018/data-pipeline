# --- security/main.tf ---

resource "aws_iam_role" "iam_role" {
  for_each = var.iam_role
  name     = each.value.name

  assume_role_policy  = each.value.assume_role_policy
  managed_policy_arns = [for i in each.value.policy_name : aws_iam_policy.iam_policy[i].arn]
  tags = {
    tag-key = each.value.name
  }
}

resource "aws_iam_policy" "iam_policy" {
  for_each = var.iam_policy
  name     = each.value.name
  policy   = each.value.policy
}
