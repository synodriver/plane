extends Node2D

@onready var res_cube: Resource = preload("res://scenes/toy/cube.tscn")
@onready var screen_size = get_viewport_rect().size

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_time_out)
	timer.wait_time = 0.01
	timer.start()
	
func _on_timer_time_out():
	var cube: RigidBody2D = res_cube.instantiate()
	cube.position = Vector2(screen_size.x / 2 + (randf() - 0.5) * 500, 0)
	cube.color = Color(randf(), randf(), randf())
	cube.duration = 2
	add_child(cube)
