DROP TABLE IF EXISTS ip_address;
DROP TABLE IF EXISTS subnet;
DROP TABLE IF EXISTS vlan;

CREATE TABLE vlan (
    vlan_id      INTEGER PRIMARY KEY,        -- auto-increments in SQLite
    vlan_number  INTEGER NOT NULL UNIQUE,    -- ex: 10, 20, 30
    vlan_name    TEXT    NOT NULL,           -- ex: 'Operations'
    description  TEXT
);

-- A Subnet = the IP range assigned to a VLAN (the addressing design).
CREATE TABLE subnet (
    subnet_id        INTEGER PRIMARY KEY,
    vlan_id          INTEGER NOT NULL,
    network_address  TEXT    NOT NULL,       -- ex: '10.50.0.0'
    cidr_prefix      INTEGER NOT NULL,       -- ex: 24
    subnet_mask      TEXT    NOT NULL,       -- ex: '255.255.255.0'
    gateway          TEXT    NOT NULL,       -- ex: '10.50.0.1'
    broadcast        TEXT    NOT NULL,       -- ex: '10.50.0.255'
    usable_hosts     INTEGER NOT NULL,       -- ex: 254
    description      TEXT,
    FOREIGN KEY (vlan_id) REFERENCES vlan(vlan_id)
);

-- An IP address = a single address within a subnet, optionally assigned.
CREATE TABLE ip_address (
    ip_id        INTEGER PRIMARY KEY,
    subnet_id    INTEGER NOT NULL,
    ip_address   TEXT    NOT NULL,
    status       TEXT    NOT NULL DEFAULT 'available',  -- available, assigned, reserved
    device_name  TEXT,                                  -- what's using it (NULL if free)
    FOREIGN KEY (subnet_id) REFERENCES subnet(subnet_id)
);
