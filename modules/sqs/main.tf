resource "aws_sqs_queue" "custodian-mailer-queue" {
  name                      = "custodian-mailer-queue"
  delay_seconds             = 60
  max_message_size          = 40960
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
#   redrive_policy = jsonencode({
#     deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
#     maxReceiveCount     = 4
#   })

}