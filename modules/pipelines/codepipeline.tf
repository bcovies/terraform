resource "aws_iam_policy" "cf-policy_one" {
  name = "cf-policy_one-${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ecs:*", "ecr:*", "iam:*", "ec2:*", "logs:*", "route53:*", "codebuild:*", "codepipeline:*", "elasticloadbalancing:*", "application-autoscaling:*", "secretsmanager:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "CloudFormationExecutionRole" {
  name = "cf-${var.cluster_name}"
  path = "/"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudformation.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [aws_iam_policy.cf-policy_one.arn]
}


resource "aws_codepipeline" "codepipeline" {
  name     = "cp-${var.cluster_name}"
  role_arn = aws_iam_role.CodePipelineServiceRole.arn

  artifact_store {
    location = aws_s3_bucket.ArtifactBucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "App"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["App"]
      run_order        = "1"

      configuration = {
        OAuthToken   = var.app_gitHub_token
        Owner        = var.app_gitHub_owner
        Repo         = var.app_gitHub_repo
        Branch       = var.app_gitHub_branch
      }
    }

    action {
      name             = "Infra"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["Infra"]
      run_order        = "1"

      configuration = {
        OAuthToken           = var.infra_gitHub_token
        Owner                = var.infra_gitHub_owner
        Repo                 = var.infra_gitHub_repo
        Branch               = var.infra_gitHub_branch
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["App", "Infra"]
      output_artifacts = ["BuildOutput"]
      version          = "1"
      run_order        = "1"
      configuration = {
        ProjectName   = "cb-${var.cluster_name}"
        PrimarySource = "Infra"
      }
    }
  }

  stage {
    name = "DeployApp"

    action {
      name            = "DeployApp"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["Infra", "BuildOutput"]
      version         = "1"
      run_order       = "1"

      configuration = {
        ChangeSetName  = "Deploy"
        ActionMode     = "CHANGE_SET_REPLACE"
        Capabilities   = "CAPABILITY_NAMED_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName      = "${var.cluster_name}-backend-service-stack"
        TemplatePath   = "Infra::modules/backend/service.yml"
        RoleArn        = aws_iam_role.CloudFormationExecutionRole.arn
        ParameterOverrides = jsonencode({
          "ClusterName"                 = "${var.cluster_name}",
          "CertificateArn"              = "${var.CertificateArn}",
          "LoadBalancerCname"           = "${var.LoadBalancerCname}",
          "ProjectName"                 = "${var.cluster_name}",
          "StageEnv"                    = "${var.tag_environment}",
          "AlbHealthCheckPath"          = "${var.AlbHealthCheckPath}",
          "ECSRoleArn"                  = "${var.ecsrole}",
          "ListenerArn"                 = "${var.ListenerArn}",
          "InternalAccessSecurityGroup" = "${var.InternalAccessSecurityGroup}",
          "PrivateNameSpace"            = "${var.name_space}",
          "ClusterID"                   = "${var.cluster_id}",
          "SiteTgPriority"              = "${var.tg_priority}",
          "vpc"                         = "${var.vpc_id}",
          "TaskCpu"                     = "${var.TaskCpu}"
          "ContainerCpu"                = "${var.ContainerCpu}",
          "ContainerPort"               = "${var.ContainerPort}",
          "ContainerMemoryReservation"  = "${var.ContainerMemoryReservation}",
          "DockerImageVersion"          = { "Fn::GetParam" : [ "BuildOutput", "build.json", "tag" ] }
#         "EcsTasksNumber"              = "1",
        })
      }
    }

    action {
      name             = "ExecuteChangeSet"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CloudFormation"
      input_artifacts = ["BuildOutput", "Infra"]
      version          = "1"
      run_order        = "2"
      configuration = {
        ChangeSetName = "Deploy"
        ActionMode    = "CHANGE_SET_EXECUTE"
        StackName     = "${var.cluster_name}-backend-service-stack"
        RoleArn       = aws_iam_role.CloudFormationExecutionRole.arn
      }
    }
  }
}