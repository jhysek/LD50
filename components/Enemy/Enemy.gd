extends KinematicBody2D

enum State {
	IDLE,
	SEE,
	SEE_NEAR,
	ATTACKING,
	ENDING_ATTACK,
	DEAD
}

export var GRAVITY = 70 * 70
export var frozen = false

var direction = 1
var motion = Vector2(0,0)
var state = State.IDLE

onready var game = get_node("/root/Game")
onready var ray = $RayCast2D
onready var rayClose = $RayCastClose

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

func fov():
	if ray.is_colliding():
		if state != State.SEE:
			state = State.SEE
			$FOV.modulate = Color("77b698a1")
			print("VIDIM TE!")
			
		if rayClose.is_colliding():
			if state != State.SEE_NEAR:
				state = State.SEE_NEAR
				$FOV.modulate = Color("27e20303")
	else:
		if state == State.SEE:
			$FOV.modulate = Color("27f6f6f6")
			state = State.IDLE
			

			
			
		
func behavior(delta):
	pass

func _physics_process(delta):
	if frozen or (game and game.paused):
		return

	motion.y += GRAVITY * delta

	if state != State.DEAD:
		fov()
		behavior(delta)
	else:
		motion.x = lerp(motion.x, 0, 4 * delta)

	motion = move_and_slide(motion, Vector2(0, -1), 1, 4)
	
	

func stab():
	print("AU AU AU")
