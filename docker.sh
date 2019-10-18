# Запуск контейнера
docker run -d \
  --name nginx \
  --hostname nginx0 \
  -v  /etc/nginx:/etc/nginx \
  -p  80:80 \
  -p  443:443 \
  --env "ENV1=/tmp, ENV2=/sys" \
  --memory 1024m \
  --add-host=postgres:192.168.1.24 \
  --log-driver syslog \
  --log-opt syslog-address=udp://.46:514 \
  --log-opt syslog-format=rfc3164 \
  --log-opt tag= \
nginx

# Опцции доступа к хостовым процессам/сетям
docker run -d \
  --name nginx \
  --hostname nhinx0 \
  -v  /etc/nginx:/etc/nginx \
  -p  80:80 \
  -p  443:443 \
  --pid host \
  --network host \
  --log-driver syslog \
  --log-opt syslog-address=udp://.46:514 \
  --log-opt syslog-format=rfc3164 \
  --log-opt tag= \
image

# Быстрый запуск ssl в nginx
docker run --rm \
    --name nginx \
    --hostname example.com \
	-p 80:80 \
	-p 443:443 \
	-v /home/reptile/nginx/ssl.conf:/etc/nginx/conf.d/example.com.conf \
	-v /home/reptile/nginx/x0.itmh.io.pem:/etc/nginx/conf.d/example.com.pem \
	-v /home/reptile/nginx/x0.itmh.io.key:/etc/nginx/conf.d/example.com.key \
nginx