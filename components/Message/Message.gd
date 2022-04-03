extends Label

var delay = false
var wait_time = 0
var texts = []
var current = null
export var fontSize = 150

func _ready():
	#set("custom_fonts/font/size", fontSize)
	set_process(true)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("Stopping")
		if !delay:
			$Timer.stop()
			_on_Timer_timeout()

func tell_lines(texts):
	var messages = []
	for text in texts:
		messages.append({
			"text": text[0],
			"timeout": text[1],
			"delay": text[2]
		})	
	tell_all(messages)

func tell_all(text_list, start_delay = 0):
	texts = text_list
	tell_next()

func tell_next():
	if texts != []:
		current = texts.pop_front()
		tell_current()	
	else:
		current = null

func tell_current():
	if !current:
		return
		
	if current.delay > 0:
		delay = true
		wait_time = current.timeout + 1
		$Timer.wait_time = current.delay
		$Timer.start()
	else:
		text = current.text
		$AnimationPlayer.play("Show")
		$Timer.wait_time = current.timeout + 1
		$Timer.start()


func _on_Timer_timeout():
	if !current:
		return
		
	if delay:
		delay = false
		$Timer.wait_time = current.timeout
		$Timer.start()
		text = current.text
		$AnimationPlayer.play("Show")
	else:
		$AnimationPlayer.play_backwards("Show")
		tell_next()
