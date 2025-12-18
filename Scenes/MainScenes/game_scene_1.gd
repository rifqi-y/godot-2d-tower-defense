extends Node2D

signal game_finished(result)

var map_node1

var build_mode = false
var build_valid = false
var build_location = false
var build_tile
var build_type
var base_health = 100
var base_money = 100

var spawned_enemies = 0
var killed_enemies = 0
var current_wave = 0
var enemies_in_wave = 0
var total_wave = 3

@onready var currency_label = $UI/InfoBar/H/Money
@onready var stage_result_scene = preload("res://Scenes/UIScenes/result_scene.tscn")

func _ready() -> void:
	print("Map ready: ", name)
	map_node1 = get_node("Map2")
	
	update_currency_label()
	
	for i in get_tree().get_nodes_in_group("build_button"):
		i.pressed.connect(initiate_build_mode.bind(i.name))
	
	var path_nodes = ["Path2D", "Path2D2"]
	
	for node in path_nodes:
		for enemy in map_node1.get_node(node).get_children():
			enemy.connect("enemy_killed", on_enemy_killed)
	
func _process(delta: float) -> void:
	if build_mode:
		update_tower_preview()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

##
## Wave Function
##
func start_next_wave():
	if current_wave == total_wave:
		emit_signal("game_finished", true)
		return
		
	var wave_data = retrieve_wave_data()
	await(get_tree().create_timer(0.2).timeout) ## Padding between waves
	spawn_enemies(wave_data)
	
func retrieve_wave_data():
	if current_wave >= total_wave:
		return []
	
	var wave_data = [
		["red_spirit", 0.7], ["red_spirit", 0.7], ["red_spirit", 0.7], ["red_spirit", 0.7], ["red_spirit", 0.7], ["red_spirit", 0.7], 
		["red_spirit", 15.0], ["red_spirit", 0.7], ["red_spirit", 0.7], ["red_spirit", 3.0], ["red_spirit", 0.7], ["red_spirit", 0.7], ["red_spirit", 0.7], ["red_spirit", 0.7],
		["red_spirit", 15.0], ["red_spirit", 0.5], ["red_spirit", 0.5], ["red_spirit", 0.5], ["red_spirit", 0.5], ["red_spirit", 0.5], ["red_spirit", 0.5], ["red_spirit", 0.5], ["red_spirit", 0.5], ["red_spirit", 0.5],
		["red_spirit", 15.0], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6], ["red_spirit", 0.6],
		["red_spirit", 20.0], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3], ["red_spirit", 0.3]
	]
	
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	var paths = [
		map_node1.get_node("Path2D"),
		map_node1.get_node("Path2D2")
	]
	
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		new_enemy.connect("base_damage", on_base_damage)
		new_enemy.connect("enemy_killed", on_enemy_killed)
		
		var path = paths.pick_random()
		
		path.add_child(new_enemy, true)
		
		spawned_enemies += 1
		print(spawned_enemies)
		await(get_tree().create_timer(i[1]).timeout)

##
## Building Function
##
func initiate_build_mode(tower_type):
	if build_mode:
		return
	
	build_type = tower_type
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var local_mouse = map_node1.get_node("TileMapLayer4").to_local(mouse_position)
	var current_tile = map_node1.get_node("TileMapLayer4").local_to_map(local_mouse)
	var tile_position = map_node1.get_node("TileMapLayer4").map_to_local(current_tile)
	
	if map_node1.get_node("TileMapLayer4").get_cell_source_id(current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "00b83cff")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
		
	else:
		get_node("UI").update_tower_preview(tile_position, "ff2913ff")
		build_valid = false
	
func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()
	
func verify_and_build():
	
	if build_valid:
		var tower_cost = GameData.tower_data[build_type]["cost"]
		if base_money >= tower_cost:
			var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
			new_tower.position = build_location
			new_tower.built = true
			new_tower.type = build_type
			new_tower.category = GameData.tower_data[build_type]["category"]
			map_node1.get_node("Tower1").add_child(new_tower, true)
			map_node1.get_node("TileMapLayer4").set_cell(build_tile, 0, Vector2i(1,0))
			
			base_money -= tower_cost
			update_currency_label()
			
		else:
			print("Not enough money!")
		
func on_base_damage(damage):
	base_health -= damage
	
	#if base_health < 21:
		#preload("res://Scenes/UIScenes/main_menu.tscn")
	
	killed_enemies += 1
	print(killed_enemies)
	
	if base_health <= 0:
		emit_signal("game_finished", false)
	elif killed_enemies == enemies_in_wave and spawned_enemies == enemies_in_wave:
		await(get_tree().create_timer(0.5).timeout)
		emit_signal("game_finished", true)
	else:
		get_node("UI").update_health_bar(base_health)
		
func update_currency_label():
	currency_label.text = str(base_money)
	
func on_enemy_killed(reward):
	base_money += reward
	update_currency_label()
	
	killed_enemies += 1
	print(killed_enemies)
	
	if spawned_enemies == enemies_in_wave and killed_enemies == enemies_in_wave:
		await(get_tree().create_timer(0.5).timeout)
		emit_signal("game_finished", true)


func _on_texture_button_pressed() -> void:
	emit_signal("game_finished", false)
