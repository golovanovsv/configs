# acme.sh

## DNS challenge with selectel
export SL_Key="HvnPe5eZ5UX685e7ycbKyg229_78997"
acme.sh --issue \
  --dns dns_selectel \
  -d '*.example.com' \
  -d 'example.com' \
  --cert-file /etc/letsencrypt/live/example.com/cert.pem \
  --key-file /etc/letsencrypt/live/example.com/privkey.pem \
  --fullchain-file /etc/letsencrypt/live/example.com/fullchain.pem

## DNS challenge with letsencrypt
acme.sh --issue \
  --dns dns_cf \
  -d '*.example.com' \
  -d 'example.com' \
  --server letsencrypt

## HTTP challenge
acme.sh --issue \
  -d example.com \
  -w /var/www/letsencrypt \
  --cert-file /etc/letsencrypt/live/example.com/cert.pem \
  --key-file /etc/letsencrypt/live/example.com/privkey.pem \
  --fullchain-file /etc/letsencrypt/live/example.com/fullchain.pem

## DNS Manual
acme.sh --issue \
  --dns -yes-I-know-dns-manual-mode-enough-go-ahead-please \
  -d '*.example.com' \
  -d 'example.com' \
  --cert-file /etc/letsencrypt/live/example.com/cert.pem \
  --key-file /etc/letsencrypt/live/example.com/privkey.pem \
  --fullchain-file /etc/letsencrypt/live/example.com/fullchain.pem

Добавить нужный TXT.

acme.sh --issue --renew \
  --dns -yes-I-know-dns-manual-mode-enough-go-ahead-please \
  -d '*.example.com' \
  -d 'example.com' \
  --cert-file /etc/letsencrypt/live/example.com/cert.pem \
  --key-file /etc/letsencrypt/live/example.com/privkey.pem \
  --fullchain-file /etc/letsencrypt/live/example.com/fullchain.pem

## renewal
acme.sh --renew-all
