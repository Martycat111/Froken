extends Node2D

var Spin = load("res://scenes/Spin.tscn")
var Move = load("res://scenes/Move.tscn")
var Ice = load("res://scenes/Ice.tscn")
@onready var Objects = get_node("../Objects")
@onready var Player = get_node("../Player")

var ice1 = load("res://scenes/Ice/ice_1.tscn")

var timesincespawn = 0
var spawninterval

#speedup ratio to normal
#normal is 300
# 300 + Globals.speedup / 300

var speedup_ratio = 1
func _process(delta: float) -> void:
	speedup_ratio = float((300 + Global.speedup)) / 300
	timesincespawn += delta
	spawninterval = 2 / float(speedup_ratio)
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
	#instance.position.y = 200


func spawn():
	spawnbase()
	#var chance = randf()
	#if chance > 0.5:
	#	spawnmove()
	#if chance < 0.3:
	#	spawnspin()
	#if chance < 0.5 and chance > 0.3:
	#	spawnice()


func spawnbase():
	spawnice1()
