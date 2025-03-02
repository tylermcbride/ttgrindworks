extends Control

const TIP_FILE := "res://scenes/loading_screen/tips.txt"

@onready var tip_label := $TipScroll/TipLabel


func _ready() -> void:
	if FileAccess.file_exists(TIP_FILE):
		var file_as_string := FileAccess.get_file_as_string(TIP_FILE)
		var file_as_array := file_as_string.split("\n")
		tip_label.set_text(
		"TOON TIP:\n" + 
		file_as_array[RandomService.randi_channel('true_random') % (file_as_array.size() -3)]
		)

func load_scene(scene_path : String) -> void:
	ResourceLoader.load_threaded_request(scene_path)
	
	var percentage_arr := []
	
	while ResourceLoader.load_threaded_get_status(scene_path, percentage_arr) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
		$ProgressBar.value = percentage_arr[0]
	
	SceneLoader.change_scene_to_packed(ResourceLoader.load_threaded_get(scene_path))
