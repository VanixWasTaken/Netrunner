extends CanvasLayer

func change_scene_to_file(target: String) -> void:
	$ColorRect/AnimationPlayer.play('dissolve')
	await $ColorRect/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$ColorRect/GlitchSound.play()
	$ColorRect/AnimationPlayer.play_backwards('dissolve')
