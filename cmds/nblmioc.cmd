# launch IOC in E3:
# iocsh.bash ./cmds/nblmioc.cmd

require nblmioc, master

require ADSupport,1.9.0 ## for HDF5 library ##
# autosave
require autosave, 5.10.0
# save and restore a specific config
require saverestore, master
require nblmplc, master
require nblmpower, master
require mrfioc2, 2.2.0-rc7
require nblmapp, master
require nds3epics,1.0.1
require modbus,3.0.0
require s7plc,1.4.1

# Constant definitions
epicsEnvSet(TRIG0_PV,           "$(TRIG0_PV=MTCA-EVR:EvtECnt-I.TIME)")
#epicsEnvSet(TIMESTAMP,          "null")
epicsEnvSet(TIMESTAMP,          "$(TIMESTAMP=MTCA-EVR:Time-I.TIME)")
epicsEnvSet(PREFIX,             "$(PREFIX=FEBx)")
epicsEnvSet(ACQ_IFC1410,    "ICS tag 345")
epicsEnvSet(AREA,           "$(AREA=CEA)")  # default prefix is "CEA"
epicsEnvSet(DEVICE,         "PBI-nBLM")
epicsEnvSet(HV_LV_PREFIX,   "SY4527")
# The tens of AMC gives the card in slot 3
epicsEnvSet(AMC1,               "$(AMC1=130)")
# The tens of AMC gives the card in slot 5
epicsEnvSet(AMC2,               "$(AMC2=150)")
##################### Only one board ##############################
#epicsEnvSet(AMCs,               "$(AMC1)")
################# or with several IFC1410 #########################
epicsEnvSet(AMCs,               "$(AMC1)_$(AMC2)")
###################################################################
epicsEnvSet("IOC", "MTCA")
epicsEnvSet("DEV", "EVR")
# Not use in this script, but it is needed for the expansion. 
epicsEnvSet("MainEvtCODE" "14")


########################################################################################################
#### hardware connection layer: What we find in e3-nblmpower, e3-nblmplc, e3-nblmapp and e3-mrfioc2 ####
########################################################################################################

#############################################################################################################################################################################################################
### CAEN power supply (HV + LV)
#############################################################################################################################################################################################################
# NEXT LINES ARE COPIED FROM e3-nblmpower/cmds/nblmpower.cmd
# CAEN crate (touchscreen)
dbLoadRecords("CAEN_SY4527_crate.template", "AREA=${AREA}, DEVICE=${DEVICE}, HV_LV_PREFIX="${HV_LV_PREFIX}", CRATE_IDX="1"")       # first crate
## HV
dbLoadRecords("CAEN_HV_A7030.db", "AREA=${AREA}, DEVICE=${DEVICE}, HV_LV_PREFIX="${HV_LV_PREFIX}", CRATE_IDX="1", HV_SLOT="02"")
dbLoadRecords("CAEN_HV_A7030.db", "AREA=${AREA}, DEVICE=${DEVICE}, HV_LV_PREFIX="${HV_LV_PREFIX}", CRATE_IDX="1", HV_SLOT="05"")
## LV
dbLoadRecords("CAEN_LV_A2519.db", "AREA=${AREA}, DEVICE=${DEVICE}, HV_LV_PREFIX="${HV_LV_PREFIX}", CRATE_IDX="1", LV_SLOT="10"")

# CAEN crate 2
dbLoadRecords("CAEN_SY4527_crate.template", "AREA=${AREA}, DEVICE=${DEVICE}, HV_LV_PREFIX="${HV_LV_PREFIX}", CRATE_IDX="2"")   # second crate
## HV
dbLoadRecords("CAEN_HV_A7030.db", "AREA=${AREA}, DEVICE=${DEVICE}, HV_LV_PREFIX="${HV_LV_PREFIX}", CRATE_IDX="2", HV_SLOT="15"")
# #LV
#############################################################################################################################################################################################################


#############################################################################################################################################################################################################
### gas
#############################################################################################################################################################################################################
## -- S7PLC --
# add communications IOC (S7PLC + modbus)

## -- S7PLC --
#s7plcConfigure("plcName",     "ip",          port, inByte, outByte, bigEndian, recTimeout, sendIntervall)
# NEXT LINE IS COPIED FROM e3-nblmplc/cmds/nblmplc.cmd
s7plcConfigure("ESS_NBLM_PLC","10.2.176.36",2000,534,0,1,500,100)
# var s7plcDebug 0


## -- MODBUS --
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

# NEXT LINES ARE COPIED FROM e3-nblmplc/cmds/nblmplc.cmd
drvAsynIPPortConfigure("ESS_NBLM_PLC509",		"10.2.176.36:509",0,0,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC502",		"10.2.176.36:502",0,0,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC503",		"10.2.176.36:503",0,0,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC504",		"10.2.176.36:504",0,0,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC505",		"10.2.176.36:505",0,0,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC506",		"10.2.176.36:506",0,0,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC507",		"10.2.176.36:507",0,0,1)
drvAsynIPPortConfigure("ESS_NBLM_PLC508",		"10.2.176.36:508",0,0,1)

# modbusInterposeConfig(portName, linkType, timeoutMsec, writeDelayMsec)
# linkType: 0 = TCP/IP, 1 = RTU, 2 = ASCII
# timeoutMsec: The timeout in milliseconds for write and read
# writeDelayMsec: delay in milliseconds before each write from EPICS to the device (only needed for Serial RTU devices, default is 0)

# NEXT LINES ARE COPIED FROM e3-nblmplc/cmds/nblmplc.cmd
modbusInterposeConfig("ESS_NBLM_PLC509",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC502",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC503",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC504",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC505",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC506",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC507",0,1000,0)
modbusInterposeConfig("ESS_NBLM_PLC508",0,1000,0)

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
# NEXT LINES ARE COPIED FROM e3-nblmplc/cmds/nblmplc.cmd
#					    portName,	                        tcpPortName,	        slaveAddr,	modbusFct,	addr,	length,	dataType,	pollMsec,	plcType,
drvModbusAsynConfigure("ESS_NBLM_PLC502_AS_WRITE_0",		"ESS_NBLM_PLC502",		1,			16,			0,		40,		8,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC508_AS_WRITE_0",		"ESS_NBLM_PLC508",		1,			16,			0,		6,		4,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC509_AS_WRITE_0",		"ESS_NBLM_PLC509",		1,			16,			0,		2,		8,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC503_AS_WRITE_0",		"ESS_NBLM_PLC503",		1,			16,			0,		40,		8,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC504_AS_WRITE_0",		"ESS_NBLM_PLC504",		1,			16,			0,		40,		8,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC507_AS_WRITE_0",		"ESS_NBLM_PLC507",		1,			16,			0,		40,		8,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC505_AS_WRITE_0",		"ESS_NBLM_PLC505",		1,			16,			0,		40,		8,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC506_AS_WRITE_0",		"ESS_NBLM_PLC506",		1,			16,			0,		40,		8,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC502_TS_WRITE_4000",		"ESS_NBLM_PLC502",		1,			5,			4000,	1640,	0,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC502_TS_WRITE_6400",		"ESS_NBLM_PLC502",		1,			5,			6400,	1640,	0,			1,			"SIEMENS")
drvModbusAsynConfigure("ESS_NBLM_PLC502_TS_WRITE_8800",		"ESS_NBLM_PLC502",		1,			5,			8800,	3,		0,			1,			"SIEMENS")
#=======================================================
    
# load database
# NEXT LINE IS COPIED FROM e3-nblmplc/cmds/nblmplc.cmd
dbLoadRecords("iocEss_nblm.db")
#############################################################################################################################################################################################################


#############################################################################################################################################################################################################
# configure EVR
#############################################################################################################################################################################################################
iocshLoad("$(mrfioc2_DIR)/evr-mtca-300.iocsh", "S=$(IOC), DEV=$(DEV), PCIID=08:00.0")
#############################################################################################################################################################################################################


#############################################################################################################################################################################################################
### ACQ
#############################################################################################################################################################################################################
# Constant definitions
epicsEnvSet(EPICS_CA_MAX_ARRAY_BYTES, 400000000)
# Set maximum number of samples: SCOPE_RAW_DATA_SAMPLES_MAX for the scope in the code
epicsEnvSet(NELM, 5000)
var onAMCOne 1
ndsCreateDevice(nblm, ${PREFIX}, chGrp=${DEVICE}, grpNb=${AMCs}, MB_DOD="64")

dbLoadRecords("trigTime.db", "TIMESTAMP=${TRIG0_PV}")

dbLoadRecords("nblm_group.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC1},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC1},CH_ID=CH0, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC1},CH_ID=CH1, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC1},CH_ID=CH2, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC1},CH_ID=CH3, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC1},CH_ID=CH4, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC1},CH_ID=CH5, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")

################# Test with a 2nd IFC1410 #########################
dbLoadRecords("nblm_group.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC2},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC2},CH_ID=CH0, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC2},CH_ID=CH1, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC2},CH_ID=CH2, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC2},CH_ID=CH3, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC2},CH_ID=CH4, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
dbLoadRecords("nblm.db", "PREFIX=${PREFIX},CH_GRP_ID=${DEVICE}${AMC2},CH_ID=CH5, NELM=${NELM},TIMESTAMP=${TIMESTAMP}")
#############################################################################################################################################################################################################



#############################################################################################################################################################################################################
#### Hardware abstraction layer (nBLM per nBLM)
#############################################################################################################################################################################################################
### nblm database: LV + gas + ACQ monitoring + 2 HV channel control + CAEN SY4527 and boards status
epicsEnvSet(AREA,               "$(AREA=CEA)")
# ACQ (RO)
epicsEnvSet(ACQ_DEVICE,         "$(DEVICE)")
# gas (RO)
dbLoadRecords("nblm_detector.db", "AREA=${AREA}, DEVICE=${DEVICE}, ACQ_DEVICE=${ACQ_DEVICE}, ACQ_IFC1410=${ACQ_IFC1410}") 
# fast
#############################################################################################################################################################################################################


#############################################################################################################################################################################################################
# configure save and restore (Alexis Gaget)
#############################################################################################################################################################################################################
dbLoadRecords("SaveRestoreC.template", PREFIX="${AREA}:${DEVICE}-saveRestore-HV")
dbLoadRecords("SaveRestoreC.template", PREFIX="${AREA}:${DEVICE}-saveRestore-LV")
dbLoadRecords("SaveRestoreC.template", PREFIX="${AREA}:${DEVICE}-saveRestore-GAS")
dbLoadRecords("SaveRestoreC.template", PREFIX="${AREA}:${DEVICE}-saveRestore-ND")
#############################################################################################################################################################################################################


#############################################################################################################################################################################################################
# configure autosave
#############################################################################################################################################################################################################
# debug level
save_restoreSet_Debug(0)

# Specify directories in which to search for request files. This requested file (.req) is containing PVs name to autosave.
set_requestfile_path("/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/autosave/","")

# specify where save files should be (.sav)
set_savefile_path("/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/autosave/", "data/")

# Specify which saved files should be restored
## gas + ND + HV + LV
# hardware connection layer
set_pass1_restoreFile("nblm_autosave_hardware_connection_layer.sav")
# hardware abstraction layer
set_pass1_restoreFile("nblm_autosave_hardware_abstraction_layer.sav")
#############################################################################################################################################################################################################


iocInit

#############################################################################################################################################################################################################
# Start autosave task
#############################################################################################################################################################################################################
# create_monitor_set(char *request_file, int period, char *macrostring)
# file containing PVs to autosave
# period: periodic autosave if PV has changed
# macrostring: macro for the req file
## gas + ND + HV + LV
# hardware connection layer.
# 2nd parameter : Save every <time> seconds, if any of the PVs named in the file <name>.req have changed value since the last write
create_monitor_set("nblm_autosave_hardware_connection_layer.req", 5, "AREA=${AREA}, DEVICE=${DEVICE}")
# hardware abstraction layer
create_monitor_set("nblm_autosave_hardware_abstraction_layer.req", 5, "AREA=${AREA}, DEVICE=${DEVICE}")
#############################################################################################################################################################################################################


###################################################################
## saveRestore paths
###################################################################
# HV
dbpf ${AREA}:${DEVICE}-saveRestore-HV:PathReq "/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/saveAndRestore/HV_config.req"
dbpf ${AREA}:${DEVICE}-saveRestore-HV:PathSav "/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/saveAndRestore/HV_config.sav"
# LV
dbpf ${AREA}:${DEVICE}-saveRestore-LV:PathReq "/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/saveAndRestore/LV_config.req"
dbpf ${AREA}:${DEVICE}-saveRestore-LV:PathSav "/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/saveAndRestore/LV_config.sav"
# gas
dbpf ${AREA}:${DEVICE}-saveRestore-GAS:PathReq "/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/saveAndRestore/GAS_config.req"
dbpf ${AREA}:${DEVICE}-saveRestore-GAS:PathSav "/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/saveAndRestore/GAS_config.sav"
# neutron detection
dbpf ${AREA}:${DEVICE}-saveRestore-ND:PathReq "/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/saveAndRestore/ND_config.req"
dbpf ${AREA}:${DEVICE}-saveRestore-ND:PathSav "/home/ceauser/e3-3.15.5/e3-nblmioc/m-epics-nblm/misc/saveAndRestore/ND_config.sav"
###################################################################


###################################################################
# Start acquisition threads
###################################################################
dbpf ${PREFIX}:${DEVICE}${AMC1}:STAT "ON"

################# Test with a 2nd IFC1410 #########################
dbpf ${PREFIX}:${DEVICE}${AMC2}:STAT "ON"
###################################################################

###################################################################
# For EVR
###################################################################
dbpf "MTCA-EVR:Link-Clk-SP" 88.052
dbpf "MTCA-EVR:DlyGen0-Width-SP" 4000
dbpf "MTCA-EVR:DlyGen0-Evt-Trig0-SP" 14
dbpf "MTCA-EVR:OutFP0-Src-Pulse-SP" "Pulser 0"
dbpf "MTCA-EVR:OutBack0-Src-Pulse-SP" "Pulser 0"
dbpf "MTCA-EVR:EvtE-SP.OUT" "@OBJ=EVR,Code=14"
dbl > "${IOC}_PVs.list"
###################################################################


