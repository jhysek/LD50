extends KinematicBody2D

# DASH

# DOUBLE JUMP
# [X] functionality
# [X] animation

# ATTACK
# [X] functionality
# [X] anumation

# HIDE
# [X] functionality
# [X] animation

export var GRAVITY = 70 * 70
export var SPEED   = 60000 #40000
export var JUMP_SPEED  = -1800
export var frozen = false

enum State {
	READY,
	HIDDEN,
	ATTACKING,
	ENDING_ATTACK,
	DEAD
}

var double_jumped = false
var in_air = false
var was_in_air = false
var jump_timeout = 0
var hidden = false 
var blink = false
var state = State.READY

var motion = Vector2(0,0)

onready var visual = $Visual
onready var game = get_node("/root/Game")
onready var sfx_run = $Sfx/Run
onready var anim = $AnimationPlayer

func _ready():
	set_physics_process(true)
	
func is_dead():
	return state == State.DEAD
	
func is_hidden():
	return state == State.HIDDEN
	
func _physics_process(delta):
	if frozen or (game and game.paused):
		return
	
	if state != State.HIDDEN:
		motion.y += GRAVITY * delta

	if state != State.DEAD:
		controlled_process(delta)
	else:
		motion.x = lerp(motion.x, 0, 4 * delta)

	motion = move_and_slide(motion, Vector2(0, -1), 1, 4)


func controlled_process(delta):
	var grounded = is_on_floor()
	
	if grounded:
		in_air = false
		double_jumped = false
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

	if state != State.DEAD:
		if state == State.READY and !in_air and Input.is_action_pressed("ui_down"):
			for area in $Area.get_overlapping_areas():
				if area.is_in_group("Hidable"):
					state = State.HIDDEN
					motion.x = 0
					motion.y = 0
					anim.play("Hide")
					
		if state == State.HIDDEN and Input.is_action_just_released("ui_down"):
			anim.stop()
			anim.play("UnHide")
		
		
		if state == State.HIDDEN:
			return
			
		if Input.is_action_just_pressed('attack'):
			state = State.ATTACKING
			anim.play("Stab")
			$Sfx/Attack.play()
		
		if state != State.READY:
			if !in_air:
				motion.x = 0
			return
			
		if (!in_air or !double_jumped) and Input.is_action_just_pressed("ui_up"):
			if in_air: 
				double_jumped = true
				anim.play("DoubleJump")
				$Sfx/DoubleJump.play()
			else:
				in_air = true
				anim.play("Jump")
				$Sfx/Jump.play()
			jump_timeout = 0
			
			motion.y = JUMP_SPEED
			sfx_run.stop()
			
		if Input.is_action_pressed('ui_right'):
			if !in_air and anim.current_animation != "WalkRight":
				anim.play("WalkRight")
			if in_air:
				$Visual.scale.x = 1
			motion.x = min(motion.x + SPEED * delta, SPEED * delta)
			if sfx_run and !sfx_run.playing and !in_air:
				sfx_run.play()

		if Input.is_action_pressed('ui_left'):
			if not in_air and anim.current_animation != "WalkLeft":
				anim.play("WalkLeft")
			if in_air:
				$Visual.scale.x = -1
			motion.x = max(motion.x - SPEED * delta, -SPEED * delta)
			if sfx_run and !sfx_run.playing and !in_air:
				sfx_run.play()

		elif !Input.is_action_pressed('ui_right'):
			if !in_air and anim.current_animation != "Idle":
				anim.play("Idle")
			motion.x = 0
			
			if sfx_run and sfx_run.playing:
				sfx_run.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "UnHide":
		state = State.READY
		
	if state == State.ENDING_ATTACK:
		state = State.READY

	if state == State.ATTACKING:
		state = State.ENDING_ATTACK
		anim.play_backwards("Stab")
		


func _on_EyeBlinker_timeout():
	if state == State.DEAD:
		return
		
	if !blink:
		if !hidden:
			$Visual/Body/Head/ClosedEyes.show()
		$EyeBlinker.wait_time = 0.1
		blink = true
		$EyeBlinker.start()
	else:
		blink = false
		$Visual/Body/Head/ClosedEyes.hide()
		$EyeBlinker.wait_time = rand_range(2, 7)
		$EyeBlinker.start()


func _on_Area2D_area_entered(area):
	if area.is_in_group("Killable"):
		area.stab()


func _on_Area2D_body_entered(body):	
	if body.is_in_group("Killable"):
		body.stab()
	

func die():
	Music.stop()
	$Sfx/Death.play()
	anim.play("Death")
	state = State.DEAD
