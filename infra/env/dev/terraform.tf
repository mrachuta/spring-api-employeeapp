terraform {
  required_version = ">= 1.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.80.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~>4"
    }
  }

  backend "gcs" {
    bucket  = "terraform-dev-ea-state"
    prefix  = "terraform/state"
  }
}

# No credentials key; use GOOGLE_APPLICATION_CREDENTIALS env variable to config auth
# No project set; use GOOGLE_PROJECT env variable to config project
