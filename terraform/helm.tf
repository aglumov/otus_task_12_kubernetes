resource "helm_release" "nginx_ingress" {
  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace        = "ingress-nginx"
  create_namespace = true

  atomic = true

  depends_on = [
    yandex_kubernetes_node_group.node_group
  ]
}

resource "helm_release" "mysql" {
  name   = "mysql"
  chart  = "../charts/mysql"
  atomic = true

  set_sensitive {
    name  = "db.root.password"
    value = var.db_root_password
  }

  set_sensitive {
    name  = "db.user.username"
    value = var.db_user_username
  }

  set_sensitive {
    name  = "db.user.password"
    value = var.db_user_password
  }

  depends_on = [
    yandex_kubernetes_node_group.node_group
  ]
}

resource "helm_release" "wordpress" {
  name   = "wordpress"
  chart  = "../charts/wordpress"
  atomic = true

  set_sensitive {
    name  = "db.user.username"
    value = var.db_user_username
  }

  set_sensitive {
    name  = "db.user.password"
    value = var.db_user_password
  }

  depends_on = [
    yandex_kubernetes_node_group.node_group,
    helm_release.mysql,
    helm_release.nginx_ingress
  ]
}
