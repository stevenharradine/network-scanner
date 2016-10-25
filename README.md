# network-scanner
Scans a network looking for nodes and open ports.  If it finds open ports it will scan them for basic default username and password combinations and alert you.

## Usage
```
./scan $network $start_host_range $end_host_range $start_port_range $end_port_range
```

example
```
./scan 192.168.1 1 255 1 65535
```
