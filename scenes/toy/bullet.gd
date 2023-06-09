extends RigidBody2D

@export var speed = 500.0

func _ready():
	linear_velocity = Vector2(cos(global_rotation), sin(global_rotation)) * speed
