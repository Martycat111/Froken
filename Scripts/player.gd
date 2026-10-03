extends CharacterBody2D

@onready var Fademan = get_node("../Fade/Fademan")

var titlescene = load("res://scenes/Titlescreen.tscn")

var spin_add_velocity = 400

var x_drag = 200

var rotate_amount = 5
var rotate_velocity = 0

var rotate_drag = 100
var rotate_terminal_velocity = 100
var holding = false #is holding
var hold_velocity = 10 #additional hold vertical velocity
const JUMP_VELOCITY = 500.0

var hold_timeout = 0.5
var hold_time = 0

var time_since_last_speedup = 0
var speedup_frequency = 2
var speedup_amount = 10 #speedup increment

var tempspeedup = 0 # current amount of temporary speedup
var tempspeed = false #temporary speedup is active
var tempspeedslowdown = 250 #amount to take off the temporary speedup (drag)

#jumps left
var floorjumpamount = 3 #number of jumps when on floor
var numjumpsleft = 4 #current number of jumps
var canjump = true

#was on floor
var wasonfloor = false
var was_check_rate = 0.1 #check every _ seconds
var was_time_since_check = 0 

var time_on_floor = 0
var current_floor_session_max_angle = 0

var ramp_jump_threshold = 0
var ramp_jump_angle_threshold = -0.5

var DEBUG = Global.DEBUG


func _physics_process(delta: float) -> void:
	#global can access the current amount of temp speedup
	Global.tempspeedupamount = tempspeedup
	
	#global can access the current amount of jumps left
	Global.jumpsleft = numjumpsleft
	
	#jump count and stop
	if numjumpsleft < 0 or numjumpsleft == 0:
		canjump = false
	
	#set jumps if on floor
	if is_on_floor():
		numjumpsleft = floorjumpamount
		canjump = true
	
	#always go to the same place
	if position.x > 556.0: 
		position.x -= 3
	if position.x < 556.0:
		position.x += 3
	#snap if close enough
	if abs(556 - position.x) < 5:
		position.x = 556.0
	
	
	if tempspeed:
		tempspeedup -= tempspeedslowdown * delta
		Global.speedup -= tempspeedslowdown * delta
	if abs(tempspeedup) < 10:
		tempspeed = false
	
	if holding:
		velocity.y -= hold_velocity
		rotate_velocity += rotate_amount
	
	if !hold_time < hold_timeout: #stop adding velocity after a period of time
		holding = false
	
	#if rotating, add drag
	if rotate_velocity > 0:
		rotate_velocity -= rotate_drag * delta
	
	#check if rotating backwards, set to not rotating.
	if rotate_velocity < 0:
		rotate_velocity = 0
	
	#max rotate speed
	if rotate_velocity > rotate_terminal_velocity:
		rotate_velocity = rotate_terminal_velocity
	
	#rotate with speed
	if (300 + Global.speedup) / 600 > 2:
		rotate_velocity += (300 + Global.speedup) / 600
	
	#gravity
	var gravity = get_gravity() / 1.3
	velocity += gravity * delta
	
	#hold time
	if holding: hold_time += delta
	#speedup
	if time_since_last_speedup > speedup_frequency: 
		Global.speedup += speedup_amount
		time_since_last_speedup = 0
	if Global.speedup > 2000:
		if !tempspeed:
			#won
			print("congradulations you have won capatilizism")
		else:
			Global.speedup -= tempspeedup
			tempspeed = false
			tempspeedup = 0
	#correction
	if self.get_rotation() < get_floor_normal()[0] and get_floor_normal()[0] != 0:
		self.rotate(0.03)
	if self.get_rotation() > get_floor_normal()[0] and get_floor_normal()[0] != 0: 
		self.rotate(-0.03)
	#rotation
	self.rotate((rotate_velocity / 10) * delta)
	
	time_since_last_speedup += delta
	
	
	#   check if bigger than current_floor_session_max_angle   and    that its a big enough difference to matter
	if get_floor_normal()[0] < current_floor_session_max_angle and abs(get_floor_normal()[0]) - abs(current_floor_session_max_angle) > 0.05:
		current_floor_session_max_angle = get_floor_normal()[0]
		printdbg("updated max: " + str(current_floor_session_max_angle))
	


	#ramp jump
	if wasonfloor and !is_on_floor():
		
		#was on floor now is not
		
		# speed check                                   and      floor angle was big enough                             and (self explanatory) sec
		if (300 + Global.speedup) > ramp_jump_threshold and current_floor_session_max_angle < ramp_jump_angle_threshold and time_on_floor > 0.2:
			#successful ramp
			rampjump()
			
		#failure code
		if 300 + Global.speedup < ramp_jump_threshold:
			printdbg("failed a")
		
		if current_floor_session_max_angle > ramp_jump_angle_threshold:
			printdbg("failed b: " + str(current_floor_session_max_angle) + " > " + str(ramp_jump_angle_threshold))
		
		if time_on_floor < 0.2:
			printdbg("failed c")
		
		was_time_since_check = was_check_rate + 1
		current_floor_session_max_angle = 0
		


	
	if was_time_since_check > was_check_rate:
		wasonfloor = is_on_floor()
		was_time_since_check = 0
		
		#if too close to 0 angle, reset it.
		if abs(get_floor_normal()[0]) < 0.1 and is_on_floor() and current_floor_session_max_angle != 0:
			printdbg("resetti spageriti")
			current_floor_session_max_angle = 0

	
	was_time_since_check += delta
	
	if is_on_floor():
		time_on_floor += delta
	else:
		time_on_floor = 0
	
	move_and_slide()


func add_rotate_velocity(amount):
	rotate_velocity += amount

func dead():
	titlescreen()

func _input(event):
	if event.is_action_pressed("exit"):
		titlescreen()
	
	if event.is_action_pressed("jump") and canjump:
		numjumpsleft -= 1
		velocity.y = 0 - JUMP_VELOCITY

	if event.is_action_pressed("jump"):
		holding = true
	if event.is_action_released("jump"):
		holding = false
		hold_time = 0


func hitjump():
	Global.score += 30
	velocity.y = -600
	
func hitspin():
	temporaryspeedup(50)
	Global.score += 10
	holding = false
	rotate_velocity += 90
	velocity.y = 0 - spin_add_velocity
	numjumpsleft += 1
	canjump = true
	
func hitmove():
	temporaryspeedup(200)
	velocity.y -= 150
	Global.speedup += 5


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dead()


func _on_move_back_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		velocity.y = 200

func temporaryspeedup(amount):
	if tempspeedup > 1000:
		return
	Global.speedup += amount
	tempspeedup += amount
	tempspeed = true

func titlescreen():
	Fademan.play("fade")
	await Fademan.animation_finished
	Global.score = 0
	Global.speedup = 0
	var title = titlescene.instantiate()
	get_tree().root.add_child(title) #add the titlescreen to the scene tree
	get_tree().root.get_node("Game").queue_free() #remove the game

func printdbg(text: String):
	if DEBUG:
		print(text)

func rampjump():
	if holding:
		printdbg("fayul ramp jump: jumping.")
		return
	if Global.speedup > 500:
		printdbg("ramp speedup")
		velocity.y -= Global.speedup
	else:
		printdbg("ramp default")
		velocity.y -= 500
	printdbg("Ramp jump")

func _exit_tree() -> void:
	printdbg("Player removed from tree")
