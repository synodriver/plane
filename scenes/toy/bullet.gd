extends RigidBody2D

@export var speed: float = 500.0
@export var duration: float = 5

@onready var timer = Timer.new()

func _ready():
	linear_velocity = Vector2(cos(global_rotation), sin(global_rotation)) * speed
	
	self.add_child(self.timer)
	self.timer.wait_time = self.duration
	self.timer.timeout.connect(_on_timer_timeout)
	self.timer.start()

func _on_timer_timeout():
	self.get_parent().remove_child(self)
