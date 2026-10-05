extends Node3D


@export var damage := 25
@onready var raycast: RayCast3D = $Marker3D/RayCast3D


func _process(_delta):
	if Input.is_action_just_pressed("player_shoot"):
		shoot()


func shoot():
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		return


	var target = raycast.get_collider()
	if target.has_method("take_damage"):
		target.take_damage(damage)
