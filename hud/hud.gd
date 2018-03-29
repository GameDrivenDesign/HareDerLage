extends Control

func set_health_percentage(val):
	$health_bar/health_bar_background.rect_scale = Vector2(val, 1)