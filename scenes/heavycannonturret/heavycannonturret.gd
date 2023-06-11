extends BaseTurret
class_name HeavyCannonTurret

var barrel_length = 350 # 炮管长度，炮弹在炮口生成
@onready var cannon_shell_t = preload("res://scenes/projectiles/cannon/cannon.tscn")
# Called when the node enters the scene tree for the first time.
func fire():
	if self.aimed:
		var shell: CannonShell = self.cannon_shell_t.instantiate()
		var rorate_vector = Vector2.from_angle(self.global_rotation)
		shell.global_position = self.global_position + rorate_vector * self.barrel_length 
		shell.speed = 500 * rorate_vector
		self.get_node("/root").add_child(shell)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
