format PE CONSOLE
include 'win32ax.inc'

section '.code' code readable executable
entry start

start:
 invoke SetConsoleOutputCP,1251
 invoke SetConsoleCP,1251
 cinvoke printf,'%s',<'Привет мир!',13,10,0>

.finish:
 cinvoke puts,'Press any key...'
 cinvoke _getch
 invoke ExitProcess,0

section '.idata' import data readable writeable

library kernel,'kernel32.dll',\
msvcrt,'msvcrt.dll'

import kernel,\
ExitProcess,'ExitProcess',\
SetConsoleOutputCP,'SetConsoleOutputCP',\
SetConsoleCP,'SetConsoleCP'

import msvcrt,\
__getmainargs,'__getmainargs',\
printf,'printf',\
_getch,'_getch',\
puts,'puts'
