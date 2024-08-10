extends CharacterBody3D

var max_speed = 0.0
var speed = 10.0
var new_speed = 10.0
var jump_velocity = 5
var sensitivity = 0.003

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# bob variables
var bob_frequency = 2.0
var bob_amplifier = 0.08
var t_bob = 0.0

# fov_variation
var base_fov = 77.0
var fov_change = 1.2

# slide variables
var is_sliding = false
var is_jumping = false
var timing_frames = false
var timing_frames2 = false
var currently_playing_slide_anim = false

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var label = $ConsoleLayer/Label
@onready var animation_player = $AnimationPlayer
@onready var running_animation = $Head/Mesh/AnimationPlayer
@onready var bone = $"Head/Mesh/game-rig/Skeleton3D/BoneAttachment3D"





func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	running_animation.play("BAKED_idle-1")
	





func _process(delta):
	camera.global_position = bone.global_position
	if is_sliding:
		timing_frames = false
	if speed >= 20:
		$ConsoleLayer/SpeedEffect.show()
	elif speed < 20:
		$ConsoleLayer/SpeedEffect.hide()
	label.text = "is_sliding = " + str(is_sliding) + " 
			" + "speed = " + str(speed) + "
			" + "is_jumping = " + str(is_jumping) + "
			" + "is_on_floor = " + str(is_on_floor()) + "
			" + "timing_frames = " + str(timing_frames) + "
			" + "timing_frames2 = " + str(timing_frames2) + "
			" + "max_speed = " + str(Global.global_speed) + " km/h"

	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


		


func _physics_process(delta):
	save_local_new_speed()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif is_on_floor() and is_sliding:
		velocity.y -= 20

	if !is_on_floor():
		is_jumping = true
	else:
		is_jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_sliding = false
		velocity.y = jump_velocity
		animation_player.stop()
		speed = new_speed
		new_speed = 10
		$JumpSound.play()
		
	
	
	
	if is_jumping and Input.is_action_just_pressed("slide"):
		timing_frames = true
		$TimingTimer.start()
	
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if direction == Vector3.ZERO and !currently_playing_slide_anim:
		running_animation.play("BAKED_idle-1")


	
	if is_on_floor():
		if Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed == 10.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 14.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_2")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 18.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_3")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 20.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_4")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 22.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_5")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 24.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_6")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 26.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_7")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 28.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_8")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 30.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_9")
		elif Input.is_action_just_pressed("slide") and !direction == Vector3.ZERO and speed <= 32.0 and !is_sliding and !timing_frames:
			is_sliding = true
			animation_player.play("slide_animation_9")



			
		if direction:
			if !is_sliding and !currently_playing_slide_anim:
				running_animation.play("BAKED_running-fast")
			elif is_sliding:
				running_animation.play("BAKED_slide")
				currently_playing_slide_anim = true
			velocity.x = direction.x * speed / 2
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 8.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 8.0)
	if !direction == Vector3.ZERO and speed <= 14.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_2")
	elif !direction == Vector3.ZERO and speed <= 18.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_3")
	elif !direction == Vector3.ZERO and speed <= 20.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_4")
	elif !direction == Vector3.ZERO and speed <= 22.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_5")
	elif !direction == Vector3.ZERO and speed <= 24.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_6")
	elif !direction == Vector3.ZERO and speed <= 26.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_7")
	elif !direction == Vector3.ZERO and speed <= 28.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_8")
	elif !direction == Vector3.ZERO and speed <= 30.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_9")
	elif !direction == Vector3.ZERO and speed <= 31.0 and !is_sliding and timing_frames and is_on_floor():
		is_sliding = true
		animation_player.play("slide_animation_9")
	#elif !direction == Vector3.ZERO and speed <= 34.0 and !is_sliding and timing_frames and is_on_floor():
		#is_sliding = true
		#animation_player.play("slide_animation_10")
	#elif !direction == Vector3.ZERO and speed <= 35.0 and !is_sliding and timing_frames and is_on_floor():
		#is_sliding = true
		#animation_player.play("slide_animation_11")
	#elif !direction == Vector3.ZERO and speed <= 36.0 and !is_sliding and timing_frames and is_on_floor():
		#is_sliding = true
		#animation_player.play("slide_animation_12")
	#elif !direction == Vector3.ZERO and speed <= 37.0 and !is_sliding and timing_frames and is_on_floor():
		#is_sliding = true
		#animation_player.play("slide_animation_13")
	#elif !direction == Vector3.ZERO and speed <= 38.0 and !is_sliding and timing_frames and is_on_floor():
		#is_sliding = true
		#animation_player.play("slide_animation_14")
	#elif !direction == Vector3.ZERO and speed <= 39.0 and !is_sliding and timing_frames and is_on_floor():
		#is_sliding = true
		#animation_player.play("slide_animation_15")
	#elif !direction == Vector3.ZERO and speed <= 41.0 and !is_sliding and timing_frames and is_on_floor():
		#is_sliding = true
		#animation_player.play("slide_animation_15")

			
			
			
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
	
	Global.global_direction = direction
	
	move_and_slide()
	
	if speed > 10.0 and is_on_floor() and !is_sliding and !timing_frames:
		await get_tree().create_timer(0.5).timeout
		if !is_jumping and !timing_frames2:
			speed = 10.0



func save_local_new_speed():
	new_speed = speed
	if max_speed < speed:
		Global.global_speed = speed * 3
		max_speed = speed

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplifier
	pos.x = cos(time * bob_frequency / 2) * bob_amplifier
	return pos

func _input(event):
	if event.is_action_pressed("end"):
		get_tree().quit()
	if event.is_action_pressed("slide"):
		$TimingTimer2.start()
		timing_frames2 = true
		
	if event.is_action_pressed("mouse_right"):
		running_animation.play("BAKED_idle-1")

# checks the slide_animation
func _on_animation_player_animation_finished(anim_name):
	is_sliding = false
	if anim_name == "BAKED_slide":
		currently_playing_slide_anim = false








func _on_timing_timer_timeout():
	timing_frames = false


func _on_timing_timer_2_timeout():
	timing_frames2 = false





