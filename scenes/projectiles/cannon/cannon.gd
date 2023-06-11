extends Node2D
class_name CannonShell

@export var is_enemy: bool = true  # 每个东西都要这个属性判断敌我
@export var damage: float = 10000 # 威力，越近越大
@export var hp: float = 100 # 生命值
var speed: Vector2 = Vector2(100,0) # 速度


var tracing_objs: Array[Area2D] = []  # 进入追踪范围的对象
var ddistance: Array[Array] = []


func _ready():
	self.add_to_group("shell")  # 所有炮弹都在shell组
	self.get_node("DetectArea").connect("area_entered", Callable(self, "detectarea_on_area_entered"))
	self.get_node("DetectArea").connect("area_exited", Callable(self, "detectarea_on_area_exited"))
	self.get_node("BodyArea").connect("area_entered", Callable(self, "bodyarea_on_area_entered"))
	
func detectarea_on_area_entered(area: Area2D):
	if area.get_parent().is_enemy != self.is_enemy:
		if area.get_parent().is_in_group("plane"):
			self.tracing_objs.append(area)
			self.ddistance.append([])

func detectarea_on_area_exited(area: Area2D):
	var idx = self.tracing_objs.find(area)
	self.tracing_objs.erase(area)
	self.ddistance.remove_at(idx)

func bodyarea_on_area_entered(area: Area2D):
	if area.get_parent().is_enemy != self.is_enemy:
		var other = area.get_parent()
		if other.is_in_group("plane") || other.is_in_group("shell"): # 撞上敌方飞机or炮弹
			self.destroy()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.global_position += self.speed * delta
	self.look_at(self.global_position + self.speed)  # 指向速度方向
	var idx: int = 0
	var tmpdis: float
	for obj in self.tracing_objs:
		tmpdis = self.global_position.distance_to(obj.global_position)
		self.ddistance[idx].append(tmpdis)
		if len(self.ddistance[idx]) >=2:
			if self.ddistance[idx][-1]>self.ddistance[idx][-2]:
				self.destroy() # 为了找到一个最短距离
			else:
				self.ddistance[idx].remove_at(0)
		idx += 1


func destroy(): # 炮弹爆炸
	var detect_area: Area2D = self.get_node("DetectArea")
	for obj in detect_area.get_overlapping_areas():
		if obj.get_parent().is_enemy != self.is_enemy:
			obj.get_parent().take_damage(self.damage/self.global_position.distance_to(obj.global_position))
	self.get_parent().remove_child(self)
	self.queue_free()
	
func take_damage(hp_: float):
	self.hp -= hp_
	if self.hp < 0:
		self.destroy()
