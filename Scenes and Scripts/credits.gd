extends Control




func _on_back_pressed():
	SceneTransition.change_scene_to_file("res://Scenes and Scripts/main_menu.tscn")


func _on_back_mouse_entered():
	$HoverClick.play()
