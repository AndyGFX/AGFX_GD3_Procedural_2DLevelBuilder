
class_name SceneBuilderTilemap

enum eLayerType { BACKGROUND, BASE, FOREGROUND}
enum eTileType {WALL,LADDER,PLATFORM,ONEWAYPLATFORM}
enum eBackgroundMode {PATTERN,CONWAY}

var wallPatterns:Array = []
var ladderPatterns:Array = []
var platformPatterns:Array = []
var backgroundPatterns:Array = []
var scanColor:Array = []
var targetLayers:Array = []
var layerType:int = eLayerType.BASE
var rooms:ProceduralRooms = null
var roomsCount:Vector2 = Vector2(12,10)
var roomSize:Vector2 = Vector2(0,0)
var minimap:Image=null
var enableFlipRoom:bool = false
var bkgMode = eBackgroundMode.PATTERN

# seed ui used for procedural rooms and conways (not for room patterns)
var conway:ProceduralConways
var _seed:int = 2019
var _rndSeed:bool = false

# ----------------------------------------------------------------------------------------
# Initialize builder
# ----------------------------------------------------------------------------------------
func Initialize(roomsCount:Vector2,userSeed:int,randomSeed:bool = true)->void:
	
	
	self._seed = userSeed
	self._rndSeed = randomSeed
	self.roomsCount = roomsCount
	self.rooms = ProceduralRooms.new(self.roomsCount.x,self.roomsCount.y,self._rndSeed,self._seed)	
	
	self.rooms.Build()
	self.roomSize = self.wallPatterns[0].get_size()
	
	self.minimap = Image.new()
	self.minimap.create(self.roomsCount.x*2+1,self.roomsCount.y*2+1,false,Image.FORMAT_RGBA8)
	
	

# ----------------------------------------------------------------------------------------
# Geberate minimap
# ----------------------------------------------------------------------------------------
func GenerateMinimap():

	for x in range(0,self.rooms.maze.width):
		for y in range(0,self.rooms.maze.height):
			
			self.minimap.lock()
			if (self.rooms.maze.data[x][y].value==0):
				self.minimap.set_pixel(x,y,Color(0,0,0,1))
			else:
				self.minimap.set_pixel(x,y,Color(1,1,1,1))
			self.minimap.unlock()
	
	# preview [0,0] pivot
	self.minimap.lock()
	self.minimap.set_pixel(0,0,Color.red)
	self.minimap.unlock()
	pass

# ----------------------------------------------------------------------------------------
# Set paint mode for backgroun PATTERN or CONWAY
# ----------------------------------------------------------------------------------------
func SetBackgroundMode(mode:int)->void:
	self.bkgMode = mode
	pass

# ----------------------------------------------------------------------------------------
# Set background properties for CONWAY'S paint mode
# ----------------------------------------------------------------------------------------
func SetBackgroundConway(cellSpawnChance,birthLimit,deathLimit,repeatCount)->void:
	
	self.conway = ProceduralConways.new(self.roomsCount.x*self.roomSize.x,self.roomsCount.y*self.roomSize.y)
	self.conway.cellSpawnChance = cellSpawnChance
	self.conway.birthLimit = deathLimit
	self.conway.deathLimit = deathLimit
	self.conway.repeatCount = repeatCount
	self.conway._seed_ = self._seed
	self.conway.randomSeed = self._rndSeed
	
	pass
	
# ----------------------------------------------------------------------------------------
# Set scene tilemap and assing type of layer
# ----------------------------------------------------------------------------------------
func SetTargetTilemap(tm:TileMap, type:int)->void:
	self.targetLayers.append({"tilemap":tm,"type":type})	
	pass

# ----------------------------------------------------------------------------------------
# add color for pattern in layer and assigned tile ID
# ----------------------------------------------------------------------------------------
func AddScanColor(layer:int,tileid:int,pattern:int,c:Color)->void:
	self.scanColor.append({"layer":layer,"tile_id":tileid,"pattern":pattern,"color":c})
	pass

# ----------------------------------------------------------------------------------------
# add patterns to WALL's patterns
# ----------------------------------------------------------------------------------------
func AddWallPattern(sprite:Texture)->void:
	self.wallPatterns.append(sprite.get_data())
	pass

# ----------------------------------------------------------------------------------------
# add patterns to LADDER's patterns
# ----------------------------------------------------------------------------------------
func AddLadderPattern(sprite:Texture)->void:
	self.ladderPatterns.append(sprite.get_data())
	pass

# ----------------------------------------------------------------------------------------
# add patterns to PLATFORM's patterns
# ----------------------------------------------------------------------------------------
func AddPlatformPattern(sprite:Texture)->void:
	self.platformPatterns.append(sprite.get_data())
	pass
	
# ----------------------------------------------------------------------------------------
# add patterns to BACKGROUND's patterns
# ----------------------------------------------------------------------------------------
func AddBackgroundPattern(sprite:Texture)->void:
	self.backgroundPatterns.append(sprite.get_data())
	pass
	
# ----------------------------------------------------------------------------------------
# Read pixel color from pattern
# ----------------------------------------------------------------------------------------
func GetPixelPatternColor(pattern:Image,x,y)->Color:
	var res:Color = Color.black
	pattern.lock()
	res=pattern.get_pixel(x,y)
	pattern.unlock()
	return res
# ----------------------------------------------------------------------------------------
# Get Tile ID from pattern and color
# ----------------------------------------------------------------------------------------
func GetTileIdByColor(layer:int,pattern:int,color:Color)->int:
	for i in range(0,self.scanColor.size()):
		#if self.scanColor[i].layer == layer and self.scanColor[i].pattern==pattern and self.scanColor[i].color==color:
		if self.scanColor[i].layer == layer and self.scanColor[i].color==color:
			return self.scanColor[i].tile_id;
	return -1

# ----------------------------------------------------------------------------------------
# DRAW room to BACKGROUND in CONWAY mode
# ----------------------------------------------------------------------------------------
func DrawRoomBackground_CONWAY(layer,room_x,room_y):
	var tilemap = layer.tilemap
	var pixel:Color = Color.black
	var rnd_background_id:int = rand_range(0,self.backgroundPatterns.size())
	
	var flipX:bool = false
	
	if self.enableFlipRoom and randf()>=0.5: flipX=true
	
	for x in range(0,self.roomSize.x):
		for y in range(0,self.roomSize.y):
			
			var  rx:int = room_x*self.roomSize.x + x 
			var  ry:int = room_y*self.roomSize.x + y 
			
			if flipX:
				rx = room_x*self.roomSize.x + self.roomSize.x - x - 1
	
			var cell = self.conway.data[rx][ry].value
			if cell==1:
				self.DrawTileToLayer(layer,eTileType.WALL,rx,ry,pixel)
			
			tilemap.update_bitmask_area(Vector2(rx,ry))
			

# ----------------------------------------------------------------------------------------
# DRAW room to BACKGROUND in PATTERM mode
# ----------------------------------------------------------------------------------------
func DrawRoomBackground_PATTERN(layer,room_x,room_y):
	var tilemap = layer.tilemap
	var pixel:Color = Color.black
	var rnd_background_id:int = rand_range(0,self.backgroundPatterns.size())
	
	var flipX:bool = false
	
	if self.enableFlipRoom and randf()>=0.5: flipX=true
	
	for x in range(0,self.roomSize.x):
		for y in range(0,self.roomSize.y):
			
			var  rx:int = room_x*self.roomSize.x + x 
			var  ry:int = room_y*self.roomSize.x + y 
			
			if flipX:
				rx = room_x*self.roomSize.x + self.roomSize.x - x - 1
	
			pixel = GetPixelPatternColor(self.backgroundPatterns[rnd_background_id],x,y)
			self.DrawTileToLayer(layer,eTileType.WALL,rx,ry,pixel)
			
			tilemap.update_bitmask_area(Vector2(rx,ry))

# ----------------------------------------------------------------------------------------
# DRAW room to BASE layer
# ----------------------------------------------------------------------------------------
func DrawRoomInterior(layer,room_x,room_y):
	
	var tilemap = layer.tilemap
	var pixel:Color = Color.black
	var rnd_platform_id:int = rand_range(0,self.platformPatterns.size())
	var rnd_ladder_id:int = rand_range(0,self.ladderPatterns.size())
	var flipX:bool = false
	
	if self.enableFlipRoom and randf()>=0.5: flipX=true
	
	for x in range(0,self.roomSize.x):
		for y in range(0,self.roomSize.y):
			
			var  rx:int = room_x*self.roomSize.x + x 
			var  ry:int = room_y*self.roomSize.x + y 
			
			if flipX:
				rx = room_x*self.roomSize.x + self.roomSize.x - x - 1
				
			if self.rooms.IsUp(room_x,room_y,ProceduralRooms.eSide.EXIT):
				pixel = GetPixelPatternColor(self.ladderPatterns[rnd_ladder_id],x,y)
				self.DrawTileToLayer(layer,eTileType.LADDER,rx,ry,pixel)
			else:
				pixel = GetPixelPatternColor(self.platformPatterns[rnd_platform_id],x,y)
				self.DrawTileToLayer(layer,eTileType.PLATFORM,rx,ry,pixel)
			
			
			tilemap.update_bitmask_area(Vector2(rx,ry))

# ----------------------------------------------------------------------------------------
# DRAW tile to tilemap
# ----------------------------------------------------------------------------------------
func DrawTileToLayer(layer:Dictionary,pattern:int,rx:int,ry:int,pixelColor:Color):
	
	var tile_id = -1
	# if pixel has alpha, then is used for randomized paint
	if pixelColor.r>=0 and pixelColor.g>=0 and pixelColor.b>=0 and pixelColor.a>0.01 and pixelColor.a<1.0:	
		if randf()>=pixelColor.a:
			pixelColor.a=1
			tile_id = GetTileIdByColor(layer.type,pattern,pixelColor)
	else:
		tile_id = GetTileIdByColor(layer.type,pattern,pixelColor)
		
	if tile_id>=0:
		layer.tilemap.set_cell(rx,ry,tile_id)
	pass

# ----------------------------------------------------------------------------------------
# DRAW room walls to BASE layer
# ----------------------------------------------------------------------------------------
func DrawRoomWalls(layer,room_x,room_y):
	
	var tilemap = layer.tilemap
	var  rx = 0
	var  ry = 0
	for x in range(0,self.roomSize.x):
		for y in range(0,self.roomSize.y):
			
			rx = room_x*self.roomSize.x + x 
			
			ry = room_y*self.roomSize.y + y 
				
			
			if self.rooms.IsUp(room_x,room_y,ProceduralRooms.eSide.WALL):
				var pixel = GetPixelPatternColor(self.wallPatterns[0],x,y)
				self.DrawTileToLayer(layer,eTileType.WALL,rx,ry,pixel)
		
			if self.rooms.IsRight(room_x,room_y,ProceduralRooms.eSide.WALL):
				var pixel = GetPixelPatternColor(self.wallPatterns[1],x,y)
				self.DrawTileToLayer(layer,eTileType.WALL,rx,ry,pixel)
					
			if self.rooms.IsDown(room_x,room_y,ProceduralRooms.eSide.WALL):
				var pixel = GetPixelPatternColor(self.wallPatterns[2],x,y)
				self.DrawTileToLayer(layer,eTileType.WALL,rx,ry,pixel)
					
			if self.rooms.IsLeft(room_x,room_y,ProceduralRooms.eSide.WALL):
				var pixel = GetPixelPatternColor(self.wallPatterns[3],x,y)
				self.DrawTileToLayer(layer,eTileType.WALL,rx,ry,pixel)
		
			tilemap.update_bitmask_area(Vector2(rx,ry))

# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func DrawRoomForeground(tilemap,room_x,room_y):
	pass

# ----------------------------------------------------------------------------------------
# Draw ROOM to layer at X,Y
# ----------------------------------------------------------------------------------------
func DrawRoom(layer:Dictionary,room_x:int, room_y:int):
	
#	# paint Background
	if layer.type == eLayerType.BACKGROUND:
		if self.bkgMode == eBackgroundMode.PATTERN:
			self.DrawRoomBackground_PATTERN(layer,room_x,room_y)
		else:
			self.DrawRoomBackground_CONWAY(layer,room_x,room_y)

	# paint base [platforms, laggders, ...]
	if layer.type == eLayerType.BASE:
		self.DrawRoomInterior(layer,room_x,room_y)
		
	# paint wall 
	if layer.type == eLayerType.BASE:
		self.DrawRoomWalls(layer,room_x,room_y)
	
#	# paint foreground decoration 
#	if layer.type == eLayerType.FOREGROUND:
#		self.DrawRoomForeground(layer,room_x,room_y)

# ----------------------------------------------------------------------------------------
# Draw ROOMS in defined LAYER
# ----------------------------------------------------------------------------------------
func GenerateLayer(layer:Dictionary)->void:
	
	for x in range(0,self.roomsCount.x):
		for y in range(0,self.roomsCount.y):		
			self.DrawRoom(layer,x,y)
			#print("["+String(x)+","+String(y)+"]="+self.rooms.ToString(x,y))

# ----------------------------------------------------------------------------------------
# BUILD scene for assigned layers (tilemaps)
# ----------------------------------------------------------------------------------------
func Build()->void:
	self.rooms.Build()
	
	if self.bkgMode == eBackgroundMode.CONWAY:
		self.conway.Build()
		
	for layer in range(0,targetLayers.size()):
		self.targetLayers[layer].tilemap.clear()
		self.GenerateLayer(self.targetLayers[layer])	
	
	
	
	
