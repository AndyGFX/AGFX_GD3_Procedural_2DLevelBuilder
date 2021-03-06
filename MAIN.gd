extends Node2D


export (Vector2) var roomCounts = Vector2(13,10)
export (int) var userSeed = 125
export (bool) var randomSeed = false
export (bool) var enableFlipRoom = false
var levelBuilder:SceneBuilderTilemap = null
var tilesetBuilder =  TilesetBuilder.new()

# parameters for CONWAYS background
export (bool) var useConaway = true
export (int, 100) var cellSpawnChance = 50
export (int, 1,8) var birthLimit = 4
export (int, 1,8) var deathLimit = 4
export (int, 1,10) var repeatCount = 4


func _ready():
	
	randomize()
	
	# create Tilesets (optional - not needed if you have your own tilsets assigned to tilemaps)	
	self.PrepareTilesets()
	
	
	# create builder
	self.levelBuilder = SceneBuilderTilemap.new()
	self.levelBuilder.enableFlipRoom = self.enableFlipRoom
	
	# add patterns for BACKGROUND
	self.levelBuilder.AddBackgroundPattern(load("res://Sprites/Patterns/BACKGROUND-001.png"))
	self.levelBuilder.AddBackgroundPattern(load("res://Sprites/Patterns/BACKGROUND-002.png"))
	self.levelBuilder.AddBackgroundPattern(load("res://Sprites/Patterns/BACKGROUND-003.png"))
	self.levelBuilder.AddBackgroundPattern(load("res://Sprites/Patterns/BACKGROUND-004.png"))
	self.levelBuilder.AddBackgroundPattern(load("res://Sprites/Patterns/BACKGROUND-005.png"))
	
	# add patterns for WALLS (interriror)
	self.levelBuilder.AddWallPattern(load("res://Sprites/Patterns/WALL-0.png"))
	self.levelBuilder.AddWallPattern(load("res://Sprites/Patterns/WALL-1.png"))
	self.levelBuilder.AddWallPattern(load("res://Sprites/Patterns/WALL-2.png"))
	self.levelBuilder.AddWallPattern(load("res://Sprites/Patterns/WALL-3.png"))
	
	# add patterns for rooms without UP exit -> PLATFORMS | ONE WAY PLATFORMS
	self.levelBuilder.AddPlatformPattern(load("res://Sprites/Patterns/PLATFORMS-001.png"))
	self.levelBuilder.AddPlatformPattern(load("res://Sprites/Patterns/PLATFORMS-002.png"))
	self.levelBuilder.AddPlatformPattern(load("res://Sprites/Patterns/PLATFORMS-003.png"))
	
	# add patterns for rooms with exit UP -> LADDERS
	self.levelBuilder.AddLadderPattern(load("res://Sprites/Patterns/LADDER-001.png"))
	self.levelBuilder.AddLadderPattern(load("res://Sprites/Patterns/LADDER-002.png"))
	self.levelBuilder.AddLadderPattern(load("res://Sprites/Patterns/LADDER-003.png"))
	
	# assign scene tilemap
	self.levelBuilder.SetTargetTilemap($"Tilemaps/L0-BACK",SceneBuilderTilemap.eLayerType.BACKGROUND)
	self.levelBuilder.SetTargetTilemap($"Tilemaps/L1-BASE",SceneBuilderTilemap.eLayerType.BASE)
	#self.levelBuilder.SetTargetTilemap($"Tilemaps/L2-FRONT",SceneBuilderTilemap.eLayerType.FOREGROUND)
	
	# add pattern color definition for:
	
	# BACKGROUND layer
	self.levelBuilder.AddScanColor(SceneBuilderTilemap.eLayerType.BACKGROUND,0,SceneBuilderTilemap.eTileType.WALL,Color.black)
	
	
	# BASE layer
	self.levelBuilder.AddScanColor(SceneBuilderTilemap.eLayerType.BASE,1,SceneBuilderTilemap.eTileType.WALL,Color.black)
	self.levelBuilder.AddScanColor(SceneBuilderTilemap.eLayerType.BASE,1,SceneBuilderTilemap.eTileType.PLATFORM,Color.black)	
	self.levelBuilder.AddScanColor(SceneBuilderTilemap.eLayerType.BASE,2,SceneBuilderTilemap.eTileType.ONEWAYPLATFORM,Color.blue)
	
	self.levelBuilder.AddScanColor(SceneBuilderTilemap.eLayerType.BASE,3,SceneBuilderTilemap.eTileType.LADDER,Color.green)
	self.levelBuilder.AddScanColor(SceneBuilderTilemap.eLayerType.BASE,1,SceneBuilderTilemap.eTileType.LADDER,Color.black)
	
	# FOREGROUND layer
	# ...
	
	
	# initialzie builder
	
	
	self.levelBuilder.Initialize(roomCounts,self.userSeed,self.randomSeed)
	
	if self.useConaway:
		# init BKG from CONWAY
		self.levelBuilder.SetBackgroundMode(SceneBuilderTilemap.eBackgroundMode.CONWAY)
		self.levelBuilder.SetBackgroundConway(self.cellSpawnChance,self.birthLimit, self.deathLimit,self.repeatCount)
	else:
		# init BKG from PATTERNS
		self.levelBuilder.SetBackgroundMode(SceneBuilderTilemap.eBackgroundMode.PATTERN)
		
	
	# create minimap
	self.levelBuilder.GenerateMinimap()
	$Tilemaps/Minimap.set_texture(Utils.CreateTextureFromImage(self.levelBuilder.minimap))
	
	# build
	self.levelBuilder.Build()
	
	
	
func PrepareTilesets()->void:
	var images_json = {
		"0" : {"name": "BACK" ,"width":16,"height":16, "src":"res://Sprites/AutoTile_0.png"},
		"1" : {"name": "WALL" ,"width":16,"height":16, "src":"res://Sprites/AutoTile_1a.png"},
		"2" : {"name": "ONWAY" ,"width":16,"height":16, "src":"res://Sprites/AutoTile_OneWay.png"},
		"3" : {"name": "LADDER" ,"width":16,"height":16, "src":"res://Sprites/AutoTile_Ladder.png"}
	}
	
	Utils.SaveJSON("res://TilesetImages.data",images_json,true)
	tilesetBuilder.BuildFromFile(Utils.LoadJSON("res://TilesetImages.data"),"BASE-ProceduralTilesets.tres")
	pass

func _on_Button_pressed():
	self.levelBuilder.Initialize(roomCounts,self.userSeed,self.randomSeed)
	self.levelBuilder.Build()
	self.levelBuilder.GenerateMinimap()
	$Tilemaps/Minimap.set_texture(Utils.CreateTextureFromImage(self.levelBuilder.minimap))
	
