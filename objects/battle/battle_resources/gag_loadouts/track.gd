extends Resource
class_name Track

## Gag Track class. Couldn't be called GagTrack bc it's taken :(
enum TrackType {
	OFFENSE,
	SUPPORT,
	SPECIAL
}
@export var track_type := TrackType.OFFENSE

@export var track_name: String
@export var track_color: Color
@export var gags: Array[ToonAttack]
