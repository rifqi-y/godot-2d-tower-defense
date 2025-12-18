extends Node2D

@onready var main_menu_bgm: AudioStreamPlayer = $MainMenuBGM
@onready var level1_bgm: AudioStreamPlayer = $Level1BGM
@onready var victory_sfx: AudioStreamPlayer = $VictorySFX
@onready var defeat_sfx: AudioStreamPlayer = $DefeatSFX
@onready var level2_bgm: AudioStreamPlayer = $Level2BGM
@onready var level3_bgm: AudioStreamPlayer = $Level3BGM

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

func level2_bgm_play():
	level2_bgm.play()
	
func level2_bgm_stop():
	level2_bgm.stop()

func level3_bgm_play():
	level3_bgm.play()
	
func level3_bgm_stop():
	level3_bgm.stop()
