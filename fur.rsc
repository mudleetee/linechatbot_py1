# apr/21/2020 18:57:31 by RouterOS 6.42.10
# software id = R6TK-DF5Z
#
# model = RouterBOARD 3011UiAS
# serial number = 8EEE0A1D25B9
/ip firewall address-list
add address=203.113.8.18 list=NTP
add address=118.174.8.42 list=NTP
/ip firewall filter
add chain=input comment="Allow Monitor Zone" src-address=203.113.112.16/28
add chain=input comment="Allow SNMP NEX" dst-port=161 protocol=udp \
    src-address=118.174.248.112/28
add chain=input comment="Allow SNMP NEX" dst-port=161 protocol=udp \
    src-address=118.174.244.112/28
add action=accept chain=input comment=NTP dst-port=123 log-prefix=\
    ->toport1723 protocol=udp src-address-list=NTP
add action=drop chain=input comment="Drop Invalid connections" \
    connection-state=invalid
add action=accept chain=input comment="Allow ICMP" protocol=icmp
add chain=input comment="Allow Winbox" dst-port=8291 protocol=tcp
add chain=input comment="Allow Telnet" dst-port=23 protocol=tcp
add action=drop chain=input comment="Drop everything else" disabled=yes
add action=drop chain=input connection-state=invalid disabled=yes
add action=accept chain=input connection-state=established,related
add action=drop chain=input dst-port=53 in-interface=pppoe-out1 protocol=udp
add action=drop chain=input dst-port=53 in-interface=pppoe-out1 protocol=tcp
add action=drop chain=forward connection-state=invalid
add action=accept chain=forward connection-state=established,related
add action=drop chain=input comment="Winbox " in-interface=pppoe-out1 \
    src-address-list="winbox_Black List"
add action=add-src-to-address-list address-list="winbox_Black List" \
    address-list-timeout=2w5m chain=input connection-state=new dst-port=8291 \
    in-interface=pppoe-out1 protocol=tcp src-address-list=winbox_4
add action=add-src-to-address-list address-list=winbox_4 \
    address-list-timeout=5m chain=input connection-state=new dst-port=8291 \
    in-interface=pppoe-out1 protocol=tcp src-address-list=winbox_3
add action=add-src-to-address-list address-list=winbox_3 \
    address-list-timeout=5m chain=input connection-state=new dst-port=8291 \
    in-interface=pppoe-out1 protocol=tcp src-address-list=winbox_2
add action=add-src-to-address-list address-list=winbox_2 \
    address-list-timeout=5m chain=input connection-state=new dst-port=8291 \
    in-interface=pppoe-out1 protocol=tcp src-address-list=winbox_1
add action=add-src-to-address-list address-list=winbox_1 \
    address-list-timeout=5m chain=input connection-state=new dst-port=8291 \
    in-interface=pppoe-out1 protocol=tcp
/ip firewall mangle
add action=mark-routing chain=prerouting comment=PBX new-routing-mark=PBX \
    passthrough=no src-address=192.168.1.20
add action=mark-connection chain=input in-interface=Sfp1-WAN-3471L0021 \
    new-connection-mark="LLi Conn" passthrough=yes
add action=mark-routing chain=output connection-mark="LLi Conn" \
    new-routing-mark="LLi IN" passthrough=no
add action=mark-connection chain=input in-interface=pppoe-out1 \
    new-connection-mark="FTTx Conn" passthrough=yes
add action=mark-routing chain=output connection-mark="FTTx Conn" \
    new-routing-mark="FTTx In" passthrough=no
/ip firewall nat
add action=src-nat chain=srcnat comment="Using for Client to internet" \
    out-interface=Sfp1-WAN-3471L0021 to-addresses=1.179.209.49
add action=src-nat chain=srcnat comment="Using for NTP command" src-address=\
    172.27.9.214 to-addresses=1.179.209.49
add action=masquerade chain=srcnat out-interface=pppoe-out1
add action=dst-nat chain=dstnat comment=PBX dst-port=8089 protocol=tcp \
    src-address-type=!local to-addresses=192.168.1.20 to-ports=8089
add action=dst-nat chain=dstnat dst-address=1.179.209.49 dst-port=5060-5061 \
    protocol=tcp to-addresses=192.168.1.20 to-ports=5060-5061
add action=dst-nat chain=dstnat dst-address=1.179.209.49 dst-port=5060-5061 \
    protocol=udp to-addresses=192.168.1.20 to-ports=5060-5061
add action=dst-nat chain=dstnat dst-address=1.179.209.49 dst-port=10000-20000 \
    protocol=tcp to-addresses=192.168.1.20 to-ports=10000-20000
add action=dst-nat chain=dstnat dst-address=1.179.209.49 dst-port=10000-20000 \
    protocol=udp to-addresses=192.168.1.20 to-ports=10000-20000
/ip firewall service-port
set sip disabled=yes
