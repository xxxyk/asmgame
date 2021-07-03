.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include inc\acllib.inc
include inc\kbcontrol.inc
include mscontrol.inc
include globalvariable.inc

public drawBoundary


.code 
	
	drawBoundary PROC stdcall
		local z_x, z_y:DWORD 
		local x1, y1, x2, y2:DWORD 

		

		;计算两个坐标点
		mov z_x, PLAY_AREA_CENTER_X - 5 * VIEW_IN_GAME_WIDTH
		mov z_y, PLAY_AREA_CENTER_Y - 5 * VIEW_IN_GAME_HIGH

		.IF i_m == IM_PLAY \
			&& game_clt.select_lt.x >= 0 && game_clt.select_lt.x <= 9 \
			&& game_clt.select_lt.y >= 0 && game_clt.select_lt.y <= 9 \
			&& game_clt.select_rb.x >= 0 && game_clt.select_rb.x <= 9 \
			&& game_clt.select_rb.y >= 0 && game_clt.select_rb.y <= 9 

			;如果选中区域合法那么开始画边框
			;此时的game_clt.select_lt.x是纵向的，也就是和z_y运算，得到y1
			mov eax, game_clt.select_lt.x
			xor edx, edx
			mov ebx, VIEW_IN_GAME_HIGH
			mul ebx
			add eax, z_y
			mov y1, eax

			mov eax, game_clt.select_lt.y
			xor edx, edx
			mov ebx, VIEW_IN_GAME_WIDTH
			mul ebx
			add eax, z_x
			mov x1, eax

			mov eax, game_clt.select_rb.x
			inc eax
			xor edx, edx
			mov ebx, VIEW_IN_GAME_HIGH
			mul ebx
			add eax, z_y
			mov y2, eax

			mov eax, game_clt.select_rb.y
			inc eax
			xor edx, edx
			mov ebx, VIEW_IN_GAME_WIDTH
			mul ebx
			add eax, z_x
			mov x2, eax

			invoke setPenColor, 0ffffffh
			invoke setPenWidth, 2
			invoke beginPaint
			;invoke putImageScale, offset useless_image, 0, 0, VIEW_BG_WIDTH, VIEW_BG_HIGH
			invoke line, x1, y1, x1, y2
			invoke line, x2, y1, x2, y2
			invoke line, x1, y1, x2, y1
			invoke line, x1, y2, x2, y2
			invoke endPaint



		.ENDIF 
		ret

	drawBoundary endp
	
end 