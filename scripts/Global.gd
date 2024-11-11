extends Node

var saveFile = File.new()
var savepath = "user://savegame.save"
var savedata = {"level1": 0,
                "level2": -1,
                "level3": -1,
                "level4": -1,
                "level5": -1,
                "level6": -1}
var curLevel = 1
var stars = 0
func _ready():
	if not saveFile.file_exists(savepath):
		save()
	read()

func save():
	saveFile.open(savepath, File.WRITE)
	saveFile.store_var(savedata)
	saveFile.close()
func read():
	saveFile.open(savepath, File.READ)
	savedata = saveFile.get_var()
	saveFile.close()
func save_level(level, stars):
	if level > 6: return
	savedata["level" + str(level)] = stars
	save()
	