extends Node2D



func _on_Return_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	Transition.clear_above()


func _on_Home_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	Transition.fade_to("res://scenes/Mainscreen.tscn")
	Transition.clear_above()


func _on_Replay_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	Transition.fade_to("res://scenes/LevelDesign.tscn")
	Transition.clear_above()
