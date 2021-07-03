.386
.model flat, stdcall
option casemap:none

include datastruct.inc
include inc\acllib.inc

public i_m
public game_clt
public main_buttons
public select_buttons
public play_buttons
public level

public	gamebg 
public	game_floor  
public	game_lava   
public	game_peoples 
public	game_peoplex 
public	game_peoplez 
public	game_peopley 
public	game_peoples_xukong 
public	game_peoplex_xukong 
public	game_peoplez_xukong 
public	game_peopley_xukong 
public	game_out            
public	game_out_xukong     	
public	game_ctrl    
public	game_C      
public	game_V       
public	game_S		
public	game_X		 
public	game_Z		 
public	game_Y		

public	imgGamebg      
public	imgGameFloor   
public	imgGameLava    
public	imgGamePeopleS 
public	imgGamePeopleX 
public	imgGamePeopleZ 
public	imgGamePeopleY 
public	imgGameOut     
public	imgGameOutX    
public	imgGameCtrl    
public	imgGameC       
public	imgGameV       
public	imgGameS	   
public	imgGameX	  
public	imgGameZ	   
public	imgGameY	   
public	imgGamePeopleS_x	   
public	imgGamePeopleX_x	   
public	imgGamePeopleZ_x       
public	imgGamePeopleY_x	 

public imgWin 
public win_path 

.data


;界面模式
i_m DD ?
;游戏区控制结构体
game_clt control <>
;界面绘制元素状态控制结构
main_buttons main_btns <>
select_buttons select_btns <>
play_buttons play_btns <>
level DD ?

	gamebg byte ".\view\gamebg.bmp",0
	game_floor  byte ".\view\game_floor.bmp",0	
	game_lava   byte ".\view\game_lava.bmp",0	
	game_peoples byte ".\view\game_peoples.bmp",0
	game_peoplex byte ".\view\game_peoplex.bmp",0
	game_peoplez byte ".\view\game_peoplez.bmp",0
	game_peopley byte ".\view\game_peopley.bmp",0
	game_peoples_xukong byte ".\view\game_peoples_xukong.bmp",0
	game_peoplex_xukong byte ".\view\game_peoplex_xukong.bmp",0
	game_peoplez_xukong byte ".\view\game_peoplez_xukong.bmp",0
	game_peopley_xukong byte ".\view\game_peopley_xukong.bmp",0
	game_out            byte ".\view\game_out.bmp",0	
	game_out_xukong     byte ".\view\game_out_xukong.bmp",0	
	game_ctrl    byte ".\view\game_ctrl.bmp",0
	game_C       byte ".\view\game_C.bmp",0
	game_V       byte ".\view\game_V.bmp",0
	game_S		 byte ".\view\game_S.bmp",0
	game_X		 byte ".\view\game_X.bmp",0
	game_Z		 byte ".\view\game_Z.bmp",0
	game_Y		 byte ".\view\game_Y.bmp",0
	imgGamebg      ACL_Image <>
	imgGameFloor   ACL_Image <>
	imgGameLava    ACL_Image <>
	imgGamePeopleS ACL_Image <>
	imgGamePeopleX ACL_Image <>
	imgGamePeopleZ ACL_Image <>
	imgGamePeopleY ACL_Image <>
	imgGameOut     ACL_Image <>
	imgGameOutX    ACL_Image <>
	imgGameCtrl    ACL_Image <>
	imgGameC       ACL_Image <>
	imgGameV       ACL_Image <>
	imgGameS	   ACL_Image <>
	imgGameX	   ACL_Image <>
	imgGameZ	   ACL_Image <>
	imgGameY	   ACL_Image <>
	imgGamePeopleS_x	   ACL_Image <>
	imgGamePeopleX_x	   ACL_Image <>
	imgGamePeopleZ_x       ACL_Image <>
	imgGamePeopleY_x	   ACL_Image <>
imgWin		   ACL_Image <>
win_path    byte ".\view\win_path.bmp",0   

end