extends Area2D
class_name DetectArea

var tracing_objs: Array[Area2D] = []  # 进入追踪范围的对象
var ddistance: Array[Array] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", Callable(self,"on_area_entered"))
	self.connect("area_exited", Callable(self,"on_area_exited"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var idx: int = 0
	var tmpdis: float
	for obj in self.tracing_objs:
		tmpdis = self.global_position.distance_to(obj.global_position)
		self.ddistance[idx].append(tmpdis)
		if len(self.ddistance[idx]) >=2 && self.ddistance[idx][-1]>self.ddistance[idx][-2]:
			self.get_parent().destroy() # 为了找到一个最短距离
		idx += 1

func on_area_entered(area: Area2D):
	if area.get_parent().is_enemy != self.get_parent().is_enemy:
		if area.get_parent().is_in_group("plane"):
			self.tracing_objs.append(area)
			self.ddistance.append([])

func on_area_exited(area: Area2D):
	var idx = self.tracing_objs.find(area)
	self.tracing_objs.erase(area)
	self.ddistance.remove_at(idx)
