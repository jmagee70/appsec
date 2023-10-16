resource google_sql_database_instance "master_instance" {
  name             = "casdemo-${var.environment}-master"
  database_version = "POSTGRES_11"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "WWW"
        value = "0.0.0.0/0"
      }
    }
    backup_configuration {
      enabled = false
    }
  }
}

resource google_bigquery_dataset "dataset" {
  dataset_id = "casdemo_${var.environment}_dataset"
  access {
    special_group = "allAuthenticatedUsers"
    role          = "READER"
  }
  labels = {
    yor_trace = "03ca38d0-fa92-4398-ae4a-6933ea74691b"
  }
}