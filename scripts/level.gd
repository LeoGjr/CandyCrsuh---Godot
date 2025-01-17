extends Area2D

export(int) var level = 0
export(String, FILE) var marker_unlock
export(String, FILE) var star1
export(String, FILE) var star2
export(String, FILE) var star3
var stars

func _ready():
	stars = Global.savedata["level" + str(level)]
	if stars != -1:
		get_node("lock").set_texture(load(marker_unlock))
		if stars != 0:
			get_node("stars").show()
	
	if stars == 1:
		get_node("stars").set_texture(load(star1))
	elif stars == 2:
		get_node("stars").set_texture(load(star2))
	elif stars == 3:
		get_node("stars").set_texture(load(star3))
	
	get_node("number").set_texture(load("res://Shary the fairy/files/png/gui/Group_" + str(level) + ".png"))
  


func _on_level_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed and stars != -1:
		Global.curLevel = level
		Transition.fade_to("res://scenes/LevelDesign.tscn")
