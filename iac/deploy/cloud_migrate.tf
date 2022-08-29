terraform {
  cloud {
    organization = "juansarrias15"

    workspaces {
      name = "example-workspace"
    }
  }
}