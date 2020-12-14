from __future__ import annotations
import epics
import numpy
from PIL import Image


class EpicsImage:
    def __init__(self: EpicsImage, pv_name_root: str) -> None:

        self._array_data_pv = epics.PV(pv_name_root + ":image1:ArrayData")
        self._array_width_pv = epics.PV(pv_name_root + ":image1:ArraySize0_RBV")
        self._array_height_pv = epics.PV(pv_name_root + ":image1:ArraySize1_RBV")

    @property
    def size(self: EpicsImage) -> int:
        return self._array_data_pv.get().size

    @property
    def data(self: EpicsImage) -> numpy.ndarray:
        return self._array_data_pv.get()

    @property
    def width(self: EpicsImage) -> int:
        return self._array_width_pv.get()

    @property
    def height(self: EpicsImage) -> int:
        return self._array_height_pv.get()

    def write_to_file(self: EpicsImage, filename: str) -> None:
        image_array = numpy.reshape(self.data, (self.height, self.width))
        Image.fromarray(image_array).save(filename)
