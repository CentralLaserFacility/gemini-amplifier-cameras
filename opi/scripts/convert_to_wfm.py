from connect2j import scriptContext


timeout = 1000
max_length_of_wfm = PVUtil.getLong(pvs[0])


def waveform_is_full(wfm, max_length):
    return len(wfm) == max_length


def value_if_not_null(pv):
    val = PVUtil.getDouble(pv)
    return val if val else 0


def get_data_points():
    data_pvs = [pvs[1], pvs[3], pvs[5], pvs[7], pvs[9], pvs[11]]
    return [value_if_not_null(pv) for pv in data_pvs]

    
def write_wfms(data_points):
    local_wfms_pvs = [pvs[2], pvs[4], pvs[6], pvs[8], pvs[10], pvs[12]]
    for i in range(len(local_wfms_pvs)):
        wfm = PVUtil.getDoubleArray(local_wfms_pvs[i])
        if waveform_is_full(wfm, max_length_of_wfm):
            wfm.pop(0)
        wfm.append(data_points[i])
        local_wfms_pvs[i].write(wfm)



with scriptContext('widget', 'pvs', 'PVUtil', dict=globals()):    
    data_points = get_data_points()
    write_wfms(data_points)




     