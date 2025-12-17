extends Node

const GAME_SCENE = preload("res://Scenes/MainScenes/game_scene.tscn")
const MAIN_MENU = preload("res://Scenes/UIScenes/main_menu.tscn")
const RESULT_SCREEN = preload("res://Scenes/UIScenes/result_scene.tscn")
const LEVEL_SELECTION = preload("res://Scenes/UIScenes/level_selection.tscn")
const SPLASH_SCREEN = preload("res://Scenes/UIScenes/splash_screen_manager.tscn")

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
	
	show_level_selection()
	
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
	
func load_level1():
	game_instance = GAME_SCENE.instantiate()
	game_instance.connect("game_finished", unload_game)
	add_child(game_instance)
	
func show_level_selection():
	var level_selection_scene = LEVEL_SELECTION.instantiate()
	add_child(level_selection_scene)
	
	var back_button = level_selection_scene.get_node("Back")
	var level1_button = level_selection_scene.get_node("Level1")
	
	back_button.pressed.connect(on_main_menu_pressed)
	level1_button.pressed.connect(load_level1)

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
	
func fade() -> void:
	var splash_screen_node = SPLASH_SCREEN.instantiate()
	add_child(splash_screen_node)
	
	var splash_screen = splash_screen_node.get_node("CenterContainer/SplashScreen")
	
	splash_screen.modulate.a = 0.0
	var tween = self.create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(splash_screen, "modulate:a", 1.0, 1.5)
	tween.tween_interval(1.5)
	tween.tween_property(splash_screen, "modulate:a", 0.0, 1.5)
	tween.tween_interval(1.5)
	await tween.finished
	
	splash_screen_node.queue_free()
	
	load_main_menu()
