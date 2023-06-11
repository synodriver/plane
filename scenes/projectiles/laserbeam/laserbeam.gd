extends Node2D
class_name LaserBeam

@export var is_enemy: bool = true  # 每个东西都要这个属性判断敌我
@export var damage: float = 1000 # 威力，越近越大
var start: Vector2 = Vector2(100,100)  # 光束起点，通常是炮口
var angle: float = PI/4# 指向

var length: float = 2000# 最大光束长度，贯穿型需要延申到屏幕外，普通的到第一个敌人那就停
var duration: float = 1.0 # 光束存在时间
var can_through: bool = false # 可以贯穿
@export var color:String = "red"  # 颜色

# 一段128像素
@onready var blue_beam = preload("res://images/laser/blue_beam.png")
@onready var yellow_beam = preload("res://images/laser/yellow_beam.png")
@onready var red_beam = preload("res://images/laser/red_beam.dds")

var on_the_way: Array # 挡路的
# Called when the node enters the scene tree for the first time.
func _ready():
	var param = PhysicsRayQueryParameters2D.create(self.start, 
		self.start + self.length *Vector2.from_angle(self.angle)
	)
	param.collide_with_areas = true
	while true:
		var result = self.get_world_2d().direct_space_state.intersect_ray(param)
		if len(result)==0:
			break
		if result["collider"].is_in_group("solid"): # 创到了实体
			if result["collider"].get_parent().is_enemy != self.is_enemy: # 创到了敌方的什么
				self.on_the_way.append(result)
				param.exclude.append(result["rid"])
			else: # 创到了自己
				param.exclude.append(result["rid"])
		else: # 创到了力场
			param.exclude.append(result["rid"])
			
	# print(red_beam)
	if not self.can_through: # 不能穿透，打中第一个
		if self.on_the_way:
			self.length = self.start.distance_to(self.on_the_way[0]["position"])
	var beam_count: int = self.length / 128

		#
	# print(beam_count)
	for i in range(beam_count):
		var icon: Sprite2D = Sprite2D.new()
		if self.color == "blue":
			icon.texture = blue_beam
		elif self.color == "red":
			icon.texture = red_beam
		elif self.color == "yellow":
			icon.texture = yellow_beam
		icon.global_position = self.start + i *128* Vector2.from_angle(self.angle)
		icon.global_rotation = self.angle
		self.add_child(icon)
		# print("添加光束段",icon, icon.texture)
		pass # Replace with function body.
	var timer = self.get_tree().create_timer(self.duration)	
	timer.timeout.connect(self._on_timer_timeout)
	if self.can_through:
		for obj in self.on_the_way:
			obj["collider"].get_parent().take_damage(self.damage)
	else:
		if self.on_the_way:
			self.on_the_way[0]["collider"].get_parent().take_damage(self.damage)
	# print("添加超时")

func _on_timer_timeout():
	# print("消失")
	self.get_parent().remove_child(self)
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
