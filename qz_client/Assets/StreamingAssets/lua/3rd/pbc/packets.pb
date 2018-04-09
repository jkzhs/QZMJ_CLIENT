
†
packets.protoproto"#
Packet
cmd (
body ("%
CSC_SysHeartBeat
	timestamp ("$
CS_Login
uid (
acc (	"!
SC_OFFLINE_NOTIFY
code ("µ
_basic_data
lineid (
serverid (
playerid (
name (	
level (
RMB (
money (
vip (
	login_day	 (
headid
 (

charge_sum (
day_charge_sum (
rmb2money_count (
rmb2money_count_max (
gender (

createTime (
charge_rmb_sum (
day_lottery_count (
day_ten_lottery_count (
daili (

headimgurl (	
ticket (")
__SYSTEM_INFO

id (
open ("a
SC_Login
errcode (!
basic (2.proto._basic_data
	timestamp (
param1 (	"9

CS_AskInfo
type (
param (
param1 ("
CS_CREATE_ROLE
lineid (
serverid (
userid (
gender (
heaid (
name (	
headid ("4
SC_CREATE_ROLE

error_code (
param1 (".

CS_Command
content (	
errcode ("l
CS_CHAT
ch_id (
to_playerid (
to_name (	
msg (	
msgtype (
param1 ("™
SC_CHAT

error_code (
ch_id (
from_playerid (
	from_name (	
msg (	
showtype (
count (
from_headid (	";
SC_MSG

error_code (
msg (	
showtype ("š
SC_UpdateKeys
hero_dataId (+
kvs (2.proto.SC_UpdateKeys.key_valueG
	key_value
key (	
value (
param1 (
fvalue ("P
missioninfo

id (
	is_finish (
cur_num (
	is_reward ("~
SC_MissionList
sendtype ('
achievement (2.proto.missioninfo
day (2.proto.missioninfo
activity ("&
CS_MissionOP

op (

id ("3
SC_MissionOP
ret (

op (

id ("B
SC_FlushMission
sendtype (
m (2.proto.missioninfo"²
_activityinfo

id (
	is_finish (
accept_time (
task_end_time (

close_time (
event_cur_num (
sub_activity (
activity_time ("I
SC_ACTIVITYLIST

error_code ("
list (2.proto._activityinfo"6
CS_ACTIVITYOP

op (

id (
subid ("#
SC_ACTIVITYOP

error_code ("Z
SC_FLUSHACTIVITY

error_code (
del_id ("
info (2.proto._activityinfo"¯
mailinfo
sno (
	mail_type (
sender (	
sendtime (
title (	
content (	
money (
RMB (-

attachment	 (2.proto.mailinfo.itemsinfo
timeout
 (
state (
name (	
reason (
playerid (&
	itemsinfo

id (
count ("Z

SC_MailRet
type (!
maillist (2.proto.mailinfo
param (
list ("j
SC_TavernInfo&
info (2.proto.SC_TavernInfo._ti1
_ti
ftimes (
time (
type (",

CS_Lottery
type (
use_free ("…
SC_Lottery_result
result (+
prize (2.proto.SC_Lottery_result._lt3
_lt
type (
param1 (
param2 ("&
CS_Sell
itemid (
num ("
SC_Sell
result ("3
CS_Buy
type (
itemid (
num ("6
SC_Buy
result (
itemid (
type ("€
productinfo

id (
is_sale (
itemid (
num (
	needlevel (
	moneytype (
	baseprice ("d
shopinfo
type (
	flush_num (
	next_time ($
products (2.proto.productinfo"L
SC_StoreList
result (
sendtype (
p (2.proto.shopinfo"!
CS_FlushStore
sendtype (">
SC_FlushStore
sendtype (

id (
is_sale ("!
CS_AskOnlineAward
type ("S
SC_AskOnlineAward

error_code (
type (

id (
end_time ("Œ
SC_SignInList
result (
month (2
products (2 .proto.SC_SignInList.productinfo
isget (
productinfo

id ("6
	SC_SignIn
result (

id (
isget ("
	CS_SignIn

id ("‚
SC_GuideList
result ('
steps (2.proto.SC_GuideList.step9
step
index (
complete (
subindex ("<
CS_Step
index (
complete (
subindex ("
SC_Step
result ("
SC_TIME_EVENT
time ("
SC_OPEN_SYSTEM

id ("=
CS_CHANGE_BASIC
type (
name (	
headid ("%
SC_CHANGE_BASIC

error_code ("Ÿ
__athletic_formation
index (
heroid (
	monsterid (
	herolevel (
	armslevel (
armsnum (
quality (
stars ("@
CS_ASK_ATHLETIC
type (
params (
params1 ("5
SC_ASK_ATHLETIC

error_code (
params ("“
SC_ATHLETIC_BASE

error_code (
rank (
win (
count (
maxcount (

cd ((
fms (2.proto.__athletic_formation
playerid (
query_times	 (
query_times_max
 (
	last_rank (
	buy_count (
reward_mark ("¢
SC_ATHLETIC_TOP.
tops (2 .proto.SC_ATHLETIC_TOP.__TOPINFO_
	__TOPINFO
rank (
playerid (
name (	
headid (
battle_value ("ß
SC_ATHLETIC_ENEMYS

error_code (5
enemys (2%.proto.SC_ATHLETIC_ENEMYS.__ENEMYINFO
count (o
__ENEMYINFO
rank (
playerid (
name (	
headid (
battle_value (
wins ("„
SC_ATHLETIC_REPORT>
reports (2-.proto.SC_ATHLETIC_REPORT._ATHLETIC_CHALLENGE­
_ATHLETIC_CHALLENGE
playerid (
name (	
battle_value (
headid (
	win_count (
rank (
iswin (
isattack (
rankup	 ("y
	SC_NOTIFY
type (
param1 (
param2 (
param3 (	
param4 (
param5 (
param6 (""
SC_EMPTY_MSG

error_code ("®
SC_NOTIFYCHARGERESP1
ord_list (2.proto.SC_NOTIFYCHARGERESP._ordd
_ord

error_code (
playerid (
create_time (
ord_dbid (	
diamond ("
CS_WITHDRAW
ord_dbid (	"q
SC_CHARGE_INFO1
info (2#.proto.SC_CHARGE_INFO.__charge_info,
__charge_info
index (
mark ("j
_REQ_ADD_FRIEND
from_id (
	from_name (	
level (
headid (
battle_value ("<
CS_FRIEND_OP
type (
playerid (
name (	".
SC_FRIEND_OP
errcode (
param ("M
SC_REQ_ADD_FRIEND
errcode ('
reqlist (2.proto._REQ_ADD_FRIEND"œ
SC_FRIEND_INFO
errcode (
isdel (
playerid (
player_name (	
level (
headid (
battle_value (
online ("F
SC_FRIEND_LIST
errcode (#
list (2.proto.SC_FRIEND_INFO"[
_leaderboard
rank (
score (
playerid (
name (	
headid ("?
CS_ASK_LEADERBOARD
type (
start (
stop ("u
SC_LEADERBOARD
errcode (
type (!
list (2.proto._leaderboard!
rank (2.proto._leaderboard"
CS_GET_CDKEY
key (	"
SC_GET_CDKEY
errcode ("M
CS_QUERY_INFO

op (
playerid (
param1 (
param2 ("?
SC_QUERY_INFO
param1 (	
param2 (
param3 ("h

CS_OP_ROOM
gameid (

op (
param1 (
param2 (
param3 (
param4 (	"I

SC_OP_ROOM
errcode (

op (
param1 (
param2 ("/
CS_ENTER_ROOM
gameid (
roomid (	"@
SC_ENTER_ROOM
errcode (
gameid (
roomid (	"4
SC_OP_ROOM_ACTION
op_type (
param1 (	".
CS_EXIT_ROOM
gameid (
param1 ("/
SC_EXIT_ROOM
errcode (
gameid ("
SC_HALL_LIST
errcode (
gameid (1
	hall_info (2.proto.SC_HALL_LIST._hall_info)

_hall_info
roomid (	
num ("0
CS_CREATE_ROOM
gameid (
param1 (	"A
SC_CREATE_ROOM
errcode (
gameid (
roomid (	"/
SC_BET
errcode (
chouma_index ("y
_invite_roomlist
gameid (
roomid (	
playerid (
player_name (	
param1 (
param2 (";
SC_INVITE_ROOMLIST%
list (2.proto._invite_roomlist"-
_12zhi_bet_info
pos (
money ("Û
SC_12ZHI_GETDATA
errcode (
game_status (
	over_time (7
history (2&.proto.SC_12ZHI_GETDATA._12zhi_history4
	bet_users (2!.proto.SC_12ZHI_GETDATA._bet_user
result_card (
house_owner_name (	
bout (
	play_type	 (
bout_amount
 (.
pos_amount_bet (2.proto._12zhi_bet_infoh
	_bet_user
player_name (	
playerid (
param1 (	
result_money (
param2 ( 
_12zhi_history
cardid ("8
CS_12ZHI_BET(
bet_list (2.proto._12zhi_bet_info"r
SC_12ZHI_BET
errcode ((
bet_list (2.proto._12zhi_bet_info
player_name (	

headimgurl (	"x
_twelve_record
time (
bout (
card (
coin (.
pos_amount_bet (2.proto._12zhi_bet_info"J
SC_TWELVE_RECORD
errcode (%
record (2.proto._twelve_record"ê

_play_user
player_name (	
playerid (
param1 (	
player_money (
seatid ($
	hand_list (2.proto._card_list#
out_list (2.proto._card_list$
	cphg_list (2.proto._cphg_list
param2	 ("r

_cphg_list
angang_list (2
.proto._id!
minggang_list (2
.proto._id 
pengchi_list (2
.proto._id";

_card_list
posid (
cardid (
param1 ("=
_flower_list
seatid (
posid (
cardid ("!
_id

id (
param1 ("Ÿ
_result_list%

play_users (2.proto._play_user
	hand_list (2
.proto._id
flower_list (2
.proto._id
angang_list (2
.proto._id!
minggang_list (2
.proto._id 
pengchi_list (2
.proto._id
	hu_cardid (
hu_type (
param1	 (
param2
 ("Ø
SC_MJ_GETDATA
errcode (
game_status (
	over_time (
	play_type (
cards_amount (%

play_users (2.proto._play_user
dices (2
.proto._id
goldid ((
flower_list	 (2.proto._flower_list$
	deal_list
 (2.proto._card_list$
	hand_list (2.proto._card_list'

add_flower (2.proto._flower_list
play_seatid (
draw_cardid (
can_hu (&
param1_list (2.proto._card_list&
param2_list (2.proto._card_list(
result_list (2.proto._result_list
result (
param1 (
param2 (
bet_coin ("h
SC_MJ_ENTER
errcode (%

play_users (2.proto._play_user
	play_type (
param1 ("p
SC_MJ_OUT_CARD
errcode (
seatid (
posid (
cardid (
param1 (
param2 ("‡

SC_MJ_CPHG
errcode (
play_seatid (
type (&
param1_list (2.proto._card_list
posid (
param1 ("Q
SC_MJ_ENTRUST
errcode (
seatid (
entrust (
param1 ("‡
SC_MJ_BROADCAST
errcode (
type (
param1 (
param2 (
param3 (%

play_users (2.proto._play_user"ž
SC_YAOLEZI_GETDATA
errcode (
game_status (
	over_time (;
history (2*.proto.SC_YAOLEZI_GETDATA._yaolezi_history6
	bet_users (2#.proto.SC_YAOLEZI_GETDATA._bet_user<
result_cards (2&.proto.SC_YAOLEZI_GETDATA._result_card
house_owner_name (	
bout (
	play_type	 (
bout_amount
 (>
shenzhi_bet_users (2#.proto.SC_YAOLEZI_GETDATA._bet_user=
get_bet_info (2'.proto.SC_YAOLEZI_GETDATA._get_bet_infoA
get_fangzhi_info (2'.proto.SC_YAOLEZI_GETDATA._get_bet_info?
get_nazhi_info (2'.proto.SC_YAOLEZI_GETDATA._get_bet_info
daobang (7

result_bet (2#.proto.SC_YAOLEZI_GETDATA._bet_userz
	_bet_user
player_name (	
playerid (
param1 (	
result_money (
param2 (
is_liuju ("
_yaolezi_history
cardid (
_result_card
cardid (?
_get_bet_info
posid (
money (
playerid ("/
_yaolezi_bet_info
pos (
money ("H
CS_YAOLEZI_BET*
bet_list (2.proto._yaolezi_bet_info

op ("”
SC_YAOLEZI_BET
errcode (*
bet_list (2.proto._yaolezi_bet_info
player_name (	

headimgurl (	

op (
playerid ("
SC_SHEN_ZHI
errcode ("K
SC_PUBLIC_SHEN_ZHI
coin (

headimgurl (	
player_name (	"æ
SC_NIU_GETDATA
errcode (
game_status (
	over_time (2
	bet_users (2.proto.SC_NIU_GETDATA._bet_userg
	_bet_user
player_name (	
playerid (
cards (	
result_money (
param1 (	"·
SC_ROOM_MEMBERS
errcode (0
members (2.proto.SC_ROOM_MEMBERS._membersa
_members
player_name (	
playerid (

headimgurl (	
RMB (
money ("
SC_NIUNIU_BET
errcode (
coin (
player_name (	
amount_money (

headimgurl (	
bet_type ("#
SC_OX_ROB_BANKER
errcode ("P
SC_OX_PUBLIC_ROB_BANKER
coin (

headimgurl (	
player_name (	"#
SC_OX_CARD_SHOW
playerid ("o
_paigow_bet_user
player_name (	
playerid (
param1 (	
result_money (
param2 ("1
_paigow_history
a_index (
cards (	"¸
SC_PAIGOW_GETDATA_ENTER
errcode (
game_status (
	over_time ('
history (2.proto._paigow_history*
	bet_users (2.proto._paigow_bet_user
result_card (
house_owner_name (	
bout (
bout_amount	 (
	play_type
 (*

areas_card (2.proto._paigow_history"†
SC_PAIGOW_GETDATA
errcode (
game_status (
	over_time ('
history (2.proto._paigow_history*
	bet_users (2.proto._paigow_bet_user
result_card (
house_owner_name (	
bout (
bout_amount	 (
	play_type
 ("'
	_bet_info
pos (
money ("
SC_PAIGOW_BET
errcode ("
bet_info (2.proto._bet_info
player_name (	

headimgurl (	
playerid ("&
SC_OP_PAIGOW_ACTION
op_type ("e
room_members
player_name (	
playerid (

headimgurl (	
RMB (
money (">
water_card_info
a_index (
card (
type ("†
account_playerid
add_odds (

extra_odds (%
cards (2.proto.water_card_info

odds_index (
	card_type ("
bemound
playerid ("ç
	open_card

open_order (
	comm_odds (
is_spec (
	card_type (
mound (2.proto.bemound(
account (2.proto.account_playerid
swat (
playerid (

extra_odds	 (

mound_odds
 ("Á
SC_WATER_GETDATA
errcode (
game_status (
	over_time (8
history (2'.proto.SC_WATER_GETDATA._paigow_history4
	bet_users (2!.proto.SC_WATER_GETDATA._bet_user
result_card (
house_owner_name (	
bout (
bout_amount	 (
	play_type
 (%
cards (2.proto.water_card_info
playerid ($
members (2.proto.room_members
	card_type (%
open_result (2.proto.open_card
param_id (
is_spec (%
bet_playerids (2.proto.bemound|
	_bet_user
player_name (	
playerid (
param1 (	
result_money (
param2 (

gain_money (>
_paigow_history
a_index (
card (
type ("|
SC_WATER_BET
errcode (
money (
player_name (	

headimgurl (	
playerid (
	own_money ("L
SC_WATER_ENTER_ROOM
errcode ($
members (2.proto.room_members"&
SC_WATER_EXIT_ROOM
playerid ("!
SC_WATER_TRIM
playerid ("%
SC_OP_WATER_ACTION
op_type ("Ñ
SC_WATERHALL_LIST
errcode (
gameid (7

hall_info1 (2#.proto.SC_WATERHALL_LIST._hall_info7

hall_info2 (2#.proto.SC_WATERHALL_LIST._hall_info)

_hall_info
roomid (	
num ("Ê
_dealer_members
dealerid (
level (
coin (
invite_code (
profit_rate (
parent (

all_profit (
today_profit (

dealer_num	 (
user_num
 ("1
_dealer_level_coin
level (
coin ("K
_dealer_date_bill
date (	(
coins (2.proto._dealer_level_coin"X
_dealer_bill
dealerid (
level ('
bills (2.proto._dealer_date_bill":
CS_OP_DEALER

op (
param1 (
param2 ("J
SC_DEALER_LIST
errcode ('
members (2.proto._dealer_members"H
SC_DEALER_ADD
errcode (&
member (2.proto._dealer_members"[
_dealer_user_members
playerid (
player_name (	
coin (
online ("P
SC_DEALER_USERS
errcode (,
members (2.proto._dealer_user_members"G
SC_DEALER_BILL
errcode ($
dealers (2.proto._dealer_bill"a
CS_ORDER_CREATE
paytype (
fee (

notify_url (	
param1 (	
name (	"@
SC_ORDER_CREATE
errcode (
url (	
paytype ("
CS_PAY_INFO
paytype ("?
SC_PAY_INFO
errcode (
userid (	
paytype (";
CS_Transfer
playerid (
coin (
type ("
SC_Transfer
errcode ("å
SC_TRANSFER_RECODE;
members (2*.proto.SC_TRANSFER_RECODE._transfer_recode‘
_transfer_recode
to_playerid (
	coin_type (
amount (
log_time (
to_name (	
role_id (
	role_name (	"1
SC_CommonParam1
param1 (	
param2 (