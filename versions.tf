terraform {
  required_version = ">= 1.3"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.10.0"
    }
  }
}
