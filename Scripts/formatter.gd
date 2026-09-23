@tool
extends Container
class_name Formatter

@export var lines : int = 2

signal focus_started
signal focus_ended

#focus data
var current_focus : Control = null
var original_rect : Rect2 
@export var zoom_timer : Timer

func _ready() -> void:
	Api.zoom_request.connect(_on_zoom_request)
	zoom_timer.timeout.connect(_stop_focus)

func _on_zoom_request(n : Node, _filliere : String):
	if current_focus != null:
		return
	
	_start_focus(n)
	zoom_timer.wait_time = randf_range(6, 15)
	zoom_timer.start()
	

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	if Input.is_key_pressed(KEY_A):
		if current_focus == null:
			_start_focus(get_children()[randi_range(0, get_child_count()-1)])
	if Input.is_key_pressed(KEY_B):
		if current_focus != null:
			_stop_focus()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		# Must re-sort the children
		_sort_children()

func _sort_children():
	print("Sorting children")
	var children : Array[Node] = get_children().filter(func(n : Node): return n is Control)
	var children_per_lines : Array[int] = []
	var base_cpl : int = int(floor( float(len(children)) / float(lines) ))
	var l : int = len(children)
	for i in range(lines - 1):
		children_per_lines += [base_cpl]
		l -= base_cpl
	children_per_lines += [l]
	print(children_per_lines)
	
	#finally put them in
	var rect := Rect2(Vector2.ZERO, size)
	var rects : Array[Rect2] = []
	for line in range(lines):
		var new_rect := Rect2()
		new_rect.size = Vector2(rect.size.x / children_per_lines[line], rect.size.y / lines)
		for x in range(children_per_lines[line]):
			var r := Rect2(new_rect)
			r.position = new_rect.position + Vector2.RIGHT * new_rect.size.x * x + Vector2.DOWN * new_rect.size.y * line
			rects += [r]
	for i in range(len(children)):
		if children[i] != current_focus:
			fit_child_in_rect(children[i], rects[i])

func _start_focus(n : Control):
	if n == null: return
	current_focus = n
	current_focus.z_index = 100
	print("current focus : ", current_focus)
	original_rect = n.get_rect()
	print("og rect", original_rect)
	
	if current_focus != null:
		var tween = create_tween()
		tween.tween_method(
			(func(t : float):
				var new_rect = original_rect
				new_rect.position = (1 - t)  * original_rect.position
				new_rect.size = (1 - t) * original_rect.size + t * size
				if current_focus != null:
					fit_child_in_rect(current_focus, new_rect)
					if current_focus is Focusable:
						current_focus._update_focus_amout(t)
				), 0.0, 1.0, 1
		)
		tween.tween_callback(focus_started.emit)
	pass
	
func _stop_focus():
	if current_focus == null : return
	var tween = create_tween()
	tween.tween_method(
			(func(t : float):
				var new_rect = original_rect
				new_rect.position = (1 - t)  * original_rect.position
				new_rect.size = (1 - t) * original_rect.size + t * size
				if current_focus != null:
					fit_child_in_rect(current_focus, new_rect)
					if current_focus is Focusable:
						current_focus._update_focus_amout(t)
				), 1.0, 0.0, 1
		)
	tween.tween_callback(
		(func(): 
			if current_focus != null:
				current_focus.z_index = 0
			focus_ended.emit()))
		
	tween.tween_callback((func(): current_focus = null))
	pass
