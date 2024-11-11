extends Sprite

export(String, FILE) var starOn
var ponts = 0
var p3 = 200
var p1 = (151.0/408)*p3
var p2 = (p1 + p3)/2

func _ready():
	starOn = load(starOn)

	pass
func set_max(pmax):
	p3 = pmax
	p1 = (151.0/408)*p3
	p2 = (p1 + p3)/2
    

func _on_Candies_add_points( p ):
	ponts += p
	if ponts > p3: ponts = p3
	get_node("Green").set_region_rect(Rect2(0, 0, 408*ponts/p3, 42))
	if ponts >= p3:
		Global.stars = 3
		get_node("Star3").set_texture(starOn)
	elif ponts >= p2:
		Global.stars = 2
		get_node("Star2").set_texture(starOn)
	elif ponts >= p1:
		Global.stars = 1
		get_node("Star1").set_texture(starOn)
func win():
	return ponts >= p1
func rmax():
	return ponts >= p3