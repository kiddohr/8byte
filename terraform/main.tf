module "vpc_8byte" {
  source = "./modules/vpc"
  cidr_block = var.cidr
  public_subnet_cidr = var.public_cidr
  private_subnet_cidr = var.private_cidr
}

module "ecs_8byte_cluster"{
    source = "./modules/ecs"
    public_subnet_id = module.vpc_8byte.public_subnet_a_id
    image_uri = var.image_uri
    security_group = module.security_groups.ecs_sg
    target_group = module.alb.target_group
}

module "rds_8byte" {
  source = "./modules/rds"
  vpc_id = module.vpc_8byte.vpc_id
  subnet_group = module.vpc_8byte.subnetgroup_for_rds_name
  db_username = var.db_username
  db_password = var.db_password
  db_allocated_storage = var.db_allocated_storage
  db_instance_class = var.db_instance_class
  security_groups = module.security_groups.rds_sg
}

module "security_groups" {
  source = "./modules/sg"
  vpc_id = module.vpc_8byte.vpc_id
}

module "alb"{
  source = "./modules/loadbalancer"
  vpc_id = module.vpc_8byte.vpc_id
  security_group = module.security_groups.alb_sg
  subnet_id = [module.vpc_8byte.public_subnet_a_id, module.vpc_8byte.public_subnet_b_id]
}