extends "ProceduralData.gd"

class_name ProceduralMaze

var invert = false;
var g_intDepth:int = 0 

class empty_cell:
	var value:int = 0
	

func _init(w:int,h:int,rnd:bool,useed:int):
	
	self.width = w
	self.height = h	
	self.randomSeed = rnd
	self._seed_ = useed
	self.Create(empty_cell)
	self.Clean(empty_cell)
	pass
	

func Build()->void:	
	self.done = false
	self.GenerateMap()
	if self.invert: self.InvertMap()
	self.done = true
	
func GenerateMap()->void:
	
	g_intDepth = 0; 
	
	if (self.randomSeed):
		randomize()
		self._seed_ = randi()
	
	seed(self._seed_)	

	self.DigMaze(self.data, 1, 1); 

func InvertMap()->void:
	for x in range(self.width):		
		for y in range(self.height):
			if self.data[x][y].value == 0:
				self.data[x][y].value = 1
			elif self.data[x][y].value == 1:
				self.data[x][y].value = 0

func DigMaze(Maze, x:int, y:int)->void:
	
	var newx:int = 0; 
	var newy:int = 0; 
	
	g_intDepth = g_intDepth + 1; 
 
	Maze[x][y].value = 1
	var intCount:int = self.ValidCount(Maze, x, y)
	
	while (intCount > 0):
		match (randi()%4):
			0:
				if (self.ValidMove(Maze, x,y-2) > 0):
					Maze[x][y-1].value = 1
					self.DigMaze(Maze, x,y-2) 
			1:
				if (self.ValidMove(Maze, x+2,y) > 0):  
					Maze[x+1][y].value = 1; 
					self.DigMaze (Maze, x+2,y)

			2:
				if (self.ValidMove(Maze, x,y+2) > 0): 
					Maze[x][y+1].value = 1
					self.DigMaze (Maze, x,y+2)
			3:
				if (ValidMove(Maze, x-2,y) > 0): 
					Maze[x-1][y].value = 1 
					self.DigMaze (Maze, x-2,y)

		intCount = self.ValidCount(Maze, x, y)
		pass
	g_intDepth = g_intDepth - 1


func ValidMove(Maze, x:int, y:int)->int:
	
	var intResult:int = 0; 
	if (x>=0 and x<self.width and y>=0 and y<self.height and int(Maze[x][y].value) == 0):
		intResult = 1
	return intResult

func ValidCount(Maze, x:int, y:int)->int:
	var intResult:int = 0
 
	var res = self.ValidMove(Maze, x,y-2)
	intResult = intResult + self.ValidMove(Maze, x,y-2)
	intResult = intResult + self.ValidMove(Maze, x+2,y) 
	intResult = intResult + self.ValidMove(Maze, x,y+2) 
	intResult = intResult + self.ValidMove(Maze, x-2,y) 
 
	return intResult; 
