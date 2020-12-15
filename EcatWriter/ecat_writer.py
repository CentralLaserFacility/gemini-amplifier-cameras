from __future__ import annotations
import epics
import os, datetime, numpy
from epics_image import EpicsImage
from typing import List


class EcatWriter:
    def __init__(self: EcatWriter, prefix: str) -> None:
        self._prefix = prefix
        self._listfile_name = "./AAL-FileList.txt"
        self._image_channels = [
            prefix + "_COMP_FF",
            prefix + "_COMP_NF",
            prefix + "_FLUOR",
            prefix + "_INP_NF",
            prefix + "_LEG1_GREEN_NF",
            prefix + "_LEG2_GREEN_NF",
            prefix + "_UNCOMP_NF",
        ]
        suffixes = [".dat", ".mdt.xml", ".png"]
        self._datafile_names = [
            channel + suffix for channel in self._image_channels for suffix in suffixes
        ]
        self._datafile_names.append(prefix + "_COMP_E.mdt.xml")
        self._images = [EpicsImage(ch) for ch in self._image_channels]

    def _get_today(self: EcatWriter) -> str:
        return datetime.date.today().strftime("%Y%m%d")

    def _get_shot_time(self: EcatWriter) -> str:
        return ("dummy_time", "dummy_times")

    def _get_shot_number(self: EcatWriter) -> int:
        # return epics.caget(self._prefix + "SHOT_NUMBER")
        return 20500

    def _get_compressor_energy(self: EcatWriter) -> float:
        # return epics.caget(self._prefix + "COMP_ENERGY")
        return 17.5

    def _get_compressor_throughput(self: EcatWriter) -> float:
        # return epics.caget(self._prefix + "COMP_THROUGHPUT")
        return 0.73

    def _get_amplifier_energy(self: EcatWriter) -> float:
        # return epics.caget(self._prefix + "AMP_E")
        return 20.1

    def _get_comp_energy_template_contents(
        self: EcatWriter, directory: str = os.getcwd()
    ) -> str:
        filename = directory + os.sep + "eCatEnergyTemplate.xml"
        with open(filename, "r") as f:
            data = f.read()
        return data

    def _get_shot_details(self: EcatWriter) -> None:
        self._shot_date = self._get_today()
        self._shot_number = self._get_shot_number()
        self._shot_time, self._shot_times = self._get_shot_time()

    def _generate_datafile_dir(self: EcatWriter) -> None:
        directory = self._get_today() + os.sep
        if not os.path.exists(directory):
            os.makedirs(directory)
        self._datafile_dir = directory

    def _build_comp_energy_file_contents(
        self: EcatWriter, energy: float, throughput: float
    ) -> str:
        template = self._get_comp_energy_template_contents()
        contents = template.replace("ENERGY_SUB", f"{energy:.2f}")
        contents = contents.replace("THROUGHPUT_SUB", f"{throughput:.2f}")
        return contents

    def _write_comp_energy_file(self: EcatWriter) -> None:
        compressor_energy = self._get_compressor_energy()
        compressor_throughput = self._get_compressor_throughput()

        file_content = self._build_comp_energy_file_contents(
            compressor_energy, compressor_throughput
        )

        filename = (
            f"{self._datafile_dir}{self._shot_date}GS{self._shot_number}COMP_E.mdt.xml"
        )

        with open(filename, "w") as f:
            f.write(file_content)

    def _write_datafile_names(self: EcatWriter) -> None:
        filename = f"{self._datafile_dir}{self._listfile_name}"
        with open(filename, "a+") as f:
            f.writelines(
                [
                    f"{self._shot_date}GS{self._shot_number:08}{ch}\n"
                    for ch in self._datafile_names
                ]
            )

    def _write_all_images(self: EcatWriter) -> None:
        for image, image_name in zip(self._images, self._image_channels):
            image_filename = f"{self._datafile_dir}{self._shot_date}GS{self._shot_number:08}{image_name}.png"
            dat_filename = f"{self._datafile_dir}{self._shot_date}GS{self._shot_number:08}{image_name}.dat"
            width = image.width
            height = image.height
            self._write_dat_file(dat_filename, image_filename, width, height)
            image.write_to_file(image_filename)

    def _write_dat_file(
        self: EcatWriter, dat_filename, image_filename, image_width, image_height
    ) -> None:
        with open(dat_filename, "w") as f:
            f.write(f"FNAME:{dat_filename}\n")
            f.write(f"DATE:{self._shot_date}\n")
            f.write(f"SECTION:\n")
            f.write(f"TIME:{self._shot_time}\n")
            f.write(f"TIMES:{self._shot_times}\n")
            f.write(f"SHOTNUM:{self._shot_number:08}\n")
            f.write(f"DIM:2\n")
            f.write(f"ARRAY:{width},{height}\n")
            f.write("DATASIZE:EXT_FILE\n")
            f.write("FORMAT:IMAGE\n")
            f.write("BYTEORDER:\n")
            f.write("CISTIME:OFF\n")
            f.write("PARENT:\n")
            f.write("CHANS:1\n")
            f.write("CNAMES:1\n")
            f.write("AXIS_NUM:0\n")
            f.write("UNITS:pixels\n")
            f.write(f"EXT_FILE:{image_filename}\n")
            f.write("EOH]\n")

    def write_all_files(self: EcatWriter) -> None:
        self._generate_datafile_dir()
        self._get_shot_details()
        self._write_all_images()
        self._write_comp_energy_file()
        self._write_datafile_names()
