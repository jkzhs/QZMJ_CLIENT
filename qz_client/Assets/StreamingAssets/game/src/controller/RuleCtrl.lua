require "logic/ViewManager"
local global = require("global")
RuleCtrl = {};
local this = RuleCtrl;

--构建函数--
function this.New()
	return this;
end


function this.Awake(gameid)
	this._gameId = gameid
	panelMgr:CreatePanel('Rule', this.OnCreate);
end

--启动事件--
function this.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.beh= this.transform:GetComponent('LuaBehaviour');
	this.beh:AddClick(RulePanel.close, function ()
		RulePanel.clearView()
	end);
	this.render()
end

this._ruleVec = {}
this._niuniuStr = {"百人模式：需至少一人开始游戏。","下注阶段：所有玩家自行下注。",
		"发牌阶段：系统向玩家各发5张牌。",
		"比牌阶段：跟庄家比牌进行胜负判定。","结算阶段：输家向赢家支付积分=下注额*牌大小倍数。",
		"抢庄：玩家满足抢庄条件，可置闲家最高下注金额，设置最高下注者成为当局庄家。",
		"梭哈：输赢皆1倍",
		"倍数：炸弹(15倍)\n           顺子(13倍)\n           牛牛(10倍)\n           牛1~牛9(1~9倍)",
		"炸弹牛：比炸弹>比单张","顺子：比单张","牛牛：庄家赢",
		"有牛:跟庄家同样的点数，庄家赢","无牛：同样大小庄家赢",}
this._shierziStr = {"发布邀请玩家：开房间人有权利发布邀请，玩家看到发布邀请可随意进入",
		"申请庄家要有足够的钱币，方可做庄，在房间内闲家也可以申请做庄，一旦申请成功后排队上庄",
		"大厅模式：","1、申请庄家要有足够的钱币，方可做庄，在房间内闲家也可以申请做庄，一旦申请成功后排队上庄",
		"一天二开：","开奖时间：","14:00开一次","22:30开一次","在未开奖期间任意玩家可以随时随地进入押注",
		"玩法：","1、押一赔十，每次只开下面十二个字其中的一个：","[ff0000]帥、仕、相、俥、傌、佨、 [000000]將、士、象、車、馬、包",
		"2、顶割、下割、黑红押一赔0.916","（顶割为：帥仕相 將仕象   共六字)","（下割为：俥傌佨 車馬包   共六字）",
		"（黑为：將士象車馬包      共六字）","（红为：帥仕相俥傌佨      共六字）",}
this._paigowStr = {"发布邀请玩家：开房间人有权利发布邀请，玩家看到发布邀请可随意进入",
		"申请庄家要有足够的钱币，方可做庄，在房间内闲家也可以申请做庄，一旦申请成功后排队上庄",
		"下注赔率为1:1","头水：全挡输赢","后挡：八点以上输赢","牌的大小区分","1、比对子",
		"2、比点，同点数按排名，排名谁大谁赢","3、同排名庄家大",}
this._yaoleziStr = {"发布邀请玩家：开房间人有权利发布邀请，玩家看到发布邀请可随意进入",
		"申请庄家要有足够的钱币，方可做庄，在房间内闲家也可以申请做庄，一旦申请成功后排队上庄",
		"创建房间模式","1、开奖赔率：开一个赔一倍，开两个赔两倍，如开“帥”“帥”“帥”赔三倍；如开“帥”“帥”“包”押到帥赔两倍，押到包赔一倍",
		"2、可抢庄：谁的底分高谁抢庄谁做庄","3、任何人可放支可拿支","大厅模式","1、开奖赔率：开一个赔一倍，开两个赔两倍，如开“帥”“帥”“帥”赔三倍；如开“帥”“帥”“包”押到帥赔两倍，押到包赔一倍",
		"2、可抢庄：谁的底分高谁抢庄谁做庄"}
this._sanshuiStr = {
	"通比模式：","1.各家对各家牌面对比输赢",
                        "2.最少二人对比模式，最高八人",
                        "3.四人以上才有全垒打各加三注",
                        "4.所有注数最高不超过所限定的注数",
	"做庄模式：","1.一人做庄，闲家下注，后各闲家与庄家对比输赢",
                         "2.最少二人，最高八人",
                         "3.任何人都可抢庄，由分数最高的人优先做庄",
                         "4.牌面报道6注",
                         "5.所有注数最高不超过所限定的注数",}
this._mjStr = {
	"咱厝麻将-规则：","          1、庄家十七张，闲家十六张，胡牌十七张",
					"          2、如庄家胡牌连庄直到闲家胡牌才卸庄，轮到下一家做庄",
	"分数计算方式:","          1、暗杠为2水",
					"          2、明杠为1水",
					"          3、1个金为1水",
					"          4、4个乱花为1水",
					"          5、4个纯花为2水",
					"          6、庄家胡牌+10，平胡X1，自摸X2，游金X3（如胡牌时一个明杠一个金  对闲家的算账方式=2+10",
					"          7、闲家胡牌+5， 平胡X1，自摸X2，游金X3（如胡牌时一个明杠一个金  对闲家的算账方式=2+5",
					"          8、没有胡牌的庄家或闲家如牌面有暗杠、明杠、金、乱花、纯花之间可以互算，但对胡牌的那家不能互算",


}
function this.render()
	local Content = {}
	if this._gameId == global.const.GAME_ID_12ZHI then 
		Content = this._shierziStr
	elseif this._gameId == global.const.GAME_ID_NIUNIU then 
		Content = this._niuniuStr
	elseif this._gameId == global.const.GAME_ID_PAIGOW then
		Content = this._paigowStr
	elseif this._gameId == global.const.GAME_ID_YAOLEZI then
		Content = this._yaoleziStr
	elseif this._gameId == global.const.GAME_ID_WATER then 
		Content = this._sanshuiStr
	elseif this._gameId == global.const.GAME_ID_MJ then
		Content = this._mjStr
	end 
	local parent = RulePanel.rulelist.transform;
    local bundle = resMgr:LoadBundle("ruleBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"ruleBar");
    local startY = 222
    local height = 0
	local len = #Content;
	for i = 1, len do
		local data = Content[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "ruleBar"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0, startY - height, 0);
		resMgr:addAltas(go.transform,"Rule")
		local ruleTxt = go.transform:Find('ruleTxt').gameObject;
		ruleTxt.name = "ruleTxt" .. i
		local ruleTxt_UILabel = ruleTxt:GetComponent('UILabel');
		ruleTxt_UILabel.text = data
		local ph = ruleTxt_UILabel.height
		height = height + ph + 10
		table.insert(this._ruleVec,go)
	end
	RulePanel.ruleCollider_UISprite.height = height
end

function this.clearRuleList()
	local len = #this._ruleVec;
	for i=1,len do
		local data = this._ruleVec[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._ruleVec = {}
end

function this.Close()
	this.clearRuleList()
	panelMgr:ClosePanel(CtrlNames.Rule);
end

return this