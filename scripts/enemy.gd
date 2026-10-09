extends CharacterBody3D


var health = 100
@onready var body = $MeshInstance3D
@onready var hit = $AudioStreamPlayer3D
@onready var death = $AudioStreamPlayer3D2



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()


func take_damage(amount: int):
	health -= amount
	hit.play()
	if health <= 0:
		death.play()
		visible = false 
