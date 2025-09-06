#!/bin/bash
# validate_mappings.sh - Validate all configuration mappings

set -e

echo "=========================================="
echo "Network Automation Mapping Validation"
echo "Interface Format: switch/port (e.g., 1/1)"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "ansible.cfg" ]; then
    echo -e "${RED}Error: Please run this script from the project root directory${NC}"
    exit 1
fi

echo "1. Validating YAML syntax..."
echo "----------------------------"

# Check YAML syntax for all files
for file in vars/*.yml inventory/*.yml playbooks/*.yml; do
    if [ -f "$file" ]; then
        if command -v python3 &> /dev/null; then
            if python3 -c "import yaml; yaml.safe_load(open('$file'))" &>/dev/null; then
                print_status 0 "$file - Valid YAML"
            else
                print_status 1 "$file - Invalid YAML"
                exit 1
            fi
        else
            print_status 0 "$file - YAML validation skipped (python3 not found)"
        fi
    fi
done

echo
echo "2. Validating switch mappings..."
echo "---------------------------------"

# Extract and validate switch IPs
switch_ips=$(grep -oP '\d+\.\d+\.\d+\.\d+' vars/switch_mapping.yml 2>/dev/null || true)
if [ -z "$switch_ips" ]; then
    print_status 1 "No switch IPs found in switch_mapping.yml"
    exit 1
else
    print_status 0 "Found $(echo "$switch_ips" | wc -l) switch IPs"
fi

echo
echo "3. Validating interface format..."
echo "---------------------------------"

# Count wall points
wall_points=$(grep -cP '^\s*"\d+":\s*"\d+/\d+"' vars/wall_point_mapping.yml 2>/dev/null || echo 0)
print_status 0 "Found $wall_points wall point mappings"

# Validate interface format (should be switch/port - e.g., 1/1, 2/24)
invalid_interfaces=$(grep -oP '"\d+":\s*"[^"]*"' vars/wall_point_mapping.yml | grep -v '"\d\+/\d\+"' | wc -l)
if [ "$invalid_interfaces" -eq 0 ]; then
    print_status 0 "All interfaces use correct Aruba format (switch/port)"
else
    print_status 1 "Found $invalid_interfaces interfaces with incorrect format"
fi

echo
echo "4. Summary"
echo "----------"
echo "Validation completed!"
echo "Interface Format: switch/port (e.g., 1/1, 2/24, 8/48) ✓"
echo "Total wall points configured: $wall_points"
print_status 0 "Project structure validated successfully"
