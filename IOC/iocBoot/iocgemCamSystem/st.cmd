#!../../bin/linux-x86_64/gemCamSystem

## You may have to change gemCamSystem to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet(PREFIX, "GEM:N_AMP:")
epicsEnvSet(PUMP_T_CAM, "$(PREFIX)cam5")
epicsEnvSet(PUMP_R_CAM, "$(PREFIX)cam6")
epicsEnvSet(COMP_FF_CAM, "$(PREFIX)cam4")
epicsEnvSet(AMP_OUT_CAM, "$(PREFIX)cam1")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/gemCamSystem.dbd"
gemCamSystem_registerRecordDeviceDriver pdbbase

## Load record instances
#dbLoadRecords("db/xxx.db","user=jqg93617")
dbLoadRecords("db/amplifier_cameras.db","P=GEM:N_AMP, AMP_OUT_CAM=$(AMP_OUT_CAM),PUMP_T_CAM=$(PUMP_T_CAM), PUMP_R_CAM=$(PUMP_R_CAM),COMP_FF_CAM=$(COMP_FF_CAM)")

dbLoadRecords("db/display.db","CAM=$(PREFIX)cam1")
dbLoadRecords("db/display.db","CAM=$(PREFIX)cam2")
dbLoadRecords("db/display.db","CAM=$(PREFIX)cam3")
dbLoadRecords("db/display.db","CAM=$(PREFIX)cam4")
dbLoadRecords("db/display.db","CAM=$(PREFIX)cam5")
dbLoadRecords("db/display.db","CAM=$(PREFIX)cam6")
dbLoadRecords("db/display.db","CAM=$(PREFIX)cam7")
dbLoadRecords("db/display.db","CAM=$(PREFIX)cam8")


cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=jqg93617"
