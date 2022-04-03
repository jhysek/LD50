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
	WALKING
}

export var GRAVITY = 70 * 70
export var frozen = false
export var movementType = MovementType.STATIC

var direction = 1
var motion = Vector2(0,0)
var state = State.IDLE

onready var game = get_node("/root/Game")
onready var ray = $RayCast2D
onready var rayClose = $RayCastClose
onready var anim = $AnimationPlayer
onready var player = game.get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("WalkRight")
	set_physics_process(true)

func fov():
	if player.is_hidden():
		return
		
	if ray.is_colliding():
		print("COLLIDING")
		
		if state != State.SEE:
			state = State.SEE
			print("I can see you")
			$FOV.modulate = Color("77b698a1")
			
		if rayClose.is_colliding():
			print("CLOSE COLLIDING")
			if state != State.SEE_NEAR:
				state = State.SEE_NEAR
				$FOV.modulate = Color("27e20303")
				print("I can kill you")
				var closeObject = rayClose.get_collider()
				if closeObject.is_in_group("Player") and !player.is_dead():
					attack()
	else:
		print("NOT COLLIDING")
		if state == State.SEE:
			print("DON'T SEE A SHIT")
			$FOV.modulate = Color("27f6f6f6")
			state = State.IDLE
			
func attack():
	$Sfx/Attack.play()
	state = State.ATTACKING
	anim.play("Attack")
	motion.y = -1000
	motion.x = direction * 2000
		
		
func die():
	anim.play("Die")
	$Sfx/Death.play()
	state = State.DEAD
	$Visual/VisionArea.monitoring = false
	$Visual/VisionArea/CloseArea.monitoring = false
	
func behavior(delta):
	if movementType == MovementType.STATIC:
		return
		
	if movementType == MovementType.WALKING:
		pass

func _physics_process(delta):
	if frozen or (game and game.paused):
		return

	motion.y += GRAVITY * delta

	if state != State.DEAD:
		#fov()
		behavior(delta)
	else:
		motion.x = lerp(motion.x, 0, 4 * delta)

	motion = move_and_slide(motion, Vector2(0, -1), 1, 4)
	
	

func stab():
	if state != State.DEAD:
		die()


func _on_VisionArea_area_entered(area):
	if area.is_in_group("Player"):
		print("VIDIM TE")
		attack()


func _on_VisionArea_area_exited(area):
	if area.is_in_group("Player"):
		print("NE VIDIM TE")
		


func _on_CloseArea_area_entered(area):
	if area.is_in_group("Player"):
		print("Zakousnu te")
		attack()

func _on_CloseArea_area_exited(area):
	if area.is_in_group("Player"):
		print("Mas stesti")


func _on_Teeth_area_entered(area):
	if area.is_in_group("Player") and !player.is_dead():
		player.die()
