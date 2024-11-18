extends Area2D

@onready var sound: AudioStreamPlayer2D = $Sound
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	SignalManager.on_pickup.emit()
	animation_player.play("vanish")
	play_sound()


func play_sound():
	sound.stream = SoundManager.get_random_pickup_sound()
	sound.play()

func _on_sound_finished() -> void:
	queue_free()
