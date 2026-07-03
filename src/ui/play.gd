extends Button

func _ready() -> void:
	$"../AnimationPlayer".play("Fade-In")
	await $"../AnimationPlayer".animation_finished
func _on_pressed() -> void:
	$"../AnimationPlayer".play("Fade-Out")
	await $"../AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://src/map-cene/map.tscn")
