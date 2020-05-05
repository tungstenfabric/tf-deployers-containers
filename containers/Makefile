DEPLOYERS_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

-include $(shell find $(DEPLOYERS_DIR) -name module.mk)

list-deployers:
	@$(DEPLOYERS_DIR)/build.sh list | grep -v INFO | sed -e 's,/,_,g' -e 's/^/deployer-/'

all-deployers: $(ALL_DEPLOERS)
	@echo $(ALL_DEPLOERS)

.PHONY: list-deployers all-deployers
