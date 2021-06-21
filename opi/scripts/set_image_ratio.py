from org.csstudio.display.builder.runtime.script import PVUtil, ScriptUtil

sizex = PVUtil.getLong(pvs[1])
sizey = PVUtil.getLong(pvs[2])

max_widget_height = 337
max_widget_width = 500

aspect_ratio = 1.0*sizex/sizey

if aspect_ratio > 1 and (max_widget_width/aspect_ratio <= max_widget_height):
  widget.setPropertyValue("height",max_widget_width/aspect_ratio)
  widget.setPropertyValue("width", max_widget_width)
elif aspect_ratio > 1 and (max_widget_width/aspect_ratio > max_widget_height):
  widget.setPropertyValue("height",max_widget_height)
  widget.setPropertyValue("width", max_widget_height * aspect_ratio)
elif aspect_ratio < 1:
  widget.setPropertyValue("width", max_widget_height*aspect_ratio)
  widget.setPropertyValue("height", max_widget_height)
else:
  widget.setPropertyValue("height", max_widget_height)
  widget.setPropertyValue("width", max_widget_height) 



