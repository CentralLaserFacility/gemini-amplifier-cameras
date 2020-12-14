# Set color map
from org.csstudio.display.builder.runtime.script import PVUtil, ScriptUtil
from org.csstudio.display.builder.model.properties import PredefinedColorMaps

mapname = PVUtil.getString(pvs[0]).upper()

colormap = None

# Initial Display Builder used ColorMap.PREDEFINED ..
for m in PredefinedColorMaps.PREDEFINED:

    if mapname == m.getName():
        colormap = m
        break

if colormap is None:
    ScriptUtil.getLogger().warning("Unknown color map " + mapname)
else:
    widget.setPropertyValue("color_map", colormap)

