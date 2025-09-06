# Network Automation for Aruba Switches

This project provides automated configuration management for Aruba switches using Ansible AWX. It supports dynamic inventory management, VLAN assignments, and device-specific configurations based on room assignments and wall point mappings.

## Features

- **Dynamic Switch Discovery**: Automatically identifies the correct switch based on room number
- **Wall Point Mapping**: Converts physical wall points to switch interface configurations (1/1 format)
- **Device Type Management**: Supports phones, PCs, printers, cameras, projectors, and zero clients
- **VLAN Assignment**: Automatic VLAN configuration based on device types
- **Port Security**: Configures appropriate port security settings
- **Multi-Device Support**: Handles scenarios with phones + other devices on same port

## Supported Device Types

| Device Type | VLAN ID | Description |
|-------------|---------|-------------|
| phone | 528 | IP Phones |
| pc | 80 | Desktop/Laptop computers |
| printer | 531 | Network printers |
| cam | 536 | Surveillance cameras |
| projector | 533 | Network projectors |
| zero_client | 541 | Thin clients |
| none | shutdown | Disabled port |

## Quick Start

```bash
# Clone repository
git clone https://github.com/salwan-mohamed/network-automation-aruba.git
cd network-automation-aruba

# Install dependencies
make install

# Validate configuration
make validate

# Run example configuration
make example
```

## Usage Examples

### Configure a PC port
```bash
ansible-playbook playbooks/configure_switch_port.yml \
  -e "room=roomAG2" \
  -e "wall_point=101" \
  -e "device_type=pc"
```

### Configure PC with phone
```bash
ansible-playbook playbooks/configure_switch_port.yml \
  -e "room=roomA250" \
  -e "wall_point=205" \
  -e "device_type=pc" \
  -e "second_device_type=phone"
```

### Bulk configuration
```bash
./scripts/bulk_configure.sh -r roomAG2 -s 101 -e 110 -t pc
```

## Configuration Cases

1. **Phone Only**: Tagged phone VLAN, 1 MAC limit
2. **Single Device**: Untagged device VLAN, 1 MAC limit  
3. **Device + Phone**: Untagged device + tagged phone VLANs, 2 MAC limit
4. **Disabled Port**: Port disabled and secured

## Documentation

- [Usage Guide](docs/usage.md) - Comprehensive usage instructions
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions

## License

MIT License - see LICENSE file for details.
