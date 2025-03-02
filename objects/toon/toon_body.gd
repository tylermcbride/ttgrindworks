extends Node3D
class_name ToonBody

@export var anim: String
@export var animator: AnimationPlayer
@export var skeleton: Skeleton3D

@export_category("Bones")
# Accessory bones
@export var hat_bone: BoneAttachment3D
@export var glasses_bone: BoneAttachment3D
@export var backpack_bone: BoneAttachment3D
@export var head_bone: BoneAttachment3D

# Battle Necessary Bones
@export var right_hand_bone: BoneAttachment3D
@export var left_hand_bone: BoneAttachment3D
@export var flower_bone: BoneAttachment3D
@export var hip_bone: BoneAttachment3D


@export_category("Meshes")
@export var shirt: MeshInstance3D
@export var bottoms: MeshInstance3D
@export var neck: MeshInstance3D
@export var arm_left: MeshInstance3D
@export var arm_right: MeshInstance3D
@export var sleeve_left: MeshInstance3D
@export var sleeve_right: MeshInstance3D
@export var hand_left: MeshInstance3D
@export var hand_right: MeshInstance3D

@export var leg_left: MeshInstance3D
@export var leg_right: MeshInstance3D
@export var foot_left: MeshInstance3D
@export var foot_right: MeshInstance3D
@export var ear_left: MeshInstance3D
@export var ear_right: MeshInstance3D

func set_animation(animation: String):
	if animator.has_animation(animation):
		skeleton.reset_bone_poses()
		animator.play(animation)
		animator.advance(0.0)
	else:
		push_warning("Invalid toon animation: %s" % animation)
	anim = animator.current_animation
