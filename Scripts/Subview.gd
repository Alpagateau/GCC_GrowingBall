extends SubViewportContainer
class_name Focusable

@export var apparatus : Apparatus

var ti : Timer

func _ready():
	ti = Timer.new()
	ti.one_shot = false
	ti.wait_time = randf_range(0.1, 0.3)
	ti.timeout.connect(_on_t_timeout)
	ti.autostart = true
	add_child(ti)
	ti.start()

func _on_t_timeout():
	print("can i zoom ?", apparatus.total_money - apparatus.total_used_money)
	if apparatus.total_money - apparatus.total_used_money > 10:
		print("Requested zoom !!!!")
		Api.zoom_request.emit(self, apparatus.filiere)

#focus amout between 0 and 1
func _update_focus_amout(t : float):
	apparatus._update_focus_amout(t)
