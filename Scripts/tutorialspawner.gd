extends Node2D

var sincespawn = 0
var spawninterval = 590
var currenttime = 0
var last_text = -1

var text_tutorials = [
	"Space or Click to jump", 
	"Hold jump to go higher, and to spin", 
	"When you touch the ground,
	you have 3 jumps",
	"If you go off-screen, you die",
	"If you hit a spin, you get +1 jump",
	"Here are some modifiers to try out",
	0,
	1,
	2,
	"Esc to go back to the title"]


var ice4 = load("res://scenes/Ice/ice_4.tscn")
var water = load("res://scenes/water.tscn")

var labelscript = load("res://Scripts/lable.gd")

@onready var Objects = get_node("../Objects")
@onready var Labels = get_node("../Labels")
@onready var Water = get_node("../Water")
@onready var Extras = get_node("../Extras")

var Spin = load("res://scenes/spin.tscn")
var Move = load("res://scenes/move.tscn")
var Jumpup = load("res://scenes/jumpup.tscn")

func label(text: String):
	var labeli = Label.new()
	labeli.text = text
	labeli.set_script(labelscript)
	Labels.add_child(labeli)

func spawnspin():
	var instance = Spin.instantiate()
	Extras.add_child(instance)

func spawnmove():
	var instance = Move.instantiate()
	Extras.add_child(instance)

func spawnjump():
	var instance = Jumpup.instantiate()
	Extras.add_child(instance)

func spawnwater():
	var instance = water.instantiate()
	Water.add_child(instance)

func spawnice4():
	var instance = ice4.instantiate()
	Objects.add_child(instance)
	instance.position.x += 2400


func _process(delta: float) -> void:
	currenttime += delta
	sincespawn += (300 + Global.speedup) * delta
	if sincespawn > spawninterval:
		spawnice4()
		spawnwater()
		sincespawn = 0
	if currenttime > 4:
		currenttime = 0
		
		if last_text + 1 == len(text_tutorials):
			last_text = -1
		
		var current_val = text_tutorials[last_text + 1]
		
		if typeof(current_val) == TYPE_STRING:
			label(current_val)
		elif typeof(current_val) == TYPE_INT:
			if current_val == 0:
				spawnspin()
			if current_val == 1:
				spawnmove()
			if current_val == 2:
				spawnjump()
		last_text += 1
	
	
