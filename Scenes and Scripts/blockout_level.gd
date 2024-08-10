extends Node3D

var level_state = "blue" # can be "blue" or "red"

@onready var box18 = $CSGBoxes/Boxes/Box18


func _ready():
	$SceneTransition/ColorRect/AnimationPlayer.play("evolvedissolve")

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
