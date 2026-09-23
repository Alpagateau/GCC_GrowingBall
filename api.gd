extends Node
class_name PassAPI

var timer       : Timer
var requester   : HTTPRequest

@warning_ignore("unused_signal")
signal new_payment(s : String, v : float)

@warning_ignore("unused_signal")
signal zoom_request(n : Node, filiere : String)

func _ready() -> void:
	timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = 5
	timer.timeout.connect(_get_data)
	add_child(timer)
	requester = HTTPRequest.new()
	requester.request_completed.connect(_on_request_complete)
	add_child(requester)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		_queue_reset_values()

func _get_data():
	print("get data")
	requester.request("https://c245gcd345gcdqaergnbw54g.eirb.fr/api/getData")

func _queue_reset_values():
	requester.request("https://c245gcd345gcdqaergnbw54g.eirb.fr/api/reset")
	

func _on_request_complete(result : int, response : int, header : PackedStringArray, body : PackedByteArray):
	print("requested")
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var json_response : Dictionary = json.get_data()
	
	for k in json_response.keys(): 
		print("EMITTING : [%s, %f] " % [k, float(json_response[k])])
		new_payment.emit(k, json_response[k])
	
