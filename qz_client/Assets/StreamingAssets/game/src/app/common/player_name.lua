--
-- Author:
-- Date: 2015-12-28 21:30:00
-- Filename: player_name.lua
--
local global = require "global"
local config = global.config
local language_type = require "config.language_type"

local mt = {}

local surname = {}
local man_name = {}
local d_man_name = {}
local woman_name = {}
local d_woman_name = {}

local random = math.random
--随机角色名字
if config.DEFAULT_LANGUAGE == language_type.ChineseSimplified then
	surname = {
		"万俟","闻人","拓跋","酆","公冶","伯赏","轩辕","长孙","司马","鲜于","欧阳","司空","单于","夏侯","上官","皇甫","南宫","诸葛","巫马",
		"阳佟","太叔","东方","尉迟","呼延","慕容","宇文","淳于","子车","闾丘","东郭","归海","赫连","司空","乐正","濮阳","西门","百里","司徒",
		"令狐","左丘","公西","谷粱",
		"赵","钱","孙","李","周","吴","郑","王",'陈',"蒋","沈","韩","杨","朱","秦","尤","许","何","吕","施","张","孔","曹","严","华","金",
		"魏","陶","姜","戚","谢","邹","喻","柏","水","窦","章","云","苏","潘","葛","奚","范","彭","郎","鲁","韦","昌","马","苗","凤","花",
		"方","俞","任","袁","柳","鲍","史","唐","费","鲍","唐","殷","罗","毕","郝","邬","安","常","乐","于","傅","皮","齐","康","伍","余",
		"顾","孟","黄","和","穆","萧","尹","姚","邵","湛","汪","祁","毛","禹","狄","米","贝","宋","庞","熊","纪","舒","屈","项","祝","董",
		"梁","杜","阮","蓝","江","童","颜","郭","梅","林","徐","邱","骆","高","夏","田","樊","胡","凌","虞","霍","万","柯","卢","莫","丁",
		"宣","洪","程","陆","乌","刘",'叶',"白","牛","庄","蔡","甄","卓","庾","欧","龙","敖","赫","华","解","雷","廉","聂","汤","滕","应",
		"杭","仇","堪","黎","席","经","车","贾","裘","支","祁","鄂","阎","粱","咎","管",
	}
	man_name = {
		"斌","林","志","庆","贤","吉","兴","华","强","超","霸","刀","平","建","炜","非","飞","欣","阳","名","达","杠","气","炼","狱","钦",
		"青","来","伟","达","炎","燕","森","税","荤","靖","绪","愈","硕","巧","朋","羽","贵","禾","保","苟","佼","玄","乘","裔","延","植",
		"环","燃","叔","圣","御","夫","仆","镇","藩","寒","少","字","桥","板","斐","独","千","势","嘉","塔","锋","闪","始","星","南","天",
		"接","暴","地","速","禚","腾","潮","镜","似","澄","潭","纵","渠","奈","风","春","濯","沐","茂","英","兰","檀","藤","枝","检","生",
		"折","登","驹","骑","格","庆","喜","及","普","建","营","巨","望","玛","道","载","声","漫","犁","力","贸","勤","修","信","闽","北",
		"守","坚","勇","汉","五","令","将","旗","军","行","奉","敬","恭","仪","特","堂","丘","义","礼","瑞","孝","理","伦","卿","问","永",
		"辉","位","让","神","雉","犹","介","承","市","所","苑","杞","剧","第","忻","迟","鄞","战","候","丸","励","萨","邝","覃","初","楼",
		"城","区","泉","麦","健","枫","迪","燎","悟","瑟","仙","海","杰","俊","龙","怨","元","心","乾","坤"
	}
	d_man_name = {
		"叫兽","之玉","越泽","锦程","修杰","烨伟","尔曼","立辉","致远","天思","友绿","聪健","修洁","访琴","初彤","谷雪","平灵","源智","烨华",
		"振家","越彬","乞","子轩","伟宸","晋鹏","觅松","海亦","阁","康","焱","城","誉","祥","虔","胜","穆","豁","匪","霆","凡","枫","豪","铭",
		"志泽","苑博","念波","峻熙","俊驰","聪展","南松","问旋","黎昕","谷波","凝海","靖易","芷烟","渊思","煜祺","瑾瑜","鹏飞","弘文","伟泽",
		"迎松","雨泽","鹏笑","诗云","白易","远航","笑白","映波","代桃","晓啸","智宸","晓博","靖琪","十八","君浩","绍辉","冷安","盼旋","博",
		"储","羿","富","稀","松","寇","碧","珩","靳","鞅","弼","焦","天德","铁身","老黑","半邪","半山","一江","冰安","皓轩","子默","熠彤","青寒",
		"烨磊","愚志","飞风","问筠","旭尧","妙海","平文","冷之","尔阳","天宇","正豪","文博","明辉","行恶","哲瀚","子骞","泽洋","灵竹","幼旋",
		"百招","不斜","擎汉","千万","高烽","大开","不正","伟帮","如豹","三德","三毒","连虎","十三","酬海","天川","一德","复天","牛青","羊青",
		"大楚","傀斗","老五","老九","定帮","自中","开山","似狮","无声","一手","严青","老四","不可","随阴","大有","中恶","延恶","百川","世倌",
		"连碧","岱周","擎苍","思远","嘉懿","鸿煊","笑天","晟睿","强炫","寄灵","听白","鸿涛","孤风","青文","盼秋","怜烟","浩然","明杰","昊焱",
		"伟诚","剑通","鹏涛","鑫磊","醉薇","尔蓝","靖仇","成风","豪英","若风","难破","德地","无施","追命","成协","人达","亿先","不评","成威",
		"成败","难胜","人英","忘幽","世德","世平","广山","德天","人雄","人杰","不言","难摧","世立",
	}
	woman_name ={
		"玲","雪","婉","凤","淑","惠","矫","诗","琦","波","碧","盈","希","母","慈","尧","依","宛","娟","霜","莉","丽","媛","静","玉","佳",
		"儿","萦","美","妖","芸","茹","娇","乔","姫","英","蝉","香","尚","倩","茜","卉","紫","秋","苗","柔","善","纯","衣","蝶","施","珍",
		"妹","真","寒","偲","双","琴","瑶","春","兰","岚","芷","若","彤","娜","馨","蕾","姗","丝","雅","梦","悠","薇","萱","桃","青","嫚",
		"念","音","涵","柏","虹","云","晨","慧","含","雨","晴","烟","芯","婷","艳","妮","徽","妱","忆","夏","惜","语","蓉","蕊","映","晓",
		"媚","娆","佟","荷","菊","初","恋","听","芹","书","怜","璇","凝","花","萍","莲","夜","乐","雁","丹","妙","笑","枫","妍","筱","曦",
		"夕","羽","月","浅","沫","柳","玫","妃","姬","星","霓","舞","琳","裳","茵","芝","琪","菲","芳","颖","嫣","薰","姿","洁","嫦","怡","雯"
	}
	d_woman_name = {
		"醉易","紫萱","紫霜","荟","幻天","幻珊","寒天","寒凝","寒梦","寒荷","涵易","涵菱","含玉","含烟","含灵","含蕾","海云","海冬","涫",
		"谷蕊","谷兰","飞珍","飞槐","访云","访烟","访天","访风","凡阳","凡旋","凡梅","凡灵","凡蕾","尔丝","尔柳","尔芙","尔白","孤菱",
		"沛萍","梦柏","从阳","绿海","白梅","秋烟","访旋","元珊","凌旋","依珊","寻凝","幻柏","雨寒","寒安","芙","怀绿","书琴","水香","向彤",
		"曼冬","璎","姒","苠","淇","绮","怜梦","安珊","映阳","思天","初珍","冷珍","海安","从彤","灵珊","夏彤","映菡","青筠","易真","幼荷",
		"冷霜","凝旋","夜柳","紫文","凡桃","醉蝶","从云","冰萍","小萱","白筠","依云","元柏","丹烟","雁","念云","易蓉","青易","友卉","若山",
		"涵柳","映菱","依凝","怜南","水儿","从筠","千秋","代芙","之卉","幻丝","书瑶","含之","雪珊","海之","寄云","盼海","谷梦","襄","雁兰",
		"晓灵","向珊","宛筠","笑南","梦容","寄柔","静枫","尔容","沛蓝","宛海","迎彤","梦易","惜海","灵阳","念寒","紫","芯","沂","衣","荠",
		"莺","萤","采梦","夜绿","又亦","怡","苡","悒","梦山","醉波","慕晴","安彤","荧","半烟","翠桃","书蝶","寻云","冰绿","山雁","南莲",
		"夜梅","翠阳","芷文","茈","南露","向真","又晴","香","又蓝","绫","灵","雅旋","千儿","玲","听安","凌蝶","向露","从凝","雨双",
	}
elseif config.DEFAULT_LANGUAGE == language_type.ChineseTraditional then
	surname = {
		"萬俟","聞人","拓跋","酆","公冶","伯賞","軒轅","長孫","司馬","鮮于","歐陽","司空","單于","夏侯","上官","皇甫","南宮","諸葛","巫馬",
		"陽佟","太叔","東方","尉遲","呼延","慕容","宇文","淳于","子車","閭丘","東郭","歸海","赫連","司空","樂正","濮陽","西門","百里","司徒",
		"令狐","左丘","公西","穀粱",
		"趙","錢","孫","李","周","吳","鄭","王",'陳',"蔣","沈","韓","楊","朱","秦","尤","許","何","呂","施","張","孔","曹","嚴","華","金",
		"魏","陶","姜","戚","謝","鄒","喻","柏","水","竇","章","雲","蘇","潘","葛","奚","范","彭","郎","魯","韋","昌","馬","苗","鳳","花",
		"方","俞","任","袁","柳","鮑","史","唐","費","鮑","唐","殷","羅","畢","郝","鄔","安","常","樂","于","傅","皮","齊","康","伍","餘",
		"顧","孟","黃","和","穆","蕭","尹","姚","邵","湛","汪","祁","毛","禹","狄","米","貝","宋","龐","熊","紀","舒","屈","項","祝","董",
		"梁","杜","阮","藍","江","童","顏","郭","梅","林","徐","邱","駱","高","夏","田","樊","胡","淩","虞","霍","萬","柯","盧","莫","丁",
		"宣","洪","程","陸","烏","劉",'葉',"白","牛","莊","蔡","甄","卓","庾","歐","龍","敖","赫","華","解","雷","廉","聶","湯","滕","應",
		"杭","仇","堪","黎","席","經","車","賈","裘","支","祁","鄂","閻","粱","咎","管",
	}
	man_name = {
		"斌","林","志","慶","賢","吉","興","華","強","超","霸","刀","平","建","煒","非","飛","欣","陽","名","達","杠","氣","煉","獄","欽",
		"青","來","偉","達","炎","燕","森","稅","葷","靖","緒","愈","碩","巧","朋","羽","貴","禾","保","苟","佼","玄","乘","裔","延","植",
		"環","燃","叔","聖","禦","夫","僕","鎮","藩","寒","少","字","橋","板","斐","獨","千","勢","嘉","塔","鋒","閃","始","星","南","天",
		"接","暴","地","速","禚","騰","潮","鏡","似","澄","潭","縱","渠","奈","風","春","濯","沐","茂","英","蘭","檀","藤","枝","檢","生",
		"折","登","駒","騎","格","慶","喜","及","普","建","營","巨","望","瑪","道","載","聲","漫","犁","力","貿","勤","修","信","閩","北",
		"守","堅","勇","漢","五","令","將","旗","軍","行","奉","敬","恭","儀","特","堂","丘","義","禮","瑞","孝","理","倫","卿","問","永",
		"輝","位","讓","神","雉","猶","介","承","市","所","苑","杞","劇","第","忻","遲","鄞","戰","候","丸","勵","薩","鄺","覃","初","樓",
		"城","區","泉","麥","健","楓","迪","燎","悟","瑟","仙","海","傑","俊","龍","怨","元","心","乾","坤"
	}

	d_man_name = {
		"叫獸","之玉","越澤","錦程","修傑","燁偉","爾曼","立輝","致遠","天思","友綠","聰健","修潔","訪琴","初彤","谷雪","平靈","源智","燁華",
		"振家","越彬","乞","子軒","偉宸","晉鵬","覓松","海亦","閣","康","焱","城","譽","祥","虔","勝","穆","豁","匪","霆","凡","楓","豪","銘",
		"志澤","苑博","念波","峻熙","俊馳","聰展","南松","問旋","黎昕","穀波","凝海","靖易","芷煙","淵思","煜祺","瑾瑜","鵬飛","弘文","偉澤",
		"迎松","雨澤","鵬笑","詩雲","白易","遠航","笑白","映波","代桃","曉嘯","智宸","曉博","靖琪","十八","君浩","紹輝","冷安","盼旋","博",
		"儲","羿","富","稀","松","寇","碧","珩","靳","鞅","弼","焦","天德","鐵身","老黑","半邪","半山","一江","冰安","皓軒","子默","熠彤","青寒",
		"燁磊","愚志","飛風","問筠","旭堯","妙海","平文","冷之","爾陽","天宇","正豪","文博","明輝","行惡","哲瀚","子騫","澤洋","靈竹","幼旋",
		"百招","不斜","擎漢","千萬","高烽","大開","不正","偉幫","如豹","三德","三毒","連虎","十三","酬海","天川","一德","複天","牛青","羊青",
		"大楚","傀鬥","老五","老九","定幫","自中","開山","似獅","無聲","一手","嚴青","老四","不可","隨陰","大有","中惡","延惡","百川","世倌",
		"連碧","岱周","擎蒼","思遠","嘉懿","鴻煊","笑天","晟睿","強炫","寄靈","聽白","鴻濤","孤風","青文","盼秋","憐煙","浩然","明傑","昊焱",
		"偉誠","劍通","鵬濤","鑫磊","醉薇","爾藍","靖仇","成風","豪英","若風","難破","德地","無施","追命","成協","人達","億先","不評","成威",
		"成敗","難勝","人英","忘幽","世德","世平","廣山","德天","人雄","人傑","不言","難摧","世立",
	}
	woman_name ={
		"玲","雪","婉","鳳","淑","惠","矯","詩","琦","波","碧","盈","希","母","慈","堯","依","宛","娟","霜","莉","麗","媛","靜","玉","佳",
		"兒","縈","美","妖","芸","茹","嬌","喬","姫","英","蟬","香","尚","倩","茜","卉","紫","秋","苗","柔","善","純","衣","蝶","施","珍",
		"妹","真","寒","偲","雙","琴","瑤","春","蘭","嵐","芷","若","彤","娜","馨","蕾","姍","絲","雅","夢","悠","薇","萱","桃","青","嫚",
		"念","音","涵","柏","虹","雲","晨","慧","含","雨","晴","煙","芯","婷","豔","妮","徽","妱","憶","夏","惜","語","蓉","蕊","映","曉",
		"媚","嬈","佟","荷","菊","初","戀","聽","芹","書","憐","璿","凝","花","萍","蓮","夜","樂","雁","丹","妙","笑","楓","妍","筱","曦",
		"夕","羽","月","淺","沫","柳","玫","妃","姬","星","霓","舞","琳","裳","茵","芝","琪","菲","芳","穎","嫣","薰","姿","潔","嫦","怡","雯"
	}
	d_woman_name = {
		"醉易","紫萱","紫霜","薈","幻天","幻珊","寒天","寒凝","寒夢","寒荷","涵易","涵菱","含玉","含煙","含靈","含蕾","海雲","海冬","涫",
		"谷蕊","谷蘭","飛珍","飛槐","訪雲","訪煙","訪天","訪風","凡陽","凡旋","凡梅","凡靈","凡蕾","爾絲","爾柳","爾芙","爾白","孤菱",
		"沛萍","夢柏","從陽","綠海","白梅","秋煙","訪旋","元珊","淩旋","依珊","尋凝","幻柏","雨寒","寒安","芙","懷綠","書琴","水香","向彤",
		"曼冬","瓔","姒","苠","淇","綺","憐夢","安珊","映陽","思天","初珍","冷珍","海安","從彤","靈珊","夏彤","映菡","青筠","易真","幼荷",
		"冷霜","凝旋","夜柳","紫文","凡桃","醉蝶","從雲","冰萍","小萱","白筠","依雲","元柏","丹煙","雁","念雲","易蓉","青易","友卉","若山",
		"涵柳","映菱","依凝","憐南","水兒","從筠","千秋","代芙","之卉","幻絲","書瑤","含之","雪珊","海之","寄雲","盼海","穀夢","襄","雁蘭",
		"曉靈","向珊","宛筠","笑南","夢容","寄柔","靜楓","爾容","沛藍","宛海","迎彤","夢易","惜海","靈陽","念寒","紫","芯","沂","衣","薺",
		"鶯","螢","采夢","夜綠","又亦","怡","苡","悒","夢山","醉波","慕晴","安彤","熒","半煙","翠桃","書蝶","尋雲","冰綠","山雁","南蓮",
		"夜梅","翠陽","芷文","茈","南露","向真","又晴","香","又藍","綾","靈","雅旋","千兒","玲","聽安","淩蝶","向露","從凝","雨雙",
	}
end

local sn_count =#surname
local mn_count = #man_name
local dmn_count = #d_man_name

local wn_count = #woman_name
local d_wn_count = #d_woman_name

function mt.CREATE_RAND_NAME(sex)
	if sex == nil then
		sex = random(0,1)
	end
	local sn = random(1,sn_count)
	if sex == 0 then
		if random(0,1) == 1 then
			return surname[sn]..d_man_name[random(1,dmn_count)]
		else
			local name1 = random(1,mn_count)
			local name2 = random(1,mn_count)
			return surname[sn]..man_name[name1]..man_name[name2]
		end
	else
		if random(0,1) == 1 then
			return surname[sn]..d_woman_name[random(1,d_wn_count)]
		else
			local name1 = random(1,wn_count)
			local name2 = random(1,wn_count)
			return surname[sn]..woman_name[name1]..woman_name[name2]
		end
	end
	return "无名氏"
end

return mt