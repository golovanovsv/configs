## Репликация

# Состояние репликации
redis-cli info replication

# переключение из слейва
redis-cli slaveof no one

# настройка репликации

slaveof 78.155.202.229 6379  # Адрес мастера
masterauth <pwd of master>   # Пароль мастера
slave-read-only yes          # Принимать запросы только на чтение
