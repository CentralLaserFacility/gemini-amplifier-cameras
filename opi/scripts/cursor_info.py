# Script that receives a n image widget's "Cursor Info PV"
#
# Value is a VTable with columns X, Y, Value, one row of data

from org.csstudio.display.builder.runtime.script import PVUtil

try:
    x = PVUtil.getTableCell(pvs[0], 0, 0)
    y = PVUtil.getTableCell(pvs[0], 0, 1)
    v = PVUtil.getTableCell(pvs[0], 0, 2)
    text = "X: %d, Y: %d, Val: %d" % (x,  y,  v)
except:
    text = ""

widget.setPropertyValue("text", text)
