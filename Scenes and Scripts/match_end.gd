extends Control


func _process(delta):
	$KMH.text = str(Global.global_speed).pad_decimals(0) + " km/h"
