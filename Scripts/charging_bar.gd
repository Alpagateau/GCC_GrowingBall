extends Node2D

signal is_full 

@export var goal    : float = 0
@export var current : float = 0
@export var speed_clamp : float = 0.2
@export var proximity_clamp : float = 0.4
@export var speed   : float = 4

@export var bar : ProgressBar

func _process(delta: float) -> void:
	if current >= 10:
		current -= 10
		goal -= 10
		is_full.emit()
		
	var addition : float = (goal - current) * delta * speed
	if addition >= proximity_clamp:
		addition *=  (goal - current)
	if addition >= speed_clamp:
		addition = speed_clamp
	current += addition
	bar.value = current * 10
	pass

func add_value(v : float):
	goal += v
