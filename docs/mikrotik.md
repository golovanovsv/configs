## Certificate: LE

/ip service enable www;
/certificate enable-ssl-certificate dns-name=<domain-name>,<domain-name#2>;
/ip service disable www;

## VETH

/interface/veth/add name=veth0 address=10.10.4.4/24 gateway=10.10.4.1  # Адрес интерфейса и шлюз для него
/ip/address/add address=10.10.4.1/24 interface=container-bridge        # IP шлюза можно добавить прям на интерфейс

/interface/bridge/add name=veth-bridge                                 # Или создать для этого мост
/ip/address/add address=10.10.4.1/24 interface=veth-bridge             # И добавить IP на мост
/interface/bridge/port/add bridge=veth-bridge interface=veth0
