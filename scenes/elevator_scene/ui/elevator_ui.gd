extends Control

@onready var floor_button := $FloorChooser/FloorTypeButton

var floors : Array[FloorVariant]
var floor_index := 0

signal start_floor(floor_var : FloorVariant)


func set_floor_index(index : int) -> void:
	floor_button.floor_variant = floors[index]
	floor_index = index

func move_floor_index(by : int) -> void:
	floor_index += by
	if floor_index >= floors.size():
		floor_index = 0
	elif floor_index < 0:
		floor_index = floors.size() -1 
	set_floor_index(floor_index)

func floor_selected(floor_var : FloorVariant) -> void:
	start_floor.emit(floor_var)
	floor_button.hide()
