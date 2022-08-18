import pytest
import sys, datetime, os, imghdr, filecmp
import epics
from epics_image import EpicsImage
from ecat_writer import EcatWriter
from pathlib import Path

prefix = "GEM:N_AMP:"
cam_list = ["cam1", "cam2", "cam3", "cam4"]
comp_energy_template_file = os.getcwd() + os.sep + "eCatEnergyTemplate.xml"
ecw = EcatWriter(prefix)


def get_today():
    return datetime.date.today().strftime("%Y%m%d")


def create_filename(root=os.getcwd(), filename="test.txt"):
    return root + os.sep + get_today() + os.sep + filename


def create_comp_e_filename(shot_number):
    return (
        get_today() + os.sep + get_today() + "GS" + str(shot_number) + "COMP_E.mdt.xml"
    )


def shot_number_from_epics():
    return epics.caget(prefix + "SHOT_NUMBER")


def compressor_energy_from_epics():
    return epics.caget(prefix + "COMP_ENERGY")


def compressor_throughput_from_epics():
    return epics.caget(prefix + "COMP_THROUGHPUT")


def amplifier_energy_from_epics():
    return epics.caget(prefix + "AMP_E")


def image_array_data_from_epics(prefix, camera):
    return epics.caget(prefix + camera + ":image1:ArrayData")


def image_width_from_epics(prefix, camera):
    return epics.caget(prefix + camera + ":image1:ArraySize0_RBV")


def image_length_from_epics(prefix, camera):
    return epics.caget(prefix + camera + ":image1:ArraySize1_RBV")


epics_comms_check_mark = pytest.mark.skipif(
    shot_number_from_epics() == None, reason="Can't reach IOC"
)


class ShotGenerator:
    def __init__(self, start_shot_number=10000):
        self.shotnumber = start_shot_number
        self.comp_e_template = self._read_comp_energy_template_file()
        self.data_channels = ["filename1", "filename2", "filename3", "filename4"]

    def _read_comp_energy_template_file(self):
        with open(comp_energy_template_file) as f:
            data = f.read()
        return data

    def _date_and_shot_number(self):
        return get_today() + "GS" + str(self.shotnumber)

    def _fill_in_comp_energy_template(self, energy, throughput):
        contents = self.comp_e_template.replace("ENERGY_SUB", "{0:.2f}".format(energy))
        contents = contents.replace("THROUGHPUT_SUB", "{0:.2f}".format(throughput))
        return contents

    def get_new_shot_filenames(self):
        return [self._date_and_shot_number() + f for f in self.data_channels]

    def next_shot(self):
        self.shotnumber += 1

    def write_comp_energy_xml_file(self, filename, energy, throughput):
        contents = self._fill_in_comp_energy_template(energy, throughput)
        with open(filename, "w") as f:
            f.write(contents)


def test_datafilenames_are_written_to_file():
    data_filenames = []
    file_list_filename = create_filename()
    shot_generator = ShotGenerator()
    for _ in range(100):
        data_filenames.extend(shot_generator.get_new_shot_filenames())
        ecw.write_datafile_names(
            file_list_filename, shot_generator.data_channels, shot_generator.shotnumber
        )
        shot_generator.next_shot()
    filenames_from_file = [l.strip() for l in open(file_list_filename).readlines()]
    assert data_filenames == filenames_from_file
    del shot_generator
    os.remove(file_list_filename)


@epics_comms_check_mark
def test_read_shotnumber():
    shot_number = shot_number_from_epics()
    assert ecw._get_shot_number() == shot_number


@epics_comms_check_mark
def test_read_energy():
    compressor_energy = compressor_energy_from_epics()
    amplifier_energy = amplifier_energy_from_epics()
    assert ecw._get_compressor_energy() == compressor_energy
    assert ecw._get_amplifier_energy() == amplifier_energy


@epics_comms_check_mark
def test_comp_e_energy_file():
    reference_file_name = "reference.xml"
    shot_generator = ShotGenerator()
    compressor_energy = compressor_energy_from_epics()
    compressor_throughput = compressor_throughput_from_epics()
    shot_generator.write_comp_energy_xml_file(
        reference_file_name, compressor_energy, compressor_throughput
    )
    assert filecmp.cmp(reference_file_name, ecw.write_comp_energy_file(), shallow=False)
    del shot_generator
    os.remove(reference_file_name)
    os.remove(create_comp_e_filename(shot_number_from_epics()))


@epics_comms_check_mark
def test_read_image_and_check_dimensions():
    for camera in cam_list:
        width = image_width_from_epics(prefix, camera)
        height = image_length_from_epics(prefix, camera)
        image = image_array_data_from_epics(prefix, camera)
        test_image = EpicsImage(prefix + camera)
        assert test_image.size == image.size
        assert test_image.width == width
        assert test_image.height == height
        assert test_image.size == test_image.width * test_image.height
    del test_image


@epics_comms_check_mark
def test_write_epics_image_to_file():
    image_list = []
    img_type = "jpeg"
    for camera in cam_list:
        test_image = EpicsImage(prefix + camera)
        image_filename = create_filename(filename=camera + "_test.{}".format(img_type))
        image_list.append(image_filename)
        test_image.write_to_file(image_filename)
    del test_image
    for img in image_list:
        assert imghdr.what(img) == img_type
        os.remove(img)

