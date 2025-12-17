extends Node2D

@onready var arrow_sfx: AudioStreamPlayer = $ArrowSFX

var type
var category
var enemy_array = []
var built = false
var enemy
var turret_ready = true

func _ready() -> void:
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and built:
		select_enemy()
		
		if not get_node("AnimationPlayer").is_playing():
			turn()
		
		if turret_ready:
			fire()
	else:
		enemy = null
	
func turn():
	get_node("Hero").look_at(enemy.position)
	
func select_enemy():
	var enemy_progess_array = []
	for i in enemy_array:
		enemy_progess_array.append(i.progress)
	var max_offset = enemy_progess_array.max()
	var enemy_index = enemy_progess_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	
func fire():
	turret_ready = false
	if category == "arrow":
		fire_arrow()
	else:
		pass
	enemy.on_hit(GameData.tower_data[type]["damage"])
	await(get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
	turret_ready = true
	
func fire_arrow():
	get_node("AnimationPlayer").play("fire")
	arrow_sfx.play()

func _on_range_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())
