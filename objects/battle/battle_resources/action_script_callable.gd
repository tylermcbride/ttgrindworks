extends ActionScript
class_name ActionScriptCallable

var callable : Callable

func action() -> void:
	await callable.call()
