output "instanceprofilename" {
  value = { for i, j in aws_iam_instance_profile.AllInstanceProfiles : j.name => j.name }
}