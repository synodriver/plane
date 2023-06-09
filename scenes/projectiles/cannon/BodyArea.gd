extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", Callable(self,"on_area_entered"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_area_entered(area: Area2D): # 直接撞上，直接爆炸
	if area.get_parent().is_enemy != self.get_parent().is_enemy:
		var other = area.get_parent()
		if other.is_in_group("plane") || other.is_in_group("shell"): # 撞上敌方飞机or炮弹
			self.get_parent().destroy()
