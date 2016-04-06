define git_template 

include $(MK_DIR)/mk/tools/git/$(1).mk

$(1) ?= $(BIN_DIR)/$(1) $$($(1)_OPTIONS)

gits: $(1)

debug-gits: debug-$(1)
debug-$(1):
	@echo NAME: $$($(1)_NAME)
	@echo RELEASE: $$($(1)_RELEASE)
	@echo DOWNLOAD_URL: $$($(1)_DOWNLOAD_URL)
	@echo DEPENDENCIES: $$($(1)_DEPENDENCIES)
	@echo PARENT: $$($(1)_PARENT)
	@echo EXECUTABLE: $(BIN_DIR)/$(1)
	@echo SOURCE: $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE)
	@echo command w/options: $(1) $$($(1)_OPTIONS)
	@echo

tools-help-$(1):
	@echo "make $(1)"
	@echo "  Install $$($(1)_NAME)."
	@echo "make $(1) $(1)_RELEASE=$$($(1)_RELEASE)"
	@echo "  Install the $$($(1)_RELEASE) release of $$($(1)_NAME)."

clean-gits: clean-$(1)
clean-$(1):
	@echo Removing $$($(1)_NAME).
	@rm -f $(BIN_DIR)/$(1)
ifeq ($(1), $$($(1)_PARENT))
	@rm -rf $(SRC_DIR)/$(1)
endif

deps: deps-$(1)
deps-$(1): apt-update
	@echo Installing $$($(1)_NAME) dependencies.
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $$($(1)_DEPENDENCIES)

gits: $$($(1)_COMMANDS)

$(1): $(BIN_DIR)/$(1)

ifneq ($(1), $$($(1)_PARENT))
$$($(1)_PARENT): $(1)
clean-$$($(1)_PARENT): clean-$(1)
endif

$(BIN_DIR)/$(1): $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE)/$$($(1)_BIN_DIR)/$(1)
	@echo Installing $$($(1)_NAME).
	@ln -sf $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE)/$$($(1)_BIN_DIR)/$(1) $(BIN_DIR)/$(1)
	@chmod a+x $(BIN_DIR)/$(1)
ifeq ($(1), $$($(1)_PARENT))
	@cd $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE) && \
	$$($(1)_COMMAND) 2&>1 > /dev/null && \
	. $(MK_DIR)/scripts/hacking.sh && \
  $(1) --version
endif

$(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE)/$$($(1)_BIN_DIR)/$(1): $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE)

ifeq ($(1), $$($(1)_PARENT))
$(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE): init
	@echo Downloading the $$($(1)_RELEASE) release of $$($(1)_NAME) via Git.
	@git clone --quiet --depth 1 $$($(1)_DOWNLOAD_URL) $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE)
	@cd $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE) && \
	git fetch --quiet --tags && \
	git checkout --quiet $$($(1)_RELEASE) && \
	git submodule update --quiet --init
endif

endef

GITS ?= ansible ansible-doc ansible-playbook ansible-vault ansible-galaxy ansible-pull
$(foreach git,$(GITS),$(eval $(call git_template,$(git))))

# vi:syntax=makefile