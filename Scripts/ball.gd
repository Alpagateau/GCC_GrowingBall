extends RigidBody2D
class_name Ball

@export var value : int = 1
@export var scale_mult : float = 0.4
var can_combine = true

func _ready() -> void:
	var tween = create_tween()
	scale = Vector2.ONE * 0.0001
	tween.tween_property(self, "scale", Vector2.ONE * sqrt(value * scale_mult), 0.2)
	tween.finished.connect(func():
		var circle : CircleShape2D = $CollisionShape2D.shape.duplicate()
		circle.radius = sqrt(value * scale_mult) * 64
		$CollisionShape2D.shape  = circle
		$Sprite2D.scale = Vector2.ONE * sqrt(value * scale_mult) * 0.5
	)

func _process(_delta: float) -> void:
	if position.y > 1000:
		queue_free()
func _on_body_entered(body: Node) -> void:
	if body is Ball:
		var b : Ball = body
		if b.value == value and can_combine and b.can_combine:
			can_combine = false
			b.can_combine = false
			var copy : Ball = duplicate()
			copy.value = value * 2
			get_parent().call_deferred("add_child",copy)
			b.queue_free()
			queue_free()
