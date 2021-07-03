IFNDEF _dsinc_
_dsinc_ equ <1>

include constant.inc

array STRUCT
	ALIGN 	DWORD
	data 	DWORD 	array_rows * array_cols 	dup(?)
array ENDS

point STRUCT
	ALIGN 	DWORD
	x 		DWORD 	?
	ALIGN 	DWORD
	y 		DWORD 	?
point ENDS

control STRUCT
	ALIGN 		DWORD	
	floor 		array 	<>
	ALIGN 		DWORD
	lava 		array 	<>
	ALIGN 		DWORD
	of_pos 		point 	<>
	ALIGN 		DWORD
	out_pos	 	point 	<>
	ALIGN 		DWORD
	of_state 	DWORD 	?
	ALIGN 		DWORD
	select_lt 	point	<>
	ALIGN		DWORD
	select_rb	point	<>
	ALIGN 		DWORD
	copied_lt 	point	<>
	ALIGN		DWORD
	copied_rb	point	<>
	ALIGN		DWORD
	ctrl_left	DWORD	?
	ALIGN		DWORD
	win			DWORD	0
	ALIGN		DWORD
	on_lava		DWORD	0

control ENDS

main_btns STRUCT
	ALIGN DWORD 
	load_state	DWORD	BTN_RELEASE
	ALIGN DWORD 
	exit_state	DWORD	BTN_RELEASE
main_btns ENDS

select_btns STRUCT
	ALIGN DWORD 
	leave_1	DWORD	BTN_RELEASE
	ALIGN DWORD 
	leave_2	DWORD	BTN_RELEASE
	ALIGN DWORD 
	leave_3	DWORD	BTN_RELEASE
	ALIGN DWORD 
	leave_4	DWORD	BTN_RELEASE
	ALIGN DWORD 
	leave_5	DWORD	BTN_RELEASE
select_btns ENDS

play_btns STRUCT
	ALIGN DWORD 
	ctrl	DWORD	BTN_RELEASE
	ALIGN DWORD 
	key_c	DWORD	BTN_RELEASE
	ALIGN DWORD 
	key_v	DWORD	BTN_RELEASE
	ALIGN DWORD 
	key_down DWORD	BTN_RELEASE
	ALIGN DWORD 
	key_up DWORD	BTN_RELEASE
	ALIGN DWORD 
	key_left DWORD	BTN_RELEASE
	ALIGN DWORD 
	key_right DWORD	BTN_RELEASE
play_btns ENDS 


getIndex PROTO stdcall arr:PTR array, i:DWORD, j:DWORD
setIndex PROTO stdcall arr:PTR array, i:DWORD, j:DWORD, value:DWORD
initControl PROTO stdcall ctl_ptr:ptr control, file:ptr byte
debugControl PROTO stdcall ctl_ptr:ptr control

ENDIF
