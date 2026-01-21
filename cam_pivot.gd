extends Node3D

var mouseLock = false

@onready var player: CharacterBody3D = $".."

var twist : float = 0.0

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
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Escape"):
		if mouseLock:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouseLock = not mouseLock
		
	
	
	var twistTarget : float = -basis.x.dot(player.velocity.normalized())
	twist = lerpf(twist, twistTarget, delta * 5)
	
	$Camera3D/Hand.rotation.z = deg_to_rad(twist) * 6
	$Camera3D.rotation.z = deg_to_rad(twist) * 2
	#print(twist)
	
	
