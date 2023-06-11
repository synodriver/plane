extends Node2D
class_name LaserBeam

@export var is_enemy: bool = true  # 每个东西都要这个属性判断敌我
@export var damage: float = 10000 # 威力，越近越大
var start: Vector2 = Vector2(100,100)  # 光束起点，通常是炮口
var angle: float = PI/4# 指向

var length: float = 2000# 最大光束长度，贯穿型需要延申到屏幕外，普通的到第一个敌人那就停
var duration: float = 1.0 # 光束存在时间
# @onready var timer = Timer.new()

@export var color:String = "red"  # 颜色

# 一段128像素
@onready var blue_beam = preload("res://images/laser/blue_beam.png")
@onready var yellow_beam = preload("res://images/laser/yellow_beam.png")
@onready var red_beam = preload("res://images/laser/red_beam.dds")

# Called when the node enters the scene tree for the first time.
func _ready():
	# print(red_beam)
	var beam_count: int = self.length / 128
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
	# print("添加超时")

func _on_timer_timeout():
	# print("消失")
	self.get_parent().remove_child(self)
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
