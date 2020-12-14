from org.csstudio.display.builder.runtime.script import PVUtil, ScriptUtil

sizex = PVUtil.getLong(pvs[1])
sizey = PVUtil.getLong(pvs[2])
minx = PVUtil.getLong(pvs[3])
miny = PVUtil.getLong(pvs[4])

widget.setPropertyValue("x_axis.maximum",sizex+minx)
widget.setPropertyValue("x_axis.minimum",minx)
widget.setPropertyValue("data_width",sizex)

widget.setPropertyValue("y_axis.maximum",miny)
widget.setPropertyValue("y_axis.minimum",sizey+miny)
widget.setPropertyValue("data_height",sizey)




