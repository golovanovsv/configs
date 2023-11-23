# show virtualservers
ipvsadm -L -n [-t 1.1.1.1:53] [-u 1.1.1.1:53]

# cereate vs
ipvsadm -A -t 1.1.1.1:53 -s rr

# add routes
ipvsadm -a -t 1.1.1.1:53 -r 172.17.0.2:53 -m
ipvsadm -a -t 1.1.1.1:53 -r 172.17.0.3:53 -m

# delete routes
ipvsadm -d -t 1.1.1.1:53 -r 172.17.0.2:53

# sysctls
https://www.kernel.org/doc/Documentation/networking/ipvs-sysctl.txt

# source
https://elixir.bootlin.com/linux/v4.15/source/net/netfilter/ipvs/ip_vs_core.c
