extends CharacterBody3D

var input_dir : Vector2
var direction : Vector3

const SPEED = 8.0
const JUMP_VELOCITY = 6.0
const crouchSPEED = 4
const sprintSPEED = 16.0

var moveSpeed = SPEED

@onready var camPiv = $CamPivot

@onready var model = $Character

@onready var ParticleManager: Node = $"../Scripts/Particles"


var dt : float
var targetRot = 0

@onready var animPlr: AnimationPlayer = $AnimationPlayer

@onready var gunRay: RayCast3D = $CamPivot/Camera3D/GunRay


@export var health = 100

var isCrouch = false
var isSprint = false
@export var isSliding = false

var slideSpeed = 0
var slideDir : Vector3

var curGravity = get_gravity()

@onready var wallJumpCast: RayCast3D = $WallJump

var wallJumpForce = 0
var wallJumpDir = Vector3()

@onready var uiAnimPlr : AnimationPlayer = $"../CanvasLayer/AnimationPlayer"


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



func _physics_process(delta: float) -> void:
	dt = delta
	
	
	#gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	direction = flatten(camPiv.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	move()
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY



	if Input.is_action_just_pressed("Shoot"):
		animPlr.stop()
		uiAnimPlr.stop()
		animPlr.play("shoot")
		uiAnimPlr.play("pew")
		if gunRay.is_colliding() and gunRay.collide_with_areas:
			uiAnimPlr.stop()
			print("Hit!!!")
			uiAnimPlr.play("hit")
			gunRay.get_collider().get_parent().damage(10)
			ParticleManager.bulletHit(gunRay.get_collision_point(), global_position)
			
	
	if Input.is_action_just_pressed("Crouch"):
		#camPiv.position.y = -0.81
		$CollisionShape3D.scale.y = .2
		$CollisionShape3D.position.y = -.4
		isCrouch = true
		slideSpeed = flatten(velocity).length()
		slideDir = flatten(velocity).normalized()
		
	
	if Input.is_action_just_released("Crouch"):
		#camPiv.position.y = 0
		$CollisionShape3D.position.y = 0
		$CollisionShape3D.scale.y = 1
		
		isCrouch = false
	
	if Input.is_action_just_pressed("Sprint"):
		isSprint = true
	
	if Input.is_action_just_released("Sprint"):
		isSprint = false
	
	
	wallJumpCast.target_position = -direction * 3
	if Input.is_action_just_pressed("Jump") and not is_on_floor():
		if wallJumpCast.is_colliding():
			velocity = direction * 50
			velocity.y = 13
	
	handleSpeed()
	move_and_slide()
	 
	#print(position.y)
	
	if health <= 0 or position.y <= -40:
		get_tree().reload_current_scene()
		
	

func damage(dmg):
	health -= dmg
	


func handleSpeed():
	if isCrouch:
		crouch()
	elif isSprint:
		moveSpeed = sprintSPEED
		camPiv.twistOffset = 0
	else:
		moveSpeed = SPEED
		camPiv.twistOffset = 0
		
	



func crouch():
	camPiv.twistOffset = 3
	if flatten(velocity).length() > 5:
		
		isSliding = true
		var slideVel = slideDir * slideSpeed#-flatten(camPiv.basis.z).normalized() * slideSpeed
		slideSpeed = lerpf(slideSpeed,0,dt /3.0)
		slideVel.y += velocity.y
		velocity = slideVel
	else: 
		
		isSliding = false
		moveSpeed = crouchSPEED
	
	
