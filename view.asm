.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib lib\acllib.lib

include globalvariable.inc
include inc\msvcrt.inc
include inc\acllib.inc
include boundary.inc

printf PROTO C :ptr sbyte, :vararg

.DATA
	main_background byte ".\view\main_background.bmp",0
	main_title byte ".\view\main_title.bmp",0
	main_start byte ".\view\main_start.bmp",0
	main_load  byte ".\view\main_load.bmp",0
	levelselect_bg byte ".\view\levelselect_bg.bmp",0	
	level1 byte ".\view\1.bmp",0	
	level2 byte ".\view\2.bmp",0	
	level3 byte ".\view\3.bmp",0		
	level4 byte ".\view\4.bmp",0	
	level5 byte ".\view\5.bmp",0	

	

	main_music  byte ".\view\main.mp3",0
	level_music byte ".\view\level.mp3",0
	game_music  byte ".\view\game.mp3",0
	win_music_path  byte ".\view\win_music.mp3",0   
	lose_music_path byte ".\view\lose_music.mp3",0  
	file_txt1   byte ".\view\level1.txt",0
	file_txt2   byte ".\view\level2.txt",0
	file_txt3   byte ".\view\level3.txt",0
	file_txt4   byte ".\view\level4.txt",0
	file_txt5   byte ".\view\level5.txt",0

	imgBackground ACL_Image <>
	imgTitle ACL_Image <>
	imgStart ACL_Image <>
	imgLoad  ACL_Image <>
	imgLevelSelectBg ACL_Image <>
	imgLevel1 ACL_Image <>
	imgLevel2 ACL_Image <>
	imgLevel3 ACL_Image <>
	imgLevel4 ACL_Image <>
	imgLevel5 ACL_Image <>
	
	soundMain  ACL_Sound ?
	soundLevel ACL_Sound ?	
	soundGame  ACL_Sound ?
	win_music  ACL_Sound ?
	lose_music ACL_Sound ?
  
	i dword 0
	j dword 0
	x11 dword 0
	x22 dword 0
	y11 dword 0
	y22	dword 0

	timer_info DB 'timer, current i_m: %d', 0Ah, 0
	block_info DB 'EX=%d', 0Ah,0

	not_init DD 1
	control_ctrl DD 0
	
.CODE

drawmain proc C
;参数：无
;绘制开始界面，播放音乐
	;载入图片
	invoke loadImage, offset main_background, offset imgBackground
	invoke loadImage, offset main_title, offset imgTitle
	invoke loadImage, offset main_start, offset imgStart
	invoke loadImage, offset main_load,  offset imgLoad
	;显示主界面 ;坐标点(向下，向右)
	invoke beginPaint
		invoke putImageScale, offset imgBackground, 0, 0, VIEW_BG_WIDTH, VIEW_BG_HIGH
		;invoke putImageScale, offset imgTitle, TITLE_CENTER_X-VIEW_TITLE_WIDTH/2, TITLE_CENTER_Y-VIEW_TITLE_HIGH/2,VIEW_TITLE_WIDTH, VIEW_TITLE_HIGH

	;	invoke putImageScale, offset imgStart, LOAD_CENTER_X-128/2,LOAD_CENTER_Y-128/4,128,128
	;	invoke putImageScale, offset imgLoad,  EXIT_CENTER_X-128/2,EXIT_CENTER_Y-128/4,128,128
		invoke putImageScale, offset imgLoad,  LOAD_CENTER_X-128/2,LOAD_CENTER_Y-128/4,128,64
	invoke endPaint
	;载入音乐
	;invoke loadSound, offset main_music, offset soundMain
	;播放音乐
	;invoke playSound,  soundMain,  0;第二个参数非0，循环播放；为0只播放1遍

	ret 
drawmain endp


drawlevel proc C
;参数：无
;绘制选关界面，播放音乐
	invoke loadImage, offset levelselect_bg, offset imgLevelSelectBg
	invoke loadImage, offset level1, offset imgLevel1
	invoke loadImage, offset level2, offset imgLevel2
	invoke loadImage, offset level3, offset imgLevel3
	invoke loadImage, offset level4, offset imgLevel4	
	invoke loadImage, offset level5, offset imgLevel5

	invoke beginPaint
	invoke putImageScale, offset imgLevelSelectBg, 0, 0, 128*7, 128*4
	invoke putImageScale, offset imgLevel1, LEVEL1_CENTER_X-VIEW_LEVEL_SLT_WIDTH/2,LEVEL1_CENTER_Y-VIEW_LEVEL_SLT_HIGH/2,VIEW_LEVEL_SLT_WIDTH,VIEW_LEVEL_SLT_HIGH
	invoke putImageScale, offset imgLevel2, LEVEL2_CENTER_X-VIEW_LEVEL_SLT_WIDTH/2,LEVEL2_CENTER_Y-VIEW_LEVEL_SLT_HIGH/2,VIEW_LEVEL_SLT_WIDTH,VIEW_LEVEL_SLT_HIGH
	invoke putImageScale, offset imgLevel3, LEVEL3_CENTER_X-VIEW_LEVEL_SLT_WIDTH/2,LEVEL3_CENTER_Y-VIEW_LEVEL_SLT_HIGH/2,VIEW_LEVEL_SLT_WIDTH,VIEW_LEVEL_SLT_HIGH
	invoke putImageScale, offset imgLevel4, LEVEL4_CENTER_X-VIEW_LEVEL_SLT_WIDTH/2,LEVEL4_CENTER_Y-VIEW_LEVEL_SLT_HIGH/2,VIEW_LEVEL_SLT_WIDTH,VIEW_LEVEL_SLT_HIGH
	invoke putImageScale, offset imgLevel5, LEVEL5_CENTER_X-VIEW_LEVEL_SLT_WIDTH/2,LEVEL5_CENTER_Y-VIEW_LEVEL_SLT_HIGH/2,VIEW_LEVEL_SLT_WIDTH,VIEW_LEVEL_SLT_HIGH
	invoke endPaint
	;停止音乐	
	invoke stopSound, offset soundMain	
	;载入音乐
	invoke loadSound, offset level_music, offset soundLevel
	;播放音乐
	invoke playSound, offset soundLevel, 1;第二个参数非0，循环播放；为0只播放1遍

	ret 
drawlevel endp

drawblock proc C
;参数：无
;根据全局变量nowmap绘制具体游戏内容
; game_clt下
;	floor      地板矩阵
;	lava       熔浆矩阵
;	of_pos     小人位置
;	out_pos    出口位置
;	ctrl_left  剩余CTRL次数	
	local x1,y1,cycles:DWORD

	;绘制地板
	mov ebx, 0
         	
	
	.WHILE ebx < 10
		push ebx
		mov ecx, 0   
		.WHILE ecx < 10
			pop ebx
			push ebx
			push ecx
			mov i, ecx
			mov j, ebx
			;ebx=i从0到9，ecx=j从0到9			
			
;			push ebx
;			push ecx
			lea esi, game_clt.floor
			invoke getIndex, esi, ebx, ecx;eax = 坐标j,i的地板状态值		
;			pop  ecx
;			pop  ebx
			
			
			.if eax == 1
				
				;x1 = PLAY_AREA_CENTER_X - VIEW_IN_GAME_WIDTH * 5 + ebx*VIEW_IN_GAME_WIDTH, \
				;y1 = PLAY_AREA_CENTER_Y - VIEW_IN_GAME_HIGH  * 5  + ecx*VIEW_IN_GAME_HIGH, \
				;人物位置y(i)的值产生加载位置x坐标
				mov x1, PLAY_AREA_CENTER_X - VIEW_IN_GAME_WIDTH * 5
				mov eax, VIEW_IN_GAME_WIDTH
				xor edx, edx
				mul i
				add x1, eax

				mov y1, PLAY_AREA_CENTER_Y - VIEW_IN_GAME_HIGH * 5
				mov eax, VIEW_IN_GAME_HIGH
				xor edx, edx
				mul j
				add y1, eax

				invoke beginPaint
				invoke putImageScale, offset imgGameFloor, x1,y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
				invoke endPaint

			.endif

			pop ecx
			inc ecx
		.ENDW

		pop ebx
	inc ebx
	.ENDW
	
	;绘制岩浆
	mov ebx, 0

;	invoke putImageScale, offset imgGameLava,\
;					PLAY_AREA_CENTER_X - VIEW_IN_GAME_WIDTH * 5 + i*VIEW_IN_GAME_WIDTH, \
;					PLAY_AREA_CENTER_Y - VIEW_IN_GAME_HIGH * 5 + j*VIEW_IN_GAME_HIGH,   \
;					PLAY_AREA_CENTER_X - VIEW_IN_GAME_WIDTH * 5 + (i+1)*VIEW_IN_GAME_WIDTH, \
;					PLAY_AREA_CENTER_Y - VIEW_IN_GAME_HIGH * 5 +  (j+1)*VIEW_IN_GAME_HIGH
	.WHILE ebx < 10
		push ebx
		mov ecx, 0 
		.WHILE ecx < 10
			pop ebx
			push ebx
			push ecx
			mov i, ecx
			mov j, ebx
			;ebx=i从0到9，ecx=j从0到9			
			
;			push ebx
;			push ecx
			lea esi, game_clt.lava
			invoke getIndex, esi, ebx, ecx;eax = 坐标i,j的地板状态值		
;			pop  ecx
;			pop  ebx

			
			
			.if eax == 1
				
				;x1 = PLAY_AREA_CENTER_X - VIEW_IN_GAME_WIDTH * 5 + ebx*VIEW_IN_GAME_WIDTH, \
				;y1 = PLAY_AREA_CENTER_Y - VIEW_IN_GAME_HIGH  * 5  + ecx*VIEW_IN_GAME_HIGH, \
				
				mov x1, PLAY_AREA_CENTER_X - VIEW_IN_GAME_WIDTH * 5
				mov eax, VIEW_IN_GAME_WIDTH
				xor edx, edx
				mul i
				add x1, eax

				mov y1, PLAY_AREA_CENTER_Y - VIEW_IN_GAME_HIGH * 5
				mov eax, VIEW_IN_GAME_HIGH
				xor edx, edx
				mul j
				add y1, eax

				invoke beginPaint
				invoke putImageScale, offset imgGameLava, x1,y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
				invoke endPaint

			.endif

			pop ecx
			inc ecx
		.ENDW

		pop ebx
	inc ebx
	.ENDW


		

	;绘制人物
	;x = game_clt.of_pos.x ; y = game_clt.of_pos.y
	;x1 
	;PLAY_AREA_CENTER_X,PLAY_AREA_CENTER_Y
	;
	mov ecx, PLAY_AREA_CENTER_X
	mov ebx, PLAY_AREA_CENTER_Y
	sub ecx, 5 * VIEW_IN_GAME_WIDTH
	sub ebx, 5 * VIEW_IN_GAME_HIGH

	mov eax, VIEW_IN_GAME_WIDTH
	xor edx, edx
	mul game_clt.of_pos.y
	mov edx, ecx
	add edx, eax
	mov x1, edx

	mov eax, VIEW_IN_GAME_HIGH
	xor edx, edx
	mul game_clt.of_pos.x
	mov edx, ebx
	add edx, eax
	mov y1, edx

	invoke beginPaint

	lea esi, game_clt.floor
	invoke getIndex, esi, game_clt.of_pos.x,  game_clt.of_pos.y        ;eax = 坐标i,j的地板状态值
	.if eax == 1	
		.if game_clt.of_state == 25H     ;左
			invoke putImageScale, offset imgGamePeopleZ, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
		.elseif game_clt.of_state == 26H ;上 
			invoke putImageScale, offset imgGamePeopleS, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
		.elseif game_clt.of_state == 27H ;右
			invoke putImageScale, offset imgGamePeopleY, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
		.elseif game_clt.of_state == 28H ;下
			invoke putImageScale, offset imgGamePeopleX, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
		.endif
	.elseif eax == 0
		.if game_clt.of_state == 25H     ;左
			invoke putImageScale, offset imgGamePeopleZ_x, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
		.elseif game_clt.of_state == 26H ;上 
			invoke putImageScale, offset imgGamePeopleS_x, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
		.elseif game_clt.of_state == 27H ;右
			invoke putImageScale, offset imgGamePeopleY_x, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
		.elseif game_clt.of_state == 28H ;下
			invoke putImageScale, offset imgGamePeopleX_x, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
		.endif	
	.endif
	

	invoke endPaint

	;绘制出口	
	mov ecx, PLAY_AREA_CENTER_X
	mov ebx, PLAY_AREA_CENTER_Y
	sub ecx, 5 * VIEW_IN_GAME_WIDTH
	sub ebx, 5 * VIEW_IN_GAME_HIGH

	mov eax, VIEW_IN_GAME_WIDTH
	xor edx, edx
	mul game_clt.out_pos.y
	mov edx, ecx
	add edx, eax
	mov x1, edx

	mov eax, VIEW_IN_GAME_HIGH
	xor edx, edx
	mul game_clt.out_pos.x
	mov edx, ebx
	add edx, eax
	mov y1, edx


	invoke beginPaint
	lea esi, game_clt.floor
	invoke getIndex, esi, game_clt.out_pos.x,  game_clt.out_pos.y        ;eax = 坐标i,j的地板状态值
	
	.if eax == 1
		invoke putImageScale, offset imgGameOut,  x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
	.elseif eax == 0
		invoke putImageScale, offset imgGameOutX, x1, y1,VIEW_IN_GAME_WIDTH,VIEW_IN_GAME_HIGH
	.endif
	invoke endPaint

	;绘制CTRL次数
	;ctrl_left  剩余CTRL次数	
	mov ebx, game_clt.ctrl_left
	.WHILE ebx > 0
		push ebx
		mov eax, 32
		xor edx, edx
		mov ecx, ebx
		dec ecx
		mul ecx
		mov ebx, CTRL_CENTER_Y
		sub ebx, 32 / 2
		sub ebx, eax
		mov eax, ebx
		add eax, 32
;		invoke putImageScale, offset imgGameOut,\ 
;			CTRL_CENTER_Y - 32/2 - (ebx-1) * 32,  CTRL_CENTER_X - 48/2, \
;			CTRL_CENTER_Y + 32/2 - (ebx-1) * 32, CTRL_CENTER_X + 48/2
		invoke beginPaint
		invoke putImageScale, offset imgGameCtrl, CTRL_CENTER_X - 48/2, ebx, 48,32
		invoke endPaint
		pop ebx
		dec ebx 
	.ENDW		

	;绘制固定的C/V字母
	invoke beginPaint
		invoke putImageScale, offset imgGameC, 128*3+128/4,128*3, 32,32
		invoke putImageScale, offset imgGameV, 128*3+128/2,128*3, 32,32
	invoke endPaint 
	
	;绘制上下左右
	invoke beginPaint
		invoke putImageScale, offset imgGameS, 128*6-16,128*3   , 32,32		
		invoke putImageScale, offset imgGameX, 128*6-16,128*3+32, 32,32	
		invoke putImageScale, offset imgGameZ, 128*6-48,128*3+32, 32,32	
		invoke putImageScale, offset imgGameY, 128*6+16,128*3+32, 32,32	
	invoke endPaint


	invoke drawBoundary
	ret
drawblock endp

drawgame proc C
;参数：无
;绘制游戏界面（不包含方块内容），播放音乐
	invoke loadImage, offset gamebg, offset imgGamebg
	invoke beginPaint
	invoke putImageScale, offset imgGamebg, 0,0,VIEW_BG_WIDTH,VIEW_BG_HIGH
	invoke endPaint
	;停止音乐	
	invoke stopSound, offset soundLevel
	;载入音乐
	invoke loadSound, offset game_music, offset soundGame
	;播放音乐
	invoke playSound, offset soundGame, 1;第二个参数非0，循环播放；为0只播放1遍	
	ret
drawgame endp


drawgameinit proc C id:dword
;参数：id
;将第id关的初始信息加载到全局变量中，最后调用drawblock函数

	.if id == 1
		invoke initControl, offset game_clt, offset file_txt1
	.elseif id == 2
		invoke initControl, offset game_clt, offset file_txt2
	.elseif id == 3
		invoke initControl, offset game_clt, offset file_txt3
	.elseif id == 4
		invoke initControl, offset game_clt, offset file_txt4
	.elseif id == 5
		invoke initControl, offset game_clt, offset file_txt5
	.endif
	
	invoke debugControl, offset game_clt

;	invoke drawblock
	ret 
drawgameinit endp


draw proc C id:dword
;参数：id 当前游戏界面编号
;通过判断id调用具体的绘制函数
	mov ebx,i_m
	;选择生成的窗口
	.if control_ctrl == 1
		;画最终胜利图
		
		invoke beginPaint
		invoke putImageScale, offset imgWin, 0,0,128*7, 128*4
		invoke endPaint

	.elseif ebx==0
		invoke drawmain 
	.elseif ebx==1
		invoke drawlevel
	.elseif ebx==2
		.IF game_clt.win != 1 && game_clt.on_lava != 1
			invoke drawgame
			.IF not_init == 1
				mov not_init, 0
				invoke drawgameinit, level
			.ENDIF
			invoke drawblock
		.ELSEIF game_clt.win == 1 

			;win music胜利音效
			;载入音乐
			invoke loadSound, offset win_music_path, offset win_music
			;播放音乐
			invoke playSound,  win_music,  0;第二个参数非0，循环播放；为0只播放1遍

			mov game_clt.win, 0
			mov not_init, 1
			mov game_clt.on_lava, 0
			.IF level == 5
				mov control_ctrl, 1
			.ELSE
				inc level
			.ENDIF 
		.ELSEIF game_clt.on_lava == 1
			;lose music失败音效
			;载入音乐
			invoke loadSound, offset lose_music_path, offset lose_music
			;播放音乐
			invoke playSound,  lose_music,  0;第二个参数非0，循环播放；为0只播放1遍

			mov game_clt.win, 0
			mov not_init, 1
			mov game_clt.on_lava, 0
		.ENDIF
	.endif
	ret 
draw endp


timer proc C id:dword
	invoke draw ,id
	ret 
timer endp

End