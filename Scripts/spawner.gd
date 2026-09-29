extends Node2D



@onready var Objects = get_node("../Objects")
@onready var Player = get_node("../Player")
@onready var Extras = get_node("../Extras")


var Spin = load("res://scenes/spin.tscn")
var Move = load("res://scenes/move.tscn")
var Jumpup = load("res://scenes/jumpup.tscn")


var ice1 = load("res://scenes/Ice/ice_1.tscn")
var ice2 = load("res://scenes/Ice/ice_2.tscn")
var ice3 = load("res://scenes/Ice/ice_3.tscn")
var ice4 = load("res://scenes/Ice/ice_4.tscn")

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
	extrasincelastspawn += (300 + Global.speedup) * delta
	
	if sincelastspawn > spawninterval:
		spawnbase()
		sincelastspawn = 0
	if extrasincelastspawn > extraspawninterval:
		spawnextras()
		extrasincelastspawn = 0

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

func rollchance():
	chance = randf()

func spawnbase():
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
	if chance > 0.66:
		if lastice != 3:
			lastice = 3
			spawnice3()
		else: spawnice4()

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
