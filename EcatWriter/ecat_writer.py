from __future__ import annotations
import epics
import os, datetime, numpy, time
from epics_image import EpicsImage
from typing import List


def format_time(timestamp: float) -> str:
    timestamp, frac = divmod(timestamp, 1)
    return (
        time.strftime("%H'%M'%S", time.localtime(timestamp)),
        str(round(1.0e5 * frac)),
    )


def get_today() -> str:
    return datetime.date.today().strftime("%Y%m%d")


class EcatWriter:
    def __init__(self: EcatWriter, pv_prefix: str, amp: str) -> None:
        if amp.upper() not in ["N", "NORTH", "SOUTH", "S"]:
            raise ValueError
        amp_code = amp.upper()[0]
        self._listfile_name = "./AAL-FileList.txt"
        self._image_channels = [
            amp_code + "_COMP_FF",
            amp_code + "_COMP_NF",
            amp_code + "_FLUOR",
            amp_code + "_INP_NF",
            amp_code + "_LEG1_GREEN_NF",
            amp_code + "_LEG2_GREEN_NF",
            amp_code + "_UNCOMP_NF",
        ]
        suffixes = [".dat", ".mdt.xml", ".png"]
        self._datafile_names = [
            channel + suffix for channel in self._image_channels for suffix in suffixes
        ]
        self._datafile_names.append(amp_code + "_COMP_E.mdt.xml")
        self._images = [
            EpicsImage(pv_prefix + ":" + ch[2:]) for ch in self._image_channels
        ]
        self._shot_number_pv = epics.PV(pv_prefix + ":SHOT_NUMBER")
        self._comp_energy_pv = epics.PV(pv_prefix + ":COMP_ENERGY")
        self._comp_throughput_pv = epics.PV(pv_prefix + ":COMP_THROUGHPUT")
        self._amp_energy_pv = epics.PV(pv_prefix + ":AMP_E")

    def _get_comp_energy_template_contents(
        self: EcatWriter, directory: str = os.getcwd()
    ) -> str:
        filename = directory + os.sep + "eCatEnergyTemplate.xml"
        with open(filename, "r") as f:
            data = f.read()
        return data

    def _get_shot_details(self: EcatWriter) -> None:
        self._shot_date = get_today()
        self._shot_number = self._shot_number_pv.get()
        self._shot_time, self._shot_time_seconds = format_time(
            self._shot_number_pv.timestamp
        )

    def _generate_datafile_dir(self: EcatWriter) -> None:
        directory = get_today() + os.sep
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
        compressor_energy = self._comp_energy_pv.get()
        compressor_throughput = self._comp_throughput_pv.get()

        file_content = self._build_comp_energy_file_contents(
            compressor_energy, compressor_throughput
        )

        filename = (
            f"{self._datafile_dir}{self._shot_date}GS{self._shot_number}COMP_E.mdt.xml"
        )

        with open(filename, "w") as comp_e_file:
            comp_e_file.write(file_content)

    def _write_datafile_names(self: EcatWriter) -> None:
        filename = f"{self._datafile_dir}{self._listfile_name}"
        with open(filename, "a+") as data_file:
            data_file.writelines(
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
        with open(dat_filename, "w") as dat_file:
            dat_file.write(f"FNAME:{dat_filename.split('/')[1]}\n")
            dat_file.write(f"DATE:{self._shot_date}\n")
            dat_file.write("SECTION:\n")
            dat_file.write(f"TIME:{self._shot_time}\n")
            dat_file.write(f"TIMES:{self._shot_time_seconds}\n")
            dat_file.write(f"SHOTNUM:{self._shot_number:08}\n")
            dat_file.write("DIM:2\n")
            dat_file.write(f"ARRAY:{image_width},{image_height}\n")
            dat_file.write("DATASIZE:EXT_FILE\n")
            dat_file.write("FORMAT:IMAGE\n")
            dat_file.write("BYTEORDER:\n")
            dat_file.write("CISTIME:OFF\n")
            dat_file.write("PARENT:\n")
            dat_file.write("CHANS:1\n")
            dat_file.write("CNAMES:1\n")
            dat_file.write("AXIS_NUM:0\n")
            dat_file.write("UNITS:pixels\n")
            dat_file.write(f"EXT_FILE:{image_filename.split('/')[1]}\n")
            dat_file.write("EOH]\n")

    def write_all_files(self: EcatWriter) -> None:
        self._generate_datafile_dir()
        self._get_shot_details()
        self._write_all_images()
        self._write_comp_energy_file()
        self._write_datafile_names()


if __name__ == "__main__":
    writer = EcatWriter("GEM:N_AMP", "north")

    def write_files(**kwargs):
        writer.write_all_files()

    shot_pv = epics.PV("GEM:N_AMP:SHOT_NUMBER", callback=write_files)
    input()
