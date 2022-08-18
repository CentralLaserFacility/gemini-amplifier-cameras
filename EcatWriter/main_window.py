# Based on example from here https://plumberjack.blogspot.com/2019/11/a-qt-gui-for-logging.html

import logging
import sys

import ecat_writer
import epics_image

# Deal with minor differences between PySide2 and PyQt5
try:
    from PySide2 import QtCore, QtGui, QtWidgets
    Signal = QtCore.Signal
    Slot = QtCore.Slot
except ImportError:
    from PyQt5 import QtCore, QtGui, QtWidgets
    Signal = QtCore.pyqtSignal
    Slot = QtCore.pyqtSlot


logger = logging.getLogger(__name__)
all_loggers = [logger, ecat_writer.logger, epics_image.logger]

class Signaller(QtCore.QObject):
    signal = Signal(str, logging.LogRecord)


class QtHandler(logging.Handler):
    def __init__(self, slotfunc, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.signaller = Signaller()
        self.signaller.signal.connect(slotfunc)

    def emit(self, record):
        s = self.format(record)
        self.signaller.signal.emit(s, record)

class EcatWriterWorker(QtCore.QObject):
    def __init__(self, pv_prefix, amp):
        super().__init__()
        self.writer= ecat_writer.EcatWriter(pv_prefix, amp)

    startup = Signal()
    shutdown = Signal() 
    
    @Slot()
    def start(self):
        self.writer.run()

    @Slot()
    def stop(self):
        self.writer.stop()

class Window(QtWidgets.QWidget):

    COLOURS = {
        logging.DEBUG: 'black',
        logging.INFO: 'blue',
        logging.WARNING: 'orange',
        logging.ERROR: 'red',
        logging.CRITICAL: 'purple',
    }

    def __init__(self, app):
        super().__init__()
        self.app = app
        self.textedit = te = QtWidgets.QPlainTextEdit(self)
        f = QtGui.QFont('arial')
        f.setPixelSize(16)
        f.setBold(True)
        te.setFont(f)
        te.setReadOnly(True)
        self.add_logger_handling()
        
        app.aboutToQuit.connect(self.force_quit)

        self.go = QtWidgets.QPushButton("Go", self)
        self.stop= QtWidgets.QPushButton("Stop", self)

        worker = EcatWriterWorker(pv_prefix="GEM:S_AMP", amp="s")
        self.go.clicked.connect(worker.start)
        self.stop.clicked.connect(worker.stop)

        self.worker_thread = self.start_thread(worker)

        layout = QtWidgets.QVBoxLayout(self)
        layout.addWidget(te)
        layout.addWidget(self.go)
        layout.addWidget(self.stop)
        self.resize(1000, 400)
    

    def add_logger_handling(self):
        handler = QtHandler(self.update_status)
        fs = "%(asctime)s %(levelname)-8s %(message)s"
        handler.setFormatter(logging.Formatter(fs))
        for l in all_loggers:
            l.addHandler(handler)
        
    def kill_thread(self):
        # Stop the EcatWriter from looping, then stop the QThread.
        self.worker_thread.requestInterruption()
        if self.worker_thread.isRunning():
            self.worker_thread.quit()
            self.worker_thread.wait()
        else:
            logger.debug("Worker has already exited")

    def force_quit(self):
        if self.worker_thread.isRunning():
            self.kill_thread()

    def start_thread(self, worker):
        worker_thread = QtCore.QThread()
        worker_thread.start()
        worker.moveToThread(worker_thread)
        worker_thread.worker=worker
        return worker_thread

    @Slot(str, logging.LogRecord)
    def update_status(self, status, record):
        color = self.COLOURS.get(record.levelno, 'black')
        s = '<pre><font color="%s">%s</font></pre>' % (color, status)
        self.textedit.appendHtml(s)


def main():
    logging.getLogger().setLevel(logging.DEBUG)
    app = QtWidgets.QApplication(sys.argv)
    example = Window(app)
    example.show()
    sys.exit(app.exec_())

if __name__=='__main__':
    main()