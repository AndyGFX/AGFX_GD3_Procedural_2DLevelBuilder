extends "ProceduralData.gd"

class_name ProceduralRooms
enum eSide {WALL,EXIT}
var origin_bottomleft:bool = false
var invert = false;
var maze

# 0 = no way => WALL
# 1 =  exit
class empty_room:
	var up:int = eSide.EXIT
	var right:int = eSide.EXIT
	var down:int = eSide.EXIT
	var left:int = eSide.EXIT
	var visited:int = 0
	
func _init(w:int,h:int,rnd:bool,useed:int):

	self.width = w
	self.height = h
	self.maze = ProceduralMaze.new(self.width * 2+1,self.height * 2+1,rnd,useed)	
	self.Create(empty_room)
	self.Clean(empty_room)	
	
func Build()->void:
	self.done = false
	self.GenerateMap()	
	self.done = true

func IsUp(x:int,y:int,sideType:int)->bool:
	var res=false
	if self.origin_bottomleft:
		if self.data[x][self.height-y-1].up==sideType: res = true
	else:
		if self.data[x][y].up==sideType: res = true
	return res
	
func IsRight(x:int,y:int,sideType:int):
	var res=false
	if self.origin_bottomleft:
		if self.data[x][self.height-y-1].right==sideType: res = true
	else:
		if self.data[x][y].right==sideType: res = true
	return res
	
func IsDown(x:int,y:int,sideType:int):
	var res=false
	if self.origin_bottomleft:
		if self.data[x][self.height-y-1].down==sideType: res = true
	else:
		if self.data[x][y].down==sideType: res = true
	return res

func IsLeft(x:int,y:int,sideType:int):
	var res=false
	if self.origin_bottomleft:
		if self.data[x][self.height-y-1].left==sideType: res = true
	else:
		if self.data[x][y].left==sideType: res = true
	return res
	
func ToString(x,y):
	var _x = x
	var _y = 0
	if self.origin_bottomleft:
		_y = self.height-y-1
	else:
		_y = y
	return "{"+String(self.data[_x][_y].up)+","+String(self.data[_x][_y].right)+","+String(self.data[_x][_y].down)+","+String(self.data[_x][_y].left)+"}"
	pass
	
func GetRoom(x:int,y:int)->empty_room:
	var _y = self.height - y -1
	return self.data[x][_y]
	pass
	
func GenerateMap()->void:
	
	# generate maze
	self.maze.invert = false
	self.maze.Build()
	
	var mx = 0
	var my = 0
	
	# create rooms from maze
	for x in range(0,self.width):
		for y in range(0,self.height):
			
			mx = ((x*2) + 1)			
			my = ((y*2) + 1)  # origin bottom/left
				
			self.data[x][y].up = self.maze.data[mx][my-1].value
			self.data[x][y].down = self.maze.data[mx][my+1].value
				
			self.data[x][y].left = self.maze.data[mx-1][my].value
			self.data[x][y].right = self.maze.data[mx+1][my].value
			
		pass