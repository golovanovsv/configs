# API
## general
export TOKEN=
export CHAT_ID=

https://api.telegram.org/bot${TOKEN}/getMe
https://api.telegram.org/bot${TOKEN}/getUpdates

## Send message
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"chat_id": "$CHAT_ID", "text": "message", "disable_notification": true}' \
     https://api.telegram.org/bot${TOKEN}/sendMessage
