extends Node3D
class_name LawbotPuzzleGrid

## Lose Type
## Battle starts the attached cog battle
## Explode causes an explosion that damages the player
## Custom will do nothing. Just sends out the s_lose signal for you to whatever w/
enum LoseType {
	BATTLE,
	EXPLODE,
	CUSTOM
}
@export var lose_type := LoseType.BATTLE
@export var lose_battle : BattleNode
@export var explosion_damage := -5

## Grid Size
@export var grid_width := 7
@export var grid_height := 7
@export var beam_height := 2.5

## Locals
var grid := []
var player_cells : Array[PuzzlePanel] = []
var grid_center : Vector3
var panel_node : Node3D
var beam_node : Node3D
var LABEL := LazyLoader.defer("res://objects/interactables/lawbot_puzzles/puzzle_label.tscn")

## Signals
signal s_win
signal s_lose
signal s_began_interaction

var began_interaction := false:
	set(x):
		began_interaction = x
		if began_interaction:
			s_began_interaction.emit()

func _ready() -> void:
	# Get the puzzle center position
	# This position is used to create beams down to each panel
	grid_center = Vector3(float(grid_width)/2.0,beam_height,float(grid_height)/2.0)
	
	# Create nodes for storing the beams and panels
	panel_node = Node3D.new()
	add_child(panel_node)
	panel_node.name = "Panels"
	beam_node = Node3D.new()
	add_child(beam_node)
	beam_node.name = "Beams"
	
	# Fill the grid and start the game
	fill_grid()
	initialize_game()

## Fills the grid with panels
func fill_grid() -> void:
	for i in grid_width:
		grid.append([])
		for j in grid_height:
			var panel := PuzzlePanel.new()
			panel_node.add_child(panel)
			panel.position = Vector3(1*i,0,1*j)
			grid[i].append(panel)
			panel.pos = Vector2i(i,j)
			panel.s_player_entered.connect(_pre_player_stepped_on)
			panel.s_player_exited.connect(player_stepped_off)
			panel.s_player_entered.connect(_add_player)
			panel.s_player_exited.connect(_remove_player)
			panel.s_shape_changed.connect(panel_shape_changed)
			
			# Create the beam for the panel
			var beam := PanelBeam.new()
			beam_node.add_child(beam)
			beam.connect_panel(panel)
			beam.position = grid_center

## Overwrite this function to initialize your game
func initialize_game() -> void:
	for i in grid.size():
		for j in grid[i].size():
			var panel = grid[i][j]
			panel.panel_shape = PuzzlePanel.PanelShape.SKULL

func _pre_player_stepped_on(_panel: PuzzlePanel) -> void:
	if not began_interaction:
		began_interaction = true
		var label : Control = LABEL.load().instantiate()
		add_child(label)
		label.set_text(get_game_text())
	player_stepped_on(_panel)

## Overwrite these functions to react to player movement
func player_stepped_on(_panel : PuzzlePanel) -> void:
	pass
func player_stepped_off(_panel : PuzzlePanel) -> void:
	pass
	
## Overwrite this function to change the colors of shapes
func panel_shape_changed(_panel : PuzzlePanel,_shape : PuzzlePanel.PanelShape) -> void:
	pass

## DO NOT OVERWRITE
func _add_player(panel : PuzzlePanel) -> void:
	if panel not in player_cells:
		player_cells.append(panel)
func _remove_player(panel : PuzzlePanel) -> void:
	if panel in player_cells:
		player_cells.erase(panel)

func lose_game() -> void:
	s_lose.emit()
	if lose_type == LoseType.BATTLE:
		if not lose_battle:
			push_error("ERR: NO BATTLE NODE SPECIFIED FOR PUZZLE")
			return
		lose_battle.show()
		lose_battle.player_entered(Util.get_player())
		queue_free()
	elif lose_type == LoseType.EXPLODE:
		# Make Player slip backwards
		var player := Util.get_player()
		AudioManager.play_sound(player.toon.yelp)
		player.last_damage_source = "the Skull Master"
		player.quick_heal(Util.get_hazard_damage() + explosion_damage)
		# Only do the animation if the player is alive
		if player.stats.hp > 0:
			player.state = Player.PlayerState.STOPPED
			player.set_animation('slip_backward')
		
		# Do Kaboom
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/ENC_cogfall_apart.ogg'))
		var kaboom := Sprite3D.new()
		kaboom.render_priority = 1
		kaboom.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		kaboom.texture = load('res://models/props/gags/tnt/kaboom.png')
		add_child(kaboom)
		kaboom.global_position = player.global_position
		kaboom.scale *= 0.25
		var kaboom_tween := create_tween()
		kaboom_tween.tween_property(kaboom,'pixel_size',.05,0.25)
		await kaboom_tween.finished
		kaboom_tween.kill()
		kaboom.queue_free()
		
		# Free player (only if they're alive)
		if player.stats.hp > 0:
			await player.animator.animation_finished
			player.state = Player.PlayerState.WALK


func win_game() -> void:
	s_win.emit()
	if lose_battle:
		lose_battle.queue_free()
	queue_free()
	if Util.get_player():
		Util.get_player().quick_heal(-explosion_damage)
		AudioManager.play_sound(load("res://audio/sfx/battle/gags/toonup/sparkly.ogg"))

func connect_button(button : CogButton) -> void:
	button.s_pressed.connect(func(_button : CogButton): win_game())
	s_win.connect(button.press)

func get_game_text() -> String:
	return ""
