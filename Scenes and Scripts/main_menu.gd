extends Node3D


func _on_button_pressed():
	SceneTransition.change_scene_to_file("res://Scenes and Scripts/Blockout_level.tscn")


func _on_credits_pressed():
	SceneTransition.change_scene_to_file("res://Scenes and Scripts/credits.tscn")
