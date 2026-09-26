extends CharacterBody2D

var spin_add_velocity = 400
var time_since_hit_spin = 0

var x_velocity = 0
var x_drag = 150

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
var speedup = 0 #current speedup
var speedup_frequency = 2
var speedup_amount = 5 #speedup increment

# x = 1400 y = 800
func _physics_process(delta: float) -> void:
	# allways stay in same place
	if position.x > 556.0: 
		position.x -= 3
	if position.x < 556.0:
		position.x += 3
	#snap if close enough
	if abs(556 - position.x) < 5:
		position.x = 556.0
	
	
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
		speedup += speedup_amount
		time_since_last_speedup = 0

	 
	#correction
	if self.get_rotation() < 0:
		self.rotate(0.03)
	if self.get_rotation() > 0: 
		self.rotate(-0.03)
		
	#rotation
	self.rotate((rotate_velocity / 10) * delta)
	
	position.x += x_velocity * delta
	if x_velocity > 2:
		x_velocity -= x_drag * delta
	if x_velocity < -2:
		x_velocity += x_drag * delta
	time_since_hit_spin += delta
	time_since_last_speedup += delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().name == "Ice":
			velocity.y += velocity.x
			#velocity.y = 0

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


func hitspin():
	if time_since_hit_spin > 0.1:
		Global.score += 10
		time_since_hit_spin = 0
		holding = false
		rotate_velocity += 90
		velocity.y = 0 - spin_add_velocity

func hitmove():
	x_velocity += 500


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dead()


func _on_move_back_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		x_velocity = -500
		velocity.y = 200
