drush_NAME         ?= Drush
drush_OPTIONS      ?= --include=$(DRUSH_DIR)
drush_RELEASE      ?= 8.1.2
drush_DOWNLOAD_URL ?= https://github.com/drush-ops/drush/releases/download/$(drush_RELEASE)/drush.phar
drush_DEPENDENCIES ?= git php5-mysql php5-cli php5-gd

DRUSH_DIR ?= $(LOCAL_DIR)/drush
$(DRUSH_DIR): $(LOCAL_DIR)
	@echo "Ensuring Drush home directory ($(DRUSH_DIR)) exists."
	@mkdir -p $(DRUSH_DIR)

# vi:syntax=makefile
