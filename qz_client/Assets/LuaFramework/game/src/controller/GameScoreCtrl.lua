require "logic/ViewManager"
GameScoreCtrl = {};
local global = require("global")
local const = global.const
local this = GameScoreCtrl;
--构建函数--
function GameScoreCtrl.New()
	return this;
end

GameScoreCtrl._listData = nil
GameScoreCtrl._gameID=nil;
function GameScoreCtrl.Awake(list,gameID)
	this._listData = list;
	this._gameID=gameID;
	panelMgr:CreatePanel('GameScore', this.OnCreate);
end

function GameScoreCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.beh= this.transform:GetComponent('LuaBehaviour');
	this.beh:AddClick(GameScorePanel.back, this.OnBack);
	this.loadImg();
	this.colliderH = 0
	if this._gameID == const.GAME_ID_WATER then
		this._listData = this.memberSort(this._listData)
		this.renderCubeList(this._listData)
	elseif this._gameID == const.GAME_ID_MJ then 
		this.renderMJCubList(this._listData)
	else
		this.renderFunc(this._listData,GameScorePanel.cubelist.transform,188,this._cubeList)
	end
end

function GameScoreCtrl.memberSort(list)
	table.sort(list,function (a,b)
        return a.play_type < b.play_type
    end)
    return list
end

GameScoreCtrl.SanshuiCubelist = {}
GameScoreCtrl.rotalist = {}
GameScoreCtrl.ranklist = {}
GameScoreCtrl.colliderH = 0
function GameScoreCtrl.renderCubeList(list)
	local parent = GameScorePanel.cubelist.transform;
    local bundle = resMgr:LoadBundle("sanshuiCube");
    local Prefab = resMgr:LoadBundleAsset(bundle,"sanshuiCube");
    local allH = 0
	for i = 1, #list do
		local data = list[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "sanshuiCube"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0, 240 - allH, 0);
		resMgr:addAltas(go.transform,"GameScore")
		local cubetype = go.transform:Find('cubetype').gameObject;
		local modeTitle = go.transform:Find('modeTitle').gameObject;
		local ranktitle = go.transform:Find('ranktitle').gameObject;
		local ranktitle_UILabel = ranktitle:GetComponent('UILabel')
		local modeTitle_UILabel = modeTitle:GetComponent('UILabel')
		local tlist = this.rotalist
		if(data.play_type == 1) then
			modeTitle_UILabel.text = "对比模式"
			ranktitle_UILabel.text = "(13倍)"
			modeTitle.transform.localPosition = Vector3(-190, 0, 0);
			ranktitle.transform.localPosition = Vector3(245, 0, 0);
			cubetype:SetActive(true)
			this.renderEventList(go,data.play_type)
			tlist = this.rotalist
		else
			modeTitle_UILabel.text = "抢庄模式"
			ranktitle_UILabel.text = "(5分起,13倍)"
			modeTitle.transform.localPosition = Vector3(-90, 0, 0);
			ranktitle.transform.localPosition = Vector3(30, 0, 0);
			cubetype:SetActive(false)
			tlist = this.ranklist
		end
		local cubeObj = go.transform:Find('cubeObj').gameObject;
		this.renderFunc(data.list,cubeObj.transform,-175,tlist)
		allH = allH + this.colliderH + 140
		table.insert(this.SanshuiCubelist,go)
	end
	if(allH > 600) then
		GameScorePanel.BarCollider_UISprite.height = allH
	else
		GameScorePanel.BarCollider_UISprite.height = 598
	end
end


function GameScoreCtrl.renderMJCubList(list)
	local info = this.DealMJList(list)
	local parent = GameScorePanel.cubelist.transform;
    local bundle = resMgr:LoadBundle("sanshuiCube");
    local Prefab = resMgr:LoadBundleAsset(bundle,"sanshuiCube");
	local allH = 0
	local amount = 6		
	for i = 1 , amount do 
		local data = info[i]
		if not data then 
			return
		end 
		local go = GameObject.Instantiate(Prefab);
		go.name = "MJCube"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0, 240 - allH, 0);
		resMgr:addAltas(go.transform,"GameScore")
		local cubetype = go.transform:Find('cubetype').gameObject;
		local modeTitle = go.transform:Find('modeTitle').gameObject;
		local ranktitle = go.transform:Find('ranktitle').gameObject;
		local ranktitle_UILabel = ranktitle:GetComponent('UILabel')
		local modeTitle_UILabel = modeTitle:GetComponent('UILabel')	
		local power = const.MJ_MAX_POWER	
		local bet_coin = 1	
		local text_1 = "每水%s金币"
		local text_2 = "（入场条件：携带金额至少%s金币）"
		if i <= 1 then 
			bet_coin = 1 
			-- modeTitle_UILabel.text = "每水1金币"
			-- ranktitle_UILabel.text = "（入场条件：携带金额至少78金币）"
		elseif i <= 2 then 
			bet_coin = 2
			-- modeTitle_UILabel.text = "每水2金币"
			-- ranktitle_UILabel.text = "（入场条件：携带金额至少84金币）"
		elseif i <= 3 then 
			bet_coin = 5 
			-- modeTitle_UILabel.text = "每水5金币"
			-- ranktitle_UILabel.text = "（入场条件：携带金额至少210金币）"
		elseif i <= 4 then 
			bet_coin = 10
			-- modeTitle_UILabel.text = "每水10金币"
			-- ranktitle_UILabel.text = "（入场条件：携带金额至少420金币）"
		elseif i <= 5 then 
			bet_coin = 30
			-- modeTitle_UILabel.text = "每水30金币"
			-- ranktitle_UILabel.text = "（入场条件：携带金额至少1260金币）"
		elseif i <= 6 then 
			bet_coin = 50
			-- modeTitle_UILabel.text = "每水50金币"
			-- ranktitle_UILabel.text = "（入场条件：携带金额至少2100金币）"
		end 
		modeTitle_UILabel.text = string.format(text_1,bet_coin)
		ranktitle_UILabel.text = string.format(text_2,bet_coin*power)
		modeTitle.transform.localPosition = Vector3(-200, 0, 0);
		ranktitle.transform.localPosition = Vector3(-85, 0, 0);
		tlist = this.ranklist
		cubetype:SetActive(false)
		local cubeObj = go.transform:Find('cubeObj').gameObject;
		this.renderFunc(data,cubeObj.transform,-175,tlist)
		allH = allH + this.colliderH + 140
		table.insert(this.SanshuiCubelist,go)
	end 
	if(allH > 600) then
		GameScorePanel.BarCollider_UISprite.height = allH
	else
		GameScorePanel.BarCollider_UISprite.height = 598
	end
end 

function GameScoreCtrl.renderEventList(go,play_type)
	local cube1 = go.transform:Find('cubetype/cube1').gameObject;
	local cube2 = go.transform:Find('cubetype/cube2').gameObject;
	local cube3 = go.transform:Find('cubetype/cube3').gameObject;
	local cube4 = go.transform:Find('cubetype/cube4').gameObject;
	local cube5 = go.transform:Find('cubetype/cube5').gameObject;
	local cubegou = go.transform:Find('cubetype/cubegou').gameObject;
	local allBtn = {cube1,cube2,cube3,cube4,cube5}
	for i=1,#allBtn do
		local obj = allBtn[i]
		this.beh:AddClick(obj, function ()
			cubegou.transform.localPosition = obj.transform.localPosition;
			GameScorePanel.SanshuiGameScore(this._gameID,play_type,i)
		end);
	end
end

function GameScoreCtrl.DealMJList(list)
	local count = 0
	local data = {}
	local info = {}
	for k , v in pairs(list)do 
		table.insert(info,v)
		count = count + 1
		if count >= 5 then 			
			table.insert(data,info)
			info = {}
			count = 0
		end 
	end 
	return data 
end 
function GameScoreCtrl.reloadRotaList(mlist)
	this.clearRotaList()
	local go = this.SanshuiCubelist[1]
	local cubeObj = go.transform:Find('cubeObj').gameObject;
	this.renderFunc(mlist[1].list,cubeObj.transform,-175,this.rotalist)
end

function GameScoreCtrl.clearRotaList()
	local len = #this.rotalist;
	for i=1,len do
		local data = this.rotalist[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this.rotalist = {}
end

function GameScoreCtrl.clearRankList()
	local len = #this.ranklist;
	for i=1,len do
		local data = this.ranklist[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this.ranklist = {}
end

function GameScoreCtrl.clearSanshuiCube()
	local len = #this.SanshuiCubelist;
	for i=1,len do
		local data = this.SanshuiCubelist[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this.SanshuiCubelist = {}
end

function GameScoreCtrl.loadImg()
	GameScorePanel.playerIcon_AsyncImageDownload:SetAsyncImage(GameScorePanel.getHeadUrl())
	GameScorePanel.diamondTxt.text = GameScorePanel.get_RMB()
	GameScorePanel.coinTxt.text = GameScorePanel.get_money()
end

GameScoreCtrl._cubeList = {}
GameScoreCtrl._adressStr = {
	"泉州场","石狮场","晋江场","南安场","福州场","南平场","厦门场",
	"同安场","安溪场","龙岩场","三明场","漳州场","宁德场","莆田场",
	"德化场","福清场","惠安场","云霄场","南京场","合肥场","长沙场",
	"长春场","哈尔滨场","成都场","南昌场","银川场","台北场","拉萨场",
}
function GameScoreCtrl.renderFunc (list,tran,startPy,mlist)
    local parent = tran;
    local bundle = resMgr:LoadBundle("cubeBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"cubeBar");
    local startPx = -516
    -- local startPy = 188
    local column = 6
    local space = 206;
    local len = #list;
	for i = 1, len do
		local data = list[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "cubeBar"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(startPx + space * ((i - 1) % column), startPy - math.floor((i - 1) / column) * space, 0);
		resMgr:addAltas(go.transform,"GameScore")
		this.beh:AddClick(go, function ()
			GameScorePanel.joinRoomPoto(data.roomid,this._adressStr[i],this._gameID)
		end);
		local IsPeople = "bottom"
		local num = data.num
		if(num > 0) then
			IsPeople = "up"
		end
		local normal = go.transform:Find('normal');
		normal:GetComponent('UISprite').spriteName = IsPeople;
		local number = go.transform:Find('number');
		number:GetComponent('UILabel').text = num .. " 人";
		local adress = go.transform:Find('adress');
		adress:GetComponent('UILabel').text = this._adressStr[i];
		table.insert(mlist,go)
	end
	local low = math.floor((len - 1) / column) + 1
	this.colliderH = low * space
	if this._gameID ~= const.GAME_ID_WATER then
		if(this.colliderH > 600) then
			GameScorePanel.BarCollider_UISprite.height = this.colliderH
		else
			GameScorePanel.BarCollider_UISprite.height = 598
		end
	end
end

function GameScoreCtrl.clearRecord()
	local len = #this._cubeList;
	for i=1,len do
		local data = this._cubeList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._cubeList = {}
end

function GameScoreCtrl.OnBack()
	GameScorePanel.backNiuniu(this._gameID)
end

--关闭事件--
function GameScoreCtrl.Close()
	this._listData = nil
	this._gameID=nil;
	this.clearRecord();
	this.clearRotaList()
	this.clearRankList()
	this.clearSanshuiCube()
	panelMgr:ClosePanel(CtrlNames.GameScore);
end

return GameScoreCtrl