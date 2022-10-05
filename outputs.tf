output "sg-arn" {
  description = "Security Group ARN"
  value       = aws_security_group.ecs_task.arn
}

output "sg-id" {
  description = "Security Group ID"
  value       = aws_security_group.ecs_task.id
}