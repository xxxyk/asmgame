.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include inc\msvcrt.inc
include globalvariable.inc
include inc\acllib.inc

printf proto C :dword,:vararg

.data
	is_ctrl		dd 0
	is_ctrlc	dd 0
	is_ctrlv	dd 0
	strout		db "%s",0ah,0
	strout2num	db "%d %d",0ah,0
	strout4num	db "%d %d %d %d",0ah,0
	ctrl_down	db "ctrldown",0ah,0
	ctrl_up		db "ctrlup",0ah,0
	ctrl_c		db "ctrl+c",0ah,0
	ctrl_v		db "ctrl+v",0ah,0
	vtmp		array <>
	newpos		point <>
	ddtmp		dd 0
	ddtmp2		dd 0
	idx			dd 0
	idy			dd 0
	idxx		dd 0
	idyy		dd 0
	is_moved	dd 0
	tmp_info	db "where is my music?",0ah,0
	tmp_info2	db "has become lava haha",0ah,0

	move_sound_path byte ".\view\move.mp3",0
	lava_sound_path byte ".\view\lava.wav",0

	soundmove  ACL_Sound ?
	soundlava  ACL_Sound ?
.code
	
	iface_kbEvent proc C key:dword,event:dword
		.if i_m != 2
			JMP notingame
		.endif
		.if key == 11h ;判断ctrl键是否被按下
			.if event == KEY_DOWN
				mov is_ctrl, 1
				;invoke printf, offset strout, offset ctrl_down
				;invoke beginPaint
				;invoke paintText, 0, 0, offset ctrl_down
				;invoke endPaint
			.endif
			.if event == KEY_UP
				mov is_ctrl, 0
				mov is_ctrlc, 0
				mov is_ctrlv, 0
				;invoke printf, offset strout, offset ctrl_up
				;invoke beginPaint
				;invoke paintText, 500, 0, offset ctrl_up
				;invoke endPaint
			.endif
		.endif

		.if key == 52h ;判断R键是否被按下
			.if event == KEY_DOWN
				MOV game_clt.on_lava, 1
			.endif
		.endif

		.if key == 43h ;判断c键是否被按下
			.if event == KEY_DOWN && is_ctrl == 1 && is_ctrlc == 0
				.if game_clt.ctrl_left == 0
					ret
				.endif
				DEC game_clt.ctrl_left
				
				mov is_ctrlc, 1

				mov EAX, game_clt.select_lt.y
				mov game_clt.copied_lt.y, EAX
				mov EAX, game_clt.select_lt.x
				mov game_clt.copied_lt.x, EAX
				mov EAX, game_clt.select_rb.y
				mov game_clt.copied_rb.y, EAX
				mov EAX, game_clt.select_rb.x
				mov game_clt.copied_rb.x, EAX

				mov idx,0
				for5:
				.if idx < 10
					mov idy,0
					for6:
					.if idy < 10
						;invoke printf, offset strout2num, idx, idy
						;二重循环的正文
						invoke getIndex, offset game_clt.floor, idx, idy
						invoke setIndex, offset vtmp, idx, idy, EAX
						inc idy
						JMP for6
					.endif
					inc idx
					JMP for5
				.endif

				invoke printf, offset strout, offset ctrl_c
				invoke printf, offset strout4num, game_clt.copied_lt.x, game_clt.copied_lt.y, game_clt.copied_rb.x, game_clt.copied_rb.y
				;invoke beginPaint
				;invoke paintText, 0, 500, offset ctrl_c
				;invoke endPaint
			.elseif event == KEY_UP
				mov is_ctrlc, 0
			.endif
		.endif

		.if key == 56h ;判断v键是否被按下
			.if event == KEY_DOWN && is_ctrl == 1 && is_ctrlv == 0
				mov is_ctrlv, 1
				.if game_clt.ctrl_left == 0
					ret
				.endif
				DEC game_clt.ctrl_left

				mov idx,0
				for1:
				.if idx < 10
					mov idy,0
					for2:
					.if idy < 10
						;二重循环的正文
						invoke getIndex, offset game_clt.floor, idx, idy
						mov ddtmp, EAX
						mov EBX, idx
						mov ECX, idy
						.if EBX >= game_clt.copied_lt.x && EBX <= game_clt.copied_rb.x && ECX <= game_clt.copied_rb.y && ECX >= game_clt.copied_lt.y
							
							invoke printf, offset strout2num, idx, idy
							;计算x坐标
							MOV EAX, idx
							SUB EAX, game_clt.copied_lt.x
							ADD EAX, game_clt.select_lt.x
							MOV newpos.x, EAX
							;计算y坐标
							MOV EAX, idy
							SUB EAX, game_clt.copied_lt.y
							ADD EAX, game_clt.select_lt.y
							MOV newpos.y, EAX
							;nowpos = (idx,idy) - game_clt.copied_lt + game_clt.select_lt
							invoke printf, offset strout2num, newpos.x, newpos.y
							invoke getIndex, offset vtmp, idx, idy
							mov ddtmp, EAX
							invoke setIndex, offset game_clt.floor, newpos.x, newpos.y, ddtmp
						.endif
						inc idy
						JMP for2
					.endif
					inc idx
					JMP for1
				.endif

				mov idx,0
				for3:
				.if idx < 10
					mov idy,0
					for4:
					.if idy < 10
						;invoke printf, offset strout2num, idx, idy
						;二重循环的正文
						;invoke getIndex, offset vtmp, idx, idy
						;invoke setIndex, offset game_clt.floor, idx, idy, EAX
						inc idy
						JMP for4
					.endif
					inc idx
					JMP for3
				.endif

				invoke printf, offset strout, offset ctrl_v
				;invoke beginPaint
				;invoke paintText, 500, 500, offset ctrl_v
				;invoke endPaint
			.elseif event == KEY_UP
				mov is_ctrlv, 0
			.endif
		.endif

		.if key == 26h ;判断上键是否被按下
			.if event == KEY_DOWN
				mov game_clt.of_state, 26h
				mov is_moved,1 
				.if game_clt.of_pos.x != 0
					mov ECX, game_clt.of_pos.x
					DEC ECX
					MOV newpos.x, ECX
					invoke getIndex, offset game_clt.floor, ECX, game_clt.of_pos.y
					mov ECX, EAX
					.if ECX != 0
						MOV ECX, newpos.x
						MOV game_clt.of_pos.x, ECX
					.endif
				.endif
			.elseif event == KEY_UP
				;mov is_ctrlc, 0
			.endif
		.endif

		.if key == 25h ;判断左键是否被按下
			.if event == KEY_DOWN
				mov game_clt.of_state, 25h
				mov is_moved,1 
				.if game_clt.of_pos.y != 0
					mov ECX, game_clt.of_pos.y
					DEC ECX
					MOV newpos.x, ECX
					invoke getIndex, offset game_clt.floor, game_clt.of_pos.x, ECX 
					mov ECX, EAX
					.if ECX != 0
						MOV ECX, newpos.x
						MOV game_clt.of_pos.y, ECX
					.endif
				.endif
			.elseif event == KEY_UP
				;mov is_ctrlc, 0
			.endif
		.endif

		.if key == 27h ;判断右键是否被按下
			.if event == KEY_DOWN
				mov game_clt.of_state, 27h
				mov is_moved,1 
				.if game_clt.of_pos.y != 9
					mov ECX, game_clt.of_pos.y
					INC ECX
					MOV newpos.x, ECX
					invoke getIndex, offset game_clt.floor, game_clt.of_pos.x, ECX 
					mov ECX, EAX
					.if ECX != 0
						MOV ECX, newpos.x
						MOV game_clt.of_pos.y, ECX
					.endif
				.endif
			.elseif event == KEY_UP
				;mov is_ctrlc, 0
			.endif
		.endif

		.if key == 28h ;判断下键是否被按下
			.if event == KEY_DOWN
				mov game_clt.of_state, 28h
				mov is_moved,1 
				.if game_clt.of_pos.x != 9
					mov ECX, game_clt.of_pos.x
					INC ECX
					MOV newpos.x, ECX
					invoke getIndex, offset game_clt.floor, ECX, game_clt.of_pos.y
					mov ECX, EAX
					.if ECX != 0
						MOV ECX, newpos.x
						MOV game_clt.of_pos.x, ECX
					.endif
				.endif
			.elseif event == KEY_UP
				;mov is_ctrlc, 0
			.endif
		.endif

		.if is_moved == 0
			JMP notingame
		.endif

		invoke loadSound, offset move_sound_path, offset soundmove
		invoke playSound, soundmove, 0
		mov is_moved, 0

		mov idx,0
		for7:
		.if idx < 10
			mov idy,0
			for8:
			.if idy < 10
				;invoke printf, offset strout2num, idx, idy
				;二重循环的正文
				invoke getIndex, offset game_clt.lava, idx, idy
				MOV ddtmp, EAX
				invoke getIndex, offset game_clt.floor, idx, idy
				MOV ECX, EAX
				.if ddtmp == 1
					invoke printf, offset strout2num, idx, idy
					invoke printf, offset strout, offset tmp_info
					MOV EAX, idx
					DEC EAX
					MOV idxx, EAX
					MOV eax, idy
					MOV idyy, EAX
					.if idxx>0
						invoke getIndex, offset game_clt.floor, idxx, idyy
						MOV ddtmp2, EAX
						invoke getIndex, offset game_clt.lava, idxx, idyy
						.if EAX != 1 && ddtmp2 == 1
							invoke printf, offset strout, offset tmp_info2
							invoke printf, offset strout2num, idxx,idyy
							invoke setIndex, offset game_clt.lava, idxx, idyy, 11
						.endif
					.endif

					MOV EAX, idx
					INC EAX
					MOV idxx, EAX
					MOV eax, idy
					MOV idyy, EAX
					.if idxx<10
						invoke getIndex, offset game_clt.floor, idxx, idyy
						MOV ddtmp2, EAX
						invoke getIndex, offset game_clt.lava, idxx, idyy
						.if EAX != 1 && ddtmp2 == 1
							invoke printf, offset strout, offset tmp_info2
							invoke printf, offset strout2num, idxx,idyy
							invoke setIndex, offset game_clt.lava, idxx, idyy, 11
						.endif
					.endif
							
					MOV EAX, idx
					MOV idxx, EAX
					MOV eax, idy
					DEC EAX
					MOV idyy, EAX
					.if idyy>0
						invoke getIndex, offset game_clt.floor, idxx, idyy
						MOV ddtmp2, EAX
						invoke getIndex, offset game_clt.lava, idxx, idyy
						.if EAX != 1 && ddtmp2 == 1
							invoke printf, offset strout, offset tmp_info2
							invoke printf, offset strout2num, idxx,idyy
							invoke setIndex, offset game_clt.lava, idxx, idyy, 11
						.endif
					.endif

					MOV EAX, idx
					MOV idxx, EAX
					MOV eax, idy
					INC EAX
					MOV idyy, EAX
					.if idyy<10
						invoke getIndex, offset game_clt.floor, idxx, idyy
						MOV ddtmp2, EAX
						invoke getIndex, offset game_clt.lava, idxx, idyy
						.if EAX != 1 && ddtmp2 == 1
							invoke printf, offset strout, offset tmp_info2
							invoke printf, offset strout2num, idxx,idyy
							invoke setIndex, offset game_clt.lava, idxx, idyy, 11
						.endif
					.endif

				.endif
				inc idy
				JMP for8
			.endif
			inc idx
			JMP for7
		.endif

		mov idx,0
		for9:
		.if idx < 10
			mov idy,0
			for10:
			.if idy < 10
				invoke getIndex, offset game_clt.lava, idx, idy
				.if EAX == 11
					invoke setIndex, offset game_clt.lava, idx, idy, 1
					;invoke printf, offset strout, offset tmp_info2
					;invoke printf, offset strout2num, idx,idy
				.endif
				inc idy
				JMP for10
			.endif
			inc idx
			JMP for9
		.endif

		
		;判断是否踩在岩浆上
		invoke getIndex, offset game_clt.lava, game_clt.of_pos.x, game_clt.of_pos.y 
		.if EAX == 1
			invoke loadSound, offset lava_sound_path, offset soundlava
			invoke playSound, soundlava, 0
			MOV game_clt.on_lava, 1
			ret
		.endif
		;判断是否胜利
		MOV EBX, game_clt.out_pos.x
		MOV ECX, game_clt.out_pos.y
		.if game_clt.of_pos.x == EBX && game_clt.of_pos.y == ECX
			MOV game_clt.win, 1
			ret
		.endif

		notingame:
		.if key == 1bh
			.if event == KEY_DOWN
				invoke crt_exit,0
			.endif
		.endif
		;invoke debugControl, offset game_clt
		ret
	iface_kbEvent endp
	
end