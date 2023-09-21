variable "volume_size" {
  description = "The size of the volume in GB"
  default     = 10
  type        = number
}

variable "instance_type" {
  description = "The type of instance to start"
  default     = "t3.micro"
  type        = string
}