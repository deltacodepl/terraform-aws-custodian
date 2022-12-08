output "custodian_sqs_queue" {
  value = aws_sqs_queue.custodian-mailer-queue.url
}