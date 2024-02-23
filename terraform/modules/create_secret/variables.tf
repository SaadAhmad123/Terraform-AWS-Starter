variable "name" {
  type        = string
  description = "The name of the secret"
}

variable "description" {
  type        = string
  description = "The description of the secret"
  default     = "This is a secret value"
}

variable "value" {
  type        = string
  description = "The value of the secret"
  default     = "none"
}

variable "tags" {
  description = "A map of tags to apply to AWS resources created by the module."
  type        = map(string)
  default     = {}
}
