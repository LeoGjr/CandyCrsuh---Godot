extends Node

onready var movesBoard = get_parent().get_node("MovesBoard")
onready var Bar = get_parent().get_node("Bar")
var matrix = []
var CandyPre = preload("res://scenes/candy.tscn")
var BoxPre = preload("res://scenes/Box.tscn")
var obj1
var obj2
var canPlay = false
var level = 1
signal played
signal add_points(p)
func _ready():
	level = Global.curLevel
	clear_matrix()
	read_level()
	rand_matrix()
	find_pattern()
func read_level():
	var file = File.new()
	file.open("res://LevelData/level" + str(level) + ".txt", file.READ)
	var text = file.get_as_text()
	var lines = text.split("\n")
	file.close()
	for x in range(9):
		for y in range(12):
			if lines[y][x] == "1":
				matrix[x][y] = gen_box(x, y)
	movesBoard.set_moves(int(lines[12]))
	Bar.set_max(int(lines[13]))
func clear_matrix():
	for x in range(9):
		matrix.append([])
		matrix[x] = []
		
		for y in range(12):
			matrix[x].append([])
			matrix[x][y] = null
			
func rand_matrix():
	for x in range(9):
		for y in range(12):
			if matrix[x][y] == null:
				matrix[x][y] = gen_candy(x, y)
func gen_box(x, y):
	var new_box = BoxPre.instance()
	new_box.set_data(x, y)
	new_box.add_to_group("box")
	add_child(new_box)
	return new_box
func gen_candy(x, y):
	var newCandy = CandyPre.instance()
	newCandy.set_data(x, y)
	newCandy.connect("selected", self, "obj_sel")
	newCandy.add_to_group("candy")
	add_child(newCandy)
	return newCandy
func is_candy(obj):
	if obj != null and obj.is_in_group("candy"):
		return true
	else:
		return false
func obj_sel(obj, b):
	if not canPlay:
		obj.desel()
		return
	if b:
		if obj1 == null:
			obj1 = obj
		else:
			obj2 = obj
			
			if(test_prox()):
				canPlay = false
				emit_signal("played")
				obj1.move_to(obj2.x, obj2.y)
				obj2.move_to(obj1.x, obj1.y)
				matrix[obj1.x][obj1.y] = obj2
				matrix[obj2.x][obj2.y] = obj1
				get_node("Timer").start()
			else:
				obj1.desel()
				obj2.desel()
				obj1 = null
				obj2 = null
func test_prox():
	if obj1.x == obj2.x and abs(obj1.y - obj2.y) == 1 or obj1.y == obj2.y and abs(obj1.x - obj2.x) == 1:
		return true
	else:
		return false

func _on_Timer_timeout():
	if(find_pattern()):
		pass
	else:
		obj1.move_to(obj2.x, obj2.y)
		obj2.move_to(obj1.x, obj1.y)
		matrix[obj1.x][obj1.y] = obj2
		matrix[obj2.x][obj2.y] = obj1
		canPlay = true
	obj1.desel()
	obj2.desel()
	obj1 = null
	obj2 = null
func find_pattern():
	var to_remove = []
	var valid = false
	for y in range(12):
		for x in range(1, 8):
			var c0 = matrix[x - 1][y].color if is_candy(matrix[x - 1][y]) else null
			var c1 = matrix[x][y].color if is_candy(matrix[x][y]) else null
			var c2 = matrix[x + 1][y].color if is_candy(matrix[x + 1][y]) else null
			if c0 == c1 and c1 == c2 and c0 != null:
				add_to_remove(to_remove, matrix[x - 1][y])
				add_to_remove(to_remove, matrix[x][y])
				add_to_remove(to_remove, matrix[x + 1][y])
				valid = true
	for x in range(9):
		for y in range(1, 11):
			var c0 = matrix[x][y - 1].color if is_candy(matrix[x][y - 1]) else null
			var c1 = matrix[x][y].color if is_candy(matrix[x][y]) else null
			var c2 = matrix[x][y + 1].color if is_candy(matrix[x][y + 1]) else null
			if c0 == c1 and c1 == c2 and c0 != null:
				add_to_remove(to_remove, matrix[x][y - 1])
				add_to_remove(to_remove, matrix[x][y])
				add_to_remove(to_remove, matrix[x][y + 1])
				valid = true
	for t in to_remove:
		if t.special:
			emit_signal("add_points", 5)
		else:
			emit_signal("add_points", 1)
		remove_child(t)
		matrix[t.x][t.y] = null
		
	move_down()
	get_node("Inter").start()
	return valid
				
func add_to_remove(list, obj):
	if not list.has(obj):
		list.append(obj)
func move_down():
	for y in range(11, -1, -1):
		var x = 0
		while(x <= 8):
			if y == 0:
				if matrix[x][y] == null:
					matrix[x][y] = gen_candy(x, y)
			if is_candy(matrix[x][y]):
				#matrix[x][y].sel()
				#var timer = Timer.new()
				#timer.set_wait_time(0.2)
				#timer.start()
				#add_child(timer)
				#yield(timer, "timeout")
				#remove_child(timer)
				#matrix[x][y].desel()
				var moved = false
				var toy
				for i in range(y + 1, 12):
					if matrix[x][i] == null:
						toy = i
						moved = true
					elif matrix[x][i].is_in_group("box"):
						continue
					else:
						break

				if moved:
					matrix[x][y].move_to(x, toy)
					matrix[x][toy] = matrix[x][y]
					matrix[x][y] = null
			if y == 0 and matrix[x][y] == null:
				pass
			else:
				x += 1

func _on_Inter_timeout():
	if not find_pattern():
		get_node("Inter").stop()
		canPlay = true
		if movesBoard.moves == 0:
			if Bar.win():
				Transition.put_above("res://scenes/Win.tscn")
			else:
				Transition.put_above("res://scenes/Loose.tscn")
		if Bar.rmax():
			Transition.put_above("res://scenes/Win.tscn")
			print("Acabou!")
		
