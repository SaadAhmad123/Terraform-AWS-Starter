locals {
  project     = var.PROJECT_NAME
  stage       = var.stage
  region      = var.AWS_REGION
  version     = 1
  name_prefix = "${local.project}-${local.stage}-${local.version}"
  tags = {
    project        = local.project
    version        = local.version
    infrastructure = "core"
    stage          = local.stage
  }
  # private_subnets = {
  #   "${local.project}-private-1" = {
  #     "az"   = "${local.region}a"
  #     "cidr" = "10.0.6.0/24"
  #   },
  # }
  # public_subnets = {
  #   "${local.project}-public-1" = {
  #     "az"   = "${local.region}a"
  #     "cidr" = "10.0.106.0/24"
  #   },
  # }
}
