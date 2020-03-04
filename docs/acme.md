# acme.sh

## DNS challenge
export SL_Key="HvnPe5eZ5UX685e7ycbKyg229_78997"
acme.sh --issue \
  --dns dns_selectel \
  -d '*.example.com' \
  -d 'example.com' \
  --cert-file /etc/letsencrypt/live/example.com/cert.pem \
  --key-file /etc/letsencrypt/live/example.com/privkey.pem \
  --fullchain-file /etc/letsencrypt/live/example.com/fullchain.pem

## HTTP challenge
acme.sh --issue \
  -d example.com \
  -w /var/www/letsencrypt \
  --cert-file /etc/letsencrypt/live/example.com/cert.pem \
  --key-file /etc/letsencrypt/live/example.com/privkey.pem \
  --fullchain-file /etc/letsencrypt/live/example.com/fullchain.pem

## renewal
acme.sh --renew-all
