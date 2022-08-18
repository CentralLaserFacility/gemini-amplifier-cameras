from connect2j import scriptContext

with scriptContext('widget', 'pvs', 'PVUtil', dict=globals()):
    cam_list = PVUtil.getStringArray(pvs[1])
    formated_list = [cam for cam in cam_list if cam]
    widget.setPropertyValue("items",formated_list)

