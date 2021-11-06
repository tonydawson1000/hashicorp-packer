variable "docker_image_ubuntu_xenial" {
  type    = string
  default = "ubuntu:xenial"
}
variable "docker_image_ubuntu_bionic" {
  type    = string
  default = "ubuntu:bionic"
}
variable "docker_image_ubuntu_focal" {
  type    = string
  default = "ubuntu:focal"
}
variable "docker_image_ubuntu_jammy" {
  type    = string
  default = "ubuntu:jammy"
}

variable "env_var_value" {
  type    = string
  default = "Hello Packer from Docker!"
}
variable "file_name" {
  type    = string
  default = "myfile.txt"
}

packer {
  required_plugins {
    docker = {
      version = " >= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu-xenial" {
  image  = var.docker_image_ubuntu_xenial
  commit = true
}
source "docker" "ubuntu-bionic" {
  image  = var.docker_image_ubuntu_bionic
  commit = true
}
source "docker" "ubuntu-focal" {
  image  = var.docker_image_ubuntu_focal
  commit = true
}
source "docker" "ubuntu-jammy" {
  image  = var.docker_image_ubuntu_jammy
  commit = true
}

build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu-xenial",
    "source.docker.ubuntu-bionic",
    "source.docker.ubuntu-focal",
    "source.docker.ubuntu-jammy"
  ]

  provisioner "shell" {
    # Set ENV var
    environment_vars = [
      "FOO=${var.env_var_value}",
    ]
    # Use ENV var
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > ${var.file_name}",
    ]
  }

  # Run a simple echo provisioner on 'ONLY' the selected build
  provisioner "shell" {
    only   = ["docker.ubuntu-xenial"]
    inline = ["echo Running ${var.docker_image_ubuntu_xenial} Docker image."]
  }
  provisioner "shell" {
    only   = ["docker.ubuntu-bionic"]
    inline = ["echo Running ${var.docker_image_ubuntu_bionic} Docker image."]
  }
  provisioner "shell" {
    only   = ["docker.ubuntu-focal"]
    inline = ["echo Running ${var.docker_image_ubuntu_focal} Docker image."]
  }
  provisioner "shell" {
    only   = ["docker.ubuntu-jammy"]
    inline = ["echo Running ${var.docker_image_ubuntu_jammy} Docker image."]
  }

  # Tag the Docker Images
  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["ubuntu-xenial", "packer-rocks"]
    only       = ["docker.ubuntu-xenial"]
  }
  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["ubuntu-bionic", "packer-rocks"]
    only       = ["docker.ubuntu-bionic"]
  }
  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["ubuntu-focal", "packer-rocks"]
    only       = ["docker.ubuntu-focal"]
  }
  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["ubuntu-jammy", "packer-rocks"]
    only       = ["docker.ubuntu-jammy"]
  }
}