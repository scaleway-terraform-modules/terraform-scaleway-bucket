terraform {
  required_version = ">= 1.4.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.77.0"
    }
  }
}
