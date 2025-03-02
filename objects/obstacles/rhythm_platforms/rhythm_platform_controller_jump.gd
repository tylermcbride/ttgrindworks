extends RhythmPlatformController
class_name RhythmPlatformControllerJump

var player: Player
var change_task_id: int = 0

func _ready() -> void:
	super()
	
	change_task_id = TaskMgr.delayed_call(1.5, on_timeout)

func _exit_tree() -> void:
	if change_task_id != 0:
		TaskMgr.cancel_task(change_task_id)
		change_task_id = 0

func on_timeout() -> StringName:
	set_group(group_current + 1)
	return TaskMgr.AGAIN
