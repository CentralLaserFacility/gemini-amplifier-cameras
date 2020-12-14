#!../../bin/linux-x86_64/gemCamSystem

## You may have to change gemCamSystem to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet(PREFIX, "GEM:N_AMP:")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/gemCamSystem.dbd"
gemCamSystem_registerRecordDeviceDriver pdbbase

## Load record instances
#dbLoadRecords("db/xxx.db","user=jqg93617")
dbLoadRecords("db/amplifier_cameras.db","P=GEM:N_AMP, AMP_OUT_CAM=$(PREFIX)cam1,COMP_FF_CAM=$(PREFIX)cam4")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=jqg93617"

