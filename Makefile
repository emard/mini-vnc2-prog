###################################################################
# Project Configuration: 
# 
# Specify the name of the design (project) and the Quartus II
# Settings File (.qsf)
###################################################################

PROJECT = project
TOP_LEVEL_ENTITY = vnc2prog
ASSIGNMENT_FILES = $(PROJECT).qpf $(PROJECT).qsf

###################################################################
# Part, Family, Boardfile
FAMILY = "Cyclone IV E"
PART = EP4CE22E22C8
BOARDFILE = reverse-u16.board
CONFIG_DEVICE = EPCS16
SERIAL_FLASH_LOADER_DEVICE = EP4CE22
OPENOCD_BOARD=reverse-u16.ocd
# OPENOCD_INTERFACE=interface/altera-usb-blaster.cfg
# OPENOCD_INTERFACE=ftdi-fpu1.ocd
OPENOCD_INTERFACE=remote.ocd

###################################################################
#
# Quartus shell environment vars
#
###################################################################

quartus_env ?= . ./quartus_env.sh

# include makefile which does it all
include ./altera.mk

###################################################################
# Setup your sources here
SRCS = vnc2prog.v
