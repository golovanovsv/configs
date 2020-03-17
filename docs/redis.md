## Репликация

# Состояние репликации
redis-cli info replication

# Переключение из слейва
redis-cli slaveof no one

# Настройка репликации

slaveof 78.155.202.229 6379  # Адрес мастера
masterauth <pwd of master>   # Пароль мастера
slave-read-only yes          # Принимать запросы только на чтение

# Информация по памяти
redis-cli info memory