local Localization = {}

Localization.cn = {}

Localization.cn.level = "第%d关"

Localization.cn.back  = "返回"

Localization.cn.reset = "重置"

Localization.cn.step = "步数:%d"

Localization.cn.chooselevel = "关卡"

Localization.cn.passlevel = "您用%d步通过此关"

Localization.cn.nice = "太棒了！"

Localization.cn.nextlevel = "下一关"

Localization.cn.share = "分享"

Localization.cn.unlock = "未解锁"

Localization.cn.record = "记录:%d"

Localization.en = {}
Localization.en.level = "level%d"

Localization.en.back =	"Back"

Localization.en.reset = "Reset"

Localization.en.step = "moves:%d"

Localization.en.chooselevel = "Levels"

Localization.en.passlevel ="You completed the level in %d moves"

Localization.en.nice = "Nice!"

Localization.en.nextlevel = "next level"

Localization.en.share = "share"

Localization.en.unlock = "locked"

Localization.en.record = "record:%d"

function Localization.getString(key)

	return Localization.cn[key]

end

return Localization