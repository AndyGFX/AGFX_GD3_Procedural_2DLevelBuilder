
class_name SceneBuilderTilemap

enum eLayerType { BACKGROUND, BASE, FOREGROUND}
enum ePattern {WALL,LADDER,PLATFORM,ONEWAYPLATFORM}

var wallPatterns:Array = []
var ladderPatterns:Array = []
var platformPatterns:Array = []
var scanColor:Array = []
var targetLayer:TileMap = null
var layerType:int = eLayerType.BASE
var rooms:ProceduralRooms = null
var roomsCount:Vector2 = Vector2(12,10)
var roomSize:Vector2 = Vector2(0,0)
var minimap:Image=null

# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func Initialize(roomsCount:Vector2,userSeed:int,randomSeed:bool = true)->void:
	self.roomsCount = roomsCount
	self.rooms = ProceduralRooms.new(self.roomsCount.x,self.roomsCount.y,randomSeed,userSeed)	
	
	
	self.rooms.Build()
	self.roomSize = self.wallPatterns[0].get_size()
	
	self.minimap = Image.new()
	self.minimap.create(self.roomsCount.x*2+1,self.roomsCount.y*2+1,false,Image.FORMAT_RGBA8)

# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func GenerateMinimap():

	for x in range(0,self.rooms.maze.width):
		for y in range(0,self.rooms.maze.height):
			
			self.minimap.lock()
			if (self.rooms.maze.data[x][y].value==0):
				self.minimap.set_pixel(x,self.rooms.maze.height-y-1,Color(1,1,1,1))
			else:
				self.minimap.set_pixel(x,self.rooms.maze.height-y-1,Color(0,0,0,1))
			self.minimap.unlock()
	
	# preview [0,0] pivot
	self.minimap.lock()
	self.minimap.set_pixel(0,0,Color.red)
	self.minimap.unlock()
	pass

# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func SetTargetTilemap(tm:TileMap, type:int)->void:
	self.targetLayer = tm
	self.layerType = type
	pass

# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func AddScanColor(layer:int,tileid:int,pattern:int,c:Color)->void:
	self.scanColor.append({"layer":layer,"tile_id":tileid,"pattern":pattern,"color":c})
	pass

# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func AddWallPattern(sprite:Texture)->void:
	self.wallPatterns.append(sprite.get_data())
	pass

# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func AddLadderPattern(sprite:Texture)->void:
	self.ladderPatterns.append(sprite.get_data())
	pass

# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func AddPlatformPattern(sprite:Texture)->void:
	self.platformPatterns.append(sprite.get_data())
	pass

func DrawRoomWalls(room_x,room_y):
	for x in range(0,self.roomSize.x):
		for y in range(0,self.roomSize.y):
			
			var  rx = room_x*self.roomSize.x + x 
			var  ry = self.roomsCount.y*self.roomSize.y-(room_y*self.roomSize.y + y)-1
			
			if self.rooms.HasUpWall(room_x,room_y):
				self.wallPatterns[0].lock()
				var pixel = self.wallPatterns[0].get_pixel(x,y)				
				self.wallPatterns[0].unlock()
				if pixel == Color.black:
					self.targetLayer.set_cell(rx,ry,1)
		
			if self.rooms.HasRightWall(room_x,room_y):
				self.wallPatterns[1].lock()
				var pixel = self.wallPatterns[1].get_pixel(x,y)				
				self.wallPatterns[1].unlock()
				if pixel == Color.black:
					self.targetLayer.set_cell(rx,ry,1)
					
			if self.rooms.HasDownWall(room_x,room_y):
				self.wallPatterns[2].lock()
				var pixel = self.wallPatterns[2].get_pixel(x,y)				
				self.wallPatterns[2].unlock()
				if pixel == Color.black:
					self.targetLayer.set_cell(rx,ry,1)
					
			if self.rooms.HasLeftWall(room_x,room_y):
				self.wallPatterns[3].lock()
				var pixel = self.wallPatterns[3].get_pixel(x,y)				
				self.wallPatterns[3].unlock()
				if pixel == Color.black:
					self.targetLayer.set_cell(rx,ry,1)
		
			self.targetLayer.update_bitmask_area(Vector2(rx,ry))

func DrawRoom(room_x:int, room_y:int):

			self.DrawRoomWalls(room_x,room_y)

	
func GenerateLayer_BASE()->void:
	for y in range(0,self.roomsCount.y):
		for x in range(0,self.roomsCount.x):
			self.DrawRoom(x,y)
			pass
	pass
# ----------------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------------
func Build()->void:
	self.GenerateLayer_BASE()	
	pass
	
	
	
	