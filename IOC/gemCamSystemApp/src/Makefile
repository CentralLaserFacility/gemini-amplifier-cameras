TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = gemCamSystem
# gemCamSystem.dbd will be created and installed
DBD += gemCamSystem.dbd

# gemCamSystem.dbd will be made up from these files:
gemCamSystem_DBD += base.dbd asub.dbd
gemCamSystem_DBD += asSupport.dbd 


# Include dbd files from all support applications:
#gemCamSystem_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#gemCamSystem_LIBS += xxx
gemCamSystem_LIBS += autosave

# gemCamSystem_registerRecordDeviceDriver.cpp derives from gemCamSystem.dbd
gemCamSystem_SRCS += gemCamSystem_registerRecordDeviceDriver.cpp
gemCamSystem_SRCS += gemCamSystem.c

# Build the main IOC entry point on workstation OSs.
gemCamSystem_SRCS_DEFAULT += gemCamSystemMain.cpp
gemCamSystem_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#gemCamSystem_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
gemCamSystem_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
