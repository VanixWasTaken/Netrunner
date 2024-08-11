extends CanvasLayer


func _on_button_pressed():
	SceneTransition.change_scene_to_file("res://Scenes and Scripts/Blockout_level.tscn")


func _on_credits_pressed():
	SceneTransition.change_scene_to_file("res://Scenes and Scripts/credits.tscn")

func _input(event):
	if event.is_action_pressed("f7"):
		get_tree().change_scene_to_file("res://Scenes and Scripts/test_level.tscn")
	if event.is_action_pressed("end"):
		get_tree().quit()


func _on_start_mouse_entered():
	$HoverClick.play()
func _on_credits_mouse_entered():
	$HoverClick.play()
