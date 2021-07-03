IFNDEF _gbvarinc_
_gbvarinc_ EQU <1>

include datastruct.inc
include inc\acllib.inc

extern i_m:DWORD
extern game_clt:control
extern main_buttons:main_btns 
extern select_buttons:select_btns 
extern play_buttons:play_btns 
extern level:DWORD

extern	gamebg :byte
extern	game_floor  :byte
extern	game_lava   :byte
extern	game_peoples :byte
extern	game_peoplex :byte
extern	game_peoplez :byte
extern	game_peopley :byte
extern	game_peoples_xukong :byte
extern	game_peoplex_xukong :byte
extern	game_peoplez_xukong :byte
extern	game_peopley_xukong :byte
extern	game_out            :byte
extern	game_out_xukong     	:byte
extern	game_ctrl    :byte
extern	game_C      :byte
extern	game_V       :byte
extern	game_S		:byte
extern	game_X		 :byte
extern	game_Z		 :byte
extern	game_Y		:byte

extern	imgGamebg      :ACL_Image
extern	imgGameFloor   :ACL_Image
extern	imgGameLava    :ACL_Image
extern	imgGamePeopleS :ACL_Image
extern	imgGamePeopleX :ACL_Image
extern	imgGamePeopleZ :ACL_Image
extern	imgGamePeopleY :ACL_Image
extern	imgGameOut     :ACL_Image
extern	imgGameOutX    :ACL_Image
extern	imgGameCtrl    :ACL_Image
extern	imgGameC       :ACL_Image
extern	imgGameV       :ACL_Image
extern	imgGameS	   :ACL_Image
extern	imgGameX	  :ACL_Image
extern	imgGameZ	   :ACL_Image
extern	imgGameY	   :ACL_Image
extern	imgGamePeopleS_x	   :ACL_Image
extern	imgGamePeopleX_x	   :ACL_Image
extern	imgGamePeopleZ_x       :ACL_Image
extern	imgGamePeopleY_x	:ACL_Image

extern imgWin	:ACL_Image 
extern win_path  :byte 

ENDIF 

