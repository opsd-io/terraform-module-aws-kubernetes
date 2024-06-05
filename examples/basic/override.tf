# Make sure we're using working version (from local directory, not git).

module "kubernetes" {
  source = "./../.."
}
