extends Node

var current_level = 0

var ui: Control = null

func set_ui(node: Node) -> void:
	ui = node

func get_ui() -> Node:
	return ui
