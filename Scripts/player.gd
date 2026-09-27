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
var tempspeedslowdown = 300 #amount to take off the temporary speedup (drag)

# x = 1400 y = 800
func _physics_process(delta: float) -> void:
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
	
	#gravity
	velocity += get_gravity() * delta
	#hold time
	if holding: hold_time += delta
	#speedup
	if time_since_last_speedup > speedup_frequency: 
		Global.speedup += speedup_amount
		time_since_last_speedup = 0
		print(Global.speedup)
	if Global.speedup > 2000:
		if !tempspeed:
			#won
			print("congradulations you have won capatilizism")
		else:
			Global.speedup -= tempspeedup
			tempspeed = false
			tempspeedup = 0
	#correction
	if self.get_rotation() < get_floor_normal()[0]:
		self.rotate(0.02)
	if self.get_rotation() > get_floor_normal()[0]: 
		self.rotate(-0.02)
	#rotation
	self.rotate((rotate_velocity / 10) * delta)
	
	position.x += x_velocity * delta
	if x_velocity > 2:
		x_velocity -= x_drag * delta
	if x_velocity < -2:
		x_velocity += x_drag * delta
	time_since_last_speedup += delta
	move_and_slide()


func add_rotate_velocity(amount):
	rotate_velocity += amount

func dead():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("jump"):
		velocity.y = 0 - JUMP_VELOCITY
	if event.is_action_pressed("exit"):
		get_tree().quit()
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
	temporaryspeedup(10)
	Global.score += 10
	holding = false
	rotate_velocity += 90
	velocity.y = 0 - spin_add_velocity
func hitmove():
	temporaryspeedup(300)
	Global.speedup += 20
func hitramp():
	Global.score += 20
	position.y -= 10
	x_velocity += 350
	velocity.y -= 250


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
