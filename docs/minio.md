# minio
mc alias set <alias> https://minioserver.example.net ACCESS_KEY SECRET_KEY
mc admin info <alias>

mc ls <alias>
mc put <file> <alias>/<path>
mc rm <alias>/<pasth> [--recursive]
