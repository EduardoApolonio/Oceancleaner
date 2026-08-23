extends Control

const CENA_JOGO := "res://scenes/maps/testmapa.tscn"


func _ready() -> void:
	%StartButton.pressed.connect(_on_start_pressed)
	%QuitButton.pressed.connect(_on_quit_pressed)
	%StartButton.grab_focus()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(CENA_JOGO)


func _on_quit_pressed() -> void:
	get_tree().quit()
