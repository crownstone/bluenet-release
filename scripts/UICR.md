 
# <a name="uicr"></a> UICR variables
On flashing new Crownstones, we give it a set of variables written to its UICR (User Information Configuration Registry)

All values below are hex values and grouped in sections of 2 digits.

Type | Name | Location | Description
--- | --- | --- | ---
uint32 | [Legacy Board info](#legacy_board_info) | 0x10001084 | Board versioning
uint32 | [Product Info](#general_board_info) | 0x10001088 | General Product Information
uint32 | [PCB Version](#board_version) | 0x1000108c | Major, Minor & patch revision indication
uint32 | [Production Info](#production_info) | 0x10001090 | Production dates & component information

## <a name="legacy_board_info"></a> Legacy Board information
Type | Name | Description
--- | --- | ---
uint32 | Board version | Board value corresponding to your board.


The version number corresponding to your particular board can be found in `cs_Boards.h`

## <a name="general_board_info"></a> General Board Information
Type | Name | Description | Options
--- | --- | --- | ---
uint8 | Product Type | Product sub group indicator |  <li> Dev. Board 0x01</li> <li>Plug: 0x02</li> <li>Built-in: 0x03</li> <li>Guidestone: 0x04</li>
uint8 | Market | Regional indicator | <li> EU: 0x01 </li>  <li> US: 0x02 </li>
uint8 | Product Family | Indicator of product family | <li> Crownstone: 0x01 </li>
uint8 | Reserved | Reserved | <li> 0xFF </li>

## <a name="board_version"></a> Board Version
Type | Name | Description | Options
--- | --- | --- | ---
uint8 | Patch | Patch version | <li> default: 0x00 </li>
uint8 | Minor | Feature change version | <li>default: 0x00 </li>
uint8 | Major | Major version | <li>ACR01B2C: 0x01</li>  <li>[upcoming 2nd board]: 0x02</li>
uint8 | Reserved | Reserved | <li> 0xFF </li>

Relevant minor and patch versions vary by major version.

TODO: define minor & patch versions per major.

## <a name="production_info"></a> Production Information
Type | Name | Description | Options
--- | --- | --- | ---
uint8 | Housing ID | Iteration of relevant housing | <li> first relevant iteration: 0x01 </li>
uint8 | Production week | Week of PCB fabrication | <li> week 01: 0x01</li> <li> </li> <li>week 52: 0x34</li>
uint8 | Production year | Year of PCB fabrication | <li> 2016: 16-> 0x10 </li> <li>2017: 17 -> 0x11</li>
uint8 | Reserved | Reserved | <li> 0xFF </li>

Housing will iterate in design per product type. At the time of writing this, we have one housing design per product type so that ID will default to 0x01
