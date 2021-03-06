
::2015.10.30  添加刪除DTA語言
::2015.10.23  添加一个Firefox备份文件
::2015.10.10  精簡說明展示方式
::2015.10.04  模塊化每個備份項目，然後再組合，方便修攺維護
::2015.10.02  精簡擴展語言
::2015.10.01  優化輸出地址
::2015.09.26  開啟7zip極限壓縮

@echo off
Title 備份批處理整合版 by Cing
::一次性设置7-zip程序地址
set zip="D:\Program Files\7-Zip\7z.exe"

:menu
cls
ECHO.
ECHO  備份批處理整合版                           
ECHO.
ECHO  01、備份Firefox配置文件夾
ECHO  02、CingFox完整包制作
ECHO  03、備份Plugins和Software文件夾
ECHO  04、提取Flash32位插件
ECHO  05、備份一些文件到GitHub
ECHO.
set /p a=请输入操作序号并回车（例如01）：
cls

if %a%==01 goto Profiles
if %a%==02 goto CingFox
if %a%==03 goto Plugins-n-Software
if %a%==04 goto Flash32
if %a%==05 goto GitHub
goto cho

:Profiles
cls
ECHO.
ECHO  備份Firefox配置文件夾
ECHO.
ECHO  1.执行
ECHO  2.返回
ECHO.
Choice /C 12 /N /M 选择（1、2）：
If ErrorLevel 1 If Not ErrorLevel 2 Goto Profiles-1
If ErrorLevel 2 If Not ErrorLevel 3 Goto menu

:Profiles-1
cls
echo.
echo  1. 需要關閉Firefox程序，請保存必要的資料!
echo  2. 備份完成後，按任意鍵重啟Firefox
echo.
echo  按任意键继续……
pause>nul
cls

rem 設置備份路徑以及臨時文件夾
@echo 關閉火狐瀏覽器后自動開始備份……
cd /d %~dp0
::从批处理所在位置到配置文件夹（Profiles），共跨了3层
set BackDir=..\..\..
set TempFolder=..\..\..\Temp\Profiles
set TempFolder1=..\..\..\Temp\1
set TempFolder2=..\..\..\Temp\2
set TempFolder3=..\..\..\Temp\3

::備份輸出地址
set TargetFolder="D:\My Documents\Baiduyun\Firefox\Profiles"

taskkill /im firefox.exe

rem 复制目标文件到臨時文件夾

::以下是文件夾
::adblockplus：ABP規則備份。
::xcopy "%BackDir%\adblockplus" %TempFolder%\adblockplus\  /s /y /i
::autoproxy：Autoproxy規則備份。
xcopy "%BackDir%\autoproxy" %TempFolder%\autoproxy\  /s /y /i
::browser-extension-data：Redirector擴展的數據文件
xcopy "%BackDir%\browser-extension-data" %TempFolder%\browser-extension-data\ /s /y /i
::chrome：UC腳本。
xcopy "%BackDir%\chrome" %TempFolder%\chrome\  /s /y /i
::extensions：安裝的擴展。
xcopy "%BackDir%\extensions" %TempFolder%\extensions\ /s /y /i
::extension-data：uBlock的數據文件，包含設置。
xcopy "%BackDir%\extension-data" %TempFolder%\extension-data\ /s /y /i
::gm_scripts：安裝的油猴腳本。
xcopy "%BackDir%\gm_scripts" %TempFolder%\gm_scripts\ /s /y /i
::Plugins：便携版插件。
xcopy "%BackDir%\Plugins" %TempFolder%\Plugins\ /s /y /i
::SimpleProxy：SimpleProxy代理列表。
xcopy "%BackDir%\SimpleProxy" %TempFolder%\SimpleProxy\ /s /y /i

::刪除Lastpass的一些项目
::（一）精简Platform
del %TempFolder%\extensions\support@lastpass.com\platform\  /s /q
xcopy "%BackDir%\extensions\support@lastpass.com\platform\WINNT_x86_64-msvc" %TempFolder%\extensions\support@lastpass.com\platform\WINNT_x86_64-msvc\ /s /y /i
::（二）精简lastpass.jar中的语言
%zip% x %TempFolder%\extensions\support@lastpass.com\chrome\lastpass.jar -o%TempFolder1%\lastpass
del %TempFolder%\extensions\support@lastpass.com\chrome\lastpass.jar  /s /q
xcopy "%TempFolder1%\lastpass\locale\en-US" %TempFolder2%\lastpass\locale\en-US\ /s /y /i
xcopy "%TempFolder1%\lastpass\locale\zh-CN" %TempFolder2%\lastpass\locale\zh-CN\ /s /y /i
xcopy "%TempFolder1%\lastpass\locale\zh-TW" %TempFolder2%\lastpass\locale\zh-TW\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder1%\lastpass.jar" "%TempFolder1%\lastpass\content\" "%TempFolder1%\lastpass\icons\" "%TempFolder1%\lastpass\META-INF\" "%TempFolder1%\lastpass\skin\" "%TempFolder2%\lastpass\locale\"
xcopy "%TempFolder1%\lastpass.jar" %TempFolder%\extensions\support@lastpass.com\chrome\ /s /y /i

::刪除Inspector的语言
del %TempFolder%\extensions\inspector@mozilla.org\chrome\inspector\locale\  /s /q
xcopy "%BackDir%\extensions\inspector@mozilla.org\chrome\inspector\locale\en-US" %TempFolder%\extensions\inspector@mozilla.org\chrome\inspector\locale\en-US\ /s /y /i

::刪除FlashGot語言
%zip% x %TempFolder%\extensions\{19503e42-ca3c-4c27-b1e2-9cdb2170ee34}.xpi -o%TempFolder1%\flashgot
del %TempFolder%\extensions\{19503e42-ca3c-4c27-b1e2-9cdb2170ee34}.xpi  /s /q
%zip% x %TempFolder1%\flashgot\chrome\flashgot.jar -o%TempFolder2%\flashgot
del %TempFolder1%\flashgot\chrome\flashgot.jar  /s /q
xcopy "%TempFolder2%\flashgot\locale\en-US" %TempFolder3%\flashgot\locale\en-US\ /s /y /i
xcopy "%TempFolder2%\flashgot\locale\zh-CN" %TempFolder3%\flashgot\locale\zh-CN\ /s /y /i
xcopy "%TempFolder2%\flashgot\locale\zh-TW" %TempFolder3%\flashgot\locale\zh-TW\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder2%\flashgot.jar" "%TempFolder2%\flashgot\content\" "%TempFolder2%\flashgot\skin\" "%TempFolder3%\flashgot\locale\"
xcopy "%TempFolder2%\flashgot.jar" %TempFolder1%\flashgot\chrome\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder1%\{19503e42-ca3c-4c27-b1e2-9cdb2170ee34}.xpi" "%TempFolder1%\flashgot\chrome\" "%TempFolder1%\flashgot\components\" "%TempFolder1%\flashgot\defaults\" "%TempFolder1%\flashgot\META-INF\" "%TempFolder1%\flashgot\chrome.manifest" "%TempFolder1%\flashgot\install.js" "%TempFolder1%\flashgot\install.rdf"
xcopy "%TempFolder1%\{19503e42-ca3c-4c27-b1e2-9cdb2170ee34}.xpi" %TempFolder%\extensions\ /s /y /i

::刪除Stylish語言
%zip% x %TempFolder%\extensions\{46551EC9-40F0-4e47-8E18-8E5CF550CFB8}.xpi -o%TempFolder1%\stylish
del %TempFolder%\extensions\{46551EC9-40F0-4e47-8E18-8E5CF550CFB8}.xpi  /s /q
xcopy "%TempFolder1%\stylish\locale\en-US" %TempFolder2%\stylish\locale\en-US\ /s /y /i
xcopy "%TempFolder1%\stylish\locale\zh-CN" %TempFolder2%\stylish\locale\zh-CN\ /s /y /i
xcopy "%TempFolder1%\stylish\locale\zh-TW" %TempFolder2%\stylish\locale\zh-TW\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder1%\{46551EC9-40F0-4e47-8E18-8E5CF550CFB8}.xpi" "%TempFolder1%\stylish\components\" "%TempFolder1%\stylish\content\" "%TempFolder1%\stylish\defaults\" "%TempFolder1%\stylish\idl\" "%TempFolder1%\stylish\META-INF\" "%TempFolder1%\stylish\skin\" "%TempFolder1%\stylish\chrome.manifest" "%TempFolder1%\stylish\generate_xpt" "%TempFolder1%\stylish\install.rdf" "%TempFolder2%\stylish\locale\"
xcopy "%TempFolder1%\{46551EC9-40F0-4e47-8E18-8E5CF550CFB8}.xpi" %TempFolder%\extensions\ /s /y /i

::刪除ABP語言
%zip% x %TempFolder%\extensions\{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi -o%TempFolder1%\abp
del %TempFolder%\extensions\{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi  /s /q
xcopy "%TempFolder1%\abp\chrome\locale\en-US" %TempFolder2%\abp\chrome\locale\en-US\ /s /y /i
xcopy "%TempFolder1%\abp\chrome\locale\zh-CN" %TempFolder2%\abp\chrome\locale\zh-CN\ /s /y /i
xcopy "%TempFolder1%\abp\chrome\locale\zh-TW" %TempFolder2%\abp\chrome\locale\zh-TW\ /s /y /i
del "%TempFolder1%\abp\chrome\locale"  /s /q
xcopy "%TempFolder2%\abp\chrome\locale" %TempFolder1%\abp\chrome\locale\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder1%\{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi" "%TempFolder1%\abp\chrome\" "%TempFolder1%\abp\defaults\" "%TempFolder1%\abp\lib\" "%TempFolder1%\abp\META-INF\" "%TempFolder1%\abp\bootstrap.js" "%TempFolder1%\abp\chrome.manifest" "%TempFolder1%\abp\icon.png" "%TempFolder1%\abp\icon64.png" "%TempFolder1%\abp\install.rdf"
xcopy "%TempFolder1%\{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi" %TempFolder%\extensions\ /s /y /i

::刪除EHH語言
%zip% x %TempFolder%\extensions\elemhidehelper@adblockplus.org.xpi -o%TempFolder1%\ehh
del %TempFolder%\extensions\elemhidehelper@adblockplus.org.xpi  /s /q
xcopy "%TempFolder1%\ehh\chrome\locale\en-US" %TempFolder2%\ehh\chrome\locale\en-US\ /s /y /i
xcopy "%TempFolder1%\ehh\chrome\locale\zh-CN" %TempFolder2%\ehh\chrome\locale\zh-CN\ /s /y /i
xcopy "%TempFolder1%\ehh\chrome\locale\zh-TW" %TempFolder2%\ehh\chrome\locale\zh-TW\ /s /y /i
del "%TempFolder1%\ehh\chrome\locale"  /s /q
xcopy "%TempFolder2%\ehh\chrome\locale" %TempFolder1%\ehh\chrome\locale\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder1%\elemhidehelper@adblockplus.org.xpi" "%TempFolder1%\ehh\chrome\" "%TempFolder1%\ehh\defaults\" "%TempFolder1%\ehh\lib\" "%TempFolder1%\ehh\META-INF\" "%TempFolder1%\ehh\bootstrap.js" "%TempFolder1%\ehh\chrome.manifest" "%TempFolder1%\ehh\icon.png" "%TempFolder1%\ehh\icon64.png" "%TempFolder1%\ehh\install.rdf"
xcopy "%TempFolder1%\elemhidehelper@adblockplus.org.xpi" %TempFolder%\extensions\ /s /y /i

::刪除Greasemonkey語言
%zip% x %TempFolder%\extensions\{e4a8a97b-f2ed-450b-b12d-ee082ba24781}.xpi -o%TempFolder1%\gm
del %TempFolder%\extensions\{e4a8a97b-f2ed-450b-b12d-ee082ba24781}.xpi  /s /q
xcopy "%TempFolder1%\gm\locale\en-US" %TempFolder2%\gm\locale\en-US\ /s /y /i
xcopy "%TempFolder1%\gm\locale\zh-CN" %TempFolder2%\gm\locale\zh-CN\ /s /y /i
xcopy "%TempFolder1%\gm\locale\zh-TW" %TempFolder2%\gm\locale\zh-TW\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder1%\{e4a8a97b-f2ed-450b-b12d-ee082ba24781}.xpi" "%TempFolder1%\gm\components\" "%TempFolder1%\gm\content\" "%TempFolder1%\gm\defaults\" "%TempFolder1%\gm\META-INF\" "%TempFolder1%\gm\modules\" "%TempFolder1%\gm\skin\" "%TempFolder1%\gm\chrome.manifest" "%TempFolder1%\gm\CREDITS" "%TempFolder1%\gm\install.rdf" "%TempFolder1%\gm\LICENSE.bsd" "%TempFolder1%\gm\LICENSE.mit" "%TempFolder1%\gm\LICENSE.mpl" "%TempFolder2%\gm\locale\"
xcopy "%TempFolder1%\{e4a8a97b-f2ed-450b-b12d-ee082ba24781}.xpi" %TempFolder%\extensions\ /s /y /i

::刪除DownThemAll!語言
%zip% x %TempFolder%\extensions\{DDC359D1-844A-42a7-9AA1-88A850A938A8}.xpi -o%TempFolder1%\DTA
del %TempFolder%\extensions\{DDC359D1-844A-42a7-9AA1-88A850A938A8}.xpi  /s /q
%zip% x %TempFolder1%\DTA\chrome\chrome.jar -o%TempFolder2%\DTA
del %TempFolder1%\DTA\chrome\chrome.jar  /s /q
xcopy "%TempFolder2%\DTA\locale\en-US" %TempFolder3%\DTA\locale\en-US\ /s /y /i
xcopy "%TempFolder2%\DTA\locale\zh-CN" %TempFolder3%\DTA\locale\zh-CN\ /s /y /i
xcopy "%TempFolder2%\DTA\locale\zh-TW" %TempFolder3%\DTA\locale\zh-TW\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder2%\chrome.jar" "%TempFolder2%\DTA\content\" "%TempFolder3%\DTA\locale\"  "%TempFolder2%\DTA\public\"  "%TempFolder2%\DTA\skin\"
xcopy "%TempFolder2%\chrome.jar" %TempFolder1%\DTA\chrome\ /s /y /i
%zip% a -tzip -mx9 "%TempFolder1%\{DDC359D1-844A-42a7-9AA1-88A850A938A8}.xpi" "%TempFolder1%\DTA\chrome\" "%TempFolder1%\DTA\components\" "%TempFolder1%\DTA\defaults\" "%TempFolder1%\DTA\interfaces\" "%TempFolder1%\DTA\META-INF\" "%TempFolder1%\DTA\modules\" "%TempFolder1%\DTA\chrome.manifest" "%TempFolder1%\DTA\GPL" "%TempFolder1%\DTA\icon.png" "%TempFolder1%\DTA\install.rdf" "%TempFolder1%\DTA\LGPL" "%TempFolder1%\DTA\LICENSE" "%TempFolder1%\DTA\MPL"
xcopy "%TempFolder1%\{DDC359D1-844A-42a7-9AA1-88A850A938A8}.xpi" %TempFolder%\extensions\ /s /y /i


::其它刪除项
del %TempFolder%\chrome\UserScriptLoader\require\  /s /q
del %TempFolder%\extensions\userChromeJS@mozdev.org\content\myNewTab\bingImg\  /s /q

::以下是文件
::bookmarks.html：自動导出的书签備份。
xcopy "%BackDir%\bookmarks.html" %TempFolder%\ /y
::cert_override.txt：储存使用者指定的例外证书(certification exceptions)。
xcopy "%BackDir%\cert_override.txt" %TempFolder%\ /y
::cert8.db：安全证书。
xcopy "%BackDir%\cert8.db" %TempFolder%\ /y
::extensions.json：扩展启用禁用状态
::xcopy "%BackDir%\extensions.json" %TempFolder%\ /y
::FlashGot.exe：FlashGot的下载工具。
xcopy "%BackDir%\FlashGot.exe" %TempFolder%\ /y
::foxyproxy.xml：FoxyProxy的設置及网址列表備份。
::xcopy "%BackDir%\foxyproxy.xml" %TempFolder%\ /y
::mimeTypes.rdf：下载特定类型的档案時要执行的動作。 可刪掉来还原原来下载的設定。
xcopy "%BackDir%\mimeTypes.rdf" %TempFolder%\ /y
::MyFirefox.7z：用於官方FX的便携設置。
xcopy "%BackDir%\MyFirefox.7z" %TempFolder%\ /y
::patternSubscriptions.json：FoxyProxy的訂閱列表設置。
::xcopy "%BackDir%\patternSubscriptions.json" %TempFolder%\ /y
::permissions.sqlite：存放特定网站是否可存取密码、cookies、弹出视窗、图片载入与附加元件……等权限的资料库。
xcopy "%BackDir%\permissions.sqlite" %TempFolder%\ /y
::persdict.dat：个人的拼字字典。
xcopy "%BackDir%\persdict.dat" %TempFolder%\ /y
::pluginreg.dat：用于plugin的MIME types。
xcopy "%BackDir%\pluginreg.dat" %TempFolder%\ /y
::Portable.7z：PCXFirefox的便携設置。
xcopy "%BackDir%\Portable.7z" %TempFolder%\ /y
::prefs.js：About:config中儲存的設定。
::xcopy "%BackDir%\prefs.js" %TempFolder%\ /y
::readme.txt：个人配置修改说明。
xcopy "%BackDir%\readme.txt" %TempFolder%\ /y
::stylish.sqlite：Stylish样式數据库。
xcopy "%BackDir%\stylish.sqlite" %TempFolder%\ /y
::user.js：使用者自订的設定，在这里的設定覆盖默认設定。
xcopy "%BackDir%\user.js" %TempFolder%\ /y
::xulstore.json：界面的一些状态。
xcopy "%BackDir%\xulstore.json" %TempFolder%\ /y

::讀取版本號和日期及時間
::从批处理所在位置到Firefox程序文件夹（firefox），共跨了4层
for /f "usebackq eol=; tokens=1,2 delims==" %%i in ("..\..\..\..\Firefox\application.ini")do (if %%i==Version set ver=%%j)
::設置備份文件路徑以及文件名

ECHO.&ECHO.Profiles文件夾已複製完成，請按任意鍵繼續！&PAUSE >NUL 2>NUL

:Profiles or CingFox
cls
ECHO.
ECHO  備份Firefox配置文件夾 or CingFox
ECHO.
ECHO  1.備份Firefox配置文件夾
ECHO  2.接著製作CingFox(之二)
ECHO.
Choice /C 12 /N /M 选择（1、2）：
If ErrorLevel 1 If Not ErrorLevel 2 Goto Profiles-2
If ErrorLevel 2 If Not ErrorLevel 3 Goto Plugins-n-Software-1

:Profiles-2
cls
::完整日期和時間
set tm1=%time:~0,2%
set tm2=%time:~3,2%
set tm3=%time:~6,2%
set tm4=%time:~0,8%
set da1=%date:~0,4%
set da2=%date:~5,2%
set da3=%date:~8,2%
::輸出文件名
set Name=Profiles_%da1%%da2%%da3%-%tm1%%tm2%%tm3%_%ver%.7z

::小時數小于10点時的修正
set /a tm1=%time:~0,2%*1
if %tm1% LSS 10 set tm1=0%tm1%
::輸出文件名
set Name=Profiles_%da1%%da2%%da3%-%tm1%%tm2%%tm3%_%ver%.7z

rem 開始備份
::-mx9极限压缩 -mhc开启档案文件头压缩 -r递归到所有的子目录
%zip% -mx9 -mhc -r u -up1q3r2x2y2z2w2 %TargetFolder%\%Name% "%TempFolder%"
@echo 備份完成！并刪除臨時文件夾！
rd "%TempFolder%" "%TempFolder1%" "%TempFolder2%" "%TempFolder3%" /s/q

ECHO.&ECHO.Firefox配置已打包完成，請按任意鍵 重啟Firefox 並退出！&PAUSE >NUL 2>NUL

@ping 127.0.0.1>nul
@start ..\..\..\..\Firefox\firefox.exe

Goto end

:CingFox
cls
ECHO.
ECHO  CingFox完整包制作
ECHO.
ECHO  1.执行
ECHO  2.返回
ECHO.
Choice /C 12 /N /M 选择（1、2）：
If ErrorLevel 1 If Not ErrorLevel 2 Goto CingFox-1
If ErrorLevel 2 If Not ErrorLevel 3 Goto menu

:CingFox-1
cls
echo.
echo  *** CingFox完整包制作 ***
echo.
echo  1. 需要關閉Firefox程序，請保存必要的資料!
echo  2. 3个步驟：Profiles + Plugins&Software + firefox
echo  3. 備份完成後，按任意鍵重啟Firefox
echo.
echo  按任意键继续……
pause>nul
cls

goto Profiles-1

:pcxFirefox
cls
Title CingFox完整包制作

set BackDir=..\..\..\..
set TempFolder=..\..\..\Temp
xcopy "%BackDir%\firefox" %TempFolder%\firefox\  /s /y /i
goto CingFox-2

:CingFox-2
cls
::CingFox輸出地址
set TargetFolder="D:"

::需要刪除的项
del %TempFolder%\Software\GFW\goagent\  /s /q
del %TempFolder%\Software\GFW\IP-Update\  /s /q
del %TempFolder%\Software\GFW\Shadowsocks\  /s /q
del %TempFolder%\Software\GFW\psiphon\psiphon3.exe.orig  /s /q
del %TempFolder%\Profiles\bookmarks.html  /s /q

::給套一個主文件夾CingFox
xcopy "%TempFolder%\firefox" %TempFolder%\CingFox\firefox\ /s /y /i
xcopy "%TempFolder%\Profiles" %TempFolder%\CingFox\Profiles\ /s /y /i
xcopy "%TempFolder%\Plugins" %TempFolder%\CingFox\Plugins\ /s /y /i
xcopy "%TempFolder%\Software" %TempFolder%\CingFox\Software\ /s /y /i

::完整日期和時間
set tm1=%time:~0,2%
set tm2=%time:~3,2%
set tm3=%time:~6,2%
set tm4=%time:~0,8%
set da1=%date:~0,4%
set da2=%date:~5,2%
set da3=%date:~8,2%
::輸出文件名
set Name=CingFox_%da1%%da2%%da3%-%tm1%%tm2%%tm3%_%ver%.7z

::小時數小于10点時的修正
set /a tm1=%time:~0,2%*1
if %tm1% LSS 10 set tm1=0%tm1%
::輸出文件名
set Name=CingFox_%da1%%da2%%da3%-%tm1%%tm2%%tm3%_%ver%.7z

rem 開始備份
::-mx9极限压缩 -mhc开启档案文件头压缩 -r递归到所有的子目录
%zip% -mx9 -mhc -r u -up1q3r2x2y2z2w2 %TargetFolder%\%Name% "%TempFolder%\CingFox\"
@echo 備份完成！并刪除臨時文件夾！
rd "%TempFolder%" /s/q

ECHO.&ECHO.Firefox完整包已打包完成，請按任意鍵 重啟Firefox 並退出！&PAUSE >NUL 2>NUL

@ping 127.0.0.1>nul
@start ..\..\..\..\Firefox\firefox.exe

Goto end

:Plugins-n-Software
cls
ECHO.
ECHO  備份Plugins和Software文件夾
ECHO.
ECHO  1.执行
ECHO  2.返回
ECHO.
Choice /C 12 /N /M 选择（1、2）：
If ErrorLevel 1 If Not ErrorLevel 2 Goto Plugins-n-Software-1
If ErrorLevel 2 If Not ErrorLevel 3 Goto menu

:Plugins-n-Software-1
cls
echo.
echo  *** 備份Plugins和Software文件夾 ***
echo.
echo  含Plugins和Software兩個文件夾
echo.
pause>nul
cls

rem 設置備份路徑以及臨時文件夾
cd /d %~dp0
::从批处理所在位置到Plugins和Software文件夾，只跨了4层
set BackDir=..\..\..\..\
set TempFolder=..\..\..\Temp

rem 复制目标文件到臨時文件夾

::以下是文件夾
::Plugins：外置便携插件
xcopy "%BackDir%\Plugins" %TempFolder%\Plugins\  /s /y /i
::Software：常用軟件
xcopy "%BackDir%\Software" %TempFolder%\Software\  /s /y /i

::需要刪除的项
del %TempFolder%\Plugins\sumatrapdfcache\  /s /q 
del %TempFolder%\Software\GFW\psiphon\psiphon3.exe.orig  /s /q 
del %TempFolder%\Software\GFW\GoGoTester\gogo_cache  /s /q 

ECHO.&ECHO.Plugins和Software文件夾已打包完成，請按任意鍵退出！&PAUSE >NUL 2>NUL

:Plugins-n-Software or CingFox
cls
ECHO.
ECHO  備份Plugins和Software or CingFox
ECHO.
ECHO  1.備份Plugins和Software
ECHO  2.接著製作CingFox(之三)
ECHO.
Choice /C 12 /N /M 选择（1、2）：
If ErrorLevel 1 If Not ErrorLevel 2 Goto Plugins-n-Software-2
If ErrorLevel 2 If Not ErrorLevel 3 Goto pcxFirefox

:Plugins-n-Software-2
cls
::輸出地址
set TargetFolder="D:\My Documents\Baiduyun\Firefox\Profiles\Software & Plugins"

::設置備份文件路徑以及文件名

::完整日期和時間
set tm1=%time:~0,2%
set tm2=%time:~3,2%
set tm3=%time:~6,2%
set tm4=%time:~0,8%
set da1=%date:~0,4%
set da2=%date:~5,2%
set da3=%date:~8,2%
set Name=Plugins-n-Software_%da1%%da2%%da3%-%tm1%%tm2%%tm3%.7z

::小時數小于10点時的修正
set /a tm1=%time:~0,2%*1
if %tm1% LSS 10 set tm1=0%tm1%
set Name=Plugins-n-Software_%da1%%da2%%da3%-%tm1%%tm2%%tm3%.7z

rem 開始備份
::-mx9极限压缩 -mhc开启档案文件头压缩 -r递归到所有的子目录
%zip% -mx9 -mhc -r u -up1q3r2x2y2z2w2 %TargetFolder%\%Name% "%TempFolder%\Plugins" "%TempFolder%\Software"
@echo 備份完成！并刪除臨時文件夾！
rd "%TempFolder%" /s/q

ECHO.&ECHO.Plugins和Software文件夾已打包完成，請按任意鍵退出！&PAUSE >NUL 2>NUL

Goto end

:Flash32
cls
ECHO.
ECHO  提取Flash32位插件
ECHO.
ECHO  1.执行
ECHO  2.返回
ECHO.
Choice /C 12 /N /M 选择（1、2）：
If ErrorLevel 1 If Not ErrorLevel 2 Goto Flash32-1
If ErrorLevel 2 If Not ErrorLevel 3 Goto menu

:Flash32-1
cls
echo.
echo  *** 提取Flash32位插件 ***
echo.
echo  01、到官方下载非IE版Flash插件安装后提取！
echo  02、已经安装非IE版Flash插件的直接提取！
echo  03、返回主菜單。
echo.
set /p id=请选择，按回车键执行（例如：01）:
cls

if "%id%"=="01" goto install
if "%id%"=="02" goto set
if "%id%"=="03" goto menu

:install
cls
echo.
echo  01、到Flash官方下載最新正式版！
echo  02、到Flash官方下載最新beta版！
echo  03、返回主菜單。
echo.
set /p id=请选择，按回车键执行（例如：01）:
cls

if "%id%"=="01" goto download1
if "%id%"=="02" goto download2
if "%id%"=="03" goto menu

:download1
cls
start "" http://www.adobe.com/in/products/flashplayer/distribution3.html
echo.
echo  *请暂时不要关闭该批处理……
echo.
echo  *如果您已安装完毕Adobe Flash Player插件，请按任意键继续……
pause>nul
goto set

:download2
cls
start "" http://labs.adobe.com/downloads/flashplayer.html
echo.
echo  *请暂时不要关闭该批处理……
echo.
echo  *如果您已安装完毕Adobe Flash Player插件，请按任意键继续……
pause>nul
goto set

:set
cd /d %~dp0
set BackDir=C:\Windows\SysWOW64\Macromed\Flash
set TempFolder=D:\Temp

::輸出地址
set TargetFolder="D:\My Documents\Baiduyun\Firefox\【FX共享】\Flash32位原版提取帶vch和exe"

::複製插件到臨時文件夾
xcopy "%BackDir%\NPSWF32*.dll" %TempFolder%\  /s /y /i
xcopy "%BackDir%\FlashPlayerPlugin*.exe" %TempFolder%\  /s /y /i
xcopy "%BackDir%\plugin.vch" %TempFolder%\  /s /y /i

::讀取版本號
::找了好久，妙終於在這個回答找到了答案：http://zhidao.baidu.com/question/289963233.html
for /f "delims=" %%i in ('dir /a-d /b "%BackDir%\NPSWF32*.dll"') do (set ver=%%i)
echo %ver%

::完整日期和時間
set tm1=%time:~0,2%
set tm2=%time:~3,2%
set tm3=%time:~6,2%
set tm4=%time:~0,8%
set da1=%date:~0,4%
set da2=%date:~5,2%
set da3=%date:~8,2%
set Name=%ver%_%da1%%da2%%da3%-%tm1%%tm2%%tm3%.7z

::小時數小于10点時的修正
set /a tm1=%time:~0,2%*1
if %tm1% LSS 10 set tm1=0%tm1%
set Name=%ver%_%da1%%da2%%da3%-%tm1%%tm2%%tm3%.7z

rem 開始備份
::-mx9极限压缩 -mhc开启档案文件头压缩 -r递归到所有的子目录
%zip% -mx9 -mhc -r u -up1q3r2x2y2z2w2 %TargetFolder%\%Name% "%TempFolder%\NPSWF32*.dll" "%TempFolder%\FlashPlayerPlugin*.exe" "%TempFolder%\plugin.vch"

@echo 備份完成！并刪除臨時文件夾！
rd "%TempFolder%"  /s/q

ECHO.&ECHO.已打包完成，請按任意鍵退出，將跳轉到系統/控制面板/程序與功能！&PAUSE >NUL 2>NUL

::跳轉到系統/控制面板/程序與功能
appwiz.cpl
rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl

Goto end

:GitHub
cls
ECHO.
ECHO  備份一些文件到GitHub
ECHO.
ECHO  1.执行
ECHO  2.返回
ECHO.
Choice /C 12 /N /M 选择（1、2）：
If ErrorLevel 1 If Not ErrorLevel 2 Goto GitHub-1
If ErrorLevel 2 If Not ErrorLevel 3 Goto menu

:GitHub-1
cls
echo.
echo  *** 備份一些文件到GitHub ***
echo.
echo  1. 個人參數設置：user.js
echo  2. 詞典：persdict.dat
echo  3. Stylish樣式庫：stylish.sqlite
echo.
echo  按任意键继续……
pause>nul
cls

rem 設置備份路徑以及臨時文件夾
cd /d %~dp0
set dir1=..\..\..
set dir2=D:\My Documents\GitHub\Customization
xcopy "%dir1%\persdict.dat" "%dir2%\persdict.dat"  /s /y /i
xcopy "%dir1%\stylish.sqlite" "%dir2%\stylish.sqlite"  /s /y /i
xcopy "%dir1%\user.js" "%dir2%\user.js"  /s /y /i

ECHO.&ECHO.備份一些文件到GitHub已完成，請按任意鍵退出！&PAUSE >NUL 2>NUL

Goto end

:end
cls
ECHO  已完成！下一步？
ECHO.
ECHO  1.退出
ECHO  2.返回主菜單
ECHO.
Choice /C 12 /N /M 选择（1、2）：
If ErrorLevel 1 If Not ErrorLevel 2 Goto exit
If ErrorLevel 2 If Not ErrorLevel 3 Goto menu
