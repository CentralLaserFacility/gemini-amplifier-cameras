TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = ampCams
PROD_NAME = ampCams
# ampCams.dbd will be created and installed
DBD += ampCams.dbd

# ampCams.dbd will be made up from these files:
ampCams_DBD += base.dbd

# Include dbd files from all support applications:
#ampCams_DBD += xxx.dbd
$(PROD_NAME)_DBD += drvAsynIPPort.dbd
$(PROD_NAME)_DBD += ADSupport.dbd
$(PROD_NAME)_DBD += NDPluginSupport.dbd
$(PROD_NAME)_DBD += devIocStats.dbd
$(PROD_NAME)_DBD += ADVimbaSupport.dbd

# Add all the support libraries needed by this IOC
#ampCams_LIBS += xxx
PROD_LIBS += ADVimba
PROD_LIBS += NDPlugin
PROD_LIBS += ADGenICam
PROD_LIBS += ADBase
PROD_LIBS += calc
PROD_LIBS += busy
PROD_LIBS += sscan
PROD_LIBS += seq
PROD_LIBS += asyn
PROD_LIBS += autosave
PROD_LIBS += pv
PROD_LIBS += PvAPI

# ampCams_registerRecordDeviceDriver.cpp derives from ampCams.dbd
ampCams_SRCS += ampCams_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
ampCams_SRCS_DEFAULT += ampCamsMain.cpp
ampCams_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#ampCams_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
ampCams_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================
include $(ADCORE)/ADApp/commonDriverMakefile
include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
