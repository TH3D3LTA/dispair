extends Node3D


@export var damage := 25
@onready var raycast: RayCast3D = $Marker3D/RayCast3D
@onready var shot_range: float = raycast.target_position.length()


func _process(_delta):
	if Input.is_action_just_pressed("player_shoot"):
		shoot()


func shoot():
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return

	var aim_origin := camera.global_position
	var aim_direction := -camera.global_basis.z
	var aim_end := aim_origin + aim_direction * shot_range
	var query := PhysicsRayQueryParameters3D.create(aim_origin, aim_end)
	query.collision_mask = raycast.collision_mask
	query.collide_with_areas = raycast.collide_with_areas
	query.collide_with_bodies = raycast.collide_with_bodies

	var shooter := camera.get_parent()
	while shooter != null and not shooter is CollisionObject3D:
		shooter = shooter.get_parent()
	if shooter is CollisionObject3D:
		query.exclude = [shooter.get_rid()]

	var aim_point := aim_end
	var aim_hit := get_world_3d().direct_space_state.intersect_ray(query)
	if not aim_hit.is_empty():
		aim_point = aim_hit.position

	raycast.target_position = raycast.to_local(aim_point)
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		return


	var target = raycast.get_collider()
	if target.has_method("take_damage"):
		target.take_damage(damage)
