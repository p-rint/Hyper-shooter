extends CanvasLayer

@onready var healthBar: ProgressBar = $health
@onready var player: CharacterBody3D = $"../Player"
@onready var goal: MeshInstance3D = $"../Map/Goal"

@onready var endScreen: ColorRect = $EndScreen

var gameEnd = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.value = lerpf(healthBar.value, player.health, delta * 10)
	
	if goal.position.distance_to(player.position) < 3 and not gameEnd:
		print("A")
		gameEnd = true
		endScreen.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if gameEnd:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()
	
	
