extends Node2D

var Spin = load("res://scenes/Spin.tscn")
var Move = load("res://scenes/Move.tscn")
var Ice = load("res://scenes/Ice.tscn")
@onready var Objects = get_node("../Objects")
@onready var Player = get_node("../Player")

var ice1 = load("res://scenes/Ice/ice_1.tscn")
var ice2 = load("res://scenes/Ice/ice_2.tscn")
var ice3 = load("res://scenes/Ice/ice_3.tscn")
var ice4 = load("res://scenes/Ice/ice_4.tscn")

var timesincespawn = 0
var spawninterval
var chance

var lastice = 0

#speedup ratio to normal
#normal is 300
# 300 + Globals.speedup / 300

var speedup_ratio = 1
func _process(delta: float) -> void:
	speedup_ratio = float((300 + Global.speedup)) / 300
	timesincespawn += delta
	spawninterval = 1.995 / float(speedup_ratio)
	if timesincespawn > spawninterval:
		spawn()
		timesincespawn = 0

func spawnspin():
	var instance = Spin.instantiate()
	Objects.add_child(instance)

func spawnmove(ypos = null):
	var instance = Move.instantiate()
	Objects.add_child(instance)
	if (ypos): instance.position.y = ypos

func spawnice(ypos = null):
	var instance = Ice.instantiate()
	Objects.add_child(instance)
	if (ypos): instance.position.y = ypos

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


func spawn():
	spawnbase()
	#var chance = randf()
	#if chance > 0.5:
	#	spawnmove()
	#if chance < 0.3:
	#	spawnspin()
	#if chance < 0.5 and chance > 0.3:
	#	spawnice()

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
