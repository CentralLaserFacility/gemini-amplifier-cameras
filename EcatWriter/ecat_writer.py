from __future__ import annotations
import epics
import os, datetime, time, sys, threading
from epics_image import EpicsImage
from typing import List
import logging

logger = logging.getLogger(__name__)


def format_time(timestamp: float) -> str:
    timestamp, frac = divmod(timestamp, 1)
    return (
        time.strftime("%H'%M'%S", time.localtime(timestamp)),
        str(round(1.0e5 * frac)),
    )


def get_today() -> str:
    return datetime.date.today().strftime("%Y%m%d")


class EcatWriter:
    def __init__(self, pv_prefix: str, amp: str) -> None:
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
            "GEM:LA3:SHOTNUM", callback=self._on_shotnumber_change
        )
        self._comp_energy_pv = epics.PV(
            pv_prefix + ":COMP_ENERGY", callback=self._on_new_data_received
        )
        self._comp_throughput_pv = epics.PV(
            f"GEM:LA3:CAL:COMPTHRUPUT:{self._amplifier}"
        )
        self._amp_energy_pv = epics.PV(pv_prefix + ":AMP_E")
        self._real_shot = False
        self._shot_number = 0
        self._pv_prefix = pv_prefix
        self._loop_thread = None
        self._stop_requested = False

    def run(self, interval: float = 0.5) -> None:
        if self._loop_thread:
            logger.warning("Already running")
            return
        self._loop_thread = threading.Thread(target=self._run, args=(interval,))
        self._loop_thread.start()

    def _run(self, interval: float = 0.5):
        logger.info(
            f"EcatWriter started for {self._amplifier} amplifier. PV prefix: {self._pv_prefix}"
        )
        self._stop_requested = False
        while not self._stop_requested:
            try:
                time.sleep(interval)
            except KeyboardInterrupt:
                check_answer = input("Definitely quit? [y/N]")
                if check_answer.upper() == "Y":
                    logger.info("EcatWriter stopped")
                    sys.exit()
        else:
            logger.info(f"EcatWriter stopped for {self._amplifier} amplifier")

    def stop(self):
        self._stop_requested = True
        self._loop_thread = None

    def _on_shotnumber_change(self, **kwargs) -> None:
        shot_number = kwargs["value"]
        logger.info(f'New shot number: {shot_number}')
        if "BANG" in shot_number:
            logger.info("Real shot")
            self._real_shot = True

    def _on_new_data_received(self, **kwargs) -> None:
        if self._real_shot:
            try:
                logger.info("Writing data files")
                self._write_all_files()
            except Exception as e:
                logger.error(f"Error while writing files: {str(e)}")
            self._real_shot = False

    def _get_comp_energy_template_contents(self, directory: str = os.getcwd()) -> str:
        filename = directory + os.sep + "eCatEnergyTemplate.xml"
        with open(filename, "r") as f:
            data = f.read()
        return data

    def _get_shot_details(self) -> None:
        self._shot_date = get_today()
        shot_string = self._shot_number_pv.get()
        shot_number = shot_string.split(":")[-1]
        self._shot_number = 0 if shot_number == "TEST" else int(shot_number)
        self._shot_time, self._shot_time_seconds = format_time(
            self._shot_number_pv.timestamp
        )

    def _generate_datafile_dir(self) -> None:
        directory = get_today() + os.sep
        if not os.path.exists(directory):
            try:
                os.makedirs(directory)
            except Exception as e:
                logger.error(f"Failed to create data directory ({directory}): {str(e)}")
        self._datafile_dir = directory

    def _build_comp_energy_file_contents(self, energy: float, throughput: float) -> str:
        try:
            template = self._get_comp_energy_template_contents()
        except Exception as e:
            logger.error(f"Failed to read energy template file: {str(e)}")

        if energy == None or throughput == None:
            logger.error(
                f"Bad data: energy={energy}, throughput={throughput}. File not written"
            )
            return
        contents = template.replace("AMP_SUB", f"{self._amplifier}")
        contents = contents.replace("DATE_SUB", f"{self._shot_date}")
        contents = contents.replace("SHOTNUM_SUB", f"{self._shot_number:08}")
        contents = contents.replace("ENERGY_SUB", f"{energy:.2f}")
        contents = contents.replace("THROUGHPUT_SUB", f"{throughput:.2f}")
        return contents

    def _write_comp_energy_file(self) -> None:
        compressor_throughput = self._comp_throughput_pv.get()
        compressor_energy = self._comp_energy_pv.get()

        filename = f"{self._datafile_dir}{self._shot_date}GS{self._shot_number:08}{self._amplifier}_COMP_E.mdt.xml"

        file_content = self._build_comp_energy_file_contents(
            compressor_energy, compressor_throughput
        )

        if file_content is None:
            logger.error(
                "Unable to build compressor energy file. File won't be written"
            )
            return

        logger.info(f"Writing comp_e file to {filename}")
        with open(filename, "w") as comp_e_file:
            try:
                comp_e_file.write(file_content)
            except Exception as e:
                logger.error(f"Failed to write comp_e file: {str(e)}")

    def _write_datafile_names(self) -> None:
        filename = f"{self._datafile_dir}{self._listfile_name}"
        with open(filename, "a+") as data_file:
            try:
                data_file.writelines(
                    [
                        f"{self._shot_date}GS{self._shot_number:08}{ch}\n"
                        for ch in self._datafile_names
                    ]
                )
            except Exception as e:
                logger.error(f"Failed to update file list: {str(e)}")

    def _write_all_images(self) -> None:
        for image, image_name in zip(self._images, self._image_channels):
            image_filename = f"{self._datafile_dir}{self._shot_date}GS{self._shot_number:08}{image_name}.png"
            dat_filename = f"{self._datafile_dir}{self._shot_date}GS{self._shot_number:08}{image_name}.dat"
            mdt_filename = f"{self._datafile_dir}{self._shot_date}GS{self._shot_number:08}{image_name}.mdt.xml"
            self._write_dat_file(dat_filename, image_name, image, image_filename)
            self._write_mdt_file(mdt_filename, image_name, image)
            image.write_to_file(image_filename)

    def _get_section_name(self, filename: str) -> str:
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
        self, mdt_filename: str, image_name: str, image: EpicsImage
    ) -> None:
        section_name = self._get_section_name(mdt_filename)
        logger.info(f"Writing file {mdt_filename}")
        try:
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
        except Exception as e:
            logger.error(f"Failed to write {mdt_filename}: {str(e)}")

    def _write_dat_file(
        self,
        dat_filename: str,
        image_name: str,
        image: EpicsImage,
        image_filename: str,
    ) -> None:
        section_name = self._get_section_name(image_name)
        logger.info(f"Writing file {dat_filename}")
        try:
            with open(dat_filename, "w") as dat_file:
                dat_file.write(f"FNAME:{dat_filename.split(os.sep)[1]}\n")
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
                dat_file.write(f"EXT_FILE:{image_filename.split(os.sep)[1]}\n")
                dat_file.write("EOH]\n")
        except Exception as e:
            logger.error(f"Failed to write {dat_filename}: {str(e)}")

    def _write_all_files(self) -> None:
        self._generate_datafile_dir()
        self._get_shot_details()
        self._write_all_images()
        self._write_comp_energy_file()
        self._write_datafile_names()


if __name__ == "__main__":
    logging.basicConfig(
        level=logging.DEBUG, format="%(asctime)s %(levelname)-8s: %(message)s"
    )
    writer = EcatWriter("GEM:S_AMP", "south")
    writer.run()
