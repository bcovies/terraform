resource "aws_s3_bucket" "ArtifactBucket" {}

resource "aws_iam_role" "CodeBuildServiceRole" {
  name = "cb-${var.cluster_name}"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [aws_iam_policy.cb-policy_one.arn, aws_iam_policy.cb-policy_two.arn, aws_iam_policy.cb-policy_three.arn, aws_iam_policy.cb-policy_four.arn]
}

resource "aws_iam_policy" "cb-policy_one" {
  name = "cb-policy_one-${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "cloudformation:*", "ecs:*", "ecr:*", "ec2:*", "ssm:GetParameter", "ssm:GetParameters", "secretsmanager:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "cb-policy_two" {
  name = "cb-policy_two-${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ssm:GetParameters", "ssm:GetParameter", "ssm:GetParametersByPath"]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:${var.region}::parameter/*"
      },
    ]
  })
}

resource "aws_iam_policy" "cb-policy_three" {
  name = "cb-policy_three-${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
         Action   = ["s3:*"]
         Effect   = "Allow"
         Resource = "arn:aws:s3:::*"
#        Action   = ["s3:GetObject", "s3:PutObject", "s3:GetObjectVersion"]
#        Effect   = "Allow"
#        Resource = "${aws_s3_bucket.ArtifactBucket.arn}"
      },
    ]
  })
}

resource "aws_iam_policy" "cb-policy_four" {
  name = "cb-policy_four-${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability", "ecr:PutImage", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload"]
        Effect   = "Allow"
        Resource = "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${aws_ecr_repository.repository.name}"
      },
    ]
  })
}




resource "aws_iam_role" "CodePipelineServiceRole" {
  name = "cp-${var.cluster_name}"
  path = "/"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [aws_iam_policy.cp-policy_one.arn, aws_iam_policy.cp-policy_two.arn]
}


resource "aws_iam_policy" "cp-policy_one" {
  name = "cp-policy_one-${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::*"
      },
    ]
  })
}

resource "aws_iam_policy" "cp-policy_two" {
  name = "cp-policy_two-${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["codebuild:*", "cloudformation:*", "iam:PassRole", "codestar-connections:*", "ecr:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_codebuild_project" "CodeBuildProject" {
    name            = "cb-${var.cluster_name}"
    service_role    = aws_iam_role.CodeBuildServiceRole.arn

    artifacts {
      type = "CODEPIPELINE"
      name = "${var.cluster_name}"
    }

    source {
      type      = "CODEPIPELINE"
      buildspec = var.buildspec_path
    }

    vpc_config {
      vpc_id      = data.aws_vpc.vpc.id
      subnets     = var.private_subnets
      security_group_ids = [var.security_group_internal]
    }

    environment {
      compute_type                = "BUILD_GENERAL1_LARGE"
      image                       = "aws/codebuild/docker:17.09.0"
      privileged_mode             = true
      type                        = "LINUX_CONTAINER"

      environment_variable {
        name  = "BRANCH"
        value = var.GitHubBranch
      }
  
      environment_variable {
        name  = "AWS_DEFAULT_REGION"
        value = var.region
      }
  
      environment_variable {
        name  = "REPOSITORY_URI"
        value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.repository.name}"
      }
  
      environment_variable {
        name  = "StackName"
        value = var.StackName
      }
  
      environment_variable {
        name  = "PROPERTIES_NAME"
        value = aws_s3_bucket.ArtifactBucket.id
      }
  
      environment_variable {
        name = "CLUSTER_NAME"
        value = var.cluster_name
      }
  
      environment_variable {
        name = "SITE_NAME"
        value = var.public_alb
      }
    
    }

}