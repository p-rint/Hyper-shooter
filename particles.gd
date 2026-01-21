extends Node

var bulletHitParticle = preload("res://Particles/BulletHit.tscn")

@onready var player: CharacterBody3D = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func bulletHit(hitPos, hitfrom) -> void:
	print("AAA")
	var bulletHit : Node3D = bulletHitParticle.instantiate()
	bulletHit.global_position = hitPos
	#bulletHit.look_at(hitfrom)
	$"../../GameStuff/Particles".add_child(bulletHit)
	
	
