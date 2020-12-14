from org.csstudio.display.builder.runtime.script import PVUtil, ConsoleUtil

cameras = PVUtil.getStringArray(pvs[0])
timeout = 2000

if PVUtil.getString(pvs[1]) == "Fine":
	pvToWrite = ":SET_ROI_VIEW.PROC"
else:
	pvToWrite = ":SET_FULL_CHIP.PROC"

[PVUtil.writePV(cam + pvToWrite,1,timeout) for cam in cameras]