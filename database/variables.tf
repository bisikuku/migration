#.....database/variables.tf.......
variable "db_name" {
  default = "mydb"
}

variable "dbuser" {
  default = "adele"
}

variable "dbpass" {
  default = "c0r3d1p0"
}

variable "db_host" {
  default = "localhost"
}

variable "db_port" {
  default = "3306"
}

variable "db_root_password" {
  default = "c0r3d1p0"
}

variable "db_root_user" {
  default = "root"
}

variable "db_root_host" {
  default = "localhost"
}

variable "db_root_port" {
  default = "3306"
}

variable "db_root_socket" {
  default = "/var/run/mysqld/mysqld.sock"
}

variable "db_root_socket_path" {
  default = "/var/run/mysqld/mysqld.sock"
}

variable "db_root_socket_file" {
  default = "/var/run/mysqld/mysqld.sock"
}

variable "db_root_socket_dir" {
  default = "/var/run/mysqld"
}

variable "db_root_socket_dir_path" {
  default = "/var/run/mysqld"
}

variable "db_root_socket_dir_file" {
  default = "/var/run/mysqld/mysqld.sock"
}

variable "db_root_socket_dir_file_path" {
  default = "/var/run/mysqld/mysqld.sock"
}

variable "db_subnet_group_name" {}

variable "vpc_security_group_ids" {}

variable "db_identifier" {}


variable "db_skip_final_snapshot" {}

variable "db_engine_version" {}

variable "db_instance_class" {}

#variable "db_instance_name" {}

variable "db_storage" {}

