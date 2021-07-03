.386
.model flat, stdcall
option casemap:none

include datastruct.inc
includelib msvcrt.lib
include constant.inc

scanf PROTO C :ptr sbyte , :VARARG
printf PROTO C :ptr sbyte , :VARARG
fopen PROTO C :ptr sbyte , :ptr sbyte
fclose PROTO C :ptr FILE
fread PROTO C ,
	:ptr VOID,		;内存指针
	:sdword ,		;数据块大小
	:sdword ,		;读几次
	:ptr FILE		;文件指针
fwrite PROTO C ,
	:ptr VOID, 
	:sdword , 
	:sdword , 
	:ptr FILE		;参数意义同fread
fseek PROTO C ,
	:ptr FILE ,		;文件指针
	:sdword ,		;偏移多少
	:dword			;从哪开始偏移
ftell PROTO C ,
	:ptr			;文件指针
clock PROTO C 
fscanf PROTO C,
	:ptr FILE , 
	:ptr sbyte, 
	:VARARG


public getIndex
public setIndex
public initControl
public debugControl

.data

ds_open_mode_read DB 'r', 0
ds_read_format_array DB '%d', 0
ds_read_format_point DB '%d %d', 0
ds_array_cols DD array_cols
ds_array_rows DD array_rows
ds_debug_format_array DB '%d ', 0
ds_debug_format_enter DB 0Ah, 0
ds_debug_format_point DB '%d %d', 0Ah, 0
ds_debug_foramt_clt DB '%d', 0Ah, 0
.code

	getIndex PROC stdcall arr:PTR array, i:DWORD, j:DWORD
		mov esi, arr
		lea esi, (array PTR[esi]).data
		mov eax, i
		mul ds_array_cols
		mov ebx, eax
		add ebx, j
		mov eax, [esi][ebx*4]
	
		ret 12
	getIndex ENDP

	setIndex PROC stdcall arr:PTR array, i:DWORD, j:DWORD, value:DWORD
		mov esi, arr
		lea esi, (array PTR[esi]).data
		mov eax, i
		mul ds_array_cols
		mov ebx, eax
		add ebx, j
		mov eax, value
		mov [esi][ebx*4], eax
	
		ret 16
	setIndex ENDP 

	initControl PROC stdcall ctl_ptr:ptr control, file:ptr byte
		local file_ptr:ptr FILE
		local i, j:DWORD
		local temp:DWORD

		mov esi, ctl_ptr
		mov (control PTR[esi]).of_state, DOWN
	
		invoke fopen, file, offset ds_open_mode_read
		mov file_ptr, eax

		mov esi, ctl_ptr
		lea esi, (control PTR[esi]).floor
		;先输入地板矩阵
		mov i, 0
	initControl_loop_rows_floor:
		cmp i, array_rows	;array_rows是一个立即数
		jge initControl_loop_rows_floor_out
		mov j, 0
		initControl_loop_cols_floor:
			cmp j, array_cols
			jge initControl_loop_cols_floor_out
			push esi
			invoke fscanf, file_ptr, offset ds_read_format_array, addr temp
			pop esi
			push esi
			invoke setIndex, esi, i, j, temp
			pop esi
			add j, 1
			jmp initControl_loop_cols_floor
		initControl_loop_cols_floor_out:
		add i, 1
		jmp initControl_loop_rows_floor
	initControl_loop_rows_floor_out:

		mov esi, ctl_ptr
		lea esi, (control PTR[esi]).of_pos
		lea eax, (point PTR[esi]).x
		lea ebx, (point PTR[esi]).y
		invoke  fscanf, file_ptr, offset ds_read_format_point, eax, ebx

		mov esi, ctl_ptr
		lea esi, (control PTR[esi]).out_pos
		lea eax, (point PTR[esi]).x
		lea ebx, (point PTR[esi]).y
		invoke fscanf, file_ptr, offset ds_read_format_point, eax, ebx

		mov esi, ctl_ptr
		lea esi, (control PTR[esi]).lava
		;输入岩浆矩阵
		mov i, 0
	initControl_loop_rows_lava:
		cmp i, array_rows	;array_rows是一个立即数
		jge initControl_loop_rows_lava_out
		mov j, 0
		initControl_loop_cols_lava:
			cmp j, array_cols
			jge initControl_loop_cols_lava_out
			push esi
			invoke fscanf, file_ptr, offset ds_read_format_array, addr temp
			pop esi
			push esi
			invoke setIndex, esi, i, j, temp
			pop esi
			add j, 1
			jmp initControl_loop_cols_lava
		initControl_loop_cols_lava_out:
		add i, 1
		jmp initControl_loop_rows_lava
	initControl_loop_rows_lava_out:

	mov esi, ctl_ptr
	lea esi, (control PTR[esi]).ctrl_left
	invoke fscanf, file_ptr, offset ds_read_format_array, esi

	invoke fclose, file_ptr 
	mov eax, 0
	ret 8
	initControl ENDP

	debugControl PROC stdcall ctl_ptr:ptr control
		local i, j:DWORD
		local temp:DWORD

		mov esi, ctl_ptr
		lea esi, (control PTR[esi]).floor
		;先输出地板矩阵
		mov i, 0
	debugControl_loop_rows_floor:
		cmp i, array_rows	;array_rows是一个立即数
		jge debugControl_loop_rows_floor_out
		mov j, 0
		debugControl_loop_cols_floor:
			cmp j, array_cols
			jge debugControl_loop_cols_floor_out
			push esi
			invoke getIndex, esi, i, j
			invoke printf, offset ds_debug_format_array, eax
			pop esi 
			add j, 1
			jmp debugControl_loop_cols_floor
		debugControl_loop_cols_floor_out:
		push esi
		invoke printf, offset ds_debug_format_enter
		pop esi 
		add i, 1
		jmp debugControl_loop_rows_floor
	debugControl_loop_rows_floor_out:

		mov esi, ctl_ptr
		lea esi, (control PTR[esi]).of_pos
		invoke  printf, offset ds_debug_format_point, (point PTR[esi]).x, (point PTR[esi]).y

		mov esi, ctl_ptr
		lea esi, (control PTR[esi]).out_pos
		invoke  printf, offset ds_debug_format_point, (point PTR[esi]).x, (point PTR[esi]).y

		mov esi, ctl_ptr
		lea esi, (control PTR[esi]).lava
		;输出岩浆矩阵
		mov i, 0
	debugControl_loop_rows_lava:
		cmp i, array_rows	;array_rows是一个立即数
		jge debugControl_loop_rows_lava_out
		mov j, 0
		debugControl_loop_cols_lava:
			cmp j, array_cols
			jge debugControl_loop_cols_lava_out
			push esi
			invoke getIndex, esi, i, j
			invoke printf, offset ds_debug_format_array, eax
			pop esi 
			add j, 1
			jmp debugControl_loop_cols_lava
		debugControl_loop_cols_lava_out:
		push esi
		invoke printf, offset ds_debug_format_enter
		pop esi 
		add i, 1
		jmp debugControl_loop_rows_lava
	debugControl_loop_rows_lava_out:

	mov esi, ctl_ptr
	mov eax, (control PTR[esi]).ctrl_left
	invoke  printf, offset ds_debug_foramt_clt, eax

	mov eax, 0
	ret 4
	debugControl ENDP

end
