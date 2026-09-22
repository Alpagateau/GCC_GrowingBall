extends Node2D
class_name Apparatus

var original_pos : Vector2
@export var ball_prefab : PackedScene
var total_money : float = 0

var current_focuse_amout : float = 0

func _ready() -> void:
	$ChargingBar.is_full.connect(shake)
	$ChargingBar.is_full.connect(spawn_ball)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		var value := randf_range(0.5, 15.5)
		total_money += value
		#print(total_money)
		$ChargingBar.add_value(value)

func spawn_ball():
	var new_ball : Ball = ball_prefab.instantiate()
	new_ball.position = $Spawner.position     
	add_child(new_ball)

func shake():
	original_pos = position
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
	
