# Makefile for Network Automation Aruba project

.PHONY: help install validate test clean

help:
	@echo "Available targets:"
	@echo "  install    - Install Ansible collections and dependencies"
	@echo "  validate   - Validate all mapping files and configurations"
	@echo "  test       - Run comprehensive tests"
	@echo "  clean      - Clean temporary files and logs"
	@echo "  example    - Run example configuration"

install:
	@echo "Installing Ansible collections..."
	ansible-galaxy collection install -r requirements.yml
	@echo "Making scripts executable..."
	chmod +x scripts/*.sh
	@echo "Installation complete!"

validate:
	@echo "Running mapping validation..."
	./scripts/validate_mappings.sh

test: validate
	@echo "Running syntax checks..."
	ansible-playbook --syntax-check playbooks/configure_switch_port.yml
	@echo "All tests passed!"

example:
	@echo "Running example configuration (dry run)..."
	ansible-playbook playbooks/configure_switch_port.yml --check \
		-e "room=roomAG2" \
		-e "wall_point=101" \
		-e "device_type=pc"

clean:
	@echo "Cleaning temporary files..."
	rm -f *.retry
	rm -f ansible.log
	@echo "Cleanup complete!"
