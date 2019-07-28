extends Node2D

var Builder =  TilesetBuilder.new()

# Called when the node enters the scene tree for the first time.
func _ready():

# Example #1
# ----------------------------------------------
#	var image = Image.new()	
#	image.load("res://Sprites/Example/AutoTile_1.png")
#	Builder.SetTileSize(16,16)	
#	Builder.SetInputImage(image)	
#	Builder.Prepare()
#	Builder.Build()
#	Builder.SaveTileset("res://TestTilset_3x3M_16x16pix.tres")
#	get_node("UserInput/SpriteOutput").texture = Builder.GetResult()

# Example #2
# ----------------------------------------------
	
	
#	# method #2a
#	var image = Image.new()	
#	image.load("res://Sprites/Example/AutoTile_1.png")
#	Builder.BuildFromImage(16,16,image,"res://TestTilset_3x3M_16x16pix.tres")
#	get_node("UserInput/SpriteOutput").texture = Builder.GetResult()

#	# method #2b
#	Builder.BuildFromTexture(16,16,get_node("UserInput/SpriteInput").get_texture(),"res://TestTilset_3x3M_16x16pix.tres")
#	get_node("UserInput/SpriteOutput").texture = Builder.GetResult()

#	# method #2c
#	Builder.BuildFromSprite(16,16,get_node("UserInput/SpriteInput"),"res://TestTilset_3x3M_16x16pix.tres")
#	get_node("UserInput/SpriteOutput").texture = Builder.GetResult()

	
	
#	# method #2d
#
#	var image1 = Image.new()	
#	image1.load("res://Sprites/Example/AutoTile_1.png")
#
#
#	var image2 = Image.new()	
#	image2.load("res://Sprites/Example/AutoTile_2.png")
#
#
#	var images = { 
#		"0" : {"name": "AutoTile_1" ,"width":16,"height":16, "src":image1},
#		"1" : {"name": "AutoTile_2" ,"width":16,"height":16, "src":image2}
#		}
#
#	Builder.BuildFromImages(images,"res://TileSet/TestTilset_from_img_list.tres")


	# method #3
	
	var images_json = { 
		"0" : {"name": "AutoTile_1" ,"width":16,"height":16, "src":"res://Sprites/Example/AutoTile_1.png"},
		"1" : {"name": "AutoTile_2" ,"width":16,"height":16, "src":"res://Sprites/Example/AutoTile_2.png"},
		"2" : {"name": "AutoTile_3" ,"width":16,"height":16, "src":"res://Sprites/Example/AutoTile_3.png"}
	}
	Utils.SaveJSON("res://TilesetImages.data",images_json,true)
	
	Builder.BuildFromFile(Utils.LoadJSON("res://TilesetImages.data"),"res://TileSet/TestTilset_from_img_list.tres")
	
	pass # Replace with function body.
