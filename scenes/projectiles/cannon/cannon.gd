extends Node2D
class_name CannonShell

@export var is_enemy: bool  # 每个东西都要这个属性判断敌我
@export var damage: float = 10000 # 威力，越近越大
@export var hp: float = 100 # 生命值
var speed: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("shell")  # 所有炮弹都在shell组
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position += self.speed * delta


func destroy(): # 炮弹爆炸
	var detect_area: Area2D = self.get_node("DetectArea")
	for obj in detect_area.get_overlapping_areas():
		if obj.get_parent().is_enemy != self.is_enemy:
			obj.get_parent().decrhp(self.damage/self.global_position.distance_to(obj.global_position))
	self.get_parent().remove_child(self)
	
func decrhp(hp_: float):
	self.hp -= hp_
	if self.hp<0:
		self.destroy()
