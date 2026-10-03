extends Node2D



@onready var Objects = get_node("../Objects")
@onready var Player = get_node("../Player")
@onready var Extras = get_node("../Extras")
@onready var Water = get_node("../Water")

var Spin = load("res://scenes/spin.tscn")
var Move = load("res://scenes/move.tscn")
var Jumpup = load("res://scenes/jumpup.tscn")


var ice1 = load("res://scenes/Ice/ice_1.tscn")
var ice2 = load("res://scenes/Ice/ice_2.tscn")
var ice3 = load("res://scenes/Ice/ice_3.tscn")
var ice4 = load("res://scenes/Ice/ice_4.tscn")
var ice_start = load("res://scenes/Ice/ice_start.tscn")
var ice_end = load("res://scenes/Ice/ice_end.tscn")
var igloo = load("res://scenes/Ice/igloo.tscn")
var fort = load("res://scenes/Ice/fort.tscn")


var water = load("res://scenes/water.tscn")


var chance
var lastice = 0
var lastextra = 0

#extras spawn range
var smallest = -100
var largest = 150

var sincelastspawn = 0
var spawninterval = 590

var extrasincelastspawn = 0
var extraspawninterval = 400

func _process(delta: float) -> void:
	
	sincelastspawn += (300 + Global.speedup) * delta
	
	if sincelastspawn > spawninterval:
		spawnbase()
		spawnextras()
		spawnwater()
		sincelastspawn = 0

func spawnspin():
	var instance = Spin.instantiate()
	Extras.add_child(instance)
	instance.position[1] = randi_range(smallest, largest)

func spawnmove():
	var instance = Move.instantiate()
	Extras.add_child(instance)
	instance.position[1] = randi_range(smallest, largest)

func spawnjump():
	var instance = Jumpup.instantiate()
	Extras.add_child(instance)
	instance.position[1] = randi_range(smallest, largest)

func spawnicestart():
	var instance = ice_start.instantiate()
	Objects.add_child(instance)

func spawniceend():
	var instance = ice_end.instantiate()
	Objects.add_child(instance)

func spawnice1():
	var instance = ice1.instantiate()
	Objects.add_child(instance)

func spawnice2():
	var instance = ice2.instantiate()
	Objects.add_child(instance)
	
func spawnice3():
	var instance = ice3.instantiate()
	Objects.add_child(instance)

func spawnice4():
	var instance = ice4.instantiate()
	Objects.add_child(instance)

func spawnigloo():
	var instance = igloo.instantiate()
	Objects.add_child(instance)

func spawnfort():
	var instance = fort.instantiate()
	Objects.add_child(instance)

func spawnwater():
	var instance = water.instantiate()
	Water.add_child(instance)

func rollchance():
	chance = randf()



var current_isle_length = 0
var time_since_isle = 4 #current time since isle. set to 4 to trigger straight away on run
var time_between_isles = 4
var isle_in_prog = false

func spawnbase():
	
	if time_since_isle == time_between_isles and !isle_in_prog or time_since_isle > 5:
		#start_isle
		printdbg("Start isle")
		spawnicestart()
		isle_in_prog = true
		time_since_isle = 0
		return
	
	rollchance()
	
	if chance < 0.10 * current_isle_length or current_isle_length > 15:
		#end isle
		printdbg("Spawn end piece")
		spawniceend()
		isle_in_prog = false
	
	if isle_in_prog:
		#add a part to isle
		printdbg("Add a part to isle")
		current_isle_length += 1
		spawn_isle_part()
	
	if !isle_in_prog:
		current_isle_length = 0
		rollchance()
		if chance > 0.8:
			time_between_isles += randi_range(0, 3)
			printdbg("Change time between isles")
		time_since_isle += 1
	
func spawn_isle_part():
	rollchance()
	if chance > 0.33 and chance < 0.66:
		if lastice != 1:
			lastice = 1
			spawnice1()
		else: spawnice4()
	if chance < 0.33:
		if lastice != 2:
			lastice = 2
			spawnice2()
		else: spawnice4()
	if chance > 0.66 and chance < 0.97:
		if lastice != 3:
			lastice = 3
			spawnice3()
		else: spawnice4()
	if chance > 0.97 and chance < 0.99:
		spawnigloo()
	if chance > 0.99:
		spawnfort()



func spawnextras():
	rollchance()
	if chance > 0.7:
		lastextra = 1
		spawnmove()
	elif chance < 0.3:
		lastextra = 2
		spawnspin()
	elif chance < 0.5 and chance > 0.3:
		lastextra = 3
		spawnjump()
	else: pass

func printdbg(text: String):
	if Global.DEBUG:
		print(text)
