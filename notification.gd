extends CanvasLayer

@onready var not_enough_money: Panel = $NotEnoughMoney
@onready var invalid_location: Panel = $InvalidLocation

var mid_tween_reference = null

func show_NEM_notif():
	if mid_tween_reference:
		mid_tween_reference.kill()
		
	not_enough_money.modulate = Color(1, 1, 1, 1)
	
	mid_tween_reference = create_tween()
	mid_tween_reference.tween_interval(2)
	mid_tween_reference.tween_property(not_enough_money, "modulate", Color(1, 1, 1, 0), 0.5)
	
func show_IL_notif():
	if mid_tween_reference:
		mid_tween_reference.kill()
		
	invalid_location.modulate = Color(1, 1, 1, 1)
	
	mid_tween_reference = create_tween()
	mid_tween_reference.tween_interval(2)
	mid_tween_reference.tween_property(invalid_location, "modulate", Color(1, 1, 1, 0), 0.5)
