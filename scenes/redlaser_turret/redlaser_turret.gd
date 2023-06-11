extends BaseTurret
class_name RedLaserTurret

var barrel_length = 150 # 炮管长度，炮弹在炮口生成
@onready var shell_t = preload("res://scenes/projectiles/laserbeam/laserbeam.tscn")

func fire():
	if self.aimed:
		var laserbeam: LaserBeam = self.shell_t.instantiate()
		var rorate_vector = Vector2.from_angle(self.global_rotation)
		laserbeam.start = Vector2(self.barrel_length, 0)
		laserbeam.global_start = self.global_position + rorate_vector * self.barrel_length
		# print("RedLaserTurret.gd",self.global_rotation )
		#laserbeam.angle = self.global_rotation
		laserbeam.duration =0.1
		laserbeam.color = "red"
		self.add_child(laserbeam)
		
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
