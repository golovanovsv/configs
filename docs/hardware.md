# PXE

[https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml]

Клиент делает широковещательный запрос, в котором передает свои параметры.
Один из параметров - Client System, который может одно из следующих значений:

- 0x0000 - Legacy BIOS
- 0x0007 - UEFI

В ответ сервер может прислать следующие параметры:

- Server-Name (66) - Имя сервера TFTP
- Bootfile-Name (67) - Имя файла загрузки

## PXE: RouterOS

Пример реализации для RouterOS.

```bash
# Создаем нужные для отправки клиенту DHCP-опции
/ip/dhcp-server/option print
0  pxe_bios     67  'undionly.kpxe'                756e64696f6e6c792e6b707865
1  pxe_uefi     67  'ipxe.efi'                     697078652e656669

# Объединяем опции в наборы
/ip/dhcp-server/option/sets print
0  pxe_bios  pxe_bios
1  pxe_uefi  pxe_uefi

# Определяем какие опции каким клиентам отправлять
/ip/dhcp-server/matcher print
0 pxe_bios    93  pxe_bios    pool-ipv4-eth  0x0000  exact
1 pxe_uefi    93  pxe_uefi    pool-ipv4-eth  0x0007  exact
```

## iPXE: RouterOS

```bash
/ip/dhcp-server/option/add name=ipxe code=209 value="'http://172.16.121.6:8088/boot.ipxe'"
/ip/dhcp-server/option/add name=pxe_ipxe code=67 value="'http://172.16.121.6:8088/boot.ipxe'"
/ip/dhcp-server/option/sets/add name=ipxe options=ipxe,pxe_ipxe
/ip/dhcp-server/matcher add matcher=ipxe option-set=ipxe
```

## entities

1. PXE + iPXE/pxelinux
2. Preseed/RedHat Anaconda
3. linuxkit

## dmidecode
dmidecode -t <type>
1 - System Information
2 - Base Board Information
3 - Chassis Information
4 - Processor Information
7 - Cache Information
8 - Port Connector Information
9 - System Slot Information
10 - On Board Device Information
16 - Physical Memory Array
17 - Memory Device
18 - Memory Error Information
19 - Memory Array Mapped Address
20 - Memory Device Mapped Address
26 - Voltage Probe
27 - Cooling Device
28 - Temperature Probe
29 - Electrical Current Probe
39 - System Power Supply
41 - Onboard Device
