terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    restapi = {
      source  = "fmontezuma/restapi"
      version = "1.14.1"
    }
  }
}

variable "prisma_path" {
    type = string
    default = "/api/v1/defenders/fargate.json?consoleaddr=northamerica-northeast1.cloud.twistlock.com/canada-550157779&defenderType=appEmbedded"
}

provider "restapi" {
  # Configuration options
  uri                  = "http://127.0.0.1:4545"
  debug                = true
  write_returns_object = true
}

provider "aws" {
  region = "us-east-1"
}

variable "name" {
  type    = string
  default = "second"
}


# define 2 container definitions, the second definition is pull from a rest api call to the mock server
locals {
  defs = [
    {
      name      = "first"
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    # add additional container from the module
    jsondecode(restapi_object.service-second.api_response)
  ]
}

# create the task definition with the 2 containers
resource "aws_ecs_task_definition" "service-testing" {
  family                = "service-testing"
  container_definitions = jsonencode(local.defs)
}

resource "restapi_object" "service-second" {
  path        = var.prisma_path
  read_path   = var.prisma_path
  read_method = "POST"
  destroy_path = var.prisma_path
  destroy_method = "POST"
  data        = "{ \"containerDefinitions\": \"some task\" }"
  object_id   = "service-second"
  debug       = true
}

output "tasdef1" {
  value = restapi_object.service-second.api_response
}