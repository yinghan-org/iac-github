module "public_repository" {
  source = "mineiros-io/repository/github"
  version = "0.1.0"
  name = "iac-github"
  private = false
  description = "An example on how to manage a GitHub organization with Terraform."
  homepage_url = "https://github.com/github-terraform-example/iac-github"
  allow_merge_commit = true
  gitignore_template = "Terraform"
  license_template = "mit"
  auto_init = true

}
