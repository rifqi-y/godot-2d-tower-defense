extends Node2D

var enemy_array = []
var built = false
var enemy

func _ready() -> void:
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[self.get_name()]["range"]

func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
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

func _on_range_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())
