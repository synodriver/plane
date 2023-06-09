extends RigidBody2D

@export_color_no_alpha var color = Color.WHITE
@export var duration: float = 2.0

@onready var color_rect = $ColorRect

func _ready():
	color_rect.color = color
	
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_time_out)
	timer.wait_time = duration
	timer.start()

func _set_color(value):
	color = value

func _on_timer_time_out():
	get_parent().remove_child(self)
