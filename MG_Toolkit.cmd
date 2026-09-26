:: Paramétrage du script et vérification de la compatibilité
@echo off
pushd "%~dp0"
chcp 1252 >nul
setlocal DisableDelayedExpansion
set toolkit_version=20260926
title MG Toolkit (v%toolkit_version%)
mode con cols=90 lines=40
ver | find /i "version 10" >nul 2>&1
if errorlevel 1 (
	goto OSNoOK
)
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-CimInstance -ClassName Win32_OperatingSystem).Caption"') do set Caption=%%i
for /f "tokens=4,5,6,7 delims=[]. " %%g in ('ver') do (set major=%%g& set minor=%%h& set build=%%i& set revision=%%j)
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-CimInstance Win32_BIOS).Manufacturer"') do set BIOS_FABRICANT=%%i
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion"') do set BIOS_VERSION=%%i



:: Contrôle des droits d'administrateur
if /i not "%~1"=="admin" (
	powershell -NoProfile -Command "Start-Process -Verb RunAs -FilePath '%~f0' -ArgumentList 'admin'"
	exit /b
)



:: Coloration du texte
set u=[0m
set blink=[5m
set bold=[1m
set inverse=[7m
set under=[4m
set blue=[94m
set brown=[38;5;94m
set crimson=[91m
set cyan=[96m
set gray=[90m
set green=[92m
set lime=[38;5;154m
set orange=[38;5;214m
set red=[31m
set pink=[95m
set purple=[35m
set white=[37m
set yellow=[33m



:: Vérification de la présence d'une mise à jour
echo.
call :titre
echo.
echo Vérification de la présence d'une mise à jour...
echo.
del /f /q "%TEMP%\version.txt" >nul 2>&1
powershell -NoProfile -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/version.txt', '%TEMP%\version.txt')" >nul 2>&1
set /p controle_version_toolkit=<%TEMP%\version.txt >nul 2>&1
if exist "%TEMP%\version.txt" (
	if not "%controle_version_toolkit%"=="%toolkit_version%" (
		powershell -NoProfile -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/MG_Toolkit.cmd', '%~dp0MG_Toolkit_new.cmd')"
		if exist "%~dp0MG_Toolkit_new.cmd" (
			timeout /t 1 >nul
			del /f /q "%~dp0MG_Toolkit.cmd" >nul 2>&1
			rename "%~dp0MG_Toolkit_new.cmd" "MG_Toolkit.cmd" >nul 2>&1
			echo La version %green%%controle_version_toolkit%%u% a été téléchargée avec succès
			echo Veuillez exécuter à nouveau le programme
			echo.
			pause
			exit /b
		) else (
			echo %red%Échec du téléchargement de la mise à jour%u%
		)
	)
) else (
	echo %red%Échec de la vérification de la mise à jour%u%
)



:: Controle de la version de Windows utilisée
:AfterTest
	cls
	echo.
	call :titre
	echo.
	echo.
	echo 	%under%Votre configuration système :%u%
	echo.
	echo 	Fabricant :              %BIOS_FABRICANT%
	echo 	Version du BIOS :        %BIOS_VERSION%
	echo 	Système d'exploitation : %Caption%
	echo 	Architecture :           %PROCESSOR_ARCHITECTURE%
	echo 	Version :                %major%.%minor%.%build%.%revision%
	for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" 2^>nul ^| Find "BuildLabEx" 2^>nul') do (
		echo 	Build :                  %%b
	)
	goto OSOK

:OSNoOK
	echo.
	echo __________________________________________________________________________________________
	echo.
	echo            Votre OS n'est pas compatible (minimum Windows 10 / Server 2016)
	echo                         Le programme va maintenant se fermer
	echo __________________________________________________________________________________________
	echo.
	pause
exit

:OSOK
	echo.
	echo __________________________________________________________________________________________
	echo.
	echo %green%                               Votre système est compatible%u%
	echo %green%       !!! Il est recommandé de désactiver votre antivirus avant de poursuivre !!!%u%
	echo __________________________________________________________________________________________
	echo.
	pause
goto main



:: Menu principal
:main
	cls
	echo.
	call :titre
	echo.
	echo   %gray%%under%Activation de Windows / Office / ESU%u%
	echo.
	echo 	1.  Activation (MAS)			2.  Status d'activation
	echo.
	echo   %gray%%under%Utilitaires de configuration et maintenance%u%
	echo.
	echo 	3.  Configuration performances		5.  Ajout/suppression fonctionnalités
	echo 	4.  Configuration vie privée		6.  Modification informations OEM
	echo.
	echo   %gray%%under%Utilitaires de maintenance%u%
	echo.
	echo 	7.  Défragmentation système		13. Réparation référentiel WMI %red%/!\%u%
	echo 	8.  Nettoyage système			14. Réparation réseau
	echo 	9.  Nettoyage système complet %red%/!\%u%	15. Réparation réseau complète
	echo 	10. Nettoyage Windows Installer %red%/!\%u%	16. Réparation système Windows
	echo 	11. Réparation apps Windows		17. Réparation Windows Installer
	echo 	12. Réparation cache d'icônes		18. Réparation Windows Update
	echo.
	echo   %gray%%under%Divers%u%
	echo.
	echo 	19. Installer des mises à jour		20. Logithèque en ligne
	echo.
	echo __________________________________________________________________________________________
	echo.
	set /p choix=Sélectionnez l'opération à effectuer (0 pour quitter): 
	if /i "%choix%"=="1" goto activation_mas
	if /i "%choix%"=="2" goto activation_status
	if /i "%choix%"=="3" goto configuration_performances
	if /i "%choix%"=="4" goto configuration_privacy
	if /i "%choix%"=="5" OptionalFeatures.exe
	if /i "%choix%"=="6" goto oem_information
	if /i "%choix%"=="7" goto defrag
	if /i "%choix%"=="8" goto nettoyage_basique
	if /i "%choix%"=="9" goto nettoyage_complet
	if /i "%choix%"=="10" goto nettoyage_windows_installer
	if /i "%choix%"=="11" goto reparation_apps
	if /i "%choix%"=="12" goto reparation_icones
	if /i "%choix%"=="13" goto reparation_wmi
	if /i "%choix%"=="14" goto reparation_reseau_basique
	if /i "%choix%"=="15" goto reparation_reseau_complet
	if /i "%choix%"=="16" goto reparation_win
	if /i "%choix%"=="17" goto reparation_win_intaller
	if /i "%choix%"=="18" goto reparation_wu
	if /i "%choix%"=="19" goto windows_update
	if /i "%choix%"=="20" start https://1drv.ms/f/c/011dbcd351618514/IgAUhWFR07wdIIAB3voDAAAAAcBLZB30-366q14Z-fKgndE
	if /i "%choix%"=="0" exit
goto main



:: Activation de Windows / Office / ESU
:activation_mas
	cls
	echo.
	call :titre
	echo.
	echo %red%Activation de Windows - Office - ESU (MAS)%u%
	echo.
	echo IMPORTANT :
	echo Une connexion Internet est requise.
	echo Il est nécessaire de désactiver votre antivirus avant de poursuivre !
	echo.
	pause
	powershell -Command "(irm https://get.activated.win | iex)" >nul 2>&1
goto main



:: Status de l'activation de Windows / Office
:activation_status
	cls
	echo.
	call :titre
	echo.
	echo %red%Status de l'activation de Windows%u%
	echo.
	ver
	cscript //nologo "%SYSTEMROOT%\System32\slmgr.vbs" /dli
	cscript //nologo "%SYSTEMROOT%\System32\slmgr.vbs" /xpr
	echo.
	echo %red%Status de l'activation d'Office%u%
	set "office_found=0"
	for %%D in (
		"%ProgramFiles%\Microsoft Office\Office14"
		"%ProgramFiles(x86)%\Microsoft Office\Office14"
		"%ProgramFiles%\Microsoft Office\Office15"
		"%ProgramFiles(x86)%\Microsoft Office\Office15"
		"%ProgramFiles%\Microsoft Office\Office16"
		"%ProgramFiles(x86)%\Microsoft Office\Office16"
		"%ProgramFiles%\Microsoft Office\root\Office16"
		"%ProgramFiles(x86)%\Microsoft Office\root\Office16"
	) do (
		if exist "%%~D\OSPP.VBS" (
			set "office_found=1"
			echo.
			cscript //nologo "%%~D\OSPP.VBS" /dstatus
		)
	)
	if "%office_found%"=="0" (
		echo.
		echo Aucune version compatible d'Office n'a été détectée.
	)
	echo.
	pause
goto main



:: Configuration optimale de Windows
:configuration_performances
	cls
	echo.
	call :titre
	echo.
	echo %red%Configuration optimale de Windows%u%
	netsh int ipv4 set glob defaultcurhoplimit=65 >nul 2>&1
	netsh int ipv6 set glob defaultcurhoplimit=65 >nul 2>&1
	netsh int tcp set global autotuninglevel=normal >nul 2>&1
	netsh int tcp set global chimney=disabled >nul 2>&1
	netsh int tcp set global dca=enabled >nul 2>&1
	netsh int tcp set global ecncapability=enabled >nul 2>&1
	netsh int tcp set global initialRto=1000 >nul 2>&1
	netsh int tsp set global maxsynretransmissions=2 >nul 2>&1
	netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1
	netsh int tcp set global rsc=disabled >nul 2>&1
	netsh int tcp set global rss=enabled >nul 2>&1
	netsh int tcp set global timestamps=disabled >nul 2>&1
	netsh int tcp set heuristics disabled >nul 2>&1
	netsh int tcp set supplemental Internet congestionprovider=CUBIC >nul 2>&1
	netsh int tcp set supplemental template=custom icw=10 >nul 2>&1
	powercfg -list | findstr /i "a1841308-3541-4fab-bc81-f71556f20b4a" >nul 2>&1
	if errorlevel 1 powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1
	powercfg -list | findstr /i "381b4222-f694-41f0-9685-ff5bb260df2e" >nul 2>&1
	if errorlevel 1 powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
	powercfg -list | findstr /i "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" >nul 2>&1
	if errorlevel 1 powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
	powercfg -list | findstr /i "e9a42b02-d5df-448d-aa00-03f14749eb61" >nul 2>&1
	if errorlevel 1 powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
	reg add "HKCR\*\shell\Ouvrir avec Notepad" /v Icon /t REG_SZ /d "notepad.exe,-2" /f >nul 2>&1
	reg add "HKCR\*\shell\Ouvrir avec Notepad\command" /ve /t REG_SZ /d "notepad.exe %%1" /f >nul 2>&1
	reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f >nul 2>&1
	reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 3000 /f >nul 2>&1
	reg add "HKCU\Control Panel\Desktop" /v LowLevelHooksTimeout /t REG_SZ /d 4000 /f >nul 2>&1
	reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 10000 /f >nul 2>&1
	reg add "HKCU\Control Panel\Desktop" /v WaitToKillServiceTimeout /t REG_SZ /d 1000 /f >nul 2>&1
	reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
	reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /t REG_SZ /d "NotSpecified" /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v explorer.exe /t REG_DWORD /d 8 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v iexplore.exe /t REG_DWORD /d 8 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v explorer.exe /t REG_DWORD /d 8 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v iexplore.exe /t REG_DWORD /d 8 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v DesktopProcess /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackDocs /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v ConfirmFileDelete /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoResolveTrack /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SYSTEM\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SYSTEM\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d Y /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v value /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v MaxCachedIcons /t REG_SZ /d 4096 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPer1_0Server /t REG_DWORD /d 10 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPerServer /t REG_DWORD /d 10 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v MemCheckBoxInRunDlg /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowgameDVR /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AllowMUUpdateService /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 1000 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v AutoReboot /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisable8dot3NameCreation /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsMftZoneReservation /t REG_DWORD /d 4 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Windows32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v remoteregaccess /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 2 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheEntryTtlLimit /t REG_DWORD /d 10800 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheTtl /t REG_DWORD /d 10800 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxNegativeCacheTtl /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v NegativeSoaCacheTime /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v NetFailureCacheTime /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Size /t REG_DWORD /d 3 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DisableTaskOffload /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUBHDetect /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v NameSrvQueryTimeout /t REG_DWORD /d 3000 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpMaxDupAcks /t REG_DWORD /d 2 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v DnsPriority /t REG_DWORD /d 6 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v HostsPriority /t REG_DWORD /d 5 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v LocalPriority /t REG_DWORD /d 4 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v NetbtPriority /t REG_DWORD /d 7 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WOW" /v DefaultSeparateVDM /t REG_SZ /d Yes /f >nul 2>&1
	echo.
	echo %red%Configuration des fonctionnalités de Windows%u%
	if %build% LSS 28000 (
		dism.exe /online /enable-feature /featurename:NetFX3 /quiet /norestart >nul 2>&1
	)
	echo.
	echo %red%Configuration des services Windows%u%
	sc stop RemoteRegistry >nul 2>&1
	sc config RemoteRegistry start= Disabled >nul 2>&1
	sc stop VSS >nul 2>&1
	sc config VSS start= Disabled >nul 2>&1
	sc stop WerSvc >nul 2>&1
	sc config WerSvc start= Disabled >nul 2>&1
	echo.
	echo %red%Configuration du nettoyage de disque Windows%u%
	cleanmgr /sageset:1
	echo.
	echo %red%Désactivation de la veille prolongée%u%
	powercfg -hibernate off >nul 2>&1
	echo.
	powershell -NoProfile -command "Get-PhysicalDisk | select MediaType" | find /i "SD" >nul 2>&1
	if %errorlevel%==0 (
		echo %red%Optimisation du SSD%u%
		fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
		fsutil behavior set DisableLastAccess 1 >nul 2>&1
		reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d N /f >nul 2>&1
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableBoottrace /t REG_DWORD /d 0 /f >nul 2>&1
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
		sc stop Superfetch >nul 2>&1
		sc config Superfetch start= Disabled >nul 2>&1
		sc stop SysMain >nul 2>&1
		sc config SysMain start= Disabled >nul 2>&1
		sc stop WSearch >nul 2>&1
		sc config WSearch start= Auto >nul 2>&1
		schtasks /Delete /F /TN "Microsoft\Windows\Defrag\ScheduledDefrag" >nul 2>&1
		echo.
	) else (
		sc stop WSearch >nul 2>&1
		sc config WSearch start= Disabled >nul 2>&1
	)
	echo %green%Optimisation terminée%u%
	echo.
	call :callforrestart
goto main



:: Désactivation de la télémétrie et vie privée Windows
:configuration_privacy
	cls
	echo.
	call :titre
	echo.
	echo %red%Désactivation des services de télémétrie%u%
	sc stop DiagTrack >nul 2>&1
	sc stop diagnosticshub.standardcollector.service >nul 2>&1
	sc stop dmwappushservice >nul 2>&1
	sc stop WMPNetworkSvc >nul 2>&1
	sc config DiagTrack start= Disabled >nul 2>&1
	sc config diagnosticshub.standardcollector.service start= Disabled >nul 2>&1
	sc config dmwappushservice start= Disabled >nul 2>&1
	sc config WMPNetworkSvc start= Disabled >nul 2>&1
	echo.
	echo %red%Désactivation des tâches planifiées%u%
	schtasks /Change /DISABLE /TN "Microsoft\Windows\SetupSQMTask" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\BthSQM" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\TelTask" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Application Experience\AitAgent" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" >nul 2>&1
	schtasks /Change /DISABLE /TN "Microsoft\Windows\PerfTrack\BackgroundConfigSurveyor" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\SetupSQMTask" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\BthSQM" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\TelTask" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\Application Experience\AitAgent" >nul 2>&1
	schtasks /Delete /F /TN "Microsoft\Windows\PerfTrack\BackgroundConfigSurveyor" >nul 2>&1
	echo.
	echo %red%Modification du registre%u%
	reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v UsageTracking /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\LocationAndSensors" /v LocationEnabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v ActivityHistoryEnabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v NoExplicitFeedback /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Gwx" /v DisableGwx /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableOSUpgrade /t REG_DWORD /d 1 /f >nul 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /v AllowOSUpgrade /t REG_DWORD /d 0 /f >nul 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v DiagTrackAuthorization /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v CEIPEnable /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v SqmLoggerRunning /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v CEIPEnable /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v SqmLoggerRunning /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v SqmLoggerRunning /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v DisableOptinExperience /t REG_DWORD /d 1 /f >nul 2>&1
	reg delete "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f >nul 2>&1
	reg delete "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\Diagtrack-Listener" /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f >nul 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Appraiser" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Appraiser" /v HaveUploadedForTarget /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\AIT" /v AITEnable /t REG_DWORD /d 0 /f >nul 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v DontRetryOnError /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v IsCensusDisabled /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v TaskEnableRun /t REG_DWORD /d 0 /f >nul 2>&1
	for %%i in (InstallInfoCheck,ARPInfoCheck,MediaInfoCheck,FileInfoCheck) do reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Tracing" /v %%i /t REG_DWORD /d 0 /f >nul 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags" /v UpgradeEligible /f >nul 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v AllowRecallEnablement /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowFullControl /t REG_DWORD /d 0 /f >nul 2>&1
	echo.
	echo %red%Modifications supplémentaires%u%
	del /f /q %ProgramData%\Microsoft\Diagnosis\*.rbs >nul 2>&1
	del /f /q /s %ProgramData%\Microsoft\Diagnosis\ETLLogs\* >nul 2>&1
	::NVIDIA
	sc stop NvTelemetryContainer >nul 2>&1
	sc config NvTelemetryContainer start= Disabled >nul 2>&1
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmMon"') do schtasks /Change /DISABLE /TN "%%~t" >nul 2>&1
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRep"') do schtasks /Change /DISABLE /TN "%%~t" >nul 2>&1
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRepOnLogon"') do schtasks /Change /DISABLE /TN "%%~t" >nul 2>&1
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvProfileUpdaterDaily"') do schtasks /Change /DISABLE /TN "%%~t" >nul 2>&1
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvProfileUpdaterOnLogon"') do schtasks /Change /DISABLE /TN "%%~t" >nul 2>&1
	reg add "HKCU\SOFTWARE\NVIDIA Corporation\NVControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f >nul 2>&1
	::Office
	schtasks /Change /DISABLE /TN "\Microsoft\Office\OfficeTelemetryAgentFallBack" >nul 2>&1
	schtasks /Change /DISABLE /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn" >nul 2>&1
	schtasks /Change /DISABLE /TN "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" >nul 2>&1
	schtasks /Change /DISABLE /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" >nul 2>&1
	schtasks /Change /DISABLE /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" >nul 2>&1
	schtasks /Change /DISABLE /TN "\Microsoft\Office\Office 16 Subscription Heartbeat" >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Mail" /v EnableLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Word\Options" /v EnableLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Mail" /v EnableLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Word\Options" /v EnableLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v VerboseLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 1 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v VerboseLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common" /v QMEnable /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Feedback" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common" /v QMEnable /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Feedback" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Calendar" /v EnableCalendarLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Calendar" /v EnableCalendarLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v EnableLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v EnableUpload /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v EnableLogging /t REG_DWORD /d 0 /f >nul 2>&1
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v EnableUpload /t REG_DWORD /d 0 /f >nul 2>&1
	echo.
	echo %green%Configuration terminée%u%
	echo %green%Ce script est à appliquer après chaque mise à jour de Windows%u%
	echo.
	call :callforrestart
goto main



:: Modification des informations OEM Windows
:oem_information
	cls
	echo.
	call :titre
	echo.
	echo %red%Modification des informations OEM Windows%u%
	echo.
	set "OEM_FABRICANT="
	set "OEM_MODELE="
	set "OEM_URL="
	for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer 2^>nul') do set "OEM_FABRICANT=%%B"
	for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model 2^>nul') do set "OEM_MODELE=%%B"
	for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL 2^>nul') do set "OEM_URL=%%B"
	echo.
	echo ===== Informations enregistrées ======
	echo Fabricant      : %OEM_FABRICANT%
	echo Modèle         : %OEM_MODELE%
	echo URL du support : %OEM_URL%
	echo ======================================
	echo.
	set "confirm="
	set /p "confirm=Souhaitez-vous modifier ces informations (O/N) : "
	if /i not "%confirm%"=="O" (
		echo.
		echo Annulation. Aucune modification n'a été effectuée.
		echo.
		pause
		goto main
	)
	echo.
	echo.
	set /p manufacturer=Entrez le nom du fabricant : 
	set /p model=Entrez le modèle de l'appareil : 
	set /p supportURL=Entrez l'URL du support : 
	echo.
	echo ======== Informations saisies ========
	echo Fabricant      : %manufacturer%
	echo Modèle         : %model%
	echo URL du support : %supportURL%
	echo ======================================
	echo.
	set "confirm="
	set /p "confirm=Confirmer ces informations (O/N) : "
	if /i not "%confirm%"=="O" (
		echo.
		echo Annulation. Aucune modification n'a été effectuée.
		echo.
		pause
		goto main
	)
	echo.
	echo Mise à jour du registre...
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer /t REG_SZ /d "%manufacturer%" /f >nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model /t REG_SZ /d "%model%" /f >nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL /t REG_SZ /d "%supportURL%" /f >nul
	echo.
	echo %green%Les informations OEM ont été mises à jour%u%
	echo.
	pause
goto main



:: Nettoyage de disque Windows basique
:nettoyage_basique
	cls
	echo.
	call :titre
	echo.
	echo %red%Nettoyage des fichiers temporaires%u%
	del "%LOCALAPPDATA%\Microsoft\Windows\WebCache" /f /q /s >nul 2>&1
	del "%SYSTEMROOT%\Temp\*" /f /q /s >nul 2>&1
	del "%TEMP%\*" /f /q /s >nul 2>&1
	echo.
	echo %red%Nettoyage de Windows Update%u%
	net stop wuauserv >nul 2>&1
	rd "%SYSTEMROOT%\SoftwareDistribution" /q /s >nul 2>&1
	net start wuauserv >nul 2>&1
	echo.
	echo %red%Nettoyage de disque Windows%u%
	cleanmgr /sagerun:1 >nul 2>&1
	echo.
	echo %green%Le nettoyage est terminé%u%
	echo.
	call :callforrestart
goto main



:: Nettoyage de disque Windows complet
:nettoyage_complet
	cls
	echo.
	call :titre
	echo.
	echo %red%Nettoyage des versions précédentes de Windows%u%
	rd "%SYSTEMDRIVE%\$GetCurrent" /q /s >nul 2>&1
	rd "%SYSTEMDRIVE%\$SysReset" /q /s >nul 2>&1
	rd "%SYSTEMDRIVE%\$WinREAgent" /q /s >nul 2>&1
	rd "%SYSTEMDRIVE%\$Windows.~BT" /q /s >nul 2>&1
	rd "%SYSTEMDRIVE%\$Windows.~WS" /q /s >nul 2>&1
	rd "%SYSTEMDRIVE%\inetpub" /q /s >nul 2>&1
	rd "%SYSTEMDRIVE%\PerfLogs" /q /s >nul 2>&1
	rd "%SYSTEMDRIVE%\Windows.old" /q /s >nul 2>&1
	echo.
	echo %red%Nettoyage des fichiers temporaires%u%
	reg delete "HKCU\Software\Classes\Local Settings\MuiCache" /f >nul 2>&1
	reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /f >nul 2>&1
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f >nul 2>&1
	reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /f >nul 2>&1
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f >nul 2>&1
	del "%APPDATA%\Microsoft\Windows\Recent\*" /f /q >nul 2>&1
	del "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" /f /q >nul 2>&1
	del "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*" /f /q >nul 2>&1
	del "%LOCALAPPDATA%\IconCache.db" /a:h /f /q >nul 2>&1
	del "%LOCALAPPDATA%\Microsoft\Windows\Explorer\*.db" /f /q >nul 2>&1
	del "%PROGRAMDATA%\Microsoft\RAC\*" /f /q /s >nul 2>&1
	del "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive\*" /f /q /s >nul 2>&1
	for /d %%p in ("%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive\*.*") do rd "%%p" /q /s >nul 2>&1
	del "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue\*" /f /q /s >nul 2>&1
	for /d %%p in ("%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue\*.*") do rd "%%p" /q /s >nul 2>&1
	del "%PROGRAMDATA%\Microsoft\Windows\WER\Temp\*" /f /q /s >nul 2>&1
	del "%PROGRAMDATA%\Microsoft\Windows Defender\Definition Updates\Backup\*" /f /q /s >nul 2>&1
	del "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\Results\Quick\*" /f /q /s >nul 2>&1
	del "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\Results\Resource\*" /f /q /s >nul 2>&1
	del "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\Service\*" /f /q /s >nul 2>&1
	del "%SYSTEMROOT%\Installer\$PatchCache$\*" /f /q /s >nul 2>&1
	del "%SYSTEMROOT%\LiveKernelReports\WATCHDOG\*" /f /q /s >nul 2>&1
	taskkill /f /im explorer.exe >nul 2>&1
	start explorer.exe >nul 2>&1
	del "%TEMP%\*" /f /q /s >nul 2>&1
	del "%USERPROFILE%\*.blf" /f /q >nul 2>&1
	del "%USERPROFILE%\*.regtrans-ms" /f /q >nul 2>&1
	del "%USERPROFILE%\Recent\*" /f /q >nul 2>&1
	sc stop TrustedInstaller >nul 2>&1
	del "%SYSTEMROOT%\Logs\*" /f /q /s >nul 2>&1
	sc start TrustedInstaller >nul 2>&1
	del "%SYSTEMROOT%\Prefetch\*" /f /q /s >nul 2>&1
	del "%SYSTEMROOT%\Temp\*" /f /q /s >nul 2>&1
	rd "%SYSTEMROOT%\LastGood.tmp" /q /s >nul 2>&1
	rd "%SYSTEMROOT%\Minidump" /q /s >nul 2>&1
	echo.
	echo %red%Nettoyage de Windows Update%u%
	net stop wuauserv >nul 2>&1
	net stop bits >nul 2>&1
	dism /online /cleanup-image /startcomponentcleanup /quiet /norestart >nul 2>&1
	rd "%SYSTEMROOT%\SoftwareDistribution\Download" /q /s >nul 2>&1
	md "%SYSTEMROOT%\SoftwareDistribution\Download" >nul 2>&1
	net start wuauserv >nul 2>&1
	net start bits >nul 2>&1
	echo.
	echo %red%Nettoyage de disque Windows%u%
	cleanmgr /sagerun:1 >nul 2>&1
	echo.
	echo %red%Nettoyage des navigateurs Internet Windows (IE & Edge)%u%
	taskkill /f /im iexplore.exe >nul 2>&1
	RunDll32 InetCpl.cpl,ClearMyTracksByProcess 4351 >nul 2>&1
	taskkill /f /im msedge.exe >nul 2>&1
	set "EdgeData=%LOCALAPPDATA%\Microsoft\Edge\User Data"
	for /d %%P in ("%EdgeData%\*") do (
		rd /s /q "%%~fP\Cache" >nul 2>&1
		rd /s /q "%%~fP\Code Cache" >nul 2>&1
		rd /s /q "%%~fP\GPUCache" >nul 2>&1
	)
	echo.
	echo %red%Nettoyage des copies de sauvegarde Windows%u%
	vssadmin delete shadows /all /quiet >nul 2>&1
	echo.
	echo %red%Nettoyage du cache de l'observateur d'évènements%u%
	for /f "tokens=*" %%1 in ('wevtutil.exe el') do wevtutil.exe cl "%%1" >nul 2>&1
	echo.	
	echo %red%Nettoyage du gestionnaire de péripheriques%u%
	rundll32.exe pnpclean.dll,RunDLL_PnpClean /DEVICES /DRIVERS /FILES /MAXCLEAN >nul 2>&1
	echo.
	echo %green%Le nettoyage complet est terminé%u%
	echo.
	call :callforrestart
goto main



:: Nettoyage des fichiers orphelins du cache Windows Installer
:nettoyage_windows_installer
	cls
	echo.
	call :titre
	echo.
	echo %red%Nettoyage du cache Windows Installer%u%
	echo.
	set "installerDir=%WINDIR%\Installer"
	set "logFile=%~dp0Orphelins_MSI_MSP.log"
	set orphans_found=0
	echo Suppression des dossiers vides dans %installerDir%
	for /d /r "%installerDir%" %%d in (*) do (
		dir "%%d" /b | findstr . >nul
		if errorlevel 1 (
			rd "%%d"
		)
	)
	echo.
	echo Recherche des fichiers .msi et .msp orphelins dans %installerDir%
	dir /b /a:-d "%installerDir%\*.ms?" > all_installer_files.txt
	reg query HKLM\SOFTWARE\Classes\Installer /s > reg_installer.txt 2>nul
	reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer /s >> reg_installer.txt 2>nul
	for /f "delims=" %%F in (all_installer_files.txt) do (
		set "fileName=%%F"
		findstr /i "%%~nF" reg_installer.txt >nul
		if errorlevel 1 (
			echo %installerDir%\%%F >> "%logFile%"
			set /a orphans_found+=1
		)
	)
	echo.
	if "%orphans_found%"=="0" (
		echo Aucun fichier détecté.
		echo.
		del all_installer_files.txt >nul 2>&1
		del reg_installer.txt >nul 2>&1
		del "%logFile%" >nul 2>&1
		pause
		goto main
	)
	echo %orphans_found% fichier(s) orphelin(s) détecté(s) dans %installerDir%
	set /p delChoice=Voulez-vous supprimer ce(s) fichier(s) ? [O/N]
	if /i "%delChoice%"=="O" (
		for /f "usebackq delims=" %%F in ("%logFile%") do (
			del /f /q "%%F"
		)
		echo.
		echo Suppression terminée.
	) else (
		echo.
		echo Aucun fichier supprimé.
	)
	del all_installer_files.txt >nul 2>&1
	del reg_installer.txt >nul 2>&1
	del "%logFile%" >nul 2>&1
	echo.
	pause
goto main



:: Défragmentation de Windows
:defrag
	cls
	echo.
	call :titre
	echo.
	echo %red%Défragmentation de Windows%u%
	echo.
	defrag /o /u /v %SYSTEMDRIVE%
	echo.
	echo %green%La défragmentation est terminée%u%
	echo.
	pause
goto main



:: Réparation des apps d'origine de Microsoft Store
:reparation_apps
	cls
	echo.
	call :titre
	echo.
	echo %red%Réparation des apps d'origine de Microsoft Store%u%
	powershell -NoProfile -command "Get-AppxPackage | foreach {Add-AppxPackage -register ($_.InstallLocation + '\AppXManifest.xml') -DisableDevelopmentMode}" >nul 2>&1
	echo.
	echo %green%La réparation est terminée%u%
	echo.
	call :callforrestart
goto main



:: Réparation du cache d'icones
:reparation_icones
	cls
	echo.
	call :titre
	echo.
	echo %red%Réparation du cache d'icones%u%
	taskkill /f /im explorer.exe >nul 2>&1
	timeout /t 1 /nobreak >nul
	attrib -h -s %LOCALAPPDATA%\IconCache.db >nul 2>&1
	del "%LOCALAPPDATA%\IconCache.db" /f /q >nul 2>&1
	attrib -h -s %LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db >nul 2>&1
	del "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" /f /q >nul 2>&1
	start "" explorer.exe >nul 2>&1
	echo.
	echo %green%La réparation est terminée%u%
	echo.
	pause
goto main



:: Réparation du référentiel WMI
:reparation_wmi
	cls
	echo.
	call :titre
	echo.
	echo %red%Réparation du référentiel WMI%u%
	net stop winmgmt /y >nul 2>&1
	winmgmt /salvagerepository >nul 2>&1
	if errorlevel 1 (
		echo.
		echo %yellow%La récupération du référentiel WMI a échoué.%u%
		echo %yellow%Tentative de réinitialisation...%u%
		winmgmt /resetrepository >nul 2>&1
	)
	net start winmgmt >nul 2>&1
	echo.
	echo %green%La réparation est terminée%u%
	echo.
	call :callforrestart
goto main



:: Réparation basique du réseau Windows
:reparation_reseau_basique
	cls
	echo.
	call :titre
	echo.
	echo %red%Réparation basique du réseau Windows%u%
	netsh int ip reset >nul 2>&1
	netsh winsock reset >nul 2>&1
	ipconfig /release >nul 2>&1
	ipconfig /renew >nul 2>&1
	ipconfig /flushdns >nul 2>&1
	echo.
	echo %green%La réparation est terminée%u%
	echo.
	call :callforrestart
goto main



:: Réparation complète du réseau Windows
:reparation_reseau_complet
	cls
	echo.
	call :titre
	echo.
	echo %red%Réparation complète du réseau Windows%u%
	netsh int ip reset >nul 2>&1
	netsh winsock reset >nul 2>&1
	ipconfig /release >nul 2>&1
	ipconfig /renew >nul 2>&1
	ipconfig /flushdns >nul 2>&1
	for /f "usebackq tokens=*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles"') do reg delete "%%a" /f >nul 2>&1
	for /f "usebackq tokens=*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Unmanaged"') do reg delete "%%a" /f >nul 2>&1
	netcfg -d >nul 2>&1
	echo.
	echo %green%La réparation est terminée%u%
	echo.
	call :callforrestart
goto main



:: Réparation du système de fichiers Windows
:reparation_win
	cls
	echo.
	call :titre
	echo.
	echo %red%Réparation de l'image système Windows (DISM)%u%
	dism /online /cleanup-image /restorehealth
	echo.
	echo %red%Réparation de Windows (SFC)%u%
	sfc -scannow
	echo.
	echo %red%Analyse du systeme de fichiers Windows (CHKDSK)%u%
	set /p confirm=Souhaitez-vous analyser le système de fichiers au redémarrage ? [O/N] :
	if /i "%confirm%" EQU "O" (
		chkdsk %SYSTEMDRIVE% /f
	)
	echo.
	echo %green%Votre ordinateur doit redémarrer pour terminer le processus de réparation%u%
	echo.
	call :callforrestart
goto main



:: Réparation de Windows Installer
:reparation_win_intaller
	cls
	echo.
	call :titre
	echo.
	echo %red%Réparation de Windows Installer%u%
	net stop msiserver >nul 2>&1
	sc config msiserver start= Demand >nul 2>&1
	msiexec /unregister >nul 2>&1
	msiexec /regserver >nul 2>&1
	net start msiserver >nul 2>&1
	echo.
	echo %green%La réparation est terminée%u%
	echo.
	call :callforrestart
goto main



:: Réparation de Windows Update
:reparation_wu
	cls
	echo.
	call :titre
	echo.
	echo %red%Réparation de Windows Update%u%
	echo.
	echo %red%Arrêt des services Windows Update%u%
	net stop bits >nul 2>&1
	net stop wuauserv >nul 2>&1
	net stop cryptsvc >nul 2>&1
	net stop usosvc >nul 2>&1
	echo.
	echo %red%Réinitialisation du cache Windows Update%u%
	rd "%SYSTEMROOT%\SoftwareDistribution\Download" /q /s >nul 2>&1
	md "%SYSTEMROOT%\SoftwareDistribution\Download" >nul 2>&1
	rd "%SYSTEMROOT%\System32\catroot2" /q /s >nul 2>&1
	md "%SYSTEMROOT%\System32\catroot2" >nul 2>&1
	echo.
	echo %red%Réinitialisation de Winsock et WinHTTP%u%
	netsh winsock reset >nul 2>&1
	netsh winhttp reset proxy >nul 2>&1
	echo.
	echo %red%Réinitialisation des services Windows Update%u%
	sc config wuauserv start= auto >nul 2>&1
	sc config cryptsvc start= auto >nul 2>&1
	echo.
	echo %red%Redémarrage des services Windows Update%u%
	net start cryptsvc >nul 2>&1
	net start bits >nul 2>&1
	net start wuauserv >nul 2>&1
	net start usosvc >nul 2>&1
	echo.
	echo %green%La réparation est terminée%u%
	echo.
	call :callforrestart
goto main



:: Windows Update
:windows_update
	cls
	echo.
	call :titre
	echo.
	echo %red%Windows Update%u%
	echo.
	echo Le programme va maintenant installer les mises à jour présentes dans le dossier actuel.
	echo En cas d'erreur ou d'incompatibilité, un message s'affichera.
	echo.
	echo Les types de fichier pris en charge sont :
	echo .cab .msu .exe .appx .appxbundle .msix .msixbundle
	echo DirectX_Redist_Repack_x86_x64.exe (abbodi1406)
	echo VisualCppRedist_AIO-arm64.exe (abbodi1406)
	echo VisualCppRedist_AIO_x86_x64.exe (abbodi1406)
	echo.
	echo __________________________________________________________________________________________
	echo.
	set /p confirm=Souhaitez-vous continuer et procéder à l'installation (O/N) : 
	echo.
	if /i "%confirm%" NEQ "O" (
		echo Annulation. Aucune modification n'a été effectuée.
		echo.
		pause
		goto main
	)
	setlocal EnableDelayedExpansion
	set found=0
	if exist "%~dp0*.cab" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0*.cab"') do (
			<nul set /p=Installation de %%i...
			dism /online /add-package /packagepath:"%~dp0%%i" /quiet /norestart >nul 2>&1
			set "error=!errorlevel!"
			if !error!==0 (
				echo OK
			) else if !error!==3010 (
				echo OK - redemarrage requis
			) else (
				echo Erreur
			)
		)
	)
	if exist "%~dp0*.msu" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0*.msu"') do (
			<nul set /p=Installation de %%i...
			dism /online /add-package /packagepath:"%~dp0%%i" /quiet /norestart >nul 2>&1
			set "error=!errorlevel!"
			if !error!==0 (
				echo OK
			) else if !error!==3010 (
				echo OK - redemarrage requis
			) else (
				echo Erreur
			)
		)
	)
	if exist "%~dp0*.exe" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0*.exe"') do (
			<nul set /p=Installation de %%i...
			if "%%i"=="DirectX_Redist_Repack_x86_x64.exe" (
				"%~dp0%%i" /ai /gm2
			) else if "%%i"=="VisualCppRedist_AIO-arm64.exe" (
				"%~dp0%%i" /ai /gm2
			) else if "%%i"=="VisualCppRedist_AIO_x86_x64.exe" (
				"%~dp0%%i" /ai /gm2
			) else (
				"%~dp0%%i" /quiet /norestart
			)
			set "error=!errorlevel!"
			if !error!==0 (
				echo OK
			) else if !error!==3010 (
				echo OK - redemarrage requis
			) else (
				echo Erreur
			)
		)
	)
	if exist "%~dp0*.appx" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0*.appx"') do (
			<nul set /p=Installation de %%i...
			powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxPackage -Path '%~dp0%%i'" >nul 2>&1
			set "error=!errorlevel!"
			if !error!==0 (
				echo OK
			) else (
				echo Erreur
			)
		)
	)
	if exist "%~dp0*.appxbundle" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0*.appxbundle"') do (
			<nul set /p=Installation de %%i...
			powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxPackage -Path '%~dp0%%i'" >nul 2>&1
			set "error=!errorlevel!"
			if !error!==0 (
				echo OK
			) else (
				echo Erreur
			)
		)
	)
	if exist "%~dp0*.msix" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0*.msix"') do (
			<nul set /p=Installation de %%i...
			powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxPackage -Path '%~dp0%%i'" >nul 2>&1
			set "error=!errorlevel!"
			if !error!==0 (
				echo OK
			) else (
				echo Erreur
			)
		)
	)
	if exist "%~dp0*.msixbundle" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0*.msixbundle"') do (
			<nul set /p=Installation de %%i...
			powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxPackage -Path '%~dp0%%i'" >nul 2>&1
			set "error=!errorlevel!"
			if !error!==0 (
				echo OK
			) else (
				echo Erreur
			)
		)
	)
	if "!found!"=="0" (
		echo Aucune mise à jour trouvée dans le dossier actuel.
		echo.
		pause
		goto main
	)
	Endlocal
	echo.
	echo %green%L'installation est terminée%u%
	echo.
	call :callforrestart
goto main



:: Titre
:titre
	echo 			%inverse% ============================================= %u%
	echo 			%inverse% ^|^|         MG Toolkit  (v%toolkit_version%)         ^|^| %u%
	echo 			%inverse% ============================================= %u%
	echo.
goto :eof



:: Redémarrage de Windows
:callforrestart
	set /p choix=Voulez-vous redémarrer maintenant ? (O/N) : 
	if /i "%choix%"=="o" (
		shutdown -r -f -t 0
		exit
	)
goto :eof