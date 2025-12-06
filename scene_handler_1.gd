extends Node

@onready var play_button = $MainMenu/M/VB/Play
@onready var quit_button = $MainMenu/M/VB/Quit

const GAME_SCENE = preload("res://Scenes/MainScenes/game_scene.tscn")

func _ready() -> void:
	play_button.pressed.connect(on_play_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_play_pressed() -> void:
	$MainMenu.queue_free()
	
	var game_instance = GAME_SCENE.instantiate()
	add_child(game_instance)
	
func on_quit_pressed() -> void:
	get_tree().quit() 
