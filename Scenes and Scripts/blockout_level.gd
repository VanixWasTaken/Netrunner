extends Node3D

var level_state = "blue" # can be "blue" or "red"
var first_movement = true
var total_time_in_sec : int = 0
var should_count = true
@onready var shader = preload("res://Shader/wireframe.tres")
var shader_changed = false
@onready var empty_shader = preload("res://Shader/empty_shader.tres")
@onready var rune_shader = preload("res://Shader/rune_switch.tres")

func _input(event):
	if event.is_action_pressed("mouse_left"):
		$SceneTransition/ColorRect/AnimationPlayer.play("evolvedissolve")
		if level_state == "blue":
			level_state = "red"
		elif level_state == "red":
			level_state = "blue"
		$GogglesSound.play()
	#if event.is_action_pressed("mouse_right"):
		#get_tree().reload_current_scene()

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
		if shader_changed == false:
			for mesh_instance in get_tree().get_nodes_in_group("platform_blue"):
				if mesh_instance is MeshInstance3D:
					mesh_instance.material_override = null
				
			for mesh_instance in get_tree().get_nodes_in_group("platform_red"):
				if mesh_instance is MeshInstance3D:
					mesh_instance.material_override = rune_shader
				
			for mesh_instance in get_tree().get_nodes_in_group("material_switch"):
				if mesh_instance is MeshInstance3D:
					var material_count = mesh_instance.mesh.get_surface_count()
					mesh_instance.material_overlay = null
					for i in range(material_count):
						var material = mesh_instance.mesh.surface_get_material(i)
						if material is StandardMaterial3D:
							material.next_pass = empty_shader
							shader_changed = true
	elif level_state == "red":
		for i in get_tree().get_nodes_in_group("blue"):
			i.use_collision = false
		for i in get_tree().get_nodes_in_group("blue"):
			i.visible = false
		for i in get_tree().get_nodes_in_group("red"):
			i.use_collision = true
		for i in get_tree().get_nodes_in_group("red"):
			i.visible = true
		if shader_changed == true:
			for mesh_instance in get_tree().get_nodes_in_group("platform_blue"):
				if mesh_instance is MeshInstance3D:
					mesh_instance.material_override = rune_shader
				
			for mesh_instance in get_tree().get_nodes_in_group("platform_red"):
				if mesh_instance is MeshInstance3D:
					mesh_instance.material_override = null
					
			for mesh_instance in get_tree().get_nodes_in_group("material_switch"):
				if mesh_instance is MeshInstance3D:
					var material_count = mesh_instance.mesh.get_surface_count()
					mesh_instance.material_overlay = rune_shader
					for i in range(material_count):
						var material = mesh_instance.mesh.surface_get_material(i)
						if material is StandardMaterial3D:
							material.next_pass = shader
							shader_changed = false
	
	if Global.global_direction != Vector3.ZERO and first_movement:
		first_movement = false
	if !first_movement:
		await get_tree().create_timer(0.01).timeout
		total_time_in_sec += 1
		if should_count:
			convert_time(delta)
	
	
	
	



func _on_death_area_body_entered(body):
	$DeathSound.play()
	SceneTransition.change_scene_to_file("res://Scenes and Scripts/Blockout_level.tscn")




func _on_goal_body_entered(body):
	Engine.time_scale = 0.4
	$Goal/WinScreen.show()
	$Goal/WinScreen/MatchEnd/RankAnimation.play("match_end")
	should_count = false
	

func convert_time(delta):
	var m = int(total_time_in_sec / 60) * delta
	var s = (total_time_in_sec - m * 60) * delta
	var ms = randf_range(1, 99)
	$Goal/WinScreen/MatchEnd/Time.text = '%02d:%02d:%02d' % [m, s, ms]
	$Assets/Monitor/MonitorBig/SubViewport/ColorRect/RichTextLabel.text = '%02d:%02d:%02d' % [m, s, ms]
	$Assets/Monitor/MonitorBig2/SubViewport/ColorRect/RichTextLabel.text = '%02d:%02d:%02d' % [m, s, ms]
	$Assets/Monitor/MonitorBig3/SubViewport/ColorRect/RichTextLabel.text = '%02d:%02d:%02d' % [m, s, ms]
	$Assets/Monitor/MonitorBig4/SubViewport/ColorRect/RichTextLabel.text = '%02d:%02d:%02d' % [m, s, ms]
	$Assets/Monitor/MonitorBig5/SubViewport/ColorRect/RichTextLabel.text = '%02d:%02d:%02d' % [m, s, ms]
	$Assets/Monitor/MonitorBig6/SubViewport/ColorRect/RichTextLabel.text = '%02d:%02d:%02d' % [m, s, ms]
	
	if s < 30:
		$"Goal/WinScreen/MatchEnd/S Tier".visible = true
		$"Goal/WinScreen/MatchEnd/A Tier".visible = false
		$"Goal/WinScreen/MatchEnd/A Tier".visible = false
		$"Goal/WinScreen/MatchEnd/C Tier".visible = false
		$"Goal/WinScreen/MatchEnd/ColorRect".color = Color(0, 0.482, 0.482, 0.553) #(0,189,184,55)
	elif s < 40:
		$"Goal/WinScreen/MatchEnd/S Tier".visible = false
		$"Goal/WinScreen/MatchEnd/A Tier".visible = true
		$"Goal/WinScreen/MatchEnd/B Tier".visible = false
		$"Goal/WinScreen/MatchEnd/C Tier".visible = false
		$"Goal/WinScreen/MatchEnd/ColorRect".color = Color(0.392, 0.455, 0, 0.447)
	elif s < 50:
		$"Goal/WinScreen/MatchEnd/S Tier".visible = false
		$"Goal/WinScreen/MatchEnd/A Tier".visible = false
		$"Goal/WinScreen/MatchEnd/B Tier".visible = true
		$"Goal/WinScreen/MatchEnd/C Tier".visible = false
		$"Goal/WinScreen/MatchEnd/ColorRect".color = Color(0.879, 0.983, 0.98, 0.447)
	elif s >= 50:
		$"Goal/WinScreen/MatchEnd/S Tier".visible = false
		$"Goal/WinScreen/MatchEnd/A Tier".visible = false
		$"Goal/WinScreen/MatchEnd/B Tier".visible = false
		$"Goal/WinScreen/MatchEnd/C Tier".visible = true
		$"Goal/WinScreen/MatchEnd/ColorRect".color = Color(0.879, 0.983, 0.98, 0.447)


