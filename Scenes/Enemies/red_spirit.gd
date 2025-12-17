extends PathFollow2D

signal base_damage(damage)
signal enemy_killed(reward)

var speed = 50
var hp = 75
var reward = 50

@onready var health_bar = get_node("HeatlhBar")
@onready var impact_area = get_node("Impact")
var projectile_impact = preload("res://Scenes/SupportScenes/projectile_impact.tscn")

func _ready() -> void:
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_top_level(true)
	
func _physics_process(delta: float) -> void:
	if progress_ratio == 1.0:
		emit_signal("base_damage", 21)
		queue_free()
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.set_position(position - Vector2(15, 20))

func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()

func impact():
	randomize()
	var x_pos = randi() % 21
	randomize()
	var y_pos = randi() % 21
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)
	
func on_destroy():
	emit_signal("enemy_killed", reward)
	get_node("CharacterBody2D").queue_free()
	await(get_tree().create_timer(0.2).timeout)
	self.queue_free()
