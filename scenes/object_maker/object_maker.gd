extends Node2D

const OBJECT_SCENES: Dictionary[Constants.ObjectType, PackedScene ] = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://scenes/bullet/player_bullet/player_bullet.tscn"),
	Constants.ObjectType.BULLET_ENEMY:preload("res://scenes/bullet/enemy_bullet/enemy_bullet.tscn"),
	Constants.ObjectType.EXPLOSION: preload("res://scenes/explosion/explosion.tscn"),
	Constants.ObjectType.PICKUP: preload("res://scenes/fruit_pickup/fruit_pickup.tscn")
}

func _enter_tree() -> void:
	SignalHub.on_create_bullet.connect(on_create_bullet)
	SignalHub.on_create_object.connect(on_create_object)

func on_create_bullet( pos: Vector2, dir: Vector2, speed: float, ob_type: Constants.ObjectType ) -> void:
	if not OBJECT_SCENES.has(ob_type) or (ob_type != Constants.ObjectType.BULLET_PLAYER and ob_type !=Constants.ObjectType.BULLET_ENEMY):
		return
	var nb: Bullet = OBJECT_SCENES[ob_type].instantiate()
	nb.setup(pos, dir, speed)
	call_deferred("add_child", nb)

func on_create_object(pos: Vector2, ob_type: Constants.ObjectType) -> void:
	if not OBJECT_SCENES.has(ob_type) or (ob_type == Constants.ObjectType.BULLET_PLAYER or ob_type ==Constants.ObjectType.BULLET_ENEMY):
		return 
	
	var nobj: Node2D = OBJECT_SCENES[ob_type].instantiate()
	nobj.global_position = pos
	call_deferred("add_child", nobj)

		
