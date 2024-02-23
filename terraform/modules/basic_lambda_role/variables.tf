variable "role_name" {
  type        = string
  description = "The role name"
}

variable "tags" {
  description = "A map of tags to apply to AWS resources created by the module."
  type        = map(string)
  default     = {}
}

# Add a new variable for additional policy ARNs
variable "additional_policy_arns" {
  description = "A list of additional policy ARNs to attach to the role."
  type        = list(string)
  default     = [] # Default to an empty list if no additional policies are specified
}