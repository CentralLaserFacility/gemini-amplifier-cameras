#!../../bin/linux-x86_64/gemCamSystem

## You may have to change gemCamSystem to something else
## everywhere it appears in this file

< envPaths
< $(AMPLIFIER)

epicsEnvSet("PUMP_T_CAM", "$(PREFIX)LEG1_GREEN_NF")
epicsEnvSet("PUMP_R_CAM", "$(PREFIX)LEG2_GREEN_NF")
epicsEnvSet("COMP_FF_CAM", "$(PREFIX)COMP_FF")
epicsEnvSet("AMP_OUT_CAM", "$(PREFIX)UNCOMP_NF")
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
dbLoadRecords("db/shot_data.db","P=GEM:S_AMP, AMP_OUT_CAM=$(AMP_OUT_CAM),PUMP_T_CAM=$(PUMP_T_CAM), PUMP_R_CAM=$(PUMP_R_CAM),COMP_FF_CAM=$(COMP_FF_CAM), THROUGHPUT_PV=$(THROUGHPUT_PV), LIST_READ_FN=$(LIST_READ_FN)")
#dbLoadRecords("db/sim.db","P=GEM:S_AMP, AMP_OUT_CAM=$(AMP_OUT_CAM),PUMP_T_CAM=$(PUMP_T_CAM), PUMP_R_CAM=$(PUMP_R_CAM),COMP_FF_CAM=$(COMP_FF_CAM), THROUGHPUT_PV=$(THROUGHPUT_PV)")
dbLoadRecords("db/triggering.db","P=$(PREFIX), CAM1=$(CAM1),CAM2=$(CAM2),CAM3=$(CAM3),CAM4=$(CAM4),CAM5=$(CAM5),CAM6=$(CAM6),CAM7=$(CAM7),CAM8=$(CAM8)")

dbLoadRecords("db/display.db","P=$(PREFIX),CAM=$(CAM1)")
dbLoadRecords("db/display.db","P=$(PREFIX),CAM=$(CAM2)")
dbLoadRecords("db/display.db","P=$(PREFIX),CAM=$(CAM3)")
dbLoadRecords("db/display.db","P=$(PREFIX),CAM=$(CAM4)")
dbLoadRecords("db/display.db","P=$(PREFIX),CAM=$(CAM5)")
dbLoadRecords("db/display.db","P=$(PREFIX),CAM=$(CAM6)")
dbLoadRecords("db/display.db","P=$(PREFIX),CAM=$(CAM7)")
dbLoadRecords("db/display.db","P=$(PREFIX),CAM=$(CAM8)")

dbLoadRecords("db/roi.db","P=$(PREFIX),CAM=$(CAM1)")
dbLoadRecords("db/roi.db","P=$(PREFIX),CAM=$(CAM2)")
dbLoadRecords("db/roi.db","P=$(PREFIX),CAM=$(CAM3)")
dbLoadRecords("db/roi.db","P=$(PREFIX),CAM=$(CAM4)")
dbLoadRecords("db/roi.db","P=$(PREFIX),CAM=$(CAM5)")
dbLoadRecords("db/roi.db","P=$(PREFIX),CAM=$(CAM6)")
dbLoadRecords("db/roi.db","P=$(PREFIX),CAM=$(CAM7)")
dbLoadRecords("db/roi.db","P=$(PREFIX),CAM=$(CAM8)")

set_requestfile_path("$(TOP)/autoSaveRestore")
set_savefile_path("$(TOP)/autoSaveRestore")
set_savefile_name("display_settings.req", "$(SAVE_FILE).sav")
save_restoreSet_DatedBackupFiles(0)
set_pass0_restoreFile("$(SAVE_FILE).sav")
set_pass1_restoreFile("$(SAVE_FILE).sav")


cd "${TOP}/iocBoot/${IOC}"
iocInit

create_monitor_set("display_settings.req", 5, "P=$(PREFIX),CAM1=$(CAM1),CAM2=$(CAM2),CAM3=$(CAM3),CAM4=$(CAM4),CAM5=$(CAM5),CAM6=$(CAM6),CAM7=$(CAM7),CAM8=$(CAM8)")

## Start any sequence programs
#seq sncxxx,"user=jqg93617"
