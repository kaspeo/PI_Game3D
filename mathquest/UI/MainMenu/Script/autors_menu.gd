extends Control

@onready var autors: Control = $"."

func _on_exti_settings_pressed() -> void:
	autors.visible = false
