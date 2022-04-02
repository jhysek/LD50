extends KinematicBody2D

# DASH

# DOUBLE JUMP
# [X] functionality
# [ ] animation

# ATTACK
# [ ] functionality
# [ ] anumation

# HIDE
# [ ] functionality
# [ ] animation

export var GRAVITY = 70 * 70
export var SPEED   = 60000 #40000
export var JUMP_SPEED  = -1800
export var dead = false
export var frozen = false

var double_jumped = false
var in_air = false
var was_in_air = false
var jump_timeout = 0
var hidden = false 

var motion = Vector2(0,0)

onready var visual = $Visual
onready var game = get_node("/root/Game")
onready var sfx_run = $Sfx/Run
onready var anim = $AnimationPlayer

func _ready():
	set_physics_process(true)
	
	
func _physics_process(delta):
	if frozen or (game and game.paused):
		return

	motion.y += GRAVITY * delta

	if not dead:
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

	if !dead:
		if !hidden and !in_air and Input.is_action_just_pressed("hide"):
			for area in $Area.get_overlapping_areas():
				if area.is_in_group("Hidable"):
					hidden = true
					motion.x = 0
					motion.y = 0
					print("HIDING")
					anim.play("Hide")
					
		if hidden and Input.is_action_just_released("hide"):
			anim.stop()
			anim.play("UnHide")
			print("UN-HIDING")
		
		if hidden:
			return
		
		if (!in_air or !double_jumped) and Input.is_action_just_pressed("ui_up"):
			if in_air: 
				double_jumped = true
			else:
				in_air = true
			jump_timeout = 0
			anim.play("Jump")
			$Sfx/Jump.play()
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
		hidden = false
