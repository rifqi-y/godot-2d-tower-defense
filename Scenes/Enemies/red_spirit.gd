extends PathFollow2D

var speed = 65
var hp = 75

@onready var health_bar = get_node("HeatlhBar")

func _ready() -> void:
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_top_level(true)
	
func _physics_process(delta: float) -> void:
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.set_position(position - Vector2(15, 20))

func on_hit(damage):
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()
		
func on_destroy():
	self.queue_free()
