-- 1. Full addressing: every VLAN with its subnet details.
SELECT v.vlan_number, v.vlan_name,
       s.network_address, s.cidr_prefix, s.subnet_mask,
       s.gateway, s.broadcast, s.usable_hosts
FROM vlan v
JOIN subnet s ON v.vlan_id = s.vlan_id
ORDER BY s.network_address;

-- 2. Assigned IPs vs. usable capacity, as a percentage.
SELECT v.vlan_name,
       s.network_address || '/' || s.cidr_prefix AS subnet,
       s.usable_hosts,
       SUM(CASE WHEN i.status = 'assigned' THEN 1 ELSE 0 END) AS assigned,
       ROUND(SUM(CASE WHEN i.status = 'assigned' THEN 1 ELSE 0 END) * 100.0 / s.usable_hosts, 1) AS pct_used
FROM subnet s
JOIN vlan v            ON s.vlan_id = v.vlan_id
LEFT JOIN ip_address i ON s.subnet_id = i.subnet_id
GROUP BY s.subnet_id
ORDER BY pct_used DESC;

-- 3. All devices on a specific VLAN
SELECT v.vlan_name, i.ip_address, i.device_name, i.status
FROM ip_address i
JOIN subnet s ON i.subnet_id = s.subnet_id
JOIN vlan v   ON s.vlan_id = v.vlan_id
WHERE v.vlan_name = 'Operations'
ORDER BY i.ip_address;

-- 4. Which VLAN/subnet does a given IP belong to?
SELECT i.ip_address, v.vlan_number, v.vlan_name,
       s.network_address || '/' || s.cidr_prefix AS subnet
FROM ip_address i
JOIN subnet s ON i.subnet_id = s.subnet_id
JOIN vlan v   ON s.vlan_id = v.vlan_id
WHERE i.ip_address = '10.50.0.10';

-- 5. Available (free) IPs we currently track, by VLAN.
SELECT v.vlan_name, i.ip_address
FROM ip_address i
JOIN subnet s ON i.subnet_id = s.subnet_id
JOIN vlan v   ON s.vlan_id = v.vlan_id
WHERE i.status = 'available'
ORDER BY v.vlan_name, i.ip_address;

-- 6. Reserved addresses (gateways, etc.).
SELECT v.vlan_name, i.ip_address, i.device_name
FROM ip_address i
JOIN subnet s ON i.subnet_id = s.subnet_id
JOIN vlan v   ON s.vlan_id = v.vlan_id
WHERE i.status = 'reserved'
ORDER BY i.ip_address;

-- 7. Total address capacity designed across the whole network.
SELECT COUNT(*) AS subnet_count,
       SUM(usable_hosts) AS total_usable_addresses
FROM subnet;
