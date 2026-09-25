extends Node2D

var Spin = load("res://scenes/Spin.tscn")
var Move = load("res://scenes/Move.tscn")
var Ice = load("res://scenes/Ice.tscn")
@onready var Objects = get_node("../Objects")
@onready var Player = get_node("../Player")

var timesincespawn = 0
var spawninterval = 1


func _process(delta: float) -> void:
	timesincespawn += delta
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


func spawn():
	var chance = randf()
	if chance > 0.5:
		spawnmove()
	if chance < 0.3:
		spawnspin()
	if chance < 0.5 and chance > 0.3:
		spawnice()
