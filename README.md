# Windows Server DNS and DHCP Admin Runbook

A Windows Server DNS and DHCP runbook that uses PowerShell to complete common infrastructure administration and troubleshooting tasks

## Features

* Installs and verifies DNS Server roles
* Creates forward lookup zones
* Creates reverse lookup zones
* Creates A records
* Creates CNAME records
* Creates PTR records
* Exports DNS record reports
* Installs and verifies DHCP Server roles
* Creates DHCP scopes
* Configures DHCP scope options
* Creates DHCP reservations
* Views active DHCP leases
* Exports DHCP lease reports
* Performs DNS name resolution testing
* Performs reverse DNS testing
* Verifies DNS and DHCP services
* Clears DNS cache
* Authorises DHCP servers in Active Directory
* Reviews DNS and DHCP event logs
* Demonstrates common helpdesk troubleshooting commands

## How it works

The script is written as a PowerShell runbook for a small Windows Server environment running DNS and DHCP services.

The example environment contains:

* An Active Directory domain
* A DNS server
* A DHCP server
* Client devices
* DNS records
* DHCP scopes and reservations

The script demonstrates how common DNS and DHCP administration, support and troubleshooting tasks can be performed using PowerShell.

## Files

* `dns-dhcp-admin-runbook.ps1` - main runbook containing DNS administration, DHCP administration, reporting and troubleshooting examples

## Notes

* Built for a Windows Server DNS and DHCP lab
* Uses the DNS Server PowerShell module
* Uses the DHCP Server PowerShell module
* Demonstrates common helpdesk and sysadmin infrastructure tasks
* Covers DNS administration, DHCP administration and troubleshooting
* Includes DNS and DHCP reporting examples
* Includes DHCP authorisation examples for Active Directory environments
* Example domains, hostnames and IP addresses are for lab purposes only and should not be used in production