extends RayCast3D


@onready var shadow := $Shadow

func _physics_process(_delta: float) -> void:
	if get_collider():
		shadow.global_position.y = get_collision_point().y + 0.005
