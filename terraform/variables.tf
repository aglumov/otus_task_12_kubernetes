variable "yc_token" {
  type      = string
  sensitive = true
}

variable "yc_cloud_id" {
  type = string
}

variable "yc_folder_id" {
  type = string
}

variable "yc_zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "yc_subnets" {
  type    = list(list(string))
  default = [["192.168.0.0/24"], ["192.168.1.0/24"], ["192.168.2.0/24"]]
}

variable "db_root_password" {
  type      = string
  sensitive = true
}

variable "db_user_username" {
  type      = string
  sensitive = true
}

variable "db_user_password" {
  type      = string
  sensitive = true
}
