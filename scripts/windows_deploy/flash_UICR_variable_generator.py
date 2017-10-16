import json

jsonFile = 'uicr.json'
jsonData = open(jsonFile).read()
data = json.loads(jsonData)

outputDict  = dict()

def traverseDict(fileData,outputDict):
	for item in fileData:
		print item
		if(len(fileData[item])==1) and fileData[item]!='versioning':
			for nestItem in fileData[item]:
				outputDict[item]=fileData[item][nestItem]
		elif item=="product type":
			print("please select which product type you are flashing firmware to:")
			start = 0
			checkList = []
			for nestItem in fileData[item]:
				print str(start) + ' ' + nestItem + ' : ' + fileData[item][nestItem]
				checkList.append(nestItem)
				start += 1
			num = input()
			try:
				outputDict[item + ' name']=checkList[num]
				outputDict[item]=fileData[item][checkList[num]]
			except:
				print "I'm not gonna do error handling here. Please rerun the script and select a proper option"
				quit()


	#check which board version is used
	start=0
	checkList = []
	print("")
	print("please select which " + outputDict["product type name"] + " PCB version you are flashing firmware to:")
	for item in fileData["versioning"][outputDict["product type name"]]:	
		print str(start) + ' ' + item
		checkList.append(item)
		start += 1
	num = input()
	try:
		outputDict["boardName"]=checkList[num]
	except:
		print "I'm not gonna do error handling here. Please rerun the script and select a proper option"
		quit()
	
	#evaluate which version numbers should be assigned	
	subselect = fileData["versioning"][outputDict["product type name"]][checkList[num]]
	for versionType in subselect:
		if type(subselect[versionType])==list:
			print("please select which " + versionType + " version applies")
			start=0
			checkList = []
			for version in subselect[versionType]:
				print str(start) + ' ' + version
				checkList.append(version)
				start += 1
			num = input()
			try:
				outputDict[versionType]=checkList[num]
			except:
				print "I'm not gonna do error handling here. Please rerun the script and select a proper option"
				quit()
		else:
			outputDict[versionType]=subselect[versionType]
	return outputDict

class UICR:
	def __init__(self,inputDict):
		#defaults for non-production boards
		self.boardVal = 0
		
		self.productionYear = 17
		self.productionWeek = 0
		self.housingID = 0
		
		try:
			self.prodFamily = int(inputDict["product family"],16)
			self.market = int(inputDict["market"],16)
			self.prodType = int(inputDict["product type"],16)
			
			self.major = int(inputDict["major"],16)
			self.minor = int(inputDict["minor"],16)
			self.patch = int(inputDict["patch"],16)
			
			self.boardName=outputDict["boardName"]
			self.productTypeName=outputDict["product type name"]
			
			#optional values
			try:
				self.productionYear = inputDict["production year"]
			except:
				print ("no production year found, \tproceeding with default value")
			
			try:
				self.productionWeek = inputDict["production week"]
			except:
				print("no production week found, \tproceeding with default value")
				
			try:
				self.housingID = inputDict["housing id"]
			except:
				print("no housing ID found, \t\tproceeding with default value")
				
			try:
				self.boardVal = inputDict["legacy board value"]
			except:
				print("no legacy board value found, \tproceeding with default value")
					
		except:
			print("something went wrong while parsing the selected values")
			quit()
		
		return

	def combineVariables(self):
		# prepend all with 0xFF
		# Product Family, Market, Product type
		self.fammarkettype = (0xFF<<(8*3))+(self.prodFamily<<(8*2))+(self.market<<(8*1))+(self.prodType)
		# hardware version in major, minor, and patch numbers
		self.majminpatch = (0xFF<<(8*3))+(self.major<<(8*2))+(self.minor<<(8*1))+(self.patch)
		# Production year and week and relevant identification number for the housing
		self.prodrunHousingid = (0xFF<<(8*3))+(self.productionYear<<(8*2))+(self.productionWeek<<(8*1))+(self.housingID)
		return

	def writeFile(self,OS):
		self.combineVariables()
		if (OS=="win"):
			outputFileExtension = ".cmd"
			batchPreamble = "set "
			commentChar = "::"
		elif (OS=="lin"):
			outputFileExtension = ".sh"
			batchPreamble = ""
			commentChar = "#"
		else:
			print("no proper OS chosen")
			return
		file = open("VARIABLES" + outputFileExtension,"w")
		file.write("%s!/bin/bash\n" % commentChar)
		file.write("%s UICR variables file for %s type Crownstone\n" % (commentChar, self.productTypeName))
		file.write("%sboard_name=%s\n" % (batchPreamble, self.boardName))
		file.write("\n%s legacy board value\n" % commentChar)
		file.write("%sboard_val=0x%X\n" % (batchPreamble, self.boardVal))
		file.write("\n%s product family, market and product type\n" % commentChar)
		file.write("%s product type: %s -> 0x%0.2X\n" %(commentChar, self.productTypeName, self.prodType))
		file.write("%sfam_market_type=0x%0.8X\n" % (batchPreamble, self.fammarkettype))
		file.write("\n%s major, minor and patch version numbers\n" % commentChar)
		file.write("%smaj_min_patch=0x%0.8X\n" % (batchPreamble, self.majminpatch))
		file.write("\n%s production run in year, week and housing identification\n" % commentChar)
		file.write("%sprodrun_housingid=0x%0.8X" % (batchPreamble, self.prodrunHousingid))
		file.close()
		# also add a bash output file for raspberry pi programming
		return
	

outputDict = traverseDict(data,outputDict)
#print outputDict
ui=UICR(outputDict)
ui.writeFile("win") # output for windows (batch/cmd)
ui.writeFile("lin") # output for linux (bash/shell)
raw_input("everything in done, press enter to quit")

