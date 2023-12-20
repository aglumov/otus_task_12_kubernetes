# Задание

Развернуть кластер Kubernetes и настроить автоматический деплой веб-портала.

# Подготовка к запуску

В системе должен быть установлены утилиты:
* terraform, тестировалось на версии terraform v1.6.6;
* yc, тестировалось на версии Yandex Cloud CLI 0.102.0.

# Настройка и запуск

* склонировать репозиторий;
* настроить подключение к облаку яндекс. В каталоге ```terraform``` создать файл ```yc.auto.tfvars``` с содержимым (подставить свой токен, id облака и каталога):

```
yc_token     = токен
yc_cloud_id  = id облака
yc_folder_id = id каталога
```

* задать переменные для настройки базы данных. В каталоге ```terraform``` создать файл ```db.auto.tfvars``` с содержимым:

```
db_root_password = пароль пользователя root
db_user_username = имя пользователя для подключения к бд wordpress
db_user_password = пароль пользователя
```

* инициализировать терраформ: ```terraform init```;
* запустить создание инфраструктуры: ```terraform apply```;
* дождаться развертывания инфраструктуры;
* перейти в каталог ```charts``` и выполнить команду ```kubectl --kubeconfig kube-config get ingress``` ;
* дождаться получение ip-адреса и перейти по нему. Должен открыться сайт Wordpress.

# Пояснения

Процесс развертывания окружения при помощи terraform и демонстрация работоспособности записаны на видео. Видео доступно по ссылке: https://disk.yandex.ru/i/xwLgA03YJn0euA

В качестве кластера Kubernetes используется Managed Service for Kubernetes в облаке Яндекс.
В каталоге ```charts``` находятся helm-чарты для деплоя приложения в кластер.