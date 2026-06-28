-- ---- VLANs (one per department) ----
INSERT INTO vlan (vlan_number, vlan_name, description) VALUES
    (20, 'Field / SCADA',  'Field automation and SCADA end devices'),
    (10, 'Operations',     'Operations department workstations'),
    (30, 'Engineering',    'Engineering workstations'),
    (60, 'Guest Wi-Fi',    'Isolated guest wireless access'),
    (40, 'IT / Admin',     'IT and administrative systems'),
    (50, 'Management',     'Management workstations');

-- ---- Subnets (VLSM design, biggest-first from 10.50.0.0) ----
-- vlan_id follows insert order above (20=1, 10=2, 30=3, 60=4, 40=5, 50=6)
INSERT INTO subnet
    (vlan_id, network_address, cidr_prefix, subnet_mask, gateway, broadcast, usable_hosts, description) VALUES
    (1, '10.50.0.0',   24, '255.255.255.0',   '10.50.0.1',   '10.50.0.255',   254, 'Field/SCADA - largest segment'),
    (2, '10.50.1.0',   25, '255.255.255.128', '10.50.1.1',   '10.50.1.127',   126, 'Operations'),
    (3, '10.50.1.128', 26, '255.255.255.192', '10.50.1.129', '10.50.1.191',    62, 'Engineering'),
    (4, '10.50.1.192', 26, '255.255.255.192', '10.50.1.193', '10.50.1.255',    62, 'Guest Wi-Fi'),
    (5, '10.50.2.0',   27, '255.255.255.224', '10.50.2.1',   '10.50.2.31',     30, 'IT/Admin'),
    (6, '10.50.2.32',  28, '255.255.255.240', '10.50.2.33',  '10.50.2.47',     14, 'Management');

-- ---- Example IP assignments (a few per subnet) ----
INSERT INTO ip_address (subnet_id, ip_address, status, device_name) VALUES
    -- Field/SCADA (subnet 1)
    (1, '10.50.0.1',   'reserved',  'Gateway'),
    (1, '10.50.0.10',  'assigned',  'RTU-01'),
    (1, '10.50.0.11',  'assigned',  'RTU-02'),
    (1, '10.50.0.12',  'assigned',  'Flow-Meter-PLC'),
    (1, '10.50.0.50',  'available', NULL),
    -- Operations (subnet 2)
    (2, '10.50.1.1',   'reserved',  'Gateway'),
    (2, '10.50.1.10',  'assigned',  'OPS-WS-01'),
    (2, '10.50.1.11',  'assigned',  'OPS-WS-02'),
    (2, '10.50.1.20',  'available', NULL),
    -- Engineering (subnet 3)
    (3, '10.50.1.129', 'reserved',  'Gateway'),
    (3, '10.50.1.140', 'assigned',  'ENG-WS-01'),
    (3, '10.50.1.141', 'available', NULL),
    -- Guest Wi-Fi (subnet 4)
    (4, '10.50.1.193', 'reserved',  'Gateway'),
    (4, '10.50.1.200', 'assigned',  'Guest-AP-01'),
    -- IT/Admin (subnet 5)
    (5, '10.50.2.1',   'reserved',  'Gateway'),
    (5, '10.50.2.5',   'assigned',  'IT-SERVER-01'),
    (5, '10.50.2.6',   'assigned',  'IT-WS-01'),
    -- Management (subnet 6)
    (6, '10.50.2.33',  'reserved',  'Gateway'),
    (6, '10.50.2.40',  'assigned',  'MGMT-WS-01');
