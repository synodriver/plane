extends Node2D

@export var rotate_speed: float = deg_to_rad(90)
@export var accuracy: float = 0.8
@export var fire_rate: float = 500

@onready var res_bullet = preload("res://scenes/toy/bullet.tscn")
@onready var fire_point = $FirePoint
@onready var timer = Timer.new()

var target_pos = Vector2.ZERO
var is_aiming = false
var is_firing = false
var can_fire = true

func aim(pos):
	target_pos = pos
	is_aiming = true

func stop_aiming():
	is_aiming = false

func fire():
	is_firing = true
	
func stop_firing():
	is_firing = false

func _ready():
	is_aiming = true
	is_firing = true
	
	self.add_child(self.timer)
	self.timer.wait_time = 1 / (self.fire_rate / 60)
	self.timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta):
	self.target_pos = get_global_mouse_position()
	
	if self.is_aiming:
		var target_rotation = self.global_position.angle_to_point(target_pos)
		var rotate_angle = _delta_angle(self.global_rotation, target_rotation)
		
		var delta_rotate_angle = self.rotate_speed * delta
		if abs(rotate_angle) > delta_rotate_angle:
			if rotate_angle > 0:
				self.global_rotation += delta_rotate_angle
			else:
				self.global_rotation -= delta_rotate_angle
	
	if self.is_firing:
		if self.can_fire:
			var bullet: RigidBody2D = res_bullet.instantiate()
			bullet.global_position = fire_point.global_position
			bullet.global_rotation = self.global_rotation + (1 - self.accuracy) * PI / 2 * (randf() - 0.5)
			self.get_parent().add_child(bullet)
			
			self.can_fire = false
			self.timer.start()

func _on_timer_timeout():
	self.can_fire = true

func _delta_angle(a, b):
	if abs(b - a) < PI:
		return b - a
	else:
		if a < b:
			a += 2 * PI
		else:
			b += 2 * PI
			
		return b - a
