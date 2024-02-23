variable "lambda_arn" {
  description = "The ARN of the Lambda function to use for the WebSocket integration."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The invoke arn of the Lambda function to use for the WebSocket integration."
  type        = string
}

variable "lambda_name" {
  description = "The name of the Lambda function to use for the WebSocket integration."
  type        = string
}

variable "lambda_role_name" {
  description = "The Lambda role name"
  type        = string
}

variable "stage" {
  description = "The stage of the api deployment"
  type        = string
  default     = "nonprod"
}

variable "auto_deploy" {
  description = "Should the api stage auto-deploy"
  type        = bool
  default     = true
}

variable "api_name" {
  description = "The name to use for the WebSocket API Gateway deployment."
  type        = string
}

variable "region" {
  description = "The AWS region in which to create the WebSocket deployment."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to AWS resources created by the module."
  type        = map(string)
  default     = {}
}
