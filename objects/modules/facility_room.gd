extends Resource
class_name FacilityRoom

## The actual room scene
@export var room: PackedScene
## Room rarity 0.0 - 1.0, with 0.0 as impossible, 1.0 as very common
@export_range(0.0, 100.0) var rarity_weight := 1.0
