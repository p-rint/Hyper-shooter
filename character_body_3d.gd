extends CharacterBody3D

var input_dir : Vector2
var direction : Vector3

const SPEED = 16.0
const JUMP_VELOCITY = 4.5
const crouchSPEED = 8

var moveSpeed = SPEED

@onready var camPiv = $CamPivot

@onready var model = $Character
var dt : float
var targetRot = 0

@onready var animPlr: AnimationPlayer = $AnimationPlayer

@onready var gunRay: RayCast3D = $CamPivot/Camera3D/Hand/GunRay


func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)

func move() -> void:
	#model.rotation.y = lerp_angle(model.rotation.y, targetRot, .5)
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * moveSpeed, .15 * 2)
		velocity.z = lerp(velocity.z, direction.z * moveSpeed, .15 * 2)
		
		#model.rotation.y = lerp_angle(model.rotation.y, atan2(-velocity.x, -velocity.z), .2)
	else:
		velocity.x = move_toward(velocity.x, 0, 1)
		velocity.z = move_toward(velocity.z, 0, 1)


func crouch():
	animPlr.play("crouch")
	
	


func _physics_process(delta: float) -> void:
	dt = delta
	
	#gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	direction = flatten(camPiv.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	move()
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY



	if Input.is_action_just_pressed("Shoot"):
		animPlr.stop()
		animPlr.play("shoot")
		if gunRay.is_colliding():
			print("Hit!!!")
		
	
	if Input.is_action_just_pressed("Crouch"):
		camPiv.position.y = -0.81
		moveSpeed = crouchSPEED
		
	
	if Input.is_action_just_released("Crouch"):
		camPiv.position.y = 0
		moveSpeed = SPEED
	
	move_and_slide()
	
