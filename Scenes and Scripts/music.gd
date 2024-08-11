extends AudioStreamPlayer

@onready var music_track1 = preload("res://Assets/Audio/Music/background_track1.ogg")
@onready var music_track2 = preload("res://Assets/Audio/Music/background_track2.wav")

@onready var music = $"."


func _ready():
	var random_num = randi() % 2
	if random_num == 0:
		music.stream = music_track1
		music.play()
	elif random_num == 1:
		music.stream = music_track2
		music.play()




func _on_finished():
	if music.stream == music_track1:
		music.stream = music_track2
		music.play()
	elif  music.stream == music_track2:
		music.stream = music_track1
		music.play()
