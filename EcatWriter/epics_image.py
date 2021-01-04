from __future__ import annotations
import epics
import numpy
from PIL import Image


class EpicsImage:
    def __init__(self: EpicsImage, pv_name_root: str, timeout: float = 5) -> None:
        self._array_data_pv = epics.PV(
            pv_name_root + ":image1:ArrayData",
            connection_timeout=timeout,
            callback=self._on_data_change,
        )
        self._array_width_pv = epics.PV(
            pv_name_root + ":image1:ArraySize0_RBV",
            connection_timeout=timeout,
            callback=self._on_width_change,
        )
        self._array_height_pv = epics.PV(
            pv_name_root + ":image1:ArraySize1_RBV",
            connection_timeout=timeout,
            callback=self._on_height_change,
        )
        self._centroid_x_pv = epics.PV(
            pv_name_root + ":Stats1:CentroidX_RBV",
            connection_timeout=timeout,
            callback=self._on_centroid_x_change,
        )
        self._centroid_y_pv = epics.PV(
            pv_name_root + ":Stats1:CentroidY_RBV",
            connection_timeout=timeout,
            callback=self._on_centroid_y_change,
        )
        self._timeout = timeout
        self._data = self._width = self._height = None
        self._centroid_x = self._centroid_y = 0.0

    def _on_data_change(self, **kwargs):
        self._data = kwargs["value"]

    def _on_height_change(self, **kwargs):
        self._height = kwargs["value"]

    def _on_centroid_x_change(self, **kwargs):
        self._centroid_x = kwargs["value"]

    def _on_centroid_y_change(self, **kwargs):
        self._centroid_y = kwargs["value"]

    def _on_width_change(self, **kwargs):
        self._width = kwargs["value"]

    @property
    def size(self: EpicsImage) -> int:
        return self._data.size

    @property
    def data(self: EpicsImage) -> numpy.ndarray:
        return self._data

    @property
    def centroidX(self: EpicsImage) -> float:
        return self._centroid_x

    @property
    def centroidY(self: EpicsImage) -> float:
        return self._centroid_y

    @property
    def width(self: EpicsImage) -> int:
        return self._width

    @property
    def height(self: EpicsImage) -> int:
        return self._height

    def write_to_file(self: EpicsImage, filename: str) -> None:
        data = self._data
        width = self._width
        height = self._height
        if data is None or width is None or height is None:
            return
        image_array = numpy.reshape(data, (height, width))
        Image.fromarray(image_array).save(filename)
