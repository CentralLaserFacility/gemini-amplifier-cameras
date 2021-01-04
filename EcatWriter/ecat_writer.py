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
        self._amplifier = "N" if amp.upper()[0] == "N" else "S"
        self._listfile_name = "./AAL-FileList.txt"
        self._image_channels = [
            self._amplifier + "_COMP_FF",
            self._amplifier + "_COMP_NF",
            self._amplifier + "_FLUOR",
            self._amplifier + "_INP_NF",
            self._amplifier + "_LEG1_GREEN_NF",
            self._amplifier + "_LEG2_GREEN_NF",
            self._amplifier + "_UNCOMP_NF",
        ]
        suffixes = [".dat", ".mdt.xml", ".png"]
        self._datafile_names = [
            channel + suffix for channel in self._image_channels for suffix in suffixes
        ]
        self._datafile_names.append(self._amplifier + "_COMP_E.mdt.xml")
        self._images = [
            EpicsImage(pv_prefix + ":" + ch[2:]) for ch in self._image_channels
        ]
        self._shot_number_pv = epics.PV(
            pv_prefix + ":SHOT_NUMBER", callback=self._on_shotnumber_change
        )
        self._comp_energy_pv = epics.PV(pv_prefix + ":COMP_ENERGY")
        self._comp_throughput_pv = epics.PV(pv_prefix + ":COMP_THROUGHPUT")
        self._amp_energy_pv = epics.PV(pv_prefix + ":AMP_E")
        self._stop = False
        self._new_shot = False

    def run(self: EcatWriter, interval: float = 0.5) -> None:
        self._stop = False
        while not self._stop:
            if self._new_shot:
                self.write_all_files()
                self._new_shot = False
                time.sleep(interval)

    def stop(self: EcatWriter):
        self._stop = True

    def _on_shotnumber_change(self, **kwargs):
        self._new_shot = True

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
        if energy == None or throughput == None:
            return
        contents = template.replace("DATE_SUB", f"{self._shot_date}")
        contents = contents.replace("SHOTNUM_SUB", f"{self._shot_number:08}")
        contents = contents.replace("ENERGY_SUB", f"{energy:.2f}")
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
        if file_content is None:
            return
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
            mdt_filename = f"{self._datafile_dir}{self._shot_date}GS{self._shot_number:08}{image_name}.mdt.xml"
            self._write_dat_file(dat_filename, image_filename, image)
            self._write_mdt_file(mdt_filename, image_name, image)
            image.write_to_file(image_filename)

    def _get_section_name(self: EcatWriter, filename: str) -> str:
        if "_COMP" in filename:
            section = "COMP"
        elif "_LEG" in filename:
            section = "PUMP"
        elif "_UNCOMP" in filename or "INP" in filename or "FLUOR" in filename:
            section = "UNCOMP"
        else:
            section = "UNKNOWN"
        return f"LA3/{self._amplifier}_{section}/IMAGE"

    def _write_mdt_file(
        self: EcatWriter, mdt_filename: str, image_name: str, image: EpicsImage
    ) -> None:
        section_name = self._get_section_name(mdt_filename)
        with open(mdt_filename, "w") as mdt_file:
            mdt_file.write('<?xml version="1.0" encoding="UTF-8"?>\n')
            mdt_file.write("<GEMINI_LASER_SHOT>\n")
            mdt_file.write(f"<DATE>{self._shot_date}</DATE>\n")
            mdt_file.write("<SHOT>\n")
            mdt_file.write(f"<SHOTNUM>{self._shot_number:08}</SHOTNUM>\n")
            mdt_file.write("<SECTION>\n")
            mdt_file.write(f"<SECTIONNAME>{section_name}</SECTIONNAME>\n")
            mdt_file.write("<CHANNEL>\n")
            mdt_file.write(f"<CHANNELNAME>{image_name}</CHANNELNAME>\n")
            mdt_file.write("<MEASUREMENT>\n")
            mdt_file.write(f"<NAME>{image_name}_INTEGRATION</NAME>\n")
            mdt_file.write("<TYPE>INTEGRATION</TYPE>\n")
            mdt_file.write(f"<VALUE>{image.integration}</VALUE>\n")
            mdt_file.write("<UNITS>Count</UNITS>\n")
            mdt_file.write("</MEASUREMENT>\n")
            mdt_file.write("<MEASUREMENT>\n")
            mdt_file.write(f"<NAME>{image_name}_E</NAME>\n")
            mdt_file.write("<TYPE>E</TYPE>\n")
            mdt_file.write("<VALUE>0.0</VALUE>\n")
            mdt_file.write("<UNITS>Joule</UNITS>\n")
            mdt_file.write("</MEASUREMENT>\n")
            mdt_file.write("<MEASUREMENT>\n")
            mdt_file.write(f"<NAME>{image_name}_XPOS</NAME>\n")
            mdt_file.write("<TYPE>XPOS</TYPE>\n")
            mdt_file.write(f"<VALUE>{image.centroidX}</VALUE>\n")
            mdt_file.write("<UNITS>Pixel</UNITS>\n")
            mdt_file.write("</MEASUREMENT>\n")
            mdt_file.write("<MEASUREMENT>\n")
            mdt_file.write(f"<NAME>{image_name}_YPOS</NAME>\n")
            mdt_file.write("<TYPE>YPOS</TYPE>\n")
            mdt_file.write(f"<VALUE>{image.centroidY}</VALUE>\n")
            mdt_file.write("<UNITS>Pixel</UNITS>\n")
            mdt_file.write("</MEASUREMENT>\n")
            mdt_file.write("</CHANNEL>\n")
            mdt_file.write("</SECTION>\n")
            mdt_file.write("</SHOT>\n")
            mdt_file.write("</GEMINI_LASER_SHOT>\n")

    def _write_dat_file(
        self: EcatWriter,
        dat_filename: str,
        image_filename: str,
        image: EpicsImage,
    ) -> None:
        section_name = self._get_section_name(image_filename)
        with open(dat_filename, "w") as dat_file:
            dat_file.write(f"FNAME:{dat_filename.split('/')[1]}\n")
            dat_file.write(f"DATE:{self._shot_date}\n")
            dat_file.write(f"SECTION:{section_name}\n")
            dat_file.write(f"TIME:{self._shot_time}\n")
            dat_file.write(f"TIMES:{self._shot_time_seconds}\n")
            dat_file.write(f"SHOTNUM:{self._shot_number:08}\n")
            dat_file.write("DIM:2\n")
            dat_file.write(f"ARRAY:{image.width},{image.height}\n")
            dat_file.write("DATASIZE:EXT_FILE\n")
            dat_file.write("FORMAT:IMAGE\n")
            dat_file.write("BYTEORDER:\n")
            dat_file.write("CTSTIME:OFF\n")
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
    writer.run()
