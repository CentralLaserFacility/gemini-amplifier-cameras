#!../../bin/linux-x86_64/simAD3

## You may have to change simAD3 to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet("CAM", "PINHOLE")
epicsEnvSet("XSIZE",  "320")
epicsEnvSet("YSIZE",  "240")
epicsEnvSet("NELM", "76800")

< st-common.cmd

#< $(ADCORE)/iocBoot/commonPlugins.cmd


cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=tineHost"

create_monitor_set("cam_settings.req", 5, "P=$(PREFIX), R=$(CAM), SAVENAMEPV=$(PREFIX)$(CAM):SAVENAMEPV")

< st-camera.settings

dbpf $(PREFIX)$(CAM):SimMode 1
dbpf $(PREFIX)$(CAM):PeakWidthX 30
dbpf $(PREFIX)$(CAM):PeakWidthY 40
dbpf $(PREFIX)$(CAM):PeakStartX 80
dbpf $(PREFIX)$(CAM):PeakStartY 60
dbpf $(PREFIX)$(CAM):Gain 10
dbpf $(PREFIX)$(CAM):Noise 50
dbpf $(PREFIX)$(CAM):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM):Stats1:CentroidThreshold 5