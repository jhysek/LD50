extends KinematicBody2D

enum State {
	IDLE,
	SEE,
	SEE_NEAR,
	ATTACKING,
	ENDING_ATTACK,
	DEAD
}

enum MovementType {
	STATIC,
	WALKING,
	ANIMATED
}

export var GRAVITY = 70 * 70
export var SPEED = 30000
export var frozen = false
export var movementType = MovementType.STATIC
export var invincible = false

export var direction = 1
var motion = Vector2(0,0)
var state = State.IDLE

onready var game = get_node("/root/Game")
onready var ray = $RayCast2D
onready var rayClose = $RayCastClose
onready var anim = $AnimationPlayer
onready var player = game.get_node("Player")

var turn_cooldown = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	set_default_anim()
	set_physics_process(true)


func set_default_anim():
	if movementType == MovementType.STATIC:
		anim.play("Idle")
		
	if movementType == MovementType.WALKING:
		set_walking_anim()

func set_walking_anim():
	if state == State.DEAD:
		return
		
	if direction > 0 and anim.current_animation != "WalkRight":
		anim.play("WalkRight")
		
	if direction < 0 and anim.current_animation != "WalkLeft":
		anim.play("WalkLeft")
			
func attack():
	$Sfx/Attack.play()
	state = State.ATTACKING
	anim.play("Attack")
	motion.y = -800
	motion.x = direction * 2000
	$DirtyHack.stop()
	$DirtyHack.start()
		
		
func die():
	if invincible:
		$Sfx/Noticed2.play()
	else:
		anim.play("Die")
		$Sfx/Death.play()
		state = State.DEAD
		$Visual/Body/HeadTop/Teeth.monitoring = false
		$Visual/VisionArea.monitoring = false
		$Visual/VisionArea/CloseArea.monitoring = false
	
func behavior(delta):
	if movementType == MovementType.STATIC:
		return

	if state != State.ATTACKING and movementType == MovementType.WALKING:
		turn_cooldown -= delta
		motion.x = SPEED * delta * direction

func _physics_process(delta):
	if frozen or (game and game.paused):
		return
	
	if movementType == MovementType.ANIMATED:
		return
		
	motion.y += GRAVITY * delta

	if state != State.DEAD:
		behavior(delta)
	else:
		motion.x = lerp(motion.x, 0, 4 * delta)

	motion = move_and_slide(motion, Vector2(0, -1), 1, 4)
	
	if movementType == MovementType.WALKING and motion.x == 0 and turn_cooldown <= 0:
		direction *= -1
		turn_cooldown = 0.5
		set_walking_anim()

func stab():
	if state != State.DEAD:
		die()


func _on_VisionArea_area_entered(area):
	if movementType == MovementType.ANIMATED:
		return
		
	if area.is_in_group("Player") and !player.is_dead():
		if !player.is_hidden():
			$Sfx/Noticed1.play()
			$AttackTimer.stop()
			$AttackTimer.wait_time = 1
			$AttackTimer.start()

func _on_VisionArea_area_exited(area):
	if area.is_in_group("Player"):
		state = State.IDLE

func _on_CloseArea_area_entered(area):
	if movementType == MovementType.ANIMATED:
		return
		
	if area.is_in_group("Player") and !player.is_dead():
		if !player.is_hidden() and state != State.ATTACKING:
			attack()

func _on_CloseArea_area_exited(area):
	if area.is_in_group("Player"):
		state = State.IDLE

func _on_Teeth_area_entered(area):
	if state == State.ATTACKING and area.is_in_group("Player") and !player.is_dead() and !player.is_hidden():
		player.die()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		state = State.IDLE
		set_default_anim()


func _on_AttackTimer_timeout():
	#if 	state == State.SEE or state == State.SEE_NEAR:
	attack()


func _on_DirtyHack_timeout():
	if state != State.IDLE:
		state = State.IDLE
		set_default_anim()
