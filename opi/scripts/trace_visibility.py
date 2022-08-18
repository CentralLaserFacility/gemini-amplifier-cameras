from org.csstudio.display.builder.runtime.script import PVUtil, ScriptUtil

# Which trace parm is this for?
#trace_parm = "trace_0_visible"
trace_parm = PVUtil.getString(pvs[1])

# Locate graph widget in the display based on name
graph_widget = widget.getDisplayModel().runtimeChildren().getChildByName("time-history")

if PVUtil.getLong(pvs[0])  == 1:
	state = True
else:
    state = False

graph_widget.setPropertyValue(trace_parm, state)





   