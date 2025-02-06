variable "bucket_name" {
  description = "Nom du bucket S3 où déployer le site"
  type        = string
}

variable "source_dir" {
  description = "Répertoire contenant les fichiers build à déployer"
  type        = string
  default     = "../frontend/dist"
}