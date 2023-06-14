extends Node2D
class_name LaserBeam

@export var is_enemy: bool = true  # 每个东西都要这个属性判断敌我
@export var damage: float = 1000 # 威力，越近越大
var start: Vector2 = Vector2(100, 0)  # 光束起点，通常是炮口，相对父节点, y一定是0
# var global_start: Vector2 = Vector2(100,100) # 全局光束起点

@export var length: float = 10000# 最大光束长度，贯穿型需要延申到屏幕外，普通的到第一个敌人那就停
@export var duration: float = 2.0 # 光束存在时间
@export var can_through: bool = false # 可以贯穿
@export var color:String = "red"  # 颜色
@export var beam_width: float = 50.0  # 光束宽度
# 一段128像素
@onready var blue_beam = preload("res://images/laser/blue_beam.png")
@onready var yellow_beam = preload("res://images/laser/yellow_beam.png")
@onready var red_beam = preload("res://images/laser/red_beam.dds")

var on_the_way: Array # 挡路的
@onready var raycast: RayCast2D = self.get_node("RayCast2D")
@onready var laser: Line2D = self.get_node("Line2D")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.raycast.position = Vector2(0, 0)
	self.raycast.target_position = Vector2(self.length, 0)
	self.raycast.collide_with_areas = true
	if self.color == "blue":
		self.laser.texture = blue_beam
	elif self.color == "red":
		self.laser.texture = red_beam
	elif self.color == "yellow":
		self.laser.texture = yellow_beam
	self.laser.width = self.beam_width
	self.laser.texture_mode = 1
	
	var timer = self.get_tree().create_timer(self.duration)	
	timer.timeout.connect(self._on_timer_timeout)

func _on_timer_timeout():
	# print("消失")
	self.get_parent().remove_child(self)
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# self.raycast.force_raycast_update()
	self.update_collision()
	self.create_laserbeam()
	self.calc_damage(delta)

func update_collision():
	self.on_the_way.clear()
	self.raycast.clear_exceptions()
	while true:
		if self.raycast.is_colliding():
			var collider = self.raycast.get_collider()
			if collider.is_in_group("solid"): # 创到了实体
				if collider.get_parent().is_enemy != self.is_enemy: # 创到了敌方的什么
					self.on_the_way.append({"collider": collider, 
											"rid": self.raycast.get_collider_rid(), 
											"position": self.raycast.get_collision_point()})
					self.raycast.add_exception_rid(self.raycast.get_collider_rid())
				else: # 创到了自己
					self.raycast.add_exception_rid(self.raycast.get_collider_rid())
			else:  # 创到了力场
				self.raycast.add_exception_rid(self.raycast.get_collider_rid())
		else:
			break

func create_laserbeam():
	# print(self.laser.texture)
	self.laser.clear_points()
	self.laser.add_point(self.start)
	if self.can_through: # 贯穿激光
		self.laser.add_point(self.start + Vector2(self.length, 0))
	else: # 一般激光
		if len(self.on_the_way) == 0:
			self.laser.add_point(self.start + Vector2(self.length, 0))
		else:
			self.laser.add_point(self.laser.to_local(self.on_the_way[0]["position"]))
	
func calc_damage(delta):
	if self.can_through: # 贯穿激光
		for obj in self.on_the_way:
			obj["collider"].get_parent().take_damage(self.damage/self.duration * delta)
	else:
		if self.on_the_way:
			self.on_the_way[0]["collider"].get_parent().take_damage(self.damage/self.duration * delta)
