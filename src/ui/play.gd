extends Button

@onready var anim =  $"../../../TopLayer/AnimationPlayer"

func _ready() -> void:
	anim.play("IN")

func _on_pressed() -> void:
	anim.play("OUT")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://src/map-cene/map-cene1.tscn")

func _on_cene_2_pressed() -> void:
	anim.play("OUT")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://src/map-cene/map-cene2.tscn")
