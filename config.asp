<%
Const TESTNAME = "温州华侨中学在线考试"

Const CHAPTER_COUNT = 5   '章节数量，目前只针对计算机班'
CHAPTER_XZT_COUNT = 14    '章节练习单选题数量
CHAPTER_PDT_COUNT = 4     '章节练习判断题数量
CHAPTER_DXT_COUNT = 5     '章节练习多选题数量

Tk_xzt_display = 28  '练习模式，单选题数量
Tk_pdt_display = 15   '练习模式，判断题数量
Tk_dxt_display = 6   '练习模式，多选题数量

classID = 4  '指定要显示的班级，防止已毕业的班级还显示在排行榜里'
'--------其他专业的---------'
if session("majorID") <> "" then
	if session("majorID") = 6 then   '国贸专业 ID 6
		Tk_xzt_display = 10  '练习模式，单选题数量
		Tk_pdt_display = 0   '练习模式，判断题数量
		Tk_dxt_display = 0   '练习模式，多选题数量
	end if
end if
'-------------------------'

Const se_xzt_display = 60   '模拟考模式，单选题数量
Const se_pdt_display = 30   '模拟考模式，判断题数量
Const se_dxt_display = 10   '模拟考模式，多选题数量
Const se_id = 9   '模拟考ID

avgLevel = 40   '最低平均分'
countLevel = 2  '最低次数'

'--------其他专业的---------'
if session("majorID") <> "" then
	if session("majorID") = 6 then   '国贸专业 ID 6
		avgLevel = 8   '最低平均分'
		countLevel = 3  '最低次数'
	end if
end if
'-------------------------'

' Const Tk_xzt_min = 1   '选择题题目最小编号
' Const Tk_xzt_max = 121   '选择题题目最大编号
' Const Tk_pdt_min = 1   '判断题题目最小编号
' Const Tk_pdt_max = 60  '判断题题目最大编号
' Const Tk_dxt_min = 1   '多选题题目最小编号
' Const Tk_dxt_max = 60  '多选题题目最大编号
' Const Tk_All = 30        '题目总数
Const New_id = 20000       '从第几道开始打上新题目的标签
Const PAGE_SIZE = 50       '每页显示的记录数

Const SUBMIT_MIN_INTERVAL = 5   '提交时间最短间隔'

Const IMG_LENGTH = 600         '图片显示的长或宽（取决于哪一边更短）'

function new_text(newid,rs_id)
    if rs_id>=newid then
        new_text="<span style='color:#f00'>(新)</span>"
    end if
end function

%>
