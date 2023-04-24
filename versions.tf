terraform {
  required_version = ">= 1.3.7"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.17.0"
    }
  }
}
