<%
Const TESTNAME = "���ݻ�����ѧ���߿���"

Const CHAPTER_COUNT = 5   '�½�������Ŀǰֻ��Լ������'
CHAPTER_XZT_COUNT = 14    '�½���ϰ��ѡ������
CHAPTER_PDT_COUNT = 4     '�½���ϰ�ж�������
CHAPTER_DXT_COUNT = 5     '�½���ϰ��ѡ������

Tk_xzt_display = 28  '��ϰģʽ����ѡ������
Tk_pdt_display = 15   '��ϰģʽ���ж�������
Tk_dxt_display = 6   '��ϰģʽ����ѡ������

classID = 4  'ָ��Ҫ��ʾ�İ༶����ֹ�ѱ�ҵ�İ༶����ʾ�����а���'
'--------����רҵ��---------'
if session("majorID") <> "" then
	if session("majorID") = 6 then   '��óרҵ ID 6
		Tk_xzt_display = 10  '��ϰģʽ����ѡ������
		Tk_pdt_display = 0   '��ϰģʽ���ж�������
		Tk_dxt_display = 0   '��ϰģʽ����ѡ������
	end if
end if
'-------------------------'

Const se_xzt_display = 60   'ģ�⿼ģʽ����ѡ������
Const se_pdt_display = 30   'ģ�⿼ģʽ���ж�������
Const se_dxt_display = 10   'ģ�⿼ģʽ����ѡ������
Const se_id = 9   'ģ�⿼ID

avgLevel = 40   '���ƽ����'
countLevel = 2  '��ʹ���'

'--------����רҵ��---------'
if session("majorID") <> "" then
	if session("majorID") = 6 then   '��óרҵ ID 6
		avgLevel = 8   '���ƽ����'
		countLevel = 3  '��ʹ���'
	end if
end if
'-------------------------'

' Const Tk_xzt_min = 1   'ѡ������Ŀ��С���
' Const Tk_xzt_max = 121   'ѡ������Ŀ�����
' Const Tk_pdt_min = 1   '�ж�����Ŀ��С���
' Const Tk_pdt_max = 60  '�ж�����Ŀ�����
' Const Tk_dxt_min = 1   '��ѡ����Ŀ��С���
' Const Tk_dxt_max = 60  '��ѡ����Ŀ�����
' Const Tk_All = 30        '��Ŀ����
Const New_id = 20000       '�ӵڼ�����ʼ��������Ŀ�ı�ǩ
Const PAGE_SIZE = 50       'ÿҳ��ʾ�ļ�¼��

Const SUBMIT_MIN_INTERVAL = 5   '�ύʱ����̼��'

Const IMG_LENGTH = 600         'ͼƬ��ʾ�ĳ����ȡ������һ�߸��̣�'

function new_text(newid,rs_id)
    if rs_id>=newid then
        new_text="<span style='color:#f00'>(��)</span>"
    end if
end function

%>
