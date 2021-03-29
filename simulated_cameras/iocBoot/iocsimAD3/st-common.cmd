
epicsEnvSet("PREFIX", "GEM:N_AMP:")
epicsEnvSet("QSIZE",  "20")
epicsEnvSet("NCHANS", "2048")
epicsEnvSet("CBUFFS", "500")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "13000000")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/simAD3.dbd"
simAD3_registerRecordDeviceDriver pdbbase

## Load record instances

simDetectorConfig("$(PREFIX)$(CAM)", $(XSIZE), $(YSIZE), 1, 0, 0)
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template","P=$(PREFIX),R=$(CAM):,PORT=$(PREFIX)$(CAM),ADDR=0,TIMEOUT=1")

# Create ROI plugins
###################################
NDROIConfigure("$(PREFIX)$(CAM):ROI", $(QSIZE), 0, "$(PREFIX)$(CAM)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template", "P=$(PREFIX)$(CAM):,R=ROI1:,  PORT=$(PREFIX)$(CAM):ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM)")

# Create transform plugins
###################################
NDTransformConfigure("$(PREFIX)$(CAM):TRANS", $(QSIZE), 0, "$(PREFIX)$(CAM):ROI", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDTransform.template", "P=$(PREFIX)$(CAM):,R=Trans1:,  PORT=$(PREFIX)$(CAM):TRANS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM):ROI")

# Create statistics plugins
###################################
NDStatsConfigure("$(PREFIX)$(CAM):STATS", $(QSIZE), 0, "$(PREFIX)$(CAM):TRANS", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",  "P=$(PREFIX)$(CAM):,R=Stats1:,  PORT=$(PREFIX)$(CAM):STATS,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PREFIX)$(CAM):TRANS")

NDTimeSeriesConfigure("$(PREFIX)$(CAM):STATS_TS", $(QSIZE), 0, "$(PREFIX)$(CAM):STATS", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX)$(CAM):,R=Stats1:TS:, PORT=$(PREFIX)$(CAM):STATS_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM):STATS,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")

# Create an overlay plugin with 1 overlay for the centroid
###########################################################
NDOverlayConfigure("$(PREFIX)$(CAM):OVER", $(QSIZE), 0, "$(PREFIX)$(CAM):TRANS", 0, 9, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDOverlay.template", "P=$(PREFIX)$(CAM):,R=Over1:, PORT=$(PREFIX)$(CAM):OVER,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM):TRANS")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX)$(CAM):,R=Over1:1:,NAME=fiducial,SHAPE=0,O=Over1:,XSIZE=30,YSIZE=30,PORT=$(PREFIX)$(CAM):OVER,ADDR=0,TIMEOUT=1")

# standard arrays plugin
###############################
NDStdArraysConfigure("$(PREFIX)$(CAM):Image", 3, 0, "$(PREFIX)$(CAM):OVER", 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX)$(CAM):,R=image1:,PORT=$(PREFIX)$(CAM):Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PREFIX)$(CAM):OVER,TYPE=Int8,FTVL=UCHAR,NELEMENTS=$(NELM)")

# Autosave section
###############################
dbLoadRecords("db/autosave.db", "P=$(PREFIX), R=$(CAM)")

set_requestfile_path("$(ADSIMDETECTOR)/simDetectorApp/Db")
set_requestfile_path("$(AREA_DETECTOR)/ADCore/ADApp/Db")
set_requestfile_path("$(AREA_DETECTOR)/$(ADGENICAM)/GenICamApp/Db")
set_requestfile_path("$(AREA_DETECTOR)/$(ADVIMBA)/vimbaApp/Db")
set_requestfile_path("$(CALC)/calcApp/Db")
set_requestfile_path("$(SSCAN)/sscanApp/Db")
set_requestfile_path("$(TOP)/autoSaveRestore")
set_savefile_path("$(TOP)/autoSaveRestore/")
set_pass0_restoreFile("$(CAM).sav")
set_pass1_restoreFile("$(CAM).sav")

