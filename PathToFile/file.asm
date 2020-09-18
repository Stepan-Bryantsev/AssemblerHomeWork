format PE CONSOLE
include 'win32ax.inc'

SEEK_SET equ 0  ; ������������ ������ �����, ������ ����� - ������� 0
SEEK_CUR equ 1  ; ������������ ������� �������, > 0 - ������, < 0 - �����
SEEK_END equ 2  ; ������������ ����� ����� (�������� pos - �������������)
NULL     equ 0
EOF      equ -1

section '.data' data readable writeable

argc    dd ?
argv    dd ?
env     dd ?
fp      dd ?
flength dd ?
fbuf    dd ?
msg     db  '%s %s%s',0
errmsg  db "Error, please input correct file.",0

section '.code' code readable executable

entry start

start:
; invoke  FreeConsole
; invoke  AllocConsole
; cinvoke printf,'%s%s',,<13,10,0>
 invoke SetConsoleOutputCP,1251
 invoke SetConsoleCP,1251

 cinvoke printf,'%s',<'������!',13,10,0>

 ; �������� ������ ���� � ��������� � �������� �� �������� ���������� ��������� �� C
 cinvoke __getmainargs,argc,argv,env,0
 cmp [argc],2
 mov esi,[argv]

 invoke CharToOemA,dword [esi],dword [esi]
 invoke CharToOemA,dword [esi+4],dword [esi+4]

 ; ������� ��� ��������� � ���� � ��������
 cinvoke printf,msg,dword [esi],dword [esi+4],<13,10,0>

 ; ��������� �������� ��������� ���� � ������ "������ ������" � "��������"
 cinvoke fopen,dword [esi+4],'rb'
 test eax,eax
 mov [fp],eax

 ; ������������� ��������� ������-������ � ����� �����
 cinvoke fseek,[fp],0,SEEK_END
 .if eax <> 0
 .endif

 ; ����� �������� ����� ���������, ������� ����� ������� �����
 cinvoke ftell,[fp]
 test eax,eax
 mov [flength],eax

 ; ����������� ������������ ������ �������� ����� ����� + 1 ����
 inc eax
 cinvoke malloc,eax
 test eax,eax
 mov [fbuf],eax

 ; ���������� ��������� ������-������ � ������ �����
 cinvoke fseek,[fp],0,SEEK_SET
 test eax,eax

 ; ������ ���� ���� � ������������ ������
 cinvoke fread,[fbuf],1,[flength],[fp]
 cmp eax,[flength]

 ; ���������� 0 �� ������ ������ ��� ����������� ����� ������
 mov eax,[fbuf]
 add eax,[flength]
 mov byte [eax],0

 ; ������� ����� ����� �� �������
 ;cinvoke puts,[fbuf]
 cinvoke printf,'File length = %u%s',[flength],<13,10,0>

 ; ��������� ����
 cinvoke fclose,[fp]
 test eax,eax

 ; ����������� ������������ ������
 cinvoke free,[fbuf]

.finish:
 cinvoke puts,'Press any key...'
 cinvoke _getch
 invoke ExitProcess,0

section '.idata' import data readable writeable

library kernel,'kernel32.dll',\
msvcrt,'msvcrt.dll',\
user32,'user32.dll'

import kernel,\
ExitProcess,'ExitProcess',\
GetCommandLineA,'GetCommandLineA',\
AllocConsole,'AllocConsole',\
FreeConsole,'FreeConsole',\
SetConsoleOutputCP,'SetConsoleOutputCP',\
SetConsoleCP,'SetConsoleCP'

import msvcrt,\
__getmainargs,'__getmainargs',\
fopen,'fopen',\
fseek,'fseek',\
ftell,'ftell',\
malloc,'malloc',\
free,'free',\
fread,'fread',\
fclose,'fclose',\
printf,'printf',\
_getch,'_getch',\
puts,'puts'

import user32,\
CharToOemA,'CharToOemA'