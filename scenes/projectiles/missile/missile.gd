extends Node2D
class_name Missile

@export var is_enemy: bool  # 每个东西都要这个属性判断敌我
@export var damage: float = 1000 # 威力，越近越大
@export var hp: float = 50 # 生命值
var speed: Vector2 = Vector2(100,0) # 速度


var target: Vector2 = Vector2(500,500) # 目标的绝对坐标

func set_target(t: Vector2):
	self.target = t

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("shell")
	self.get_node("BodyArea").connect("area_entered", Callable(self, "bodyarea_on_area_entered"))

func bodyarea_on_area_entered(area: Area2D):
	if area.get_parent().is_enemy != self.is_enemy:
		var other = area.get_parent()
		if other.is_in_group("plane") || other.is_in_group("shell"): # 撞上敌方飞机or炮弹
			self.destroy()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# print("位置",self.global_position, "速度", self.speed)
	self.global_position += self.speed * delta
	self.look_at(self.global_position + self.speed)  # 指向速度方向
	var pos:Vector2 = self.global_position.direction_to(self.target)

	self.speed += pos * 500 * delta
	
	
func destroy(): # 导弹爆炸
	var detect_area: Area2D = self.get_node("BodyArea")
	for obj in detect_area.get_overlapping_areas():
		if obj.get_parent().is_enemy != self.is_enemy:
			obj.get_parent().take_damage(self.damage)
	self.get_parent().remove_child(self)
	
func take_damage(hp_: float):
	self.hp -= hp_
	if self.hp < 0:
		self.destroy()

