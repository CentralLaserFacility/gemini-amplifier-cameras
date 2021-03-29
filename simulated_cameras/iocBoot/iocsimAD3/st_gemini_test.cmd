#!../../bin/linux-x86_64/simAD3

## You may have to change simAD3 to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet("PREFIX", "GEM:N_AMP:")
epicsEnvSet("CAM1", "UNCOMP_NF")
epicsEnvSet("CAM2", "INP_NF")
epicsEnvSet("CAM3", "COMP_NF")
epicsEnvSet("CAM4", "COMP_FF")
epicsEnvSet("CAM5", "FLUOR")
epicsEnvSet("CAM6", "LEG1_GREEN_NF")
epicsEnvSet("CAM7", "LEG2_GREEN_NF")
epicsEnvSet("CAM8", "PINHOLE")
epicsEnvSet("QSIZE",  "20")
epicsEnvSet("XSIZE2",  "160")
epicsEnvSet("YSIZE2",  "120")
epicsEnvSet("XSIZE",  "320")
epicsEnvSet("YSIZE",  "240")
epicsEnvSet("NCHANS", "2048")
epicsEnvSet("CBUFFS", "500")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "13000000")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/simAD3.dbd"
simAD3_registerRecordDeviceDriver pdbbase

## Load record instances


simDetectorConfig("$(PREFIX)$(CAM1)", $(XSIZE), $(YSIZE), 1, 0, 0)
simDetectorConfig("$(PREFIX)$(CAM2)", $(XSIZE2), $(YSIZE2), 1, 0, 0)
simDetectorConfig("$(PREFIX)$(CAM3)", $(XSIZE2), $(YSIZE2), 1, 0, 0)
simDetectorConfig("$(PREFIX)$(CAM4)", $(XSIZE2), $(YSIZE2), 1, 0, 0)
simDetectorConfig("$(PREFIX)$(CAM5)", $(XSIZE2), $(YSIZE2), 1, 0, 0)
simDetectorConfig("$(PREFIX)$(CAM6)", $(XSIZE2), $(YSIZE2), 1, 0, 0)
simDetectorConfig("$(PREFIX)$(CAM7)", $(XSIZE2), $(YSIZE2), 1, 0, 0)
simDetectorConfig("$(PREFIX)$(CAM8)", $(XSIZE2), $(YSIZE2), 1, 0, 0)
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM1):,PORT=$(PREFIX)$(CAM1),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM2):,PORT=$(PREFIX)$(CAM2),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM3):,PORT=$(PREFIX)$(CAM3),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM4):,PORT=$(PREFIX)$(CAM4),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM5):,PORT=$(PREFIX)$(CAM5),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM6):,PORT=$(PREFIX)$(CAM6),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM7):,PORT=$(PREFIX)$(CAM7),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM8):,PORT=$(PREFIX)$(CAM8),ADDR=0,TIMEOUT=1")

# Create ROI plugins
###################################
NDROIConfigure("$(PREFIX)$(CAM1):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM1)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDROIConfigure("$(PREFIX)$(CAM2):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM2)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDROIConfigure("$(PREFIX)$(CAM3):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM3)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDROIConfigure("$(PREFIX)$(CAM4):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM4)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDROIConfigure("$(PREFIX)$(CAM5):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM5)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDROIConfigure("$(PREFIX)$(CAM6):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM6)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDROIConfigure("$(PREFIX)$(CAM7):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM7)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDROIConfigure("$(PREFIX)$(CAM8):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM8)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM1):,R=ROI1:,  PORT=$(PREFIX)$(CAM1):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM1)")
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM2):,R=ROI1:,  PORT=$(PREFIX)$(CAM2):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM2)")
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM3):,R=ROI1:,  PORT=$(PREFIX)$(CAM3):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM3)")
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM4):,R=ROI1:,  PORT=$(PREFIX)$(CAM4):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM4)")
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM5):,R=ROI1:,  PORT=$(PREFIX)$(CAM5):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM5)")
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM6):,R=ROI1:,  PORT=$(PREFIX)$(CAM6):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM6)")
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM7):,R=ROI1:,  PORT=$(PREFIX)$(CAM7):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM7)")
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM8):,R=ROI1:,  PORT=$(PREFIX)$(CAM8):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM8)")

# Create transform plugins
###################################
NDTransformConfigure("$(PREFIX)$(CAM1):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM1):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDTransformConfigure("$(PREFIX)$(CAM2):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM2):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDTransformConfigure("$(PREFIX)$(CAM3):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM3):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDTransformConfigure("$(PREFIX)$(CAM4):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM4):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDTransformConfigure("$(PREFIX)$(CAM5):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM5):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDTransformConfigure("$(PREFIX)$(CAM6):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM6):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDTransformConfigure("$(PREFIX)$(CAM7):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM7):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDTransformConfigure("$(PREFIX)$(CAM8):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM8):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM1):,R=Trans1:,  PORT=$(PREFIX)$(CAM1):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM1):ROI")
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM2):,R=Trans1:,  PORT=$(PREFIX)$(CAM2):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM2):ROI")
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM3):,R=Trans1:,  PORT=$(PREFIX)$(CAM3):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM3):ROI")
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM4):,R=Trans1:,  PORT=$(PREFIX)$(CAM4):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM4):ROI")
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM5):,R=Trans1:,  PORT=$(PREFIX)$(CAM5):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM5):ROI")
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM6):,R=Trans1:,  PORT=$(PREFIX)$(CAM6):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM6):ROI")
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM7):,R=Trans1:,  PORT=$(PREFIX)$(CAM7):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM7):ROI")
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM8):,R=Trans1:,  PORT=$(PREFIX)$(CAM8):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM8):ROI")

# Create statistics plugins
###################################
NDStatsConfigure("$(PREFIX)$(CAM1):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM1):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDStatsConfigure("$(PREFIX)$(CAM2):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM2):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDStatsConfigure("$(PREFIX)$(CAM3):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM3):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDStatsConfigure("$(PREFIX)$(CAM4):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM4):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDStatsConfigure("$(PREFIX)$(CAM5):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM5):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDStatsConfigure("$(PREFIX)$(CAM6):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM6):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDStatsConfigure("$(PREFIX)$(CAM7):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM7):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
NDStatsConfigure("$(PREFIX)$(CAM8):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM8):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM1):,R=Stats1:,  PORT=$(PREFIX)$(CAM1):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM1):TRANS")
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM2):,R=Stats1:,  PORT=$(PREFIX)$(CAM2):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE2),YSIZE=$(YSIZE2),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM2):TRANS")
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM3):,R=Stats1:,  PORT=$(PREFIX)$(CAM3):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE2),YSIZE=$(YSIZE2),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM3):TRANS")
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM4):,R=Stats1:,  PORT=$(PREFIX)$(CAM4):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE2),YSIZE=$(YSIZE2),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM4):TRANS")
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM5):,R=Stats1:,  PORT=$(PREFIX)$(CAM5):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE2),YSIZE=$(YSIZE2),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM5):TRANS")
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM6):,R=Stats1:,  PORT=$(PREFIX)$(CAM6):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE2),YSIZE=$(YSIZE2),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM6):TRANS")
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM7):,R=Stats1:,  PORT=$(PREFIX)$(CAM7):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE2),YSIZE=$(YSIZE2),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM7):TRANS")
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM8):,R=Stats1:,  PORT=$(PREFIX)$(CAM8):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE2),YSIZE=$(YSIZE2),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM8):TRANS")
NDTimeSeriesConfigure("$(PREFIX)$(CAM1):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM1):STATS", 1, 23)
NDTimeSeriesConfigure("$(PREFIX)$(CAM2):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM2):STATS", 1, 23)
NDTimeSeriesConfigure("$(PREFIX)$(CAM3):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM3):STATS", 1, 23)
NDTimeSeriesConfigure("$(PREFIX)$(CAM4):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM4):STATS", 1, 23)
NDTimeSeriesConfigure("$(PREFIX)$(CAM5):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM5):STATS", 1, 23)
NDTimeSeriesConfigure("$(PREFIX)$(CAM6):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM6):STATS", 1, 23)
NDTimeSeriesConfigure("$(PREFIX)$(CAM7):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM7):STATS", 1, 23)
NDTimeSeriesConfigure("$(PREFIX)$(CAM8):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM8):STATS", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM1):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM1):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM1):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM2):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM2):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM2):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM3):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM3):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM3):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM4):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM4):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM4):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM5):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM5):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM5):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM6):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM6):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM6):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM7):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM7):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM7):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM8):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM8):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM8):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")


# Create an overlay plugin with 1 overlay for the centroid
###########################################################
NDOverlayConfigure("$(PREFIX)$(CAM1):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM1):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
NDOverlayConfigure("$(PREFIX)$(CAM2):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM2):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
NDOverlayConfigure("$(PREFIX)$(CAM3):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM3):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
NDOverlayConfigure("$(PREFIX)$(CAM4):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM4):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
NDOverlayConfigure("$(PREFIX)$(CAM5):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM5):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
NDOverlayConfigure("$(PREFIX)$(CAM6):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM6):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
NDOverlayConfigure("$(PREFIX)$(CAM7):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM7):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
NDOverlayConfigure("$(PREFIX)$(CAM8):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM8):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM1):,R=Over1:, PORT=$(PREFIX)$(CAM1):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM1):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM1):,R=Over1:1:,NAME=fiducial,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM1):OVER,ADDR=0,TIMEOUT=1")
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM2):,R=Over1:, PORT=$(PREFIX)$(CAM2):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM2):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM2):,R=Over1:1:,NAME=fiducial,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM2):OVER,ADDR=0,TIMEOUT=1")
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM3):,R=Over1:, PORT=$(PREFIX)$(CAM3):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM3):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM3):,R=Over1:1:,NAME=Centroid,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM3):OVER,ADDR=0,TIMEOUT=1")
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM4):,R=Over1:, PORT=$(PREFIX)$(CAM4):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM4):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM4):,R=Over1:1:,NAME=Centroid,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM4):OVER,ADDR=0,TIMEOUT=1")
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM5):,R=Over1:, PORT=$(PREFIX)$(CAM5):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM5):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM5):,R=Over1:1:,NAME=fiducial,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM5):OVER,ADDR=0,TIMEOUT=1")
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM6):,R=Over1:, PORT=$(PREFIX)$(CAM6):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM6):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM6):,R=Over1:1:,NAME=fiducial,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM6):OVER,ADDR=0,TIMEOUT=1")
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM7):,R=Over1:, PORT=$(PREFIX)$(CAM7):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM7):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM7):,R=Over1:1:,NAME=Centroid,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM7):OVER,ADDR=0,TIMEOUT=1")
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM8):,R=Over1:, PORT=$(PREFIX)$(CAM8):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM8):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM8):,R=Over1:1:,NAME=Centroid,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM8):OVER,ADDR=0,TIMEOUT=1")

# standard arrays plugin
###############################
NDStdArraysConfigure("$(PREFIX)$(CAM1):Image", 3, 0, "$(PREFIX)$(CAM1):OVER", 0, 0)
NDStdArraysConfigure("$(PREFIX)$(CAM2):Image", 3, 0, "$(PREFIX)$(CAM2):OVER", 0, 0)
NDStdArraysConfigure("$(PREFIX)$(CAM3):Image", 3, 0, "$(PREFIX)$(CAM3):OVER", 0, 0)
NDStdArraysConfigure("$(PREFIX)$(CAM4):Image", 3, 0, "$(PREFIX)$(CAM4):OVER", 0, 0)
NDStdArraysConfigure("$(PREFIX)$(CAM5):Image", 3, 0, "$(PREFIX)$(CAM5):OVER", 0, 0)
NDStdArraysConfigure("$(PREFIX)$(CAM6):Image", 3, 0, "$(PREFIX)$(CAM6):OVER", 0, 0)
NDStdArraysConfigure("$(PREFIX)$(CAM7):Image", 3, 0, "$(PREFIX)$(CAM7):OVER", 0, 0)
NDStdArraysConfigure("$(PREFIX)$(CAM8):Image", 3, 0, "$(PREFIX)$(CAM8):OVER", 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM1):,R=image1:,PORT=$(PREFIX)$(CAM1):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM1):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=76800")
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM2):,R=image1:,PORT=$(PREFIX)$(CAM2):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM2):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=19200")
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM3):,R=image1:,PORT=$(PREFIX)$(CAM3):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM3):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=19200")
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM4):,R=image1:,PORT=$(PREFIX)$(CAM4):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM4):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=19200")
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM5):,R=image1:,PORT=$(PREFIX)$(CAM5):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM5):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=19200")
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM6):,R=image1:,PORT=$(PREFIX)$(CAM6):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM6):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=19200")
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM7):,R=image1:,PORT=$(PREFIX)$(CAM7):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM7):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=19200")
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM8):,R=image1:,PORT=$(PREFIX)$(CAM8):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM8):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=19200")


#< $(ADCORE)/iocBoot/commonPlugins.cmd
#set_requestfile_path("$(ADSIMDETECTOR)/simDetectorApp/Db")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=tineHost"

dbpf $(PREFIX)$(CAM1):AcquireTime 0.2
dbpf $(PREFIX)$(CAM1):Acquire 1
dbpf $(PREFIX)$(CAM1):ArrayCallbacks 1
dbpf $(PREFIX)$(CAM1):image1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM1):ROI1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM1):Trans1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM1):Stats1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM1):Stats1:TS:EnableCallbacks 1
dbpf $(PREFIX)$(CAM1):Over1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM1):Over1:1:Use 1
dbpf $(PREFIX)$(CAM1):SimMode 1
dbpf $(PREFIX)$(CAM1):Gain 80
dbpf $(PREFIX)$(CAM1):PeakWidthX 10
dbpf $(PREFIX)$(CAM1):PeakWidthY 20
dbpf $(PREFIX)$(CAM1):PeakStartX 80
dbpf $(PREFIX)$(CAM1):PeakStartY 40
dbpf $(PREFIX)$(CAM1):Noise 20
dbpf $(PREFIX)$(CAM1):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM1):Stats1:CentroidThreshold 20
dbpf $(PREFIX)$(CAM1):Over1:1:WidthX 2
dbpf $(PREFIX)$(CAM1):Over1:1:DrawMode 1
dbpf $(PREFIX)$(CAM1):Over1:1:Red 0
dbpf $(PREFIX)$(CAM1):Over1:1:Green 200
dbpf $(PREFIX)$(CAM1):Over1:1:Blue 0
dbpf $(PREFIX)$(CAM1):Over1:1:SizeX 10

dbpf $(PREFIX)$(CAM2):AcquireTime 0.2
dbpf $(PREFIX)$(CAM2):Acquire 1
dbpf $(PREFIX)$(CAM2):ArrayCallbacks 1
dbpf $(PREFIX)$(CAM2):image1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM2):ROI1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM2):Trans1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM2):Stats1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM2):Stats1:TS:EnableCallbacks 1
dbpf $(PREFIX)$(CAM2):Over1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM2):SimMode 1
dbpf $(PREFIX)$(CAM2):Gain 20
dbpf $(PREFIX)$(CAM2):PeakWidthX 8
dbpf $(PREFIX)$(CAM2):PeakWidthY 16
dbpf $(PREFIX)$(CAM2):PeakStartX 30
dbpf $(PREFIX)$(CAM2):PeakStartY 20
dbpf $(PREFIX)$(CAM2):Noise 20
dbpf $(PREFIX)$(CAM2):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM2):Stats1:CentroidThreshold 20
dbpf $(PREFIX)$(CAM2):Over1:1:WidthX 2
dbpf $(PREFIX)$(CAM2):Over1:1:DrawMode 1
dbpf $(PREFIX)$(CAM2):Over1:1:Red 0
dbpf $(PREFIX)$(CAM2):Over1:1:Green 200
dbpf $(PREFIX)$(CAM2):Over1:1:Blue 0
dbpf $(PREFIX)$(CAM2):Over1:1:SizeX 10


dbpf $(PREFIX)$(CAM3):AcquireTime 0.2
dbpf $(PREFIX)$(CAM3):Acquire 1
dbpf $(PREFIX)$(CAM3):ArrayCallbacks 1
dbpf $(PREFIX)$(CAM3):image1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM3):ROI1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM3):Trans1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM3):Stats1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM3):Stats1:TS:EnableCallbacks 1
dbpf $(PREFIX)$(CAM3):Over1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM3):SimMode 1
dbpf $(PREFIX)$(CAM3):PeakWidthX 20
dbpf $(PREFIX)$(CAM3):PeakWidthY 20
dbpf $(PREFIX)$(CAM3):PeakStartX 30
dbpf $(PREFIX)$(CAM3):PeakStartY 30
dbpf $(PREFIX)$(CAM3):Gain 10
dbpf $(PREFIX)$(CAM3):Noise 5
dbpf $(PREFIX)$(CAM3):PeakNumX 1
dbpf $(PREFIX)$(CAM3):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM3):Stats1:CentroidThreshold 20
#dbpf $(PREFIX)$(CAM3):Over1:1:CenterXLink.DOL "$(PREFIX)$(CAM3):Stats1:CentroidX_RBV CP"
#dbpf $(PREFIX)$(CAM3):Over1:1:CenterYLink.DOL "$(PREFIX)$(CAM3):Stats1:CentroidY_RBV CP"
dbpf $(PREFIX)$(CAM3):Over1:1:WidthX 2
dbpf $(PREFIX)$(CAM3):Over1:1:DrawMode 1
dbpf $(PREFIX)$(CAM3):Over1:1:Red 0
dbpf $(PREFIX)$(CAM3):Over1:1:Green 200
dbpf $(PREFIX)$(CAM3):Over1:1:Blue 0
dbpf $(PREFIX)$(CAM3):Over1:1:SizeX 10

dbpf $(PREFIX)$(CAM5):AcquireTime 0.2
dbpf $(PREFIX)$(CAM5):Acquire 1
dbpf $(PREFIX)$(CAM5):ArrayCallbacks 1
dbpf $(PREFIX)$(CAM5):image1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM5):ROI1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM5):Trans1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM5):Stats1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM5):Stats1:TS:EnableCallbacks 1
dbpf $(PREFIX)$(CAM5):Over1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM5):SimMode 1
dbpf $(PREFIX)$(CAM5):PeakWidthX 10
dbpf $(PREFIX)$(CAM5):PeakWidthY 10
dbpf $(PREFIX)$(CAM5):PeakStartX 80
dbpf $(PREFIX)$(CAM5):PeakStartY 100
dbpf $(PREFIX)$(CAM5):Gain 10
dbpf $(PREFIX)$(CAM5):Noise 5
dbpf $(PREFIX)$(CAM5):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM5):Stats1:CentroidThreshold 5
#dbpf $(PREFIX)$(CAM5):Over1:1:CenterXLink.DOL "$(PREFIX)$(CAM5):Stats1:CentroidX_RBV CP"
#dbpf $(PREFIX)$(CAM5):Over1:1:CenterYLink.DOL "$(PREFIX)$(CAM5):Stats1:CentroidY_RBV CP"
dbpf $(PREFIX)$(CAM5):Over1:1:WidthX 2
#dbpf $(PREFIX)$(CAM5):Over1:1:WidthYLink.DOL "$(PREFIX)$(CAM5):Over1:1:WidthX_RBV CP"
dbpf $(PREFIX)$(CAM5):Over1:1:DrawMode 1
dbpf $(PREFIX)$(CAM5):Over1:1:Red 0
dbpf $(PREFIX)$(CAM5):Over1:1:Green 200
dbpf $(PREFIX)$(CAM5):Over1:1:Blue 0
dbpf $(PREFIX)$(CAM5):Over1:1:SizeX 10
#dbpf $(PREFIX)$(CAM5):Over1:1:SizeYLink.DOL "$(PREFIX)$(CAM5):Over1:1:SizeX_RBV CP"

dbpf $(PREFIX)$(CAM4):AcquireTime 0.2
dbpf $(PREFIX)$(CAM4):Acquire 1
dbpf $(PREFIX)$(CAM4):ArrayCallbacks 1
dbpf $(PREFIX)$(CAM4):image1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM4):ROI1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM4):Trans1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM4):Stats1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM4):Stats1:TS:EnableCallbacks 1
dbpf $(PREFIX)$(CAM4):Over1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM4):SimMode 1
dbpf $(PREFIX)$(CAM4):PeakWidthX 10
dbpf $(PREFIX)$(CAM4):PeakWidthY 10
dbpf $(PREFIX)$(CAM4):PeakStartX 80
dbpf $(PREFIX)$(CAM4):PeakStartY 100
dbpf $(PREFIX)$(CAM4):Gain 100
dbpf $(PREFIX)$(CAM4):Noise 20
dbpf $(PREFIX)$(CAM4):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM4):Stats1:CentroidThreshold 5
#dbpf $(PREFIX)$(CAM4):Over1:1:CenterXLink.DOL "$(PREFIX)$(CAM4):Stats1:CentroidX_RBV CP"
#dbpf $(PREFIX)$(CAM4):Over1:1:CenterYLink.DOL "$(PREFIX)$(CAM4):Stats1:CentroidY_RBV CP"
dbpf $(PREFIX)$(CAM4):Over1:1:WidthX 2
#dbpf $(PREFIX)$(CAM4):Over1:1:WidthYLink.DOL "$(PREFIX)$(CAM4):Over1:1:WidthX_RBV CP"
dbpf $(PREFIX)$(CAM4):Over1:1:DrawMode 1
dbpf $(PREFIX)$(CAM4):Over1:1:Red 0
dbpf $(PREFIX)$(CAM4):Over1:1:Green 200
dbpf $(PREFIX)$(CAM4):Over1:1:Blue 0
dbpf $(PREFIX)$(CAM4):Over1:1:SizeX 10


dbpf $(PREFIX)$(CAM6):AcquireTime 0.2
dbpf $(PREFIX)$(CAM6):Acquire 1
dbpf $(PREFIX)$(CAM6):ArrayCallbacks 1
dbpf $(PREFIX)$(CAM6):image1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM6):ROI1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM6):Trans1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM6):Stats1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM6):Stats1:TS:EnableCallbacks 1
dbpf $(PREFIX)$(CAM6):Over1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM6):SimMode 1
dbpf $(PREFIX)$(CAM6):PeakWidthX 10
dbpf $(PREFIX)$(CAM6):PeakWidthY 10
dbpf $(PREFIX)$(CAM6):PeakStartX 80
dbpf $(PREFIX)$(CAM6):PeakStartY 100
dbpf $(PREFIX)$(CAM6):Gain 100
dbpf $(PREFIX)$(CAM6):Noise 50
dbpf $(PREFIX)$(CAM6):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM6):Stats1:CentroidThreshold 5
#dbpf $(PREFIX)$(CAM6):Over1:1:CenterXLink.DOL "$(PREFIX)$(CAM6):Stats1:CentroidX_RBV CP"
#dbpf $(PREFIX)$(CAM6):Over1:1:CenterYLink.DOL "$(PREFIX)$(CAM6):Stats1:CentroidY_RBV CP"
dbpf $(PREFIX)$(CAM6):Over1:1:WidthX 2
#dbpf $(PREFIX)$(CAM6):Over1:1:WidthYLink.DOL "$(PREFIX)$(CAM6):Over1:1:WidthX_RBV CP"
dbpf $(PREFIX)$(CAM6):Over1:1:DrawMode 1
dbpf $(PREFIX)$(CAM6):Over1:1:Red 0
dbpf $(PREFIX)$(CAM6):Over1:1:Green 200
dbpf $(PREFIX)$(CAM6):Over1:1:Blue 0
dbpf $(PREFIX)$(CAM6):Over1:1:SizeX 10


dbpf $(PREFIX)$(CAM7):AcquireTime 0.2
dbpf $(PREFIX)$(CAM7):Acquire 1
dbpf $(PREFIX)$(CAM7):ArrayCallbacks 1
dbpf $(PREFIX)$(CAM7):image1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM7):ROI1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM7):Trans1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM7):Stats1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM7):Stats1:TS:EnableCallbacks 1
dbpf $(PREFIX)$(CAM7):Over1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM7):SimMode 1
dbpf $(PREFIX)$(CAM7):PeakWidthX 10
dbpf $(PREFIX)$(CAM7):PeakWidthY 10
dbpf $(PREFIX)$(CAM7):PeakStartX 80
dbpf $(PREFIX)$(CAM7):PeakStartY 100
dbpf $(PREFIX)$(CAM7):Gain 10
dbpf $(PREFIX)$(CAM7):Noise 50
dbpf $(PREFIX)$(CAM7):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM7):Stats1:CentroidThreshold 5
#dbpf $(PREFIX)$(CAM7):Over1:1:CenterXLink.DOL "$(PREFIX)$(CAM7):Stats1:CentroidX_RBV CP"
#dbpf $(PREFIX)$(CAM7):Over1:1:CenterYLink.DOL "$(PREFIX)$(CAM7):Stats1:CentroidY_RBV CP"
dbpf $(PREFIX)$(CAM7):Over1:1:WidthX 2
#dbpf $(PREFIX)$(CAM7):Over1:1:WidthYLink.DOL "$(PREFIX)$(CAM7):Over1:1:WidthX_RBV CP"
dbpf $(PREFIX)$(CAM7):Over1:1:DrawMode 1
dbpf $(PREFIX)$(CAM7):Over1:1:Red 0
dbpf $(PREFIX)$(CAM7):Over1:1:Green 200
dbpf $(PREFIX)$(CAM7):Over1:1:Blue 0
dbpf $(PREFIX)$(CAM7):Over1:1:SizeX 10


dbpf $(PREFIX)$(CAM8):AcquireTime 0.2
dbpf $(PREFIX)$(CAM8):Acquire 1
dbpf $(PREFIX)$(CAM8):ArrayCallbacks 1
dbpf $(PREFIX)$(CAM8):image1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM8):ROI1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM8):Trans1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM8):Stats1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM8):Stats1:TS:EnableCallbacks 1
dbpf $(PREFIX)$(CAM8):Over1:EnableCallbacks 1
dbpf $(PREFIX)$(CAM8):SimMode 1
dbpf $(PREFIX)$(CAM8):PeakWidthX 30
dbpf $(PREFIX)$(CAM8):PeakWidthY 40
dbpf $(PREFIX)$(CAM8):PeakStartX 80
dbpf $(PREFIX)$(CAM8):PeakStartY 60
dbpf $(PREFIX)$(CAM8):Gain 10
dbpf $(PREFIX)$(CAM8):Noise 50
dbpf $(PREFIX)$(CAM8):Stats1:ComputeCentroid 1
dbpf $(PREFIX)$(CAM8):Stats1:CentroidThreshold 5
#dbpf $(PREFIX)$(CAM8):Over1:1:CenterXLink.DOL "$(PREFIX)$(CAM8):Stats1:CentroidX_RBV CP"
#dbpf $(PREFIX)$(CAM8):Over1:1:CenterYLink.DOL "$(PREFIX)$(CAM8):Stats1:CentroidY_RBV CP"
dbpf $(PREFIX)$(CAM8):Over1:1:WidthX 2
#dbpf $(PREFIX)$(CAM8):Over1:1:WidthYLink.DOL "$(PREFIX)$(CAM8):Over1:1:WidthX_RBV CP"
dbpf $(PREFIX)$(CAM8):Over1:1:DrawMode 1
dbpf $(PREFIX)$(CAM8):Over1:1:Red 0
dbpf $(PREFIX)$(CAM8):Over1:1:Green 200
dbpf $(PREFIX)$(CAM8):Over1:1:Blue 0
dbpf $(PREFIX)$(CAM8):Over1:1:SizeX 10
