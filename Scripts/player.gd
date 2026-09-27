extends CharacterBody2D

var spin_add_velocity = 400

var x_velocity = 0
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
var tempspeedslowdown = 3000 #amount to take off the temporary speedup (drag)

#jumps left
var floorjumpamount = 3 #number of jumps when on floor
var numjumpsleft = 4 #current number of jumps
var canjump = true

#was on floor
var wasonfloor = false
var was_check_rate = 0.5 #check every _ seconds
var was_time_since_check = 0 

var time_on_floor = 0
var current_floor_session_max_angle = 0


var DEBUG = true

func _physics_process(delta: float) -> void:
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
	if 300 + Global.speedup > 350:
		rotate_velocity += (300 + Global.speedup) / 500
	
	#gravity
	velocity += get_gravity() * delta
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
	
	
	
	if get_floor_normal()[0] < current_floor_session_max_angle:
		current_floor_session_max_angle = get_floor_normal()[0]
	
	if abs(get_floor_normal()[0]) < 0.1 and get_floor_normal()[0] != 0:
		current_floor_session_max_angle = 0
	
	#ramp jump
	if wasonfloor and !is_on_floor():
		
		
		if (300 + Global.speedup) > 500 and current_floor_session_max_angle < -0.3:
			#successful ramp
			velocity.y -= 300 + Global.speedup
			numjumpsleft = 0
		#failure debug code
		if current_floor_session_max_angle > -0.3:
			printdbg("failed b: " + str(current_floor_session_max_angle))
		if (300 + Global.speedup) < 500:
			printdbg("failed a")
		

		was_time_since_check = was_check_rate + 1
		current_floor_session_max_angle = 0
	
	
	if was_time_since_check > was_check_rate:
		wasonfloor = is_on_floor()
		was_time_since_check = 0

	
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
	x_velocity = 300
	velocity.y = -600
	
func hitspin():
	temporaryspeedup(50)
	Global.score += 10
	holding = false
	rotate_velocity += 90
	velocity.y = 0 - spin_add_velocity
	
func hitmove():
	temporaryspeedup(300)
	Global.speedup += 10
func hitramp():
	return
	Global.score += 20
	Global.speedup += 20

	position.y -= 20
	temporaryspeedup(100)
	
	if 200 + Global.speedup / 2 > 500:
		velocity.y -= 200 + Global.speedup / 2
	else:
		velocity.y -= 500
	rotate_velocity += 100


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dead()


func _on_move_back_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		x_velocity = -500
		velocity.y = 200

func temporaryspeedup(amount):
	if tempspeedup > 1000:
		return
	Global.speedup += amount
	tempspeedup += amount
	tempspeed = true

func titlescreen():
	get_tree().quit()

func printdbg(text: String):
	if DEBUG:
		print(text)
