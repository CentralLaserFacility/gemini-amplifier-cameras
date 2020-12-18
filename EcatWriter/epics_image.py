from __future__ import annotations
import epics
import numpy
from PIL import Image


class EpicsImage:
    def __init__(self: EpicsImage, pv_name_root: str, timeout: float = 2) -> None:
        self._array_data_pv = epics.PV(
            pv_name_root + ":image1:ArrayData", connection_timeout=timeout
        )
        self._array_width_pv = epics.PV(
            pv_name_root + ":image1:ArraySize0_RBV", connection_timeout=timeout
        )
        self._array_height_pv = epics.PV(
            pv_name_root + ":image1:ArraySize1_RBV", connection_timeout=timeout
        )
        self._timeout = timeout

    @property
    def size(self: EpicsImage) -> int:
        return self._array_data_pv.get(timeout=self._timeout).size

    @property
    def data(self: EpicsImage) -> numpy.ndarray:
        return self._array_data_pv.get(timeout=self._timeout)

    @property
    def width(self: EpicsImage) -> int:
        return self._array_width_pv.get(timeout=self._timeout)

    @property
    def height(self: EpicsImage) -> int:
        return self._array_height_pv.get(timeout=self._timeout)

    def write_to_file(self: EpicsImage, filename: str) -> None:
        data = self.data
        width = self.width
        height = self.height
        if data is None or width is None or height is None:
            return
        image_array = numpy.reshape(self.data, (self.height, self.width))
        Image.fromarray(image_array).save(filename)
