#!../../bin/linux-x86_64/ampCams

< envPaths
< $(AMPLIFIER)

epicsEnvSet("CAM", "LEG2_GREEN_NF")
epicsEnvSet("NICKNAME", "Pump R")
epicsEnvSet("CAMID", $(LEG2_GREEN_NF_ID))

< st-common.cmd

cd "${TOP}"
dbLoadRecords("db/camera_details.db", "PREFIX=$(PREFIX)$(CAM), CAMERA_NICKNAME=$(NICKNAME)")

cd "${TOP}/iocBoot/${IOC}"
iocInit

create_monitor_set("cam_settings.req", 5, "P=$(PREFIX), R=$(CAM), SAVENAMEPV=$(PREFIX)$(CAM):SAVENAMEPV")

< st-camera.settings
