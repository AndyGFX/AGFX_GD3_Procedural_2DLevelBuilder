extends "ProceduralData.gd"

class_name ProceduralConways

export (int, 100) var cellSpawnChance = 50
export (int, 1,8) var birthLimit = 4
export (int, 1,8) var deathLimit = 4
export (int, 1,10) var repeatCount = 3

export var invert = false;

var sorroundCells = Array()

class empty_cell:
	var value = 0
	
	
func _init(w:int,h:int):
	
	self.width = w
	self.height = h
	self.sorroundCells.append(Vector2(-1,-1))
	self.sorroundCells.append(Vector2(-1,0))
	self.sorroundCells.append(Vector2(-1,1))

	self.sorroundCells.append(Vector2(0,-1))	
	self.sorroundCells.append(Vector2(0,1))

	self.sorroundCells.append(Vector2(1,-1))
	self.sorroundCells.append(Vector2(1,0))
	self.sorroundCells.append(Vector2(1,1))

	
	self.Create(empty_cell)
	self.Clean(empty_cell)
	self.Build()

func Build()->void:
	self.done = false
	self.RandomFill(0,1,self.cellSpawnChance)
	self.GenerateMap()
	if self.invert: self.InvertMap()
	self.done = true
	
func GenerateMap()->void:
	for i in range(self.repeatCount):
		self.data = self.SetMapCells(self.data)
		pass
	pass

func InvertMap()->void:
	for x in range(self.width):		
		for y in range(self.height):
			if self.data[x][y].value == 0:
				self.data[x][y].value = 1
			elif self.data[x][y].value == 1:
				self.data[x][y].value = 0


func RandomFill(empty,fill,chance)->void:
	if (self.randomSeed):
		randomize()
		self._seed_ = randi()
	
	seed(self._seed_)	

	for x in range(self.width):		
		for y in range(self.height):
			if (randi()%100)<chance:
				self.data[x][y].value = 0
			else:
				self.data[x][y].value = 1
	pass

func SetMapCells(oldMap)->Array:
	var newMap = []
	var neighb = 0

	for x in range(self.width):
		newMap.append([])
		for y in range(self.height):
			newMap[x].append(empty_cell.new())

	for x in range(self.width):		
		for y in range(self.height):
			neighb = 0
			for b in self.sorroundCells:				
				if (b.x == 0 and b.y == 0): 
					continue
				if (x + b.x >= 0 and x + b.x < self.width and y + b.y >= 0 and y + b.y < self.height):
					neighb += oldMap[x + b.x][ y + b.y].value
				else:
					neighb+=1;

			if (oldMap[x][y].value==1):
				if (neighb < self.deathLimit):
					newMap[x][y].value = 0 
				else: 
					newMap[x][y].value = 1
					
			if (oldMap[x][y].value==0):
				if (neighb > self.birthLimit): 
					newMap[x][y].value = 1 
				else: 
					newMap[x][y].value = 0
	return newMap	

