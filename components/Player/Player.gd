extends KinematicBody2D

export var GRAVITY = 70 * 70
export var SPEED   = 40000
export var JUMP_SPEED  = -1600
export var dead = false

var in_air = false
var was_in_air = false
var jump_timeout = 0

var motion = Vector2(0,0)

onready var visual = $Visual
onready var game = get_node("/root/Game")
onready var sfx_run = $Sfx/Run
onready var anim = $AnimationPlayer

func _ready():
	set_physics_process(true)
	
	
func _physics_process(delta):
	if game and game.paused:
		return

	motion.y += GRAVITY * delta

	if not dead:
		controlled_process(delta)
	else:
		motion.x = lerp(motion.x, 0, 4 * delta)

	print(motion)
	motion = move_and_slide(motion, Vector2(0, -1), 1, 4)


func controlled_process(delta):
	var grounded = is_on_floor()
	
	if grounded:
		in_air = false
		jump_timeout = 0
	elif !in_air and jump_timeout <= 0:
		jump_timeout = 0.11

	if jump_timeout > 0:
		jump_timeout -= delta
		if jump_timeout <= 0:
			in_air = true

	if was_in_air and !in_air:
		$Sfx/Jump.play()
	
	was_in_air = in_air

	if !dead:
		if not in_air and Input.is_action_just_pressed("ui_up"):
			in_air = true
			jump_timeout = 0
			anim.play("Jump")
			$Sfx/Jump.play()
			motion.y = JUMP_SPEED
			sfx_run.stop()

		if Input.is_action_pressed('ui_right'):
			if !in_air and anim.current_animation != "WalkRight":
				anim.play("WalkRight")
			motion.x = min(motion.x + SPEED * delta, SPEED * delta)
			if sfx_run and !sfx_run.playing and !in_air:
				sfx_run.play()

		if Input.is_action_pressed('ui_left'):
			if not in_air and anim.current_animation != "WalkLeft":
				anim.play("WalkLeft")
			motion.x = max(motion.x - SPEED * delta, -SPEED * delta)
			if sfx_run and !sfx_run.playing and !in_air:
				sfx_run.play()

		elif !Input.is_action_pressed('ui_right'):
			if !in_air and anim.current_animation != "Idle":
				anim.play("Idle")
			motion.x = 0
			
		if sfx_run and sfx_run.playing:
			sfx_run.stop()
