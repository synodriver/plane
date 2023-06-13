extends Node2D
class_name Missile

@export var is_enemy: bool  # 每个东西都要这个属性判断敌我
@export var damage: float = 1000 # 威力，越近越大 
@export var hp: float = 50 # 生命值
var speed: Vector2 = Vector2(200,0) # 速度


var target: Vector2 = Vector2(500,500) # 目标的绝对坐标


@export var min_jitter = 0  # 抖动
@export var max_jitter = 0
var switch: bool = false
# var real_global_postion: Vector2  # 出生点

func set_target(t: Vector2):
	self.target = t

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("shell")
	self.get_node("BodyArea").connect("area_entered", Callable(self, "bodyarea_on_area_entered"))
	self.get_node("BodyArea").add_to_group("solid")
	self.look_at(self.global_position + self.speed)  # 指向速度方向
	
	# self.real_global_postion = self.global_position
	
func bodyarea_on_area_entered(area: Area2D):
	if area.is_in_group("solid"):
		if area.get_parent().is_enemy != self.is_enemy:
			var other = area.get_parent()
			if other.is_in_group("plane") || other.is_in_group("shell"): # 撞上敌方飞机or炮弹
				self.destroy()
	

func _physics_process(delta):
	# self.global_position = self.real_global_postion
	
#	# print("位置",self.global_position, "速度", self.speed)
	self.global_position += self.speed * delta
	self.look_at(self.global_position + self.speed)  # 指向速度方向
	# todo  加速度方向只能和速度方向垂直
	var pos: Vector2 = self.global_position.direction_to(self.target) 
	print(self.speed.angle_to(pos))
	if self.speed.angle_to(pos) > 0:
		self.speed -= self.speed.orthogonal() * 0.01
	else:
		self.speed += self.speed.orthogonal() * 0.01
	
	# self.speed += pos * 500 * delta
	
	# self.real_global_postion = self.global_position
#	if switch:
#		self.position += Vector2(0, randf_range(self.min_jitter, self.max_jitter))
#		switch = false
#	else:
#		self.position -= Vector2(0, randf_range(self.min_jitter, self.max_jitter))
#		switch = true

	
func destroy(): # 导弹爆炸
	var detect_area: Area2D = self.get_node("BodyArea")
	for obj in detect_area.get_overlapping_areas():
		if obj.is_in_group("solid"):
			if obj.get_parent().is_enemy != self.is_enemy:
				obj.get_parent().take_damage(self.damage)
	self.get_parent().remove_child(self)
	self.queue_free()
	
func take_damage(hp_: float):
	self.hp -= hp_
	if self.hp < 0:
		self.destroy()

