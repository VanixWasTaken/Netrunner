extends CharacterBody3D


@export var speed = 10.0
var new_speed = 10
@export var jump_velocity = 4.5
@export var sensitivity = 0.003

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# bob variables
var bob_frequency = 2.0
@export var bob_amplifier = 0.08
var t_bob = 0.0

# fov_variation
@export var base_fov = 77.0
@export var fov_change = 1.2

# slide variables
var is_sliding = false
var is_jumping = false

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var label = $ConsoleLayer/Label
@onready var animation_player = $AnimationPlayer



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# label test text
	label.text = "is_sliding = " + str(is_sliding) + " 
	" + str(speed) + "
			" + "is_jumping = " + str(is_jumping)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _process(delta):
	label.text = "is_sliding = " + str(is_sliding) + " 
			" + str(speed) + "
			" + "is_jumping = " + str(is_jumping)


func _physics_process(delta):
	save_local_new_speed()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		is_sliding = false
		velocity.y = jump_velocity
		animation_player.stop()
		speed = new_speed
		new_speed = 10
	elif is_on_floor():
		is_jumping = false
	
	
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if is_on_floor():
		if Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed == 10:
			is_sliding = true
			animation_player.play("slide_animation")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed < 15:
			is_sliding = true
			animation_player.play("slide_animation_2")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed < 20:
			is_sliding = true
			animation_player.play("slide_animation_3")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed < 25:
			is_sliding = true
			animation_player.play("slide_animation_4")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed < 30:
			is_sliding = true
			animation_player.play("slide_animation_5")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed < 35:
			is_sliding = true
			animation_player.play("slide_animation_5")
			
		if direction:
			velocity.x = direction.x * speed / 2
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 8.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 8.0)
		
			
			
			
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	# head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, speed * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	
	move_and_slide()
	
	if speed > 10 and is_on_floor() and !is_sliding:
		await get_tree().create_timer(1).timeout
		if !is_jumping:
			speed = 10



func save_local_new_speed():
	new_speed = speed

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplifier
	pos.x = cos(time * bob_frequency / 2) * bob_amplifier
	return pos

func _input(event):
	if event.is_action_pressed("end"):
		get_tree().quit()

# checks the slide_animation
func _on_animation_player_animation_finished(anim_name):
	is_sliding = false
