# Windows Server DNS and DHCP Admin Runbook
# Company: Aston Villa FC
# Domain: astonvilla.local
# Domain Controller:
# DC01.astonvilla.local

# DNS Server
# 192.168.10.10

# DHCP Server
# 192.168.10.10

# Gateway
# 192.168.10.1

# DHCP Scope
# 192.168.10.100 - 192.168.10.200

# Example Hosts dc01, filesrv, printer01 mail

# DNS Server Installation

# DNS is responsible for translating hostnames into IP addresses
# Example: dc01.astonvilla.local becomes 192.168.10.10
# Active Directory relies heavily on DNS.

Install-WindowsFeature DNS `
-IncludeManagementTools

Get-WindowsFeature DNS

# DNS Zone Administration: DNS zones contain DNS records for the domain
# Forward Lookup Zones: Hostname -> IP Address
# Reverse Lookup Zones: IP Address -> Hostname

Get-DnsServerZone

# Create Forward Lookup Zone

Add-DnsServerPrimaryZone `
-Name "astonvilla.local" `
-ZoneFile "astonvilla.local.dns"

# Create Reverse Lookup Zone: Used for reverse DNS lookups

Add-DnsServerPrimaryZone `
-NetworkId "192.168.10.0/24" `
-ReplicationScope Domain

# A Records: maps hostnames to IPv4 addresses

Add-DnsServerResourceRecordA `
-Name "dc01" `
-ZoneName "astonvilla.local" `
-IPv4Address "192.168.10.10"

Add-DnsServerResourceRecordA `
-Name "filesrv" `
-ZoneName "astonvilla.local" `
-IPv4Address "192.168.10.20"

Add-DnsServerResourceRecordA `
-Name "printer01" `
-ZoneName "astonvilla.local" `
-IPv4Address "192.168.10.50"

# CNAME Records: create aliases
#
# Example: mail.astonvilla.local can point to dc01.astonvilla.local

Add-DnsServerResourceRecordCName `
-Name "mail" `
-ZoneName "astonvilla.local" `
-HostNameAlias "dc01.astonvilla.local"

# PTR Records are stored in reverse lookup zones
# They allow 192.168.10.10 to resolve back to dc01.astonvilla.local

Add-DnsServerResourceRecordPtr `
-Name "10" `
-ZoneName "10.168.192.in-addr.arpa" `
-PtrDomainName "dc01.astonvilla.local"

# View DNS Records for verifying records exist and troubleshooting name resolution issues

Get-DnsServerResourceRecord `
-ZoneName "astonvilla.local"

# Export DNS Report

Get-DnsServerResourceRecord `
-ZoneName "astonvilla.local" |
Export-Csv dns-record-report.csv -NoTypeInformation

# DHCP Server Installation
# DHCP automatically assigns IP Address, Subnet Mask, Default Gateway, DNS Server to client devices

Install-WindowsFeature DHCP `
-IncludeManagementTools

Get-WindowsFeature DHCP

# DHCP Scope Creation defines the pool of available IP addresses

Add-DhcpServerv4Scope `
-Name "AstonVillaLAN" `
-StartRange 192.168.10.100 `
-EndRange 192.168.10.200 `
-SubnetMask 255.255.255.0

# DHCP Scope Options automatically provided to clients when they receive an IP address
# Configure Default Gateway

Set-DhcpServerv4OptionValue `
-Router 192.168.10.1

# Configure DNS Server
Set-DhcpServerv4OptionValue `
-DnsServer 192.168.10.10

# Configure Domain Name

Set-DhcpServerv4OptionValue `
-DnsDomain astonvilla.local

# DHCP Reservations ensure specific devices always receive the same IP address
# Common examples Printers, Servers, Network Appliances, Executive Laptops

Add-DhcpServerv4Reservation `
-ScopeId 192.168.10.0 `
-IPAddress 192.168.10.150 `
-ClientId "00-11-22-33-44-55" `
-Description "CEO Laptop"

# View DHCP Scopes

Get-DhcpServerv4Scope

# View Active DHCP Leases for identifying currently connected devices

Get-DhcpServerv4Lease

# View Reservations

Get-DhcpServerv4Reservation

# DNS Resolution Testing: Resolve hostnames using DNS
# Common troubleshooting step when users cannot reach resources

Resolve-DnsName dc01

Resolve-DnsName filesrv

Resolve-DnsName mail

# Reverse DNS Testing: Verify PTR records are working

Resolve-DnsName 192.168.10.10

# Client Troubleshooting

ipconfig /all

# Release current DHCP lease

ipconfig /release

# Request new DHCP lease

ipconfig /renew

# Flush local DNS cache

ipconfig /flushdns

# View DNS cache

ipconfig /displaydns

# Name Resolution Testing

nslookup dc01

nslookup filesrv

nslookup mail

nslookup 192.168.10.10

# Connectivity Testing

ping dc01

ping filesrv

ping 192.168.10.10

# DNS Troubleshooting: View DNS zones

Get-DnsServerZone

# View DNS records.

Get-DnsServerResourceRecord `
-ZoneName "astonvilla.local"

# Verify DHCP service

Get-Service DHCPServer

# Restart DHCP service

Restart-Service DHCPServer

# DNS Server Cache Useful when troubleshooting stale or incorrect DNS records
# View DNS Cache

Get-DnsServerCache

# Clear DNS Cache

Clear-DnsServerCache -Force

# Verify DNS Service

Get-Service DNS

# Restart DNS Service

Restart-Service DNS

# DHCP Authorization: In Active Directory environments DHCP servers must be authorized before they can issue leases
# This helps prevent rogue DHCP servers

Add-DhcpServerInDC `
-DnsName "dc01.astonvilla.local" `
-IPAddress 192.168.10.10

# Verify Authorized DHCP Servers

Get-DhcpServerInDC

# View Scope Statistics

Get-DhcpServerv4Statistics

# DNS Registration: Forces a client to register its DNS records
# Useful when a hostname is missing from DNS

ipconfig /registerdns

# DNS Event Logs: Useful when troubleshooting DNS problems

Get-EventLog `
-LogName DNS Server `
-Newest 25

# DHCP Event Logs: Useful when troubleshooting DHCP issues

Get-EventLog `
-LogName System `
-Newest 50

# Common Helpdesk Scenarios

# User cannot obtain an IP address
# Check:
# ipconfig /renew
# Get-DhcpServerv4Lease

# User cannot resolve a hostname
# Check:
# nslookup
# Resolve-DnsName

# DNS record missing
# Check:
# Get-DnsServerResourceRecord

# Device requires a permanent IP address
# Create DHCP reservation

# Printer cannot be reached
# Verify A record
# Verify PTR record
# Verify network connectivity
