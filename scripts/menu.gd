extends Control
@onready var Animation_tree = $Anims
func _on_play_button_pressed() -> void:
	Animation_tree.play("Play Button Clicked")
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_quit_button_pressed() -> void:
	Animation_tree.play("Quit Button Clicked")
	get_tree().quit()
