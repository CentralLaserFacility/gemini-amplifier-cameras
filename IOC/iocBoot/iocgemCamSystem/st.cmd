#!../../bin/linux-x86_64/gemCamSystem

## You may have to change gemCamSystem to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet(PREFIX, "GEM:N_AMP:")
epicsEnvSet(PUMP_T_CAM, "$(PREFIX)LEG1_GREEN_NF")
epicsEnvSet(PUMP_R_CAM, "$(PREFIX)LEG2_GREEN_NF")
epicsEnvSet(COMP_FF_CAM, "$(PREFIX)COMP_FF")
epicsEnvSet(AMP_OUT_CAM, "$(PREFIX)UNCOMP_NF")
epicsEnvSet("CAM1", "UNCOMP_NF")
epicsEnvSet("CAM2", "INP_NF")
epicsEnvSet("CAM3", "COMP_NF")
epicsEnvSet("CAM4", "COMP_FF")
epicsEnvSet("CAM5", "FLUOR")
epicsEnvSet("CAM6", "LEG1_GREEN_NF")
epicsEnvSet("CAM7", "LEG2_GREEN_NF")
epicsEnvSet("CAM8", "PINHOLE")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/gemCamSystem.dbd"
gemCamSystem_registerRecordDeviceDriver pdbbase

## Load record instances
#dbLoadRecords("db/xxx.db","user=jqg93617")
dbLoadRecords("db/amplifier_cameras.db","P=GEM:N_AMP, AMP_OUT_CAM=$(AMP_OUT_CAM),PUMP_T_CAM=$(PUMP_T_CAM), PUMP_R_CAM=$(PUMP_R_CAM),COMP_FF_CAM=$(COMP_FF_CAM)")
dbLoadRecords("db/sim.db","P=GEM:N_AMP")

dbLoadRecords("db/display.db","CAM=$(PREFIX)$(CAM1)")
dbLoadRecords("db/display.db","CAM=$(PREFIX)$(CAM2)")
dbLoadRecords("db/display.db","CAM=$(PREFIX)$(CAM3)")
dbLoadRecords("db/display.db","CAM=$(PREFIX)$(CAM4)")
dbLoadRecords("db/display.db","CAM=$(PREFIX)$(CAM5)")
dbLoadRecords("db/display.db","CAM=$(PREFIX)$(CAM6)")
dbLoadRecords("db/display.db","CAM=$(PREFIX)$(CAM7)")
dbLoadRecords("db/display.db","CAM=$(PREFIX)$(CAM8)")


cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=jqg93617"
