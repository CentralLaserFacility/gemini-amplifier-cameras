TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_NAME = simAD3
PROD_IOC = $(PROD_NAME)

DBD += $(PROD_NAME).dbd
$(PROD_NAME)_DBD += asub.dbd
$(PROD_NAME)_DBD += simDetectorSupport.dbd
PROD_LIBS += simDetector 

include $(ADCORE)/ADApp/commonDriverMakefile

PROD_SRCS_DEFAULT += $(PROD_NAME)_registerRecordDeviceDriver.cpp $(PROD_NAME)Main.cpp
PROD_SRCS += gemCamSystem.c

include $(TOP)/configure/RULES

