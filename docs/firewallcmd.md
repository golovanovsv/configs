firewall-cmd --state
firewall-cmd --get-default-zone        # Зона по-умолчанию
firewall-cmd --set-default-zone=public # Установить зону по-умолчанию
firewall-cmd --get-active-zones  # Покажет зоны для интерфейсов
firewall-cmd --list-all          # Все правила для активных зон
firewall-cmd --list-all-zones    # Все правила для всех зон
firewall-cmd --get-zones         # Список дсотупных зон
firewall-cmd --zone=ssh-limited --add-source=10.20.10.0/24  # Создать зону с перечнем IP

firewall-cmd --zone=home --change-interface=eth0  # Переместить интерфейс между зонами


firewall-cmd --get-services  # перечень шаблонов для сервисов
                             # Все сервисы описаны в файлах в директории /usr/lib/firewalld/service/
                             # Пользовательские /etc/firewalld/services/
firewall-cmd --zone=public --list-services  # Сервисы указанной зоны

firewall-cmd --runtime-to-permanent  # Сохранить правила

firewall-cmd --zone=public --add-port=5000/tcp
firewall-cmd --zone=public --add-port=4990-4999/udp
firewall-cmd --zone=public --add-source=10.20.10.0/24

firewall-cmd --reload  # Перечитать параметры

Пример сервиса
```bash
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>SSH</short>
  <description>Secure Shell (SSH)</description>
  <port protocol="tcp" port="22"/>  # example for port
  <protocol value="esp"/>           # example for protocol
</service>
```

firewall-cmd --zone=public --add-service=http # Разрешить сервис для зоны

firewall-cmd --zone=public --add-service=docker-registry     # 5000/TCP

firewall-cmd --zone=public --add-service=kube-control-plane  # Все сервисы куба
firewall-cmd --zone=public --add-service=kube-api            # Доступ к kubelet
firewall-cmd --zone=public --add-service=https               # Доступ к haproxy

```bash
cat <<EOF | tee /etc/firewalld/services/calico.xml
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>Calico</short>
  <description></description>
  <port protocol="tcp" port="179"/>   # BGP between k8s nodes
  <protocol value="4"/>               # IPIP
  <port protocol="udp" port="4789"/>  # Calico VXLAN
  <port protocol="tcp" port="5473"/>  # Calico Typha agent
  <port protocol="udp" port="51820"/> # WireGuard IPv4 beatween k8s nodes
  <port protocol="udp" port="51821"/> # WireGuard IPv6 beatween k8s nodes
</service>
EOF
```

```bash
cat <<EOF | tee /etc/firewalld/zones/k8s.xml
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <source address="10.10.0.0/16"/>
</zone>
```

firewall-cmd --zone=public --add-service=wireguard
firewall-cmd --zone=public --add-service=bgp

# vxlan
# bgp
