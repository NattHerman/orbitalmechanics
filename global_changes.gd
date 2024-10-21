extends Node

var time_multiplier: float = 1.0
signal time_multiplier_changed


func set_time_multiplier(value: float):
	time_multiplier = value
	time_multiplier_changed.emit()
