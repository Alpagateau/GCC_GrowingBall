extends Node2D

signal is_full 

@export var goal    : float = 0
@export var current : float = 0
@export var speed_clamp : float = 0.2
@export var proximity_clamp : float = 0.4
@export var speed   : float = 4

@export var ball_price : float = 10

@export var bar : ProgressBar

func _process(delta: float) -> void:
	if current >= ball_price - 0.001:
		current -= ball_price
		goal -= ball_price
		is_full.emit()
		
	var addition : float = min(((goal - current)**1.4) * delta * speed, 1000)
	#if addition >= proximity_clamp:
	#	addition *=  (goal - current)
	#if addition >= speed_clamp:
	#	addition = speed_clamp
	current += addition
	bar.value = current * (100 / ball_price)
	pass

func add_value(v : float):
	goal += abs(v)
