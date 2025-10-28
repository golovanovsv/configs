# MikroTik

## Install to VPS

```bash
# https://github.com/elseif/MikroTikPatch/releases
echo u > /proc/sysrq-trigger  # Переводим ФС в read-only
dd if=chr-7.20.2.img of=/dev/vda bs=4M oflag=sync
echo 1 > /proc/sys/kernel/sysrq
echo b > /proc/sysrq-trigger
```

## Certificate: LE

/ip service enable www;
/certificate enable-ssl-certificate dns-name=<domain-name>,<domain-name#2>;
/ip service disable www;

## SSTP-server

/ip/address/add address=10.128.0.1/24 interface=lo
/ip/pool/add name=sstp ranges=10.128.0.2-10.128.0.10
/ppp/profile/add name=sstp local-address=10.128.0.1 remote-address=sstp dns-server=8.8.8.8,8.8.4.4
/ip/dns/set servers=8.8.8.8
/interface/sstp-server/server/set authentication=mschap1,mschap2 enabled=yes tls-version=only-1.2 certificate=<certificate-name>
/ppp/secret/add name=<client-login> password=<client-password> remote-address=10.128.0.2 service=sstp

## VETH

/interface/veth/add name=veth0 address=10.10.4.4/24 gateway=10.10.4.1  # Адрес интерфейса и шлюз для него
/ip/address/add address=10.10.4.1/24 interface=container-bridge        # IP шлюза можно добавить прям на интерфейс

/interface/bridge/add name=veth-bridge                                 # Или создать для этого мост
/ip/address/add address=10.10.4.1/24 interface=veth-bridge             # И добавить IP на мост
/interface/bridge/port/add bridge=veth-bridge interface=veth0

## Users

/user set admin password=<mew-password>
