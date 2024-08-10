extends Node3D

var level_state = "blue" # can be "blue" or "red"
var first_movement = true
var total_time_in_sec : int = 0
var should_count = true

func _input(event):
	if event.is_action_pressed("mouse_left"):
		$SceneTransition/ColorRect/AnimationPlayer.play("evolvedissolve")
		if level_state == "blue":
			level_state = "red"
		elif level_state == "red":
			level_state = "blue"
	if event.is_action_pressed("mouse_right"):
		get_tree().reload_current_scene()

func _process(delta):
	if level_state == "blue":
		for i in get_tree().get_nodes_in_group("blue"):
			i.use_collision = true
		for i in get_tree().get_nodes_in_group("blue"):
			i.visible = true
		for i in get_tree().get_nodes_in_group("red"):
			i.use_collision = false
		for i in get_tree().get_nodes_in_group("red"):
			i.visible = false
	elif level_state == "red":
		for i in get_tree().get_nodes_in_group("blue"):
			i.use_collision = false
		for i in get_tree().get_nodes_in_group("blue"):
			i.visible = false
		for i in get_tree().get_nodes_in_group("red"):
			i.use_collision = true
		for i in get_tree().get_nodes_in_group("red"):
			i.visible = true
	
	if Global.global_direction != Vector3.ZERO and first_movement:
		first_movement = false
	if !first_movement:
		await get_tree().create_timer(0.01).timeout
		total_time_in_sec += 1
		if should_count:
			convert_time()


func _on_death_area_body_entered(body):
	SceneTransition.change_scene_to_file("res://Scenes and Scripts/Blockout_level.tscn")




func _on_goal_body_entered(body):
	Engine.time_scale = 0.2
	$Goal/WinScreen.show()
	should_count = false
	

func convert_time():
	var m = int(total_time_in_sec / 60)
	var s = total_time_in_sec - m * 60
	$Counter/Label.text = '%02d:%02d' % [m, s]
	Global.time = total_time_in_sec


