extends Node

const GAME_SCENE = preload("res://Scenes/MainScenes/game_scene.tscn")
const GAME_SCENE1 = preload("res://Scenes/MainScenes/game_scene_1.tscn")
const GAME_SCENE2 = preload("res://Scenes/MainScenes/game_scene_2.tscn")
const MAIN_MENU = preload("res://Scenes/UIScenes/main_menu.tscn")
const RESULT_SCREEN = preload("res://Scenes/UIScenes/result_scene.tscn")
const LEVEL_SELECTION = preload("res://Scenes/UIScenes/level_selection.tscn")
const SPLASH_SCREEN = preload("res://Scenes/UIScenes/splash_screen_manager.tscn")
const SETTINGS_SCREEN = preload("res://Scenes/UIScenes/settings.tscn")

var game_instance
var game_instance1
var game_instance2
var active_game
var last_played_level

func _ready() -> void:
	fade()
	
func load_main_menu():
	var main_menu_node = get_node("MainMenu")
	
	var play_button = main_menu_node.get_node("M/VB/Play")
	var settings_button = main_menu_node.get_node("M/VB/Settings")
	var quit_button = main_menu_node.get_node("M/VB/Quit")
	
	settings_button.pressed.connect(on_settings_pressed)
	play_button.pressed.connect(on_play_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	
	if not MusicController.main_menu_bgm.playing:
		MusicController.mainmenu_bgm_play()

func on_play_pressed() -> void:
	get_node("MainMenu").queue_free()
	
	show_level_selection()
	
func on_quit_pressed() -> void:
	get_tree().quit() 
	
func on_settings_pressed() -> void:
	get_node("MainMenu").queue_free()
	
	show_settings()

func unload_game(result):
	active_game.queue_free()
	if MusicController.level1_bgm.playing:
		MusicController.level1_bgm_stop()
	elif MusicController.level2_bgm.playing:
		MusicController.level2_bgm_stop()
	elif MusicController.level3_bgm.playing:
		MusicController.level3_bgm_stop()

	if result:
		show_result_screen("Victory!", true)
		MusicController.victory_sfx_play()
	else:
		show_result_screen("Defeat!", false)
		MusicController.defeat_sfx_play()
	
	#var main_menu_instance = MAIN_MENU.instantiate()
	#add_child(main_menu_instance)
	#load_main_menu()
	
func load_level1():
	remove_level_selection_scene()
	
	await show_stage1_cutscene()
	
	MusicController.level1_bgm_play()
	active_game = GAME_SCENE.instantiate()
	active_game.connect("game_finished", unload_game)
	add_child(active_game)
	last_played_level = 1
	
func load_level2():
	remove_level_selection_scene()
	
	await show_stage2_cutscene()
	
	MusicController.level2_bgm_play()
	active_game = GAME_SCENE1.instantiate()
	active_game.connect("game_finished", unload_game)
	add_child(active_game)
	last_played_level = 2
	
func load_level3():
	remove_level_selection_scene()
	
	await show_stage3_cutscene()
	
	MusicController.level3_bgm_play()
	active_game = GAME_SCENE2.instantiate()
	active_game.connect("game_finished", unload_game)
	add_child(active_game)
	last_played_level = 3
	
func show_settings():
	if not MusicController.main_menu_bgm.playing:
		MusicController.mainmenu_bgm_play()
		
	var settings_scene = SETTINGS_SCREEN.instantiate()
	add_child(settings_scene)
	
	var back_button = settings_scene.get_node("VBoxContainer2/Back")
	
	back_button.pressed.connect(on_main_menu_pressed)
	
func show_level_selection():
	if not MusicController.main_menu_bgm.playing:
		MusicController.mainmenu_bgm_play()
	
	var level_selection_scene = LEVEL_SELECTION.instantiate()
	add_child(level_selection_scene)
	
	var back_button = level_selection_scene.get_node("Back")
	var level1_button = level_selection_scene.get_node("Level1")
	var level2_button = level_selection_scene.get_node("Level2")
	var level3_button = level_selection_scene.get_node("Level3")
	
	back_button.pressed.connect(on_main_menu_pressed)
	level1_button.pressed.connect(load_level1)
	level2_button.pressed.connect(load_level2)
	level3_button.pressed.connect(load_level3)

func show_result_screen(msg, is_victory):
	var result_screen = RESULT_SCREEN.instantiate()
	add_child(result_screen)
	
	var label = result_screen.get_node("Label")
	label.text = msg
	
	var background = result_screen.get_node("B")
	
	if is_victory:
		background.texture = load("res://Assets/UI/Arts/victory.png")
	else:
		background.texture = load("res://Assets/UI/Arts/defeat.png")
	
	var replay_button = result_screen.get_node("Replay")
	var main_menu_button = result_screen.get_node("MainMenu")
	var select_level_button = result_screen.get_node("SelectLevel")
	
	replay_button.pressed.connect(on_replay_pressed)
	main_menu_button.pressed.connect(on_main_menu_pressed)
	select_level_button.pressed.connect(on_selectlevel_pressed)

func on_selectlevel_pressed():
	remove_result_scene()
	show_level_selection()

func on_replay_pressed():
	remove_result_scene()
	
	if last_played_level == 1:
		load_level1()
	elif last_played_level == 2:
		load_level2()
	elif last_played_level == 3:
		load_level3()
	
func remove_result_scene():
	var result_scene = get_node("ResultScene")
	
	if result_scene != null:
		result_scene.queue_free()
		
	if MusicController.victory_sfx.playing or MusicController.defeat_sfx.playing:
		MusicController.victory_sfx_stop()
		MusicController.defeat_sfx_stop()
		
func remove_level_selection_scene():
	if has_node("LevelSelection"):
		get_node("LevelSelection").queue_free()
	
	if MusicController.main_menu_bgm.playing:
		MusicController.mainmenu_bgm_stop()
	
func on_main_menu_pressed():
	remove_result_scene()
	
	var main_menu_instance = MAIN_MENU.instantiate()
	add_child(main_menu_instance)
	load_main_menu()
	
func fade() -> void:
	var splash_screen_node = SPLASH_SCREEN.instantiate()
	add_child(splash_screen_node)
	
	var splash_screen = splash_screen_node.get_node("CenterContainer/SplashScreen")
	var opening_scene = splash_screen_node.get_node("CenterContainer/Opening")
	var stage1_scene = splash_screen_node.get_node("CenterContainer/Stage1")
	var stage2_scene = splash_screen_node.get_node("CenterContainer/Stage2")
	var stage3_scene = splash_screen_node.get_node("CenterContainer/Stage3")
	
	splash_screen.modulate.a = 0.0
	opening_scene.modulate.a = 0.0
	stage1_scene.modulate.a = 0.0
	stage2_scene.modulate.a = 0.0
	stage3_scene.modulate.a = 0.0
	
	var tween = self.create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(splash_screen, "modulate:a", 1.0, 1.5)
	tween.tween_interval(1.5)
	tween.tween_property(splash_screen, "modulate:a", 0.0, 1.5)
	tween.tween_interval(1.5)
	
	tween.tween_interval(0.5)
	tween.tween_property(opening_scene, "modulate:a", 1.0, 1.5)
	tween.tween_interval(5.0)
	tween.tween_property(opening_scene, "modulate:a", 0.0, 1.5)
	tween.tween_interval(1.5)	
	await tween.finished
	
	splash_screen_node.queue_free()
	
	load_main_menu()

func show_stage1_cutscene() -> void:
	var splash_screen_node = SPLASH_SCREEN.instantiate()
	add_child(splash_screen_node)
	
	var splash_screen = splash_screen_node.get_node("CenterContainer/SplashScreen")
	var opening_scene = splash_screen_node.get_node("CenterContainer/Opening")
	var stage1_scene = splash_screen_node.get_node("CenterContainer/Stage1")
	var stage2_scene = splash_screen_node.get_node("CenterContainer/Stage2")
	var stage3_scene = splash_screen_node.get_node("CenterContainer/Stage3")
	
	splash_screen.modulate.a = 0.0
	opening_scene.modulate.a = 0.0
	stage1_scene.modulate.a = 0.0
	stage2_scene.modulate.a = 0.0
	stage3_scene.modulate.a = 0.0
	
	var tween = self.create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(stage1_scene, "modulate:a", 1.0, 1.5)
	tween.tween_interval(5.0)
	tween.tween_property(stage1_scene, "modulate:a", 0.0, 1.5)
	tween.tween_interval(1.5)	
	await tween.finished
	
	splash_screen_node.queue_free()

func show_stage2_cutscene() -> void:
	var splash_screen_node = SPLASH_SCREEN.instantiate()
	add_child(splash_screen_node)
	
	var splash_screen = splash_screen_node.get_node("CenterContainer/SplashScreen")
	var opening_scene = splash_screen_node.get_node("CenterContainer/Opening")
	var stage1_scene = splash_screen_node.get_node("CenterContainer/Stage1")
	var stage2_scene = splash_screen_node.get_node("CenterContainer/Stage2")
	var stage3_scene = splash_screen_node.get_node("CenterContainer/Stage3")
	
	splash_screen.modulate.a = 0.0
	opening_scene.modulate.a = 0.0
	stage1_scene.modulate.a = 0.0
	stage2_scene.modulate.a = 0.0
	stage3_scene.modulate.a = 0.0
	
	var tween = self.create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(stage2_scene, "modulate:a", 1.0, 1.5)
	tween.tween_interval(5.0)
	tween.tween_property(stage2_scene, "modulate:a", 0.0, 1.5)
	tween.tween_interval(1.5)	
	await tween.finished
	
	splash_screen_node.queue_free()

func show_stage3_cutscene() -> void:
	var splash_screen_node = SPLASH_SCREEN.instantiate()
	add_child(splash_screen_node)
	
	var splash_screen = splash_screen_node.get_node("CenterContainer/SplashScreen")
	var opening_scene = splash_screen_node.get_node("CenterContainer/Opening")
	var stage1_scene = splash_screen_node.get_node("CenterContainer/Stage1")
	var stage2_scene = splash_screen_node.get_node("CenterContainer/Stage2")
	var stage3_scene = splash_screen_node.get_node("CenterContainer/Stage3")
	
	splash_screen.modulate.a = 0.0
	opening_scene.modulate.a = 0.0
	stage1_scene.modulate.a = 0.0
	stage2_scene.modulate.a = 0.0
	stage3_scene.modulate.a = 0.0
	
	var tween = self.create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(stage3_scene, "modulate:a", 1.0, 1.5)
	tween.tween_interval(5.0)
	tween.tween_property(stage3_scene, "modulate:a", 0.0, 1.5)
	tween.tween_interval(1.5)	
	await tween.finished
	
	splash_screen_node.queue_free()
