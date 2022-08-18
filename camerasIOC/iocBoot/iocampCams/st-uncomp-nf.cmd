#!../../bin/linux-x86_64/ampCams

< envPaths

epicsEnvSet("CAM", "UNCOMP_NF")
epicsEnvSet("NICKNAME", "Uncomp NF")
epicsEnvSet("CAMID", "172.16.71.11")

< st-common.cmd

cd "${TOP}"
dbLoadRecords("db/camera_details.db", "PREFIX=$(PREFIX)$(CAM), CAMERA_NICKNAME=$(NICKNAME)")

cd "${TOP}/iocBoot/${IOC}"
iocInit

create_monitor_set("cam_settings.req", 5, "P=$(PREFIX), R=$(CAM), SAVENAMEPV=$(PREFIX)$(CAM):SAVENAMEPV")

< st-camera.settings
#< st-camera-12bit.settings
