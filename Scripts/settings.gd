extends Button

@onready var settingsmenu = get_node("../../Settingsmenu")

@onready var FPS_selector = settingsmenu.get_node("FPS")
@onready var Windowed = settingsmenu.get_node("Windowed")
@onready var Showfps = settingsmenu.get_node("Showfps")
@onready var Resolution = settingsmenu.get_node("Resolution")

var currentwindowed = false
var currentshowfps = false

@onready var Playbtn = get_node("../PlayButton")
@onready var Settingsbtn = self
@onready var Backbtn = get_node("../Back")
@onready var Tutorbtn = get_node("../Tutorial")



var fps_settings = {
	0: 60,
	1: 30,
}

func _ready() -> void:
	SaveSystem._load()
	FPS_selector.select(0)
	for res in Global.resolutions:
		Resolution.add_item(res)
	update_button_values()

func update_button_values():
	#resolution
	var window_size = str(get_window().size.x, "x", get_window().size.y)
	if window_size not in Global.resolutions:
		#its not there ??!??
		
		Resolution.add_item(window_size)
		
		var id = find_item_index_by_text(Resolution, window_size)
		if id != -1: Resolution.select(id)
		else:
			printdbg("window size not in ids even when added")
		return
	
	var resolutions_index = Global.resolutions.keys().find(window_size)
	Resolution.select(resolutions_index)
	
	#max fps
	var max_fps = SaveSystem.get_var("maxfps")
	var fps_index = find_item_index_by_text_list(fps_settings.values(), max_fps)
	if fps_index != -1:
		FPS_selector.selected = fps_index
		Engine.max_fps = fps_settings[fps_index]
		SaveSystem.set_var("maxfps", fps_settings[fps_index])
		printdbg("Set max fps: " + str(fps_settings[fps_index]))
	
	
	if SaveSystem.get_var("Windowed") == true:
		Windowed.set_pressed(true)
		currentwindowed = true
		printdbg("loaded windowed: true")
	
	elif SaveSystem.get_var("Windowed") == false:
		Windowed.set_pressed(false)
		currentwindowed = false
		printdbg("loaded windowed: false")
	
	#Show fps
	if SaveSystem.get_var("Showfps") == true:
		Showfps.set_pressed(true)
		currentshowfps = true
		printdbg("loaded showfps: true")
	
	elif SaveSystem.get_var("Showfps") == false:
		Showfps.set_pressed(false)
		currentshowfps = false
		printdbg("loaded showfps: false")
	
	#Windowed
	# 3 = windowed, 0 = fullscreen
	#if DisplayServer.window_get_mode() == 3:
	#	Windowed.set_pressed(true)
	#elif DisplayServer.window_get_mode() == 0:
	#	Windowed.set_pressed(false)
		
	printdbg("win mode: " + str(DisplayServer.window_get_mode()))
	
	Global.showFPS = currentshowfps
	
func _on_pressed() -> void:
	settingsmenu.show()
	Playbtn.disabled = true
	Settingsbtn.disabled = true
	Backbtn.disabled = true
	Tutorbtn.disabled = true


func _on_back_button_pressed() -> void:
	settingsmenu.hide()
	Playbtn.disabled = false
	Settingsbtn.disabled = false
	Backbtn.disabled = false
	Tutorbtn.disabled = false

func _on_fps_item_selected(index: int) -> void:
	Engine.max_fps = fps_settings[index]
	SaveSystem.set_var("maxfps", fps_settings[index])
	printdbg("Set max fps: " + str(fps_settings[index]))

func _on_resolution_selected(index: int) -> void:
	var res_text = Resolution.get_item_text(index)
	DisplayServer.window_set_size(Global.resolutions[res_text]);
	printdbg("set resolution: " + res_text)

func _on_windowed_pressed() -> void:
	printdbg("win mode: " + str(DisplayServer.window_get_mode()))
	currentwindowed = !currentwindowed
	var value = DisplayServer.WINDOW_MODE_WINDOWED if currentwindowed else DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(value)
	SaveSystem.set_var("Windowed", currentwindowed)
	printdbg("set disp mode: WINDOW_MODE_WINDOWED" if currentwindowed else "set disp mode: WINDOW_MODE_FULLSCREEN")

func _on_show_fps_pressed() -> void:
	currentshowfps = !currentshowfps
	Global.showFPS = currentshowfps
	SaveSystem.set_var("Showfps", currentshowfps)
	printdbg("set showfps: " + str(currentshowfps))


func exit_game() -> void:
	SaveSystem.save()
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("exit"):
		exit_game()

func find_item_index_by_text(button, target_text):
	for i in range(button.item_count):
		if button.get_item_text(i) == target_text:
			return i
	return -1

func find_item_index_by_text_list(list, target_text):
	for i in range(len(list)):
		if list[i] == target_text:
			return i
	return -1

func printdbg(texti: String):
	if Global.DEBUG:
		print(texti)
