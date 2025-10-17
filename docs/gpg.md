## Операции с ключами
gpg -k            # Список публичных ключей
gpg -K            # Список приватных ключей
gpg --fingerprint # Получить отпечаток ключа

gpg --delete-key # удалить ключ

gpg --full-generate-key [--expert]  # Сгенерировать пару ключей

```bash
# https://www.gnupg.org/documentation/manuals/gnupg/Unattended-GPG-key-generation.html
gpg --batch --full-generate-key <<EOF
%no-protection      # Не защищать ключ паролем
Key-Type: EDDSA     # Алгоритм ключа
Key-Curve: ed25519  # Кривая алгоритма (только для EDDSA)
Subkey-Type: ECDH      # Алгоритм подключа
Subkey-Curve: cv25519  # Кривая алгоритма подключа (только для EDDSA)
Expire-Date: 0         # Дата устаревания ключа
Name-Comment: gitlab             # Комментарий к ключу
Name-Real: UserName              # Название ключа
Name-Email: username@google.com  # Электронная почта владельца (требуется для СКВ)
EOF
```

Типы ключей:
- pub - публичный ключ
- sub - публичный подключ
- sec - секретный ключ
- ssb - секретный подключ

Назначение ключей:
- S - подпись (signing)
- С - подпись ключа
- E - шифрование
- A - Авторизация

gpg [--armor/a] --export [-o file]            # экспортировать публичный ключ
gpg [--armor/a] --export-secret-key [-o file] # экспортировать секретный ключ
gpg --import                                # импортировать публичный ключ из файла

## Подпись
gpg --sign      # подписать сообщение, подпись хранится отдельно
gpg --clearsign # подписать сообщение, подпись храниться внутри сообщения

gpg --verify    # проверить подпись

## Шифрование

gpg --encrypt/e [--symmetric/c] --recipient/r <user-id> <file> # зашифровать файл для пользователя user-id

[--symmetric] - при расшифровке можно использовать или приватный ключ или пароль
[--hidden-recipient/R] - шифровать имя адресата

## Дешифрование

gpg [--list-only] --decrypt/d [-o <output-file>] <input-file>
[--list-only] - посмотреть получателей

# envs

GNUPGHOME - путь к папке с ключами
