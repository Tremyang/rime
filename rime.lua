-- {{{ 说明
-- encoding: utf-8
--# vim折叠标识: {{{折叠内容}}}
--# zM/m,折叠;zR/r,打开全部折叠;zo,打开当前折叠
--# za 打开/关闭当前折叠
-- 2021年2月23日 11:11
--      请在方案配置文件比如wubi86.schema.yaml的engine\translators:下面添加滤镜引用：
--        - lua_translator@date_translator
--        - lua_translator@number_translator
--}}}

-- {{{ date_translator 日期,时间
function date_translator(input, seg)
	  --date1 2020年02月04日
    date1=os.date("%Y年%m月%d日")
	  date_y=os.date("%Y") --取年
	  date_m=os.date("%m") --取月
	  date_d=os.date("%d") --取日

	  --date2 2020年2月4日
	  num_m=os.date("%m")+0
	  num_m1=math.modf(num_m)
	  num_d=os.date("%d")+0
	  num_d1=math.modf(num_d)
	  date2=os.date("%Y年")..tostring(num_m1).."月"..tostring(num_d1).."日"

          --date20 2020年2月4日06:06:06
	  date20=os.date("%Y年")..tostring(num_m1).."月"..tostring(num_d1).."日"..os.date("%H点%M分%S秒")

          --date21 2020年2月4日06:06:06
    date21=os.date("%Y年")..tostring(num_m1).."月"..tostring(num_d1).."日"..os.date(" %H:%M")

	  --date5 2020-06-06㊅06:06:06
	  date5=os.date("%Y-%m-%d")..os.date(day_w2)..os.date("%H:%M:%S")

	  --date4 2020年6月6日星期六6点6分6秒
	  date4=os.date(date2)..os.date(day_w1)..os.date("%H点%M分%S秒")

	  --date7 Sat Jun  6 06:06:06 2020
	  date7=os.date(ChineseDate)

	  --date3 二〇二〇年十一月二十六日
	 date_y=date_y:gsub("%d",{
       ["1"]="一",
       ["2"]="二",
       ["3"]="三",
       ["4"]="四",
       ["5"]="五",
       ["6"]="六",
       ["7"]="七",
       ["8"]="八",
       ["9"]="九",
       ["0"]="〇",
--       ["0"]="零",
      })
	 date_y=date_y.."年"

	 date_m=date_m:gsub("%d",{
       ["1"]="一",
       ["2"]="二",
       ["3"]="三",
       ["4"]="四",
       ["5"]="五",
       ["6"]="六",
       ["7"]="七",
       ["8"]="八",
       ["9"]="九",
       ["0"]="",
      })
	 date_m=date_m.."月"
	 if num_m1==10 then date_m="十月" end
	 if num_m1==11 then date_m="十一月" end
	 if num_m1==12 then date_m="十二月" end

	 date_d=date_d:gsub("%d",{
       ["1"]="一",
       ["2"]="二",
       ["3"]="三",
       ["4"]="四",
       ["5"]="五",
       ["6"]="六",
       ["7"]="七",
       ["8"]="八",
       ["9"]="九",
       ["0"]="",
      })
	 date_d=date_d.."日"
	 date3=date_y..date_m..date_d

	  --星期
	 day_w=os.date("%w")
	 day_w1=""
	if day_w=="0" then day_w1="星期日" end
	if day_w=="1" then day_w1="星期一" end
	if day_w=="2" then day_w1="星期二" end
	if day_w=="3" then day_w1="星期三" end
	if day_w=="4" then day_w1="星期四" end
	if day_w=="5" then day_w1="星期五" end
	if day_w=="6" then day_w1="星期六" end

	  --星期
	 day_w3=os.date("%w")
	 day_w2=""
	if day_w3=="0" then day_w2="㊐" end
	if day_w3=="1" then day_w2="㊀" end
	if day_w3=="2" then day_w2="㊁" end
	if day_w3=="3" then day_w2="㊂" end
	if day_w3=="4" then day_w2="㊃" end
	if day_w3=="5" then day_w2="㊄" end
	if day_w3=="6" then day_w2="㊅" end

   if (input == "date" or input =="/date") then
      yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
--      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), ""))
--      yield(Candidate("date", seg.start, seg._end, date1, ""))
      yield(Candidate("date", seg.start, seg._end, date2, ""))
--      yield(Candidate("date", seg.start, seg._end, date5, ""))
--      yield(Candidate("date", seg.start, seg._end, date7, ""))
      yield(Candidate("date", seg.start, seg._end, date3, ""))
   end

   if (input == "time" or input == "/time") then
      yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), "  "))
      yield(Candidate("time", seg.start, seg._end, os.date("%H点%M分"), "  "))
      yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), ""))
      yield(Candidate("time", seg.start, seg._end, os.date("%H点%M分%S秒"), ""))
   end

   if (input == "week" or input == "/week") then
      yield(Candidate("week", seg.start, seg._end, os.date(day_w1), "  "))
   end

   if (input == "now" or input == "/now") then
      yield(Candidate("now", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), ""))
      yield(Candidate("now", seg.start, seg._end, date21, ""))
      yield(Candidate("now", seg.start, seg._end, date4, ""))
   end
end
--}}}

--{{{ number_translator 将 `/` + 阿拉伯数字 翻译为大小写汉字
local confs = {
   {
      comment = " 大写",
      number = { [0] = "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" },
      suffix = { [0] = "", "拾", "佰", "仟" },
      suffix2 = { [0] = "", "万", "亿", "万亿", "亿亿" }
   },
   {
      comment = " 小写",
      number = { [0] = "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" },
      suffix = { [0] = "", "十", "百", "千" },
      suffix2 = { [0] = "", "万", "亿", "万亿", "亿亿" }
   },
   {
      comment = " 大寫",
      number = { [0] = "零", "壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖" },
      suffix = { [0] = "", "拾", "佰", "仟" },
      suffix2 = { [0] = "", "萬", "億", "萬億", "億億" }
   },
   {
      comment = " 小寫",
      number = { [0] = "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" },
      suffix = { [0] = "", "十", "百", "千" },
      suffix2 = { [0] = "", "萬", "億", "萬億", "億億" }
   },
}

local function read_seg(conf, n)
   local s = ""
   local i = 0
   local zf = true

   while string.len(n) > 0 do
      local d = tonumber(string.sub(n, -1, -1))
      if d ~= 0 then
   s = conf.number[d] .. conf.suffix[i] .. s
   zf = false
      else
   if not zf then
      s = conf.number[0] .. s
   end
   zf = true
      end
      i = i + 1
      n = string.sub(n, 1, -2)
   end

   return i < 4, s
end

local function read_number(conf, n)
   local s = ""
   local i = 0
   local zf = false

   n = string.gsub(n, "^0+", "")

   if n == "" then
      return conf.number[0]
   end

   while string.len(n) > 0 do
      local zf2, r = read_seg(conf, string.sub(n, -4, -1))
      if r ~= "" then
   if zf and s ~= "" then
      s = r .. conf.suffix2[i] .. conf.number[0] .. s
   else
      s = r .. conf.suffix2[i] .. s
   end
      end
      zf = zf2
      i = i + 1
      n = string.sub(n, 1, -5)
   end
   return s
end

function number_translator(input, seg)
   if string.sub(input, 1, 1) == "/" then
      local n = string.sub(input, 2)
      if tonumber(n) ~= nil then
   for _, conf in ipairs(confs) do
      local r = read_number(conf, n)
      yield(Candidate("number", seg.start, seg._end, r, conf.comment))
   end
      end
   end
end
--}}}
