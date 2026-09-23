extends Node2D
class_name Apparatus

var original_pos : Vector2
@export var ball_prefab : PackedScene
@export var filiere : String
var total_money : float = 0
var total_used_money : float = 0

var current_focuse_amout : float = 0

func _ready() -> void:
	original_pos = position
	$ChargingBar.is_full.connect(shake)
	$ChargingBar.is_full.connect(spawn_ball)
	$CanvasLayer/VideoStreamPlayer.speed_scale = randf_range(0.5, 2)
	Api.new_payment.connect(_on_new_payment)

func spawn_ball():
	var new_ball : Ball = ball_prefab.instantiate()
	new_ball.position = $Spawner.position     
	add_child(new_ball)

func shake():
	var tween = create_tween()
	for i in 12:
		var offset := Vector2(
			randf_range(-10.0, 10.0),
			randf_range(-10.0, 10.0)
		)
		tween.tween_property(self, "position", original_pos + offset, 0.02)
	tween.tween_property(self, "position", original_pos, 0.02)

func _update_focus_amout(t : float):
	$Camera2D.zoom = Vector2.ONE * ((1 - t) * 0.3 + t * 0.6)

func _on_new_payment(s: String, v : float):
	if s == filiere:
		total_money = v
	pass

func _on_timer_timeout() -> void:
	var max_payment : float = total_money - total_used_money
	var payment : float = randf_range(0, max_payment)
	if max_payment < 10:
		payment = max_payment
	#print("%f %f | %s" % [max_payment, payment, filiere])
	total_used_money += payment
	$ChargingBar.add_value(payment)
	
	pass # Replace with function body.
