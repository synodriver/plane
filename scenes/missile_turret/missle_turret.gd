extends BaseTurret
class_name MissileTurret

var barrel_length = 50 # 炮管长度，炮弹在炮口生成
@onready var cannon_shell_t = preload("res://scenes/projectiles/missile/missile.tscn")


var missiles: Array[Missile]

func fire():
	if self.aimed:
		var shell: Missile = self.cannon_shell_t.instantiate()
		var rorate_vector = Vector2.from_angle(self.global_rotation)
		shell.global_position = self.global_position + rorate_vector * self.barrel_length 
		shell.speed = 300 * rorate_vector
		self.get_node("/root").add_child(shell)
		self.missiles.append(shell)
		
func set_target(t: Vector2):  # 让炮塔转向，同时设置所有导弹的目标
	super.set_target(t)
	for m in self.missiles:
		if m.is_visible_in_tree():
			m.set_target(t)
		else:
			self.missiles.erase(m)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
