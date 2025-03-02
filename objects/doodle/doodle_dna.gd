extends Resource
class_name DoodleDNA

enum DoodleTail {
	BUNNY,
	CAT,
	BIRD,
	LONG
}
@export var tail := DoodleTail.BUNNY

enum DoodleEar {
	BUNNY,
	CAT,
	DOG,
	ANTENNA,
	HORN
}
@export var ears := DoodleEar.BUNNY

enum DoodleNose {
	CLOWN,
	DOG,
	OVAL,
	PIG
}
@export var nose := DoodleNose.CLOWN

@export var color := Color.WHITE

@export var eye_lashes := false

var textures : Array[String]= [
	"res://models/doodle/Beanbody3stripes6.png",
	"res://models/doodle/BeanbodyDots6.png",
	"res://models/doodle/BeanbodyTummy6.png",
	"res://models/doodle/BeanbodyZebraStripes6.png"
]
@export var tex_num := 0
var texture : Texture2D:
	get:
		return load(textures[tex_num])

@export var hair := false


func randomize_dna():
	tail = RandomService.randi_channel('doodle_dna') % DoodleTail.keys().size() as DoodleTail
	ears = RandomService.randi_channel('doodle_dna') % DoodleEar.keys().size() as DoodleEar
	nose = RandomService.randi_channel('doodle_dna') % DoodleNose.keys().size() as DoodleNose
	color = Globals.random_dna_color
	eye_lashes = RandomService.randi_channel('doodle_dna')%2 == 0
	tex_num = RandomService.randi_channel('doodle_dna')%textures.size()
	hair = RandomService.randi_channel('doodle_dna') % 2 == 0
