extends Node2D

var current_zoom = ""

var phrases : Dictionary = {
	"telecom"      : ["Ce soir les telecoms sont connectes !"],
	"informatique" : ["tu connais eirb.fr ?", "La soiree en O(n^2)"],
	"matmeca"      : ["Matmeca, matmeca, matmeca : QUI CA\nMatmeca, matmeca, matmeca : QUI CA"],
	"electronique" : ["Aller, encore un peu de fortran !"],
	"SEE" : ["Alternant ? ca rime avec ARGENNTTTTTT"],
	"RI"  : ["Alternant ? ca rime avec ARGENNTTTTTT"],
	"any" : [
		"Ce soir c'est un grand soir, laissez moi vous le dire !!", 
		"FILLLLLOOOOOOOTTTTTT",
		"Merci le BDE ^^",]
}

@export var formatter : Formatter
@export var label : Label

func _process(delta: float) -> void:
	if !$Timer.is_stopped():
		label.visible_ratio = 1 - ($Timer.time_left / $Timer.wait_time) 
		$Sprite2D2.rotation_degrees =  abs(cos(($Timer.time_left) * 4)) * -22
	else:
		label.visible_ratio = 1
		$Sprite2D2.rotation_degrees = 0
		

func _on_timer_timeout() -> void:
	$Timer2.wait_time = randf_range(3, 9)
	$Timer2.start()
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	var possible_phrases : String = ""
	if formatter.current_focus == null:
		var rkey = phrases.keys()[randi_range(0, len(phrases.keys()) - 1)]
		possible_phrases = phrases[rkey][randi_range(0, len(phrases[rkey]) - 1)]
	else:
		var focus : Focusable = formatter.current_focus
		var rkey = focus.apparatus.filiere
		possible_phrases = phrases[rkey][randi_range(0, len(phrases[rkey]) - 1)]
	
	label.text = possible_phrases
	label.visible_ratio = 0
	$Timer.wait_time = len(possible_phrases) * 0.1
	print("Saying : ", possible_phrases)
	$Timer.start()
	pass # Replace with function body.
