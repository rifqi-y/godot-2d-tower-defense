extends Node

const GAME_SCENE = preload("res://Scenes/MainScenes/game_scene.tscn")
const MAIN_MENU = preload("res://Scenes/UIScenes/main_menu.tscn")
const RESULT_SCREEN = preload("res://Scenes/UIScenes/result_scene.tscn")

var game_instance

func _ready() -> void:
	load_main_menu()
	
func load_main_menu():
	var main_menu_node = get_node("MainMenu")
	
	var play_button = main_menu_node.get_node("M/VB/Play")
	var quit_button = main_menu_node.get_node("M/VB/Quit")
	
	play_button.pressed.connect(on_play_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_play_pressed() -> void:
	get_node("MainMenu").queue_free()
	
	game_instance = GAME_SCENE.instantiate()
	game_instance.connect("game_finished", unload_game)
	add_child(game_instance)
	
func on_quit_pressed() -> void:
	get_tree().quit() 

func unload_game(result):
	game_instance.queue_free()

	if result:
		show_result_screen("Victory!")
	else:
		show_result_screen("Defeat!")
	
	#var main_menu_instance = MAIN_MENU.instantiate()
	#add_child(main_menu_instance)
	#load_main_menu()

func show_result_screen(msg):
	var result_screen = RESULT_SCREEN.instantiate()
	add_child(result_screen)
	
	var label = result_screen.get_node("Label")
	label.text = msg
	
	var replay_button = result_screen.get_node("Replay")
	var main_menu_button = result_screen.get_node("MainMenu")
	
	replay_button.pressed.connect(on_replay_pressed)
	main_menu_button.pressed.connect(on_main_menu_pressed)
	
func on_replay_pressed():
	remove_result_scene()
	
	game_instance = GAME_SCENE.instantiate()
	game_instance.connect("game_finished", unload_game)
	add_child(game_instance)
	
func remove_result_scene():
	var result_scene = get_node("ResultScene")
	
	if result_scene != null:
		result_scene.queue_free()
	
func on_main_menu_pressed():
	var main_menu_instance = MAIN_MENU.instantiate()
	add_child(main_menu_instance)
	load_main_menu()
