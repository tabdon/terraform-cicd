module "app" {
  source = "./modules/application"

  project        = var.project
  cidr_block     = var.cidr
  private_subnet = var.private_subnet
  public_subnet  = var.public_subnet
}
