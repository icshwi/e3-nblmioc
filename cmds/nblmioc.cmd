# launch IOC in E3:
# iocsh.bash ./cmds/nblmioc.cmd
# voir comment faire dans E3 pour (dans CONFIG_MODULE...):  iocsh -r nblm,2.0.0 -c "requireSnippet(nblm.cmd,'PREFIX=IFC1410_nBLM,DEVICE=PROTO')"

require nblmioc, master

# autosave
#require autosave, 5.7.0
# save and restore a specific config
require saverestore, master
require nblmplc, master
require nblmapp, develop
require nds3epics,1.0.0
require modbus,2.11.0p
require s7plc,1.4.0p

epicsEnvSet(ACQ_IFC1410,    "ICS tag 345")
epicsEnvSet(AREA,           "$(AREA=CEA)")  # default prefix is "CEA"
epicsEnvSet(DEVICE,         "PBI-nBLM")
epicsEnvSet(HV_LV_PREFIX,   "SY4527")       # service name of HV/LV


#### hardware connection layer

#############################################################################################################################################################################################################
### CAEN power supply (HV + LV)
#############################################################################################################################################################################################################
epicsEnvSet(LV_SLOT,        "10")           # only one LV board for CEA teststand
epicsEnvSet(HV_SLOT,        "02")           # only one HV board for CEA teststand
dbLoadRecords("CAEN_nblm.db", "AREA=${AREA}, DEVICE=${DEVICE}, HV_LV_PREFIX=${HV_LV_PREFIX}, LV_SLOT=${LV_SLOT}, HV_SLOT=${HV_SLOT}")
#############################################################################################################################################################################################################



#############################################################################################################################################################################################################
### gas
#############################################################################################################################################################################################################
## -- S7PLC --
# add communications IOC (S7PLC + modbus)
#> /opt/epics/modules/nblmPLC/1.0.0/startup/IOC_PROTOCOL_CONFIGURATION.cmd
#s7plcConfigure("plcName",     "ip",          port, inByte, outByte, bigEndian, recTimeout, sendIntervall)
s7plcConfigure("ESS_NBLM_PLC", "10.2.176.36", 2000, 642,    0,       1,         1000,        100)
# var s7plcDebug 0
## -- S7PLC --

## -- MODBUS --

## -- first tests (working)
# #drvAsynIPPortConfigure( portName,          hostInfo,           priority, noAutoConnect, noProcessEos)
# # drvAsynIPPortConfigure("PLC01502",        "10.2.176.36:502",  0,        1,             1)
# # ?? 
# drvAsynIPPortConfigure("PLC01503", "10.2.176.36:503", 0, 1, 1)

# # modbusInterposeConfig(portName,          linkType, timeoutMsec, writeDelayMsec)
# # modbusInterposeConfig("PLC01502",        0,        1000,        0)
# modbusInterposeConfig(  "ESS_NBLM_PLC502", 0,        1000,        0)
# # ?
# modbusInterposeConfig(  "PLC01503",        0,        1000,        0)

# # drvModbusAsynConfigure(portName,              tcpPortName, slaveAddress, modbusFunction, modbusStartAddress, modbusLength, dataType, pollMsec, plcType
# drvModbusAsynConfigure(  "PLC01503_AS_WRITE_0", "PLC01503",  1,            16,             0,	               6,            4,        0,        "SIEMENS")
# drvModbusAsynConfigure(  "PLC01502_AS_WRITE_0", "PLC01502",  1,            16,             0,	               45,           8,        0,        "SIEMENS")
# drvModbusAsynConfigure(  "PLC01_TS_WRITE_4000", "PLC01502",  1,            5,              4000,               40,           0,        0,        "SIEMENS")
## -- first tests (working)


# Protocol configuration generated by PLCParserTool version 2.2.1 the 10-04-2019 15:12:45
#=======================================================
#-----------------------------------------------------------------
# Configure serial or TCP connections
#
# Modbus/TCP example
#
#drvAsynIPPortConfigure(portName, hostInfo, priority, noAutoConnect, noProcessEos)
#noAutoConnect flag is set to 0 so that asynManager will do normal automatic connection management
#noProcessEos flag is set to 1 because Modbus over TCP does not require end-of-string processing

drvAsynIPPortConfigure("ESS_NBLM_PLC505",		"10.2.176.36:505",0,1,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC502",		"10.2.176.36:502",0,1,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC506",		"10.2.176.36:506",0,1,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC508",		"10.2.176.36:508",0,1,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC503",		"10.2.176.36:503",0,1,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC504",		"10.2.176.36:504",0,1,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC507",		"10.2.176.36:507",0,1,1)

# modbusInterposeConfig(portName, linkType, timeoutMsec, writeDelayMsec)
# linkType: 0 = TCP/IP, 1 = RTU, 2 = ASCII
# timeoutMsec: The timeout in milliseconds for write and read
# writeDelayMsec: delay in milliseconds before each write from EPICS to the device (only needed for Serial RTU devices, default is 0)

modbusInterposeConfig("ESS_NBLM_PLC505",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC502",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC506",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC508",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC503",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC504",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC507",0,1000,0)

# Modbus port configuration
# drvModbusAsynConfigure(portName, tcpPortName, slaveAddress, modbusFunction, modbusStartAddress,modbusLength,dataType,pollMsec, plcType
# modbusLength : length in bits for TE (max 2000) and TS (max 1968) and in bytes for AE (max 125) and AS (max 123)
# modbusFunction = 1 : Read Coils (read TS)
# modbusFunction = 2 : Read Discrete Inputs (read TE)
# modbusFunction = 3 : Read Multiple Registers (2 bytes = one word) (read AS)
# modbusFunction = 4 : Read Input Registers (2 bytes = one word) (read AE)
# modbusDataType = 0: UINT16 Unsigned 16-bit binary integers; 7 = FLOAT32_LE ; 8 = FLOAT32_BE : 32-bit floating point
# TYPE_BE Big Endian (most significant word at Modbus address N, least significant word at Modbus address N+1)
# TYPE_LE Little Endian
# pollMsec: period delay in millisecond of the request
# plcType : This parameter is currently used to print information in asynReport.
#
#					portName,	tcpPortName,	slaveAddr,	modbusFct,	addr,	length,	dataType,	pollMsec,	plcType

# modbusFunction = 5 : Write Single Coil (write TS)
# modbusFunction = 16 : Write Multiple Holding Registers (2 bytes = one word) (write AS)
# pollMsec: For write functions, a non-zero value means that the Modbus data should be read once when the port driver is first created.
#
#							portName,	tcpPortName,	slaveAddr,	modbusFct,	addr,	length,	dataType,	pollMsec,	plcType,
drvModbusAsynConfigure("ESS_NBLM_PLC508_AS_WRITE_0",		"ESS_NBLM_PLC508",		1,		16,		0,		6,		4,		1,		"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC502_AS_WRITE_0",		"ESS_NBLM_PLC502",		1,		16,		0,		50,		8,		1,		"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC503_AS_WRITE_0",		"ESS_NBLM_PLC503",		1,		16,		0,		50,		8,		1,		"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC504_AS_WRITE_0",		"ESS_NBLM_PLC504",		1,		16,		0,		50,		8,		1,		"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC507_AS_WRITE_0",		"ESS_NBLM_PLC507",		1,		16,		0,		50,		8,		1,		"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC505_AS_WRITE_0",		"ESS_NBLM_PLC505",		1,		16,		0,		50,		8,		1,		"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC506_AS_WRITE_0",		"ESS_NBLM_PLC506",		1,		16,		0,		50,		8,		1,		"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC502_TS_WRITE_4000",		"ESS_NBLM_PLC502",		1,		5,		4000,		1968,		0,		1,		"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC502_TS_WRITE_6401",		"ESS_NBLM_PLC502",		1,		5,		6401,		1639,		0,		1,		"SIEMENS")
#=======================================================
    
# load database
dbLoadRecords("iocEss_nblm.db")
#############################################################################################################################################################################################################





#############################################################################################################################################################################################################
### ACQ
#############################################################################################################################################################################################################
# Constant definitions
epicsEnvSet(PREFIX,             "$(PREFIX=MEBT)")
# Already defined at the top of the file. epicsEnvSet(DEVICE,             "$(DEVICE=PBI-nBLM)")
epicsEnvSet(EPICS_CA_MAX_ARRAY_BYTES, 400000000)

# Set maximum number of samples: SCOPE_RAW_DATA_SAMPLES_MAX for the scope in the code
epicsEnvSet(NELM, 5000)

var onAMCOne 1

ndsCreateDevice(ifc14, ${PREFIX}, card=0, fmc=1, chGrp=${DEVICE})

dbLoadRecords("nblm_group.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE},CH_ID=CH0, NELM=${NELM}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE},CH_ID=CH1, NELM=${NELM}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE},CH_ID=CH2, NELM=${NELM}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE},CH_ID=CH3, NELM=${NELM}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE},CH_ID=CH4, NELM=${NELM}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE},CH_ID=CH5, NELM=${NELM}")
#############################################################################################################################################################################################################





#############################################################################################################################################################################################################
#### Hardware abstraction layer (nBLM per nBLM)
#############################################################################################################################################################################################################
### nblm database: LV + gas + ACQ monitoring + 2 HV channel control + CAEN SY4527 and boards status
epicsEnvSet(AREA,               "$(AREA=CEA)")
epicsEnvSet(TYPE,               "SLOW") # FAST
epicsEnvSet(NBLM_IDX,           "1")
# ACQ (RO)
epicsEnvSet(ACQ_AREA,           "$(PREFIX)")
epicsEnvSet(ACQ_DEVICE,         "$(DEVICE)")
epicsEnvSet(ACQ_CH,             "CH0")
# HV (R/W)
epicsEnvSet(HV_MESH_SLOT,       "02")
epicsEnvSet(HV_MESH_CH,         "000")
epicsEnvSet(HV_DRIFT_SLOT,      "02")
epicsEnvSet(HV_DRIFT_ch,        "001")
# LV (RO) 
epicsEnvSet(LV_CH,              "000")
# gas (RO)
epicsEnvSet(GAS_AREA,           "FEB-050Row")
epicsEnvSet(GAS_LINE,           "1")
epicsEnvSet(GAS_DEVICE,         "PBI-PLC-Line") # FEB-050Row:PBI-PLC-Line1
epicsEnvSet(GAS_DEVICE_INT_VAR, "PBI-FT-A")     # FEB-050Row:PBI-FT-A10:FlwR, FEB-050Row:PBI-FT-A19:FlwR
dbLoadRecords("nblm_detector.db", "AREA=${AREA}, DEVICE=${DEVICE}, NBLM_IDX=${NBLM_IDX}, TYPE=${TYPE},  HV_MESH_SLOT="${HV_MESH_SLOT}", HV_MESH_CH="${HV_MESH_CH}", HV_DRIFT_SLOT="${HV_DRIFT_SLOT}", HV_DRIFT_CH="${HV_DRIFT_ch}", LV_SLOT=${LV_SLOT}, LV_CH=${LV_CH}, GAS_AREA=${GAS_AREA}, GAS_DEVICE=${GAS_DEVICE}, GAS_DEVICE_INT_VAR=${GAS_DEVICE_INT_VAR}, GAS_LINE=${GAS_LINE}, ACQ_AREA=${ACQ_AREA}, ACQ_DEVICE=${ACQ_DEVICE}, ACQ_IFC1410=${ACQ_IFC1410}, ACQ_CH=${ACQ_CH}") 
# fast
#############################################################################################################################################################################################################



#############################################################################################################################################################################################################
# configure save and restore (Alexis Gaget)
#############################################################################################################################################################################################################
SaveRestoreConfigure("$(REQUIRE_SaveRestore_PATH)")
dbLoadRecords("SaveRestoreC.template", PREFIX="${AREA}:${DEVICE}-saveRestore-HV")

#-----------------------------------------------------------
# configure autosave  
#-----------------------------------------------------------
# debug level
save_restoreSet_Debug(0)
# Number of sequenced backup files to write
# save_restoreSet_NumSeqFiles(1)

# Specify directories in which to search for request files. This requested file (.req) is containing PVs name to autosave.
set_requestfile_path("/home/iocuser/devspace/m-epics-nblm/misc/autosave/","")

# specify where save files should be (.sav)
set_savefile_path("/home/iocuser/devspace/m-epics-nblm/misc/autosave/", "data/")

# Specify which saved files should be restored
## gas + ND + HV + LV
# hardware connection layer
set_pass0_restoreFile("nblm_autosave_hardware_connection_layer.sav")
# hardware abstraction layer
set_pass0_restoreFile("nblm_autosave_hardware_abstraction_layer.sav")
#############################################################################################################################################################################################################


iocInit


#############################################################################################################################################################################################################
# Start autosave
#############################################################################################################################################################################################################
# create_monitor_set(char *request_file, int period, char *macrostring)
# file containing PVs to autosave
# period: periodic autosave if PV has changed
# macrostring: macro for the req file
## gas + ND + HV + LV
# hardware connection layer
create_monitor_set("nblm_autosave_hardware_connection_layer.req", 1, "AREA=${AREA}, DEVICE=${DEVICE}")
# hardware abstraction layer
create_monitor_set("nblm_autosave_hardware_abstraction_layer.req", 1, "AREA=${AREA}, DEVICE=${DEVICE}")
#############################################################################################################################################################################################################




## saveRestore paths
# HV
dbpf ${AREA}:${DEVICE}-saveRestore-HV:PathReq "/home/iocuser/devspace/m-epics-nblm/misc/saveAndRestore/HV_config.req"
dbpf ${AREA}:${DEVICE}-saveRestore-HV:PathSav "/home/iocuser/devspace/m-epics-nblm/misc/saveAndRestore/HV_config.sav"
# LV
dbpf ${AREA}:${DEVICE}-saveRestore-LV:PathReq "/home/iocuser/devspace/m-epics-nblm/misc/saveAndRestore/LV_config.req"
dbpf ${AREA}:${DEVICE}-saveRestore-LV:PathSav "/home/iocuser/devspace/m-epics-nblm/misc/saveAndRestore/LV_config.sav"
# gas
dbpf ${AREA}:${DEVICE}-saveRestore-GAS:PathReq "/home/iocuser/devspace/m-epics-nblm/misc/saveAndRestore/GAS_config.req"
dbpf ${AREA}:${DEVICE}-saveRestore-GAS:PathSav "/home/iocuser/devspace/m-epics-nblm/misc/saveAndRestore/GAS_config.sav"
# neutron detection
dbpf ${AREA}:${DEVICE}-saveRestore-ND:PathReq "/home/iocuser/devspace/m-epics-nblm/misc/saveAndRestore/ND_config.req"
dbpf ${AREA}:${DEVICE}-saveRestore-ND:PathSav "/home/iocuser/devspace/m-epics-nblm/misc/saveAndRestore/ND_config.sav"


# neutron detection and scope configuration
# Pulse processing
dbpf ${PREFIX}:${DEVICE}-STAT "ON"
