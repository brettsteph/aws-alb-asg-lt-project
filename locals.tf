locals {
  env = terraform.workspace
  vpc_id_env = {
    default    = "vpc-092910cd6be87fee9"
    staging    = "vpc-092910cd6be87fee9"
    production = "vpc-092910cd6be87fee9"
  }
  vpc_id = lookup(local.vpc_id_env, local.env)

  availability_zones_env = {
    default    = ["us-east-1a", "us-east-1b"]
    staging    = ["us-east-1a", "us-east-1b"]
    production = ["us-east-1a", "us-east-1b"]
  }
  availability_zones = lookup(local.availability_zones_env, local.env)

  public_subnet_id_1_env = {
    default    = "subnet-05b5a0bf482cdcf33"
    staging    = "subnet-05b5a0bf482cdcf33"
    production = "subnet-05b5a0bf482cdcf33"
  }
  public_subnet_id_1 = lookup(local.public_subnet_id_1_env, local.env)

  public_subnet_id_2_env = {
    default    = "subnet-0bda27ca4d6ed508f"
    staging    = "subnet-0bda27ca4d6ed508f"
    production = "subnet-0bda27ca4d6ed508f"
  }
  public_subnet_id_2 = lookup(local.public_subnet_id_2_env, local.env)

  private_subnet_id_1_env = {
    default    = "subnet-04b25912d2a6208dc"
    staging    = "subnet-04b25912d2a6208dc"
    production = "subnet-04b25912d2a6208dc"
  }
  private_subnet_id_1 = lookup(local.private_subnet_id_1_env, local.env)

  private_subnet_id_2_env = {
    default    = "subnet-0babf247a90a80ddd"
    staging    = "subnet-0babf247a90a80ddd"
    production = "subnet-0babf247a90a80ddd"
  }
  private_subnet_id_2 = lookup(local.private_subnet_id_2_env, local.env)

  env_suffix_env = {
    default    = "default"
    staging    = "staging"
    production = "production"
  }

  env_suffix = lookup(local.env_suffix_env, local.env)
}

