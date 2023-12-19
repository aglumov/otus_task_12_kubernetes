resource "yandex_kubernetes_cluster" "otus_cluster" {
  name        = "otus-cluster"
  description = "otus cluster"
  network_id  = yandex_vpc_network.this.id
  master {
    public_ip = true
    version   = "1.28"
    zonal {
      zone      = yandex_vpc_subnet.yc_subnet[0].zone
      subnet_id = yandex_vpc_subnet.yc_subnet[0].id
    }
  }
  service_account_id      = yandex_iam_service_account.k8s-otus-sa.id
  node_service_account_id = yandex_iam_service_account.k8s-otus-sa.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.editor,
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ../charts/kube-config"
  }

  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials ${self.name} --external --force --kubeconfig ../charts/kube-config"
  }
}

resource "yandex_iam_service_account" "k8s-otus-sa" {
  name        = "k8s-otus-sa"
  description = "Service account for cluster Otus"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-otus-sa.id}"
}

resource "yandex_kubernetes_node_group" "node_group" {
  count      = 3
  cluster_id = yandex_kubernetes_cluster.otus_cluster.id
  name       = "group-${count.index}"
  version    = "1.28"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = false
      subnet_ids = [yandex_vpc_subnet.yc_subnet[count.index].id]
    }

    resources {
      memory        = 2
      cores         = 2
      core_fraction = 50
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = var.yc_zones[count.index]
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
