# variables.tf

variable "service_name" {
  description = "A Docker image-compatible name for the service"
  type        = string
  default     = "sagaportal"
}

variable "environment" {
  description = "Environment for deployment (like dev or staging)"
  default     = "dev"
  type        = string
}


variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}


variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "image_tag" {
  description = "Docker image tag to run in the ECS cluster"
  default     = "latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 1024
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 2048
}


variable "domain_name" {
  description = "Domain name of a private Route 53 zone to create DNS record in"
}


variable "host_name" {
  description = "Optional hostname that will be used to created a sub-domain in Route 53. If left blank then a record will be created for the root domain (ex. example.com)"
}


variable "private_zone" {
  description = "Private Route 53 zone (default=false)"
  default     = false
}


variable "ecs_task_min_count" {
  description = "How many ECS tasks should minimally run in parallel"
  default     = 2
  type        = number
}

variable "ecs_task_max_count" {
  description = "How many ECS tasks should maximally run in parallel"
  default     = 4
  type        = number
}

variable "ecr_force_delete" {
  description = "Forces deletion of Docker images before resource is destroyed"
  default     = true
  type        = bool
}
