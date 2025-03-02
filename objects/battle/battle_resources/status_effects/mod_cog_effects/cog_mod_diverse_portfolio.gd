@tool
extends StatusEffect


func apply() -> void:
	target.stats.turns += 1
	target.stats.damage *= (2.0 / 3.0)
