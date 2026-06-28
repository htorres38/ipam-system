# IP Address Management (IPAM) System

A small database for managing a network's IP addresses — keeping track of VLANs,
subnets, and which IPs are assigned or free. I started from an IT asset-tracking
database I built in a database course, then redesigned it into a network-focused
IPAM system and designed the addressing scheme myself.

## What it does

The database stores a network's addressing plan and answers questions like:
- How is each subnet laid out (network, mask, gateway, broadcast)?
- How full is each subnet?
- Which IPs are still free?
- Which VLAN does a given IP belong to?

## The network design

The network uses the block `10.50.0.0/16`, divided into six subnets — one per
department VLAN. Each subnet is sized to fit its devices with room to grow
(variable-length subnet masking):

| VLAN | Department | Subnet | Usable hosts |
|------|------------|--------|--------------|
| 20 | Field / SCADA | 10.50.0.0/24 | 254 |
| 10 | Operations | 10.50.1.0/25 | 126 |
| 30 | Engineering | 10.50.1.128/26 | 62 |
| 60 | Guest Wi-Fi | 10.50.1.192/26 | 62 |
| 40 | IT / Admin | 10.50.2.0/27 | 30 |
| 50 | Management | 10.50.2.32/28 | 14 |

## The tables

- **vlan** – the VLANs (number and name)
- **subnet** – each subnet's network address, mask, gateway, broadcast, and capacity
- **ip_address** – individual IP addresses, their status (available / assigned /
  reserved), and what device is using them

## Files

- `schema.sql` – creates the tables
- `data.sql` – adds the VLANs, subnets, and sample IP assignments
- `queries.sql` – the reporting queries

## How to run it

Built and tested with SQLite (using DB Browser for SQLite). Run `schema.sql`, then
`data.sql`, then any of the queries in `queries.sql`.
