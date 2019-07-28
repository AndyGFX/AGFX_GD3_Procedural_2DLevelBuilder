extends "ProceduralData.gd"

class_name ProceduralRooms

var invert = false;
var maze


class empty_room:
	var up:int = 1
	var right:int = 1
	var down:int = 1
	var left:int = 1
	var visited:int = 0
	
	func ToString()->String:
		return "{"+String(self.up)+","+String(self.right)+","+String(self.down)+","+String(self.left)+"}"

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
	
func HasUpWall(x:int,y:int)->bool:
	var res=false
	if self.data[x][y].up==1: res = true
	return res
	
func HasRightWall(x:int,y:int):
	var res=false
	if self.data[x][y].right==1: res = true
	return res
	
func HasDownWall(x:int,y:int):
	var res=false
	if self.data[x][y].down==1: res = true
	return res

func HasLeftWall(x:int,y:int):
	var res=false
	if self.data[x][y].left==1: res = true
	return res
	
func GenerateMap()->void:
	
	# generate maze
	self.maze.invert = true
	self.maze.Build()
	
	# create rooms from maze
	
	for y in range(0,self.height):
		for x in range(0,self.width):
			var mx = ((x*2) + 1)
			var my = ((y*2) + 1)
			self.data[x][y].up = self.maze.data[mx][my-1].value
			self.data[x][y].down = self.maze.data[mx][my+1].value
			self.data[x][y].left = self.maze.data[mx-1][my].value
			self.data[x][y].right = self.maze.data[mx+1][my].value
			pass
		pass