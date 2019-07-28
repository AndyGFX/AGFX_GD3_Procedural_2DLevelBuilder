extends Node2D


export var width = 32
export var height = 32
# warning-ignore:unused_class_variable
export var randomSeed = true
# warning-ignore:unused_class_variable
export var _seed_ = 123456

# storage for proceduraly generated data
var data = []
# warning-ignore:unused_class_variable
var done = false;


func Create(type_of):
	for x in range(self.width):
		self.data.append([])
# warning-ignore:unused_variable
		for y in range(self.height):
			self.data[x].append(type_of.new())

func Clean(type_of):
	for x in range(self.width):		
		for y in range(self.height):
			self.data[x][y] = type_of.new()



