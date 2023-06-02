###############################################################################
# IAM - Shared Roles and Policies for Launch Configuration, Task and Service
###############################################################################

resource "aws_iam_role" "custodian_role" {
  name = "${terraform.workspace}-${lower(var.app_name)}-role"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs.amazonaws.com",
            "ec2.amazonaws.com",
            "ecs-tasks.amazonaws.com",
            "lambda.amazonaws.com",
            "cloudtrail.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_role_policy" "custodian_policy" {
  name = "${terraform.workspace}-${lower(var.app_name)}-role-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateTags",
          "ec2:DescribeInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeVolumes",
          # "dynamodb:ListTables",
          "dynamodb:*",
          "health:DescribeEvents",
          "health:DescribeEventDetails",
          "health:DescribeAffectedEntities",
          "iam:*",
          # "iam:PassRole",
          # "iam:ListAccountAliases",
          # "iam:ListUsers",
          # "iam:ListRoles",
          # "iam:ListRolePolicies",
          # "iam:UpdateRoleDescription",
          # "iam:GetRole",
          # "iam:TagRole",
          # "iam:ListAttachedRolePolicies",
          # "iam:ListAttachedUserPolicies",
          # "iam:ListPolicies",
          # "iam:ListPolicyVersions",
          # "iam:ListGroupsForUser",
          # "iam:ListAccessKeys",
          # "iam:GetCredentialReport",
          # "iam:GenerateCredentialReport",
          # "iam:GetPolicyVersions",
          # "iam:GetPolicy",
          # "iam:GetRolePolicy",
          # "iam:TagPolicy",
          # "iam:GetUser",
          # "iam:DeleteAccessKey",
          # "iam:DeleteLoginProfile",
          # "iam:TagUser",
          "ses:SendEmail",
          "ses:SendRawEmail",
          "lambda:CreateFunction",
          "lambda:ListTags",
          "lambda:GetFunction",
          "lambda:AddPermission",
          "lambda:ListFunctions",
          "lambda:UpdateFunctionCode",
          "lambda:CreateAlias",
          "lambda:TagResource",
          "events:DescribeRule",
          "events:PutRule",
          "events:ListTargetsByRule",
          "events:PutTargets",
          "events:ListTargetsByRule",
          "tag:*",
          "cloudwatch:CreateLogGroup",
          "cloudwatch:CreateLogStream",
          "autoscaling:DescribeLaunchConfigurations",
          # "s3:*",
          "sqs:SendMessage",
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage",
          "sqs:GetQueueUrl",
          "s3:GetBucketLocation",
          "s3:GetBucketTagging",
          "s3:GetBucketPolicy",
          "s3:GetReplicationConfiguration",
          "s3:GetBucketVersioning",
          "s3:GetBucketNotification ",
          "s3:GetLifeCycleConfiguration",
          "s3:ListAllMyBuckets",
          "s3:GetBucketAcl",
          "s3:GetBucketWebsite",
          "s3:GetBucketLogging",
          "s3:DeleteBucket",
          "s3:PutBucketTagging",
          "s3:PutObject",
          "es:DescribeElasticsearchDomains",
          "es:ListDomainsNames",
          "es:ListTags",
          "es:AddTags",
          "cloudwatch:DescribeAlarmsForMetric",
          "cloudwatch:PutMetricAlarm",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
  role = aws_iam_role.custodian_role.id
}

resource "aws_iam_role" "custodian_ecs_task_role" {
  name = "${terraform.workspace}-${lower(var.app_name)}-ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "custodian_ecs_task_policy" {
  name = "${terraform.workspace}-${lower(var.app_name)}-ecs-task-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"] # TODO: tighten this down
        Resource = ["*"]
      },
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = ["*"] # TODO: parameterize this with a prefix value
      },
      # used for ECS Exec
      {
        "Effect" : "Allow",
        "Action" : [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : "*"
      }
    ]
  })
  role = aws_iam_role.custodian_ecs_task_role.id
}
