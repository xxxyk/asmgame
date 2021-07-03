.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include inc\msvcrt.inc
include globalvariable.inc
include inc\acllib.inc

printf PROTO C :ptr sbyte, :VARARG

public mouseevent

.data
NO_ACTION equ 0
main_load_button equ 1
main_exit_button equ 2
first_press point <>

left_button_pressing DD BTN_RELEASE

moveinfo	DB		'move %d, %d, button: %d', 0Ah, 0
upinfo		DB		'up, button: %d', 0Ah, 0
downinfo	DB		'down, button: %d', 0Ah, 0

mouse_debug DB		'left top: %d, %d, right bottom: %d, %d, first click: %d, %d', 0Ah, 0

press_sound				ACL_Sound	?
im_change_sound			ACL_Sound	?
boundary_change_sound	ACL_Sound	?

press_sound_path		DB	'.\view\press_sound_path.mp3',0
im_change_sound_path	DB	'.\view\im_change_sound_path.mp3',0
boundary_change_sound_path	DB '.\view\boundary_change_sound_path.mp3',0

.code

	mainKeyClick proc stdcall x:DWORD, y:DWORD
		;用来判断主界面下按键是否按在相应键上
		;返回值main_load_button：x,y位置在
		mov ebx, LOAD_CENTER_X
		mov eax, VIEW_MENU_BTN_WIDTH
		shr eax , 1
		sub ebx, eax
		;ecx = LOAD_CENTER_X - VIEW_MENU_BTN_WIDTH / 2
		mov ecx, ebx

		shl eax, 1
		;ebx = LOAD_CENTER_X + VIEW_MENU_BTN_WIDTH / 2
		add ebx, eax

		cmp x, ecx
		jle mainKeyClick_no_action
		cmp x, ebx
		jge mainKeyClick_no_action

		mov ebx, LOAD_CENTER_Y
		mov eax, VIEW_MENU_BTN_HIGH
		shr eax, 1
		sub ebx, eax
		;ecx = LOAD_CENTER_Y - VIEW_MENU_BTN_HIGH / 2
		mov ecx, ebx

		mov ebx, EXIT_CENTER_Y
		mov eax, VIEW_MENU_BTN_HIGH
		shr eax, 1
		;ebx = EXIT_CENTER_Y + VIEW_MENU_BTN_HIGH / 2
		add ebx, eax

		cmp y, ecx
		jle mainKeyClick_no_action
		cmp y, ebx
		jge mainKeyClick_no_action
		
		mov ebx, LOAD_CENTER_Y
		mov eax, VIEW_MENU_BTN_HIGH
		shr eax, 1
		add ebx, eax
		cmp y, ebx
		jge mainKeyClick_no_load
		mov eax, main_load_button
		jmp mainKeyClick_quit

	mainKeyClick_no_load:
		mov ebx, EXIT_CENTER_Y
		mov eax, VIEW_MENU_BTN_HIGH
		shr eax, 1
		sub ebx, eax

		cmp y, ebx
		jle mainKeyClick_no_action
		mov eax, main_exit_button
		jmp mainKeyClick_quit

	mainKeyClick_no_action:
		mov eax, NO_ACTION
	mainKeyClick_quit:
		ret 8
	mainKeyClick endp

	sltKeyClick proc stdcall x:DWORD, y:DWORD
		;在选关界面点击之后返回选中的关卡或者是没选中
		.IF x > LEVEL1_CENTER_X - VIEW_LEVEL_SLT_WIDTH / 2 \
			&& x < LEVEL1_CENTER_X + VIEW_LEVEL_SLT_WIDTH / 2 \
			&& y > LEVEL1_CENTER_Y - VIEW_LEVEL_SLT_HIGH / 2 \
			&& y < LEVEL1_CENTER_Y + VIEW_LEVEL_SLT_HIGH / 2
			mov eax, 1
		.ELSEIF x > LEVEL1_CENTER_X - VIEW_LEVEL_SLT_WIDTH / 2 + 1 * LEVEL_DX \
			&& x < LEVEL1_CENTER_X + VIEW_LEVEL_SLT_WIDTH / 2 + 1 * LEVEL_DX \
			&& y > LEVEL1_CENTER_Y - VIEW_LEVEL_SLT_HIGH / 2 \
			&& y < LEVEL1_CENTER_Y + VIEW_LEVEL_SLT_HIGH / 2
			mov eax, 2
		.ELSEIF x > LEVEL1_CENTER_X - VIEW_LEVEL_SLT_WIDTH / 2 + 2 * LEVEL_DX \
			&& x < LEVEL1_CENTER_X + VIEW_LEVEL_SLT_WIDTH / 2 + 2 * LEVEL_DX \
			&& y > LEVEL1_CENTER_Y - VIEW_LEVEL_SLT_HIGH / 2 \
			&& y < LEVEL1_CENTER_Y + VIEW_LEVEL_SLT_HIGH / 2
			mov eax, 3
		.ELSEIF x > LEVEL1_CENTER_X - VIEW_LEVEL_SLT_WIDTH / 2 + 3 * LEVEL_DX \
			&& x < LEVEL1_CENTER_X + VIEW_LEVEL_SLT_WIDTH / 2 + 3 * LEVEL_DX \
			&& y > LEVEL1_CENTER_Y - VIEW_LEVEL_SLT_HIGH / 2 \
			&& y < LEVEL1_CENTER_Y + VIEW_LEVEL_SLT_HIGH / 2
			mov eax, 4
		.ELSEIF x > LEVEL1_CENTER_X - VIEW_LEVEL_SLT_WIDTH / 2 + 4 * LEVEL_DX \
			&& x < LEVEL1_CENTER_X + VIEW_LEVEL_SLT_WIDTH / 2 + 4 * LEVEL_DX \
			&& y > LEVEL1_CENTER_Y - VIEW_LEVEL_SLT_HIGH / 2 \
			&& y < LEVEL1_CENTER_Y + VIEW_LEVEL_SLT_HIGH / 2
			mov eax, 5
		.ELSE 
			mov eax, NO_ACTION
		.ENDIF
		ret 8
	sltKeyClick endp

	playGetIndex proc stdcall x:DWORD, y:DWORD
		;eax返回纵向坐标，ebx返回横向坐标
		local z_x, z_y:DWORD
		mov z_x, PLAY_AREA_CENTER_X - 5 * VIEW_IN_GAME_WIDTH
		mov z_y, PLAY_AREA_CENTER_Y - 5 * VIEW_IN_GAME_HIGH

		mov ecx, x
		sub ecx, z_x
		.IF ecx <= 0
			mov eax, -1
			mov ebx, -1
		.ELSEIF ecx >= VIEW_IN_GAME_WIDTH * 10
			mov eax, -1
			mov ebx, -1
		.ELSE 
			mov eax, ecx
			xor edx, edx
			mov ecx, VIEW_IN_GAME_WIDTH
			div ecx
			;此时eax为横向坐标
			mov ecx, y
			sub ecx, z_y
			.IF ecx <= 0
				mov eax, -1
				mov ebx, -1
			.ELSEIF ecx >= VIEW_IN_GAME_HIGH * 10
				mov eax, -1
				mov ebx, -1
			.ELSE
				;此时ebx为横向坐标
				mov ebx, eax
				mov eax, ecx
				xor edx, edx
				mov ecx, VIEW_IN_GAME_HIGH
				div ecx
				;此时eax为纵向坐标
			.ENDIF
		.ENDIF 
		ret 8
	playGetIndex endp

	mouseevent PROC C x:DWORD, y:DWORD, button:DWORD, event:DWORD
		local i,j:DWORD

		cmp i_m, IM_MAIN
		jne mouseevent_im_not_main
			;主界面响应
			.IF event == BUTTON_DOWN
				.IF button == LEFT_BUTTON
					invoke mainKeyClick, x, y
					.IF eax == main_load_button
						mov main_buttons.load_state, BTN_PRESS
					.ELSEIF eax == main_exit_button
						mov main_buttons.exit_state, BTN_PRESS
					.ENDIF 
					.IF eax == main_load_button
						;载入音乐
						invoke loadSound, offset im_change_sound_path, offset im_change_sound
						;播放音乐
						invoke playSound,  im_change_sound,  0;第二个参数非0，循环播放；为0只播放1遍
					.ENDIF
				.ENDIF 
			.ELSEIF event == BUTTON_UP
				.IF button == LEFT_BUTTON
					.IF main_buttons.load_state == BTN_PRESS ||  main_buttons.exit_state == BTN_PRESS
						;载入音乐
						invoke loadSound, offset im_change_sound_path, offset im_change_sound
						;播放音乐
						invoke playSound,  im_change_sound,  0;第二个参数非0，循环播放；为0只播放1遍
					.ENDIF
					.IF main_buttons.load_state == BTN_PRESS
						mov main_buttons.load_state, BTN_RELEASE
						mov i_m, IM_SLT
					.ELSEIF main_buttons.exit_state == BTN_PRESS
						mov main_buttons.exit_state, BTN_RELEASE
						;invoke crt_exit, 0
					.ENDIF 
				.ENDIF 
			.ENDIF 
		jmp mouseevent_quit
	mouseevent_im_not_main:
		cmp i_m, IM_SLT
		jne mouseevent_im_not_slt
			;选关界面响应
			;受不了了，开始使用.if
			.IF event == BUTTON_DOWN
				.IF button == LEFT_BUTTON
					invoke sltKeyClick, x, y
					.IF eax == 1
						mov select_buttons.leave_1, BTN_PRESS
					.ELSEIF eax == 2
						mov select_buttons.leave_2, BTN_PRESS
					.ELSEIF eax == 3
						mov select_buttons.leave_3, BTN_PRESS
					.ELSEIF eax == 4
						mov select_buttons.leave_4, BTN_PRESS
					.ELSEIF eax == 5
						mov select_buttons.leave_5, BTN_PRESS
					.ENDIF
					.IF eax >= 1 && eax <= 5
						;载入音乐
						invoke loadSound, offset im_change_sound_path, offset im_change_sound
						;播放音乐
						invoke playSound,  im_change_sound,  0;第二个参数非0，循环播放；为0只播放1遍
					.ENDIF
				.ENDIF 
			.ELSEIF event == BUTTON_UP
				.IF button == LEFT_BUTTON
					.IF select_buttons.leave_1 == BTN_PRESS \
					|| select_buttons.leave_2 == BTN_PRESS \
					|| select_buttons.leave_3 == BTN_PRESS \
					|| select_buttons.leave_4 == BTN_PRESS \
					|| select_buttons.leave_5 == BTN_PRESS
						;载入音乐
						invoke loadSound, offset im_change_sound_path, offset im_change_sound
						;播放音乐
						invoke playSound,  im_change_sound,  0;第二个参数非0，循环播放；为0只播放1遍
					.ENDIF
					.IF select_buttons.leave_1 == BTN_PRESS
						mov select_buttons.leave_1, BTN_RELEASE
						mov level, 1
						mov i_m, IM_PLAY
					.ELSEIF  select_buttons.leave_2 == BTN_PRESS
						mov select_buttons.leave_2, BTN_RELEASE
						mov level, 2
						mov i_m, IM_PLAY
					.ELSEIF  select_buttons.leave_3 == BTN_PRESS
						mov select_buttons.leave_3, BTN_RELEASE
						mov level, 3
						mov i_m, IM_PLAY
					.ELSEIF  select_buttons.leave_4 == BTN_PRESS
						mov select_buttons.leave_4, BTN_RELEASE
						mov level, 4
						mov i_m, IM_PLAY
					.ELSEIF  select_buttons.leave_5 == BTN_PRESS
						mov select_buttons.leave_5, BTN_RELEASE
						mov level, 5
						mov i_m, IM_PLAY
					.ENDIF
				.ENDIF 
			.ENDIF 
		jmp mouseevent_quit
	mouseevent_im_not_slt:
		;游戏界面相应
		.IF event == BUTTON_DOWN
			.IF button == LEFT_BUTTON
				invoke playGetIndex, x, y
				.IF eax != -1 && ebx != -1
					mov first_press.x, eax
					mov first_press.y, ebx
					mov game_clt.select_lt.x, eax
					mov game_clt.select_lt.y, ebx
					mov game_clt.select_rb.x, eax
					mov game_clt.select_rb.y, ebx
					mov left_button_pressing, BTN_PRESS
					;载入音乐
					;invoke loadSound, offset boundary_change_sound_path, offset boundary_change_sound
					;播放音乐
					;invoke playSound,  boundary_change_sound,  0;第二个参数非0，循环播放；为0只播放1遍
				.ELSE 
					mov left_button_pressing, BTN_RELEASE
					mov first_press.x, -1
					mov first_press.y, -1
				.ENDIF 
				invoke printf, offset mouse_debug, game_clt.select_lt.x, \
					game_clt.select_lt.y,game_clt.select_rb.x, game_clt.select_rb.y, \
						first_press.x, first_press.y
			.ENDIF 
		.ELSEIF event == BUTTON_UP
			.IF button == LEFT_BUTTON
				.IF left_button_pressing == BTN_PRESS
					mov left_button_pressing, BTN_RELEASE
					invoke playGetIndex, x, y
					.IF eax != -1 && ebx != -1
						.IF eax >= first_press.x
							mov ecx, first_press.x
							mov game_clt.select_lt.x, ecx
							mov game_clt.select_rb.x, eax
						.ELSE 
							mov ecx, first_press.x
							mov game_clt.select_rb.x, ecx
							mov game_clt.select_lt.x, eax
						.ENDIF 
						.IF ebx >= first_press.y
							mov ecx, first_press.y
							mov game_clt.select_lt.y, ecx
							mov game_clt.select_rb.y, ebx
						.ELSE 
							mov ecx, first_press.y
							mov game_clt.select_rb.y, ecx
							mov game_clt.select_lt.y, ebx
						.ENDIF 
					.ENDIF 
					mov first_press.x, -1
					mov first_press.y, -1
					invoke printf, offset mouse_debug, game_clt.select_lt.x, \
						game_clt.select_lt.y,game_clt.select_rb.x, game_clt.select_rb.y, \
						first_press.x, first_press.y
				.ENDIF 
			.ENDIF 
		.ELSEIF event == MOUSEMOVE
				.IF left_button_pressing == BTN_PRESS
					invoke playGetIndex, x, y
					.IF eax != -1 && ebx != -1
						.IF eax >= first_press.x
							mov ecx, first_press.x
						.ELSE 
							mov ecx, eax
							mov eax, first_press.x
						.ENDIF 
						.IF ebx >= first_press.y
							mov edx, first_press.y
						.ELSE 
							mov edx, ebx
							mov ebx, first_press.y
						.ENDIF 
						;上面的操作产生这样的结果
						;x坐标：eax >= ecx
						;y坐标：ebx >= edx
						;这时候判断同上一次的是不是出现变化，如果变化则改变并且播放音乐
						.IF game_clt.select_lt.x != ecx \
						|| game_clt.select_lt.y != edx  \
						|| game_clt.select_rb.x != eax  \
						|| game_clt.select_rb.y != ebx  
							mov game_clt.select_lt.x, ecx
							mov game_clt.select_lt.y, edx
							mov game_clt.select_rb.x, eax
							mov game_clt.select_rb.y, ebx 
;							;invoke loadSound, offset boundary_change_sound_path, offset boundary_change_sound
;							;invoke playSound,  boundary_change_sound,  0


						.ENDIF 
					.ENDIF 
					invoke printf, offset mouse_debug, game_clt.select_lt.x, \
						game_clt.select_lt.y,game_clt.select_rb.x, game_clt.select_rb.y, \
						first_press.x, first_press.y
				.ENDIF
		.ENDIF 

	mouseevent_quit:
		ret 
	mouseevent endp

end