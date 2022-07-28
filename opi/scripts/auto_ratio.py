# Embedded python script
from org.csstudio.display.builder.runtime.script import PVUtil, ScriptUtil

default_dimension = 480 # default x and y size of the widget
sizex = PVUtil.getLong(pvs[0]) #$(CAM):image1:ArraySize0_RBV
sizey = PVUtil.getLong(pvs[1]) #$(CAM):image1:ArraySize1_RBV
widget_sizex = default_dimension
widget_sizey = default_dimension
autoScale = PVUtil.getLong(pvs[2]) #loc://autoScale
autoRatio = PVUtil.getLong(pvs[3]) #loc://autoRatio

ratio = 1.0

widget.setPropertyValue("data_width",sizex)
widget.setPropertyValue("data_height",sizey)
widget.setPropertyValue("x_axis.maximum",sizex)
widget.setPropertyValue("y_axis.maximum",sizey)

if autoScale == 1:
    #setting image size to the widget size
	widget.setPropertyValue("width",sizex) 
	widget.setPropertyValue("height",sizey)
elif autoRatio == 1:
    # keeping  the original image ratio in auto ratio mode
	if(sizex>sizey):
		ratio = float(sizey)/sizex
		widget_sizex = default_dimension
		widget_sizey = default_dimension * ratio
	elif(sizey>sizex):
		ratio = float(sizex)/sizey
		widget_sizey = default_dimension
		widget_sizex = default_dimension * ratio
	else:
		widget_sizex = default_dimension
		widget_sizey = default_dimension

	widget.setPropertyValue("width",widget_sizex )
	widget.setPropertyValue("height",widget_sizey )

else:
    #setting the default dimension if the mode is not in autoratio or autoScale
	widget.setPropertyValue("width",default_dimension)
	widget.setPropertyValue("height",default_dimension)

