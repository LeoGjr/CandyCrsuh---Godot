extends Area2D

var color
var special = false
var sel = false
var x
var y
var destX
var destY
var posX
var posY
signal selected(obj, b)

func _ready():
	randomize()
	
	color = int(rand_range(0, 6))
	if rand_range(0, 1) > 0.99:
		special = true
	if special:
		get_node("sprite").set_animation("shine" + get_color(color))
	else:
		get_node("sprite").set_animation("normal" + get_color(color))
		
	set_process(true)
func _process(delta):
	if destX == null or destY == null or (destX == x and destY == y): return
	
	var delx = posX - get_pos().x
	var dely = posY - get_pos().y
	var speed = Vector2(0, 0)
	if abs(delx) > 20:
		speed.x = 300*(destX - x)
	else:
		set_pos(Vector2(posX, get_pos().y))
		x = destX
	if abs(dely) > 20:
		speed.y = 300*(destY - y)
	else:
		set_pos(Vector2(get_pos().x, posY))
		y = destY
	set_pos(get_pos() + speed * delta)
func get_color(n):
	if n == 0:
		return "Blue"
	elif n == 1:
		return "Green"
	elif n == 2:
		return "Orange"
	elif n == 3:
		return "Pink"
	elif n == 4:
		return "Purple"
	elif n == 5:
		return "Yellow"

func _on_candy_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed:
		if sel:
			desel()
			emit_signal("selected", self, false)
		else:
			sel()
			emit_signal("selected", self, true)
func desel():
	sel = false
	get_node("Sel").hide()
func sel():
	sel = true
	get_node("Sel").show()

func set_data(x, y):
	self.x = x
	self.y = y
	
	set_pos(Vector2(62 + x * 75 + 75/2, 290 + y * 75 + 75/2))
func move_to(gx, gy):
	destX = gx
	destY = gy
	posX = get_pos().x + (gx - x) * 75
	posY = get_pos().y + (gy - y) * 75
	