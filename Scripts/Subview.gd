extends SubViewportContainer
class_name Focusable

@export var apparatus : Apparatus

#focus amout between 0 and 1
func _update_focus_amout(t : float):
	apparatus._update_focus_amout(t)
