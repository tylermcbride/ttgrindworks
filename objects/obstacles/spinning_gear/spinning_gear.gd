@tool
extends Node3D

## Config
@export var spin_speed := 1.0

## Child References
@onready var collision: AnimatableBody3D = $Collision

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	collision.sync_to_physics = false

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	collision.position = Vector3.ZERO
	rotation_degrees.y += spin_speed * delta
	if rotation_degrees.y > 360.0:
		rotation_degrees.y -= 360.0
