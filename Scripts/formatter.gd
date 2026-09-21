@tool
extends Container
class_name Formatter

@export var lines : int = 2

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		# Must re-sort the children
		_sort_children()

func _sort_children():
	print("Sorting children")
	var children : Array[Node] = get_children()
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
		fit_child_in_rect(children[i], rects[i])
