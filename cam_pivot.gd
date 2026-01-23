extends Node3D

var mouseLock = false

@onready var player: CharacterBody3D = $".."

var twistTarget : float = 0.0
var twist : float = 0.0

var twistOffset : float = 0.0

var xBob : float = 0.0
var bobTime : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.
	
	
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not mouseLock:
		
		
		rotation.y -= event.relative.x * .001 #Left <-> Right
		rotation.x -= event.relative.y * .001 #Up <-> Down
		
		rotation.y = wrapf(rotation.y, -PI, PI)
		rotation.x = clampf(rotation.x,-PI/2,PI/2)
	
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	
	if event.is_action_pressed("Tab"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_released("Tab"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
		
	
	#Strafe
	
	twistTarget = -basis.x.dot(player.velocity.normalized()) + twistOffset
	twist = lerpf(twist, twistTarget, delta * (5 + twistOffset))
	
	$Camera3D/Hand.rotation.z = deg_to_rad(twist) * 6
	$Camera3D.rotation.z = deg_to_rad(twist) * 2
	
	#View Bob
	bobTime += delta * player.velocity.length()
	var bobSpeed = (player.velocity.length()/player.SPEED)
	
	$Camera3D/Hand.position.x = .3 + sin(bobTime / 2.0) * .01
	$Camera3D/Hand.position.y = -.2 + sin(bobTime) * .01
		
	
	
	#print(twist)
	
	
