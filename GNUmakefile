# Find the path to the originally called Makefile.
orig-mk       = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
# Set the absolute path to the directory in which `make` was called.
MK_DIR       := $(shell dirname $(call orig-mk))
#include $(MK_DIR)/tmp/gmsl-1.1.7/gmsl
PROJECT_ROOT ?= $(CURDIR)
FILES_DIR    ?= $(MK_DIR)/files
SHELL        := /bin/bash

default: help

include $(MK_DIR)/mk/tasks/*.mk
include $(MK_DIR)/mk/tools/*.mk

