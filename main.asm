.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include inc\acllib.inc
include inc\kbcontrol.inc
include mscontrol.inc
include globalvariable.inc
include view.inc
.data
winTitle byte "Losing Ctrl", 0
	main_music  byte ".\view\main.mp3",0
	soundMain  ACL_Sound ?
.code
	


main proc
	mov i_m, IM_MAIN
	invoke init_first

	invoke initConsole
	invoke initWindow, offset winTitle, 0, 0, 128 * 7, 128 * 4
	
	;
	;载入图片
	invoke loadImage, offset game_floor, offset imgGameFloor
	invoke loadImage, offset game_lava,  offset imgGameLava
	invoke loadImage, offset game_peoples, offset imgGamePeopleS
	invoke loadImage, offset game_peoplex, offset imgGamePeopleX
	invoke loadImage, offset game_peoplez, offset imgGamePeopleZ
	invoke loadImage, offset game_peopley, offset imgGamePeopleY

	invoke loadImage, offset game_peoples_xukong, offset imgGamePeopleS_x
	invoke loadImage, offset game_peoplex_xukong, offset imgGamePeopleX_x
	invoke loadImage, offset game_peoplez_xukong, offset imgGamePeopleZ_x
	invoke loadImage, offset game_peopley_xukong, offset imgGamePeopleY_x
		
	invoke loadImage, offset game_out,          offset imgGameOut
	invoke loadImage, offset game_out_xukong,   offset imgGameOutX

	invoke loadImage, offset game_ctrl,  offset imgGameCtrl	
	invoke loadImage, offset game_C,  offset imgGameC
	invoke loadImage, offset game_V,  offset imgGameV
	invoke loadImage, offset game_S,  offset imgGameS
	invoke loadImage, offset game_X,  offset imgGameX
	invoke loadImage, offset game_Z,  offset imgGameZ
	invoke loadImage, offset game_Y,  offset imgGameY
	invoke loadImage, offset win_path, offset imgWin


	;

	;载入音乐
	invoke loadSound, offset main_music, offset soundMain
	;播放音乐
	invoke playSound,  soundMain,  0; 第二个参数非0，循环播放；为0只播放1遍

	invoke registerKeyboardEvent, iface_kbEvent
	invoke registerMouseEvent, mouseevent
	invoke registerTimerEvent, offset timer
	invoke startTimer,0,interval
	invoke init_second
	ret
main endp
end main