extends CharacterBody3D

@onready var attackTimer: Timer = $Timers/Attack

@onready var player: CharacterBody3D = $"../../Player"


@export var health = 30


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	if health <= 0:
		die()
	$Hitbox.look_at(player.position)



func damage(dmg):
	health -= dmg


func _on_attack_timeout() -> void:
	if position.distance_to(player.position) < 30:
		player.damage(10)


func die() -> void:
	queue_free()
	player.health += 10
