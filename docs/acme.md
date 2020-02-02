# acme.sh

export SL_Key="HvnPe5eZ5UX685e7ycbKyg229_78997"

acme.sh --issue \
  --dns dns_selectel \
  -d '*.example.com' \
  -d 'example.com' \
  --cert-file /etc/letsencrypt/live/onefit.ru/cert.pem \
  --key-file /etc/letsencrypt/live/onefit.ru/privkey.pem \
  --fullchain-file /etc/letsencrypt/live/onefit.ru/fullchain.pem

acme.sh --renew-all
