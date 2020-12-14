from connect2j import scriptContext

with scriptContext('widget', 'pvs', 'PVUtil', dict=globals()):
    camera_name = PVUtil.getString(pvs[0])
    opi_name = widget.getPropertyValue("opi_file")

    macros = widget.getPropertyValue("macros")
    
    macros.add("CAM",camera_name)
    widget.setPropertyValue("macros", macros)
    widget.setPropertyValue("opi_file", "")
    widget.setPropertyValue("opi_file", opi_name)







