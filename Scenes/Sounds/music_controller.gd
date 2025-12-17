extends Node2D

@onready var main_menu_bgm: AudioStreamPlayer = $MainMenuBGM
@onready var level1_bgm: AudioStreamPlayer = $Level1BGM
@onready var victory_sfx: AudioStreamPlayer = $VictorySFX
@onready var defeat_sfx: AudioStreamPlayer = $DefeatSFX

func mainmenu_bgm_play():
	main_menu_bgm.play()
	
func mainmenu_bgm_stop():
	main_menu_bgm.stop()

func level1_bgm_play():
	level1_bgm.play()
	
func level1_bgm_stop():
	level1_bgm.stop()

func victory_sfx_play():
	victory_sfx.play()

func victory_sfx_stop():
	victory_sfx.stop()
	
func defeat_sfx_play():
	defeat_sfx.play()
	
func defeat_sfx_stop():
	defeat_sfx.stop()
