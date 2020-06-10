extends Control
onready var globals = get_node("/root/globals")
var isFilled = false
signal mark_x
signal mark_o

func reset():
	isFilled = false
	$Panel/Area2D/red.hide()
	$Panel/Area2D/blue.hide()
	
func markSpace():
		isFilled = true	
		if (globals.humanTurn):
			$Panel/Area2D/red.show()			
			emit_signal("mark_x")
		else:
			$Panel/Area2D/blue.show()			
			emit_signal("mark_o")			

func _on_Area2D_mouse_entered():
	if (!isFilled):
		$Panel/Area2D/hover.show()

func _on_Area2D_mouse_exited():
	$Panel/Area2D/hover.hide()

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (globals.humanTurn && !globals.gameOver):
		if (event is InputEventMouseButton && event.pressed):
			markSpace()
