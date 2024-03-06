
# Редактор алертов alertmanager
https://juliusv.com/promslack/

label_replace(<vector>, "<target label>", "<content>", "<source label>", "<regexp>")
Можно использовать несколько раз label_replace(label_replace(...), ...)

topk(<num>, <vector>)

rate vs irate vs delta


rate - среднее значение по всему диапазону, используется с counters
irate - мгновенная разница на основании двух последних отсчетов
idelta - разница между последними двумя значениями вектора, используется с типом gauge
delta - разница между первым и последним значением вектора, используется с типом gauge

# kubernetes
rate(container_cpu_usage_seconds_total{pod="<pod-name>"}[1m])
kube_pod_container_resource_requests_cpu_cores{pod=~"<pod-name>"}
kube_pod_container_resource_limits_cpu_cores{pod="<pod-name>"}
container_cpu_cfs_throttled_seconds_total{pod="<pod-name>"}

container_memory_working_set_bytes{pod="<pod-name>"}
kube_pod_container_resource_requests_memory_bytes{pod="<pod-name>"}
kube_pod_container_resource_limits_memory_bytes{pod="<pod-name>"}

# Структура алерта
{
  "status": "firing",
  "labels": {
    "alertname": "SSL_expires_30",
    "channel": "mail-30-days",
    "instance": "https://github.com",
    "job": "ssl-check",
    "prometheus": "monitoring/mon-kube-prometheus-stack-prometheus",
    "severity": "warning"
  },
  "annotations": {
    "summary": "SSL certificate https://github.com will expire in %!d(float64=203.05304631944333) days"
  },
  "generatorURL": "http://10.200.99.201:30090/graph?g0.expr=%28probe_ssl_earliest_cert_expiry+-+time%28%29%29+%2F+86400+%3C+300&g0.tab=1"
}

## Как отправить
amtool --alertmanager.url=http://<alertmanager-url> \
  alert add alertname=instance-down severity=critical instance="master-0" namespace="monitoring" \
  --annotation=summary="instance master-0 is down!" \
  --annotation=runbook_url="https://prometheus.com" \
  --annotation=namespace="monitoring"

## Пример шаблонов alertmanager`а
.GroupLabels - лейбы, по которым alertmanager группирует алерты
.CommonLabels - общие для гурппы алертов лейбы
Всё, что идет на первом уровне вложенности alertmanager хочет видеть с заглавной буквы .Status/.Alerts
```bash
title: |-
  [{{ .Status | title }}{{- if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{- end -}}] {{ .GroupLabels.alertname }} ({{ .GroupLabels.severity }})
text: '{{ template "slack.default.text" . }}'
title_link: '{{ template "slack.default.titlelink" . }}'
# Цвет должен быть в одну строку иначе может не работать
color: |-
  {{ if eq .Status "firing" }}{{ if eq .GroupLabels.severity "critical"}}danger{{ else if eq .GroupLabels.severity "warning" }}warning{{ else }}normal{{ end }}{{ else }}good{{ end }}
text: |-
  {{- if .CommonAnnotations.summary }}
  {{ .CommonAnnotations.summary }}
  {{- else if .CommonAnnotations.description }}
  {{ .CommonAnnotations.description }}
  {{- else if .CommonLabels.summary }}
  {{ .CommonLabels.summary }}
  {{- else if .CommonLabels.description }}
  {{ .CommonLabels.description }}
  {{- end }}

  {{- range .Alerts }}

  {{- if .Labels.instance }}
  *{{ .Labels.instance }}*:
  {{- end }}

  {{- $labels := .Labels.Remove (stringSlice "alertname" "description" "summary" "instance" "severity") }}
  {{- range $labels.SortedPairs }}
      *{{ .Name }}:* {{ .Value }}
  {{- end }}

  {{- end }}
```

### Цикл по всем алертам:
```bash
{{- range .Alerts }}
  {{ if .Labels.pod }}<b>pod</b>: <code>{{ .Labels.pod }}</code>
  {{- else if .Labels.node -}}<b>server</b>: <code>{{ .Labels.node }}</code>
  {{- else }}<b>server</b>: <code>{{ .Labels.instance }}</code>
  {{- end }}
{{- end }}
```

Дополнительно можно пройтись по всем возникшим алертам `.Alers.Firing` или по разрешенным `.Alerts.Resolved`
