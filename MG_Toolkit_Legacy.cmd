:: Paramétrage du script et vérification de la compatibilité
@echo off
pushd "%~dp0"
chcp 1252 >nul
setlocal DisableDelayedExpansion
set toolkit_version=20260924
title MG Toolkit Legacy (v%toolkit_version%)
mode con cols=90 lines=40



:: Contrôle des droits d'administrateur
net session >nul 2>&1
if %errorlevel%==1 (
    echo.
	echo Ce script necessite des droits d'administrateur !
    echo.
    pause
    exit
)



:: Controle de la version de Windows utilisee
:TestOS
	set "os_valide=0"
	for /f "tokens=3-4 delims=[.] " %%A in ('ver') do (
    	set "major=%%A"
   		set "minor=%%B"
	)
	if "%major%"=="version" (
		for /f "tokens=4-5 delims=[.] " %%A in ('ver') do (
			set "major=%%A"
			set "minor=%%B"
		)
	)
	set "build_win=%major%.%minor%"
	if "%build_win%"=="5.0" set "os_valide=1"
	if "%build_win%"=="5.1" set "os_valide=1"
	if "%build_win%"=="5.2" set "os_valide=1"
	if "%build_win%"=="6.0" set "os_valide=1"
	if "%build_win%"=="6.1" set "os_valide=1"
	if "%build_win%"=="6.2" set "os_valide=1"
	if "%build_win%"=="6.3" set "os_valide=1"
	if "%os_valide%"=="0" (
		goto OSNoOK
	)

:AfterTest
	cls
	echo.
	call :titre
	echo.
	echo.
	echo Votre configuration systeme :
	echo -----------------------------
	echo.
	if "%build_win%"=="5.0" (
		echo.
		ver
		echo.
		echo Architecture : %PROCESSOR_ARCHITECTURE%
	) else (
		for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value 2^>nul') do for /f "delims=" %%b in ("%%a") do set "Caption=%%b"
		for /f "tokens=2 delims==" %%a in ('wmic os get CSDVersion /value 2^>nul') do for /f "delims=" %%b in ("%%a") do set "CSDVersion=%%b"
		for /f "tokens=2 delims==" %%a in ('wmic os get Version /value 2^>nul') do for /f "delims=" %%b in ("%%a") do set "Version=%%b"
		echo 	Systeme d'exploitation : %Caption%
		if not "%CSDVersion%"==" " if not "%CSDVersion%"="" (
			echo 	Service Pack :           %CSDVersion%
		) else (
			echo 	Service Pack :           RTM
		)
		echo 	Architecture :           %PROCESSOR_ARCHITECTURE%
		echo 	Version :                %Version%
		ver | find /i "version 5" 1>nul 2>nul
		if %errorlevel%==0 (
			for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" 2^>nul ^| Find "BuildLab" 2^>nul') do (
				echo 	Build :                  %%b
			)
		) else (
			for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" 2^>nul ^| Find "BuildLabEx" 2^>nul') do (
				echo 	Build :                  %%b
			)
		)
	)
	goto OSOK

:OSNoOK
	echo.
	echo __________________________________________________________________________________________
	echo.
	echo                             Votre OS n'est pas compatible
	echo                 Ce programme supporte de Windows 2000 a Windows 8.1
	echo                         Le programme va maintenant se fermer
	echo __________________________________________________________________________________________
	echo.
	pause
exit

:OSOK
	echo.
	echo __________________________________________________________________________________________
	echo.
	echo                                Votre systeme est compatible
	echo        !!! Il est recommande de desactiver votre antivirus avant de poursuivre !!!
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
	echo   Activation de Windows / Office
	echo.
	echo 	1.  Activation (MAS)
	echo 	2.  Status d'activation
	echo.
	echo   Utilitaires de configuration et maintenance
	echo.
	echo 	3.  Configuration performances
	echo 	4.  Configuration vie privee
	echo 	5.  Modification informations OEM
	echo.
	echo   Utilitaires de maintenance
	echo.
	echo 	6.  Defragmentation systeme
	echo 	7.  Nettoyage systeme
	echo 	8.  Reparation reseau
	echo 	9.  Reparation systeme Windows
	echo.
	echo   Divers
	echo.
	echo 	10. Installer des mises a jour
	echo 	11. Logitheque en ligne
	echo.
	echo __________________________________________________________________________________________
	echo.
	set /p choix=Selectionnez l'operation a effectuer (0 pour quitter): 
	if /i "%choix%"=="1" (
		ver | find /i "version 5" 1>nul
		if not %errorlevel%==1 (
			echo.
			echo Cette fonctionnalite n'est pas compatible avec Windows 2000/XP !
			pause
			goto main
		)
		goto activation_mas
	)
	if /i "%choix%"=="2" (
		ver | find /i "version 5.0" 1>nul
		if not %errorlevel%==1 (
			echo.
			echo Cette fonctionnalite n'est pas compatible avec Windows 2000 !
			pause
			goto main
		)
		goto activation_status
	)
	if /i "%choix%"=="3" (goto configuration_performances)
	if /i "%choix%"=="4" (
		ver | find /i "version 5" 1>nul
		if not %errorlevel%==1 (
			echo.
			echo Cette fonctionnalite n'est pas compatible avec Windows 2000/XP !
			pause
			goto main
		)
		ver | find /i "version 6.0"1>nul
		if not %errorlevel%==1 (
			echo.
			echo Cette fonctionnalite n'est pas compatible avec Windows Vista !
			pause
			goto main
		)
		goto configuration_privacy
	)
	if /i "%choix%"=="5" (
		ver | find /i "version 5" 1>nul
		if %errorlevel%==1 (
			goto oem_information
		) else (
			echo.
			echo Cette fonctionnalite n'est pas compatible avec Windows 2000/XP !
			pause
			goto main
		)
	)
	if /i "%choix%"=="6" (goto defrag)
	if /i "%choix%"=="7" (goto nettoyage)
	if /i "%choix%"=="8" (goto reparation_reseau)
	if /i "%choix%"=="9" (goto reparation_win)
	if /i "%choix%"=="10" (goto windows_update)
	if /i "%choix%"=="11" (start https://1drv.ms/f/c/011dbcd351618514/IgAUhWFR07wdIIAB3voDAAAAAcBLZB30-366q14Z-fKgndE)
	if /i "%choix%"=="0" (exit)
goto main



:: Activation de Windows / Office
:activation_mas
	cls
	echo.
	call :titre
	echo.
	echo Activation de Windows - Office (MAS)
	echo.
	echo IMPORTANT :
	echo Une connexion Internet est requise.
	echo Il est necessaire de desactiver votre antivirus avant de poursuivre !
	echo.
	pause
	powershell -Command "(irm https://get.activated.win | iex)" 1>nul 2>nul
goto main



:: Status de l'activation de Windows
:activation_status
	cls
	echo.
	call :titre
	echo.
	echo Status de l'activation de Windows
	ver | find /i "version 5" 1>nul
	if %errorlevel%==0 (
		%SYSTEMROOT%\system32\oobe\msoobe /a
		echo.
		pause
	) else (
		echo.
		ver
		cscript //nologo %SYSTEMROOT%\system32\slmgr.vbs /dli
		cscript //nologo %SYSTEMROOT%\system32\slmgr.vbs /xpr
		echo.
		pause
	)
goto main



:: Configuration optimale de Windows
:configuration_performances
	cls
	echo.
	call :titre
	echo.
	echo Configuration optimale de Windows
	netsh int ipv4 set glob defaultcurhoplimit=65 1>nul 2>nul
	netsh int ipv6 set glob defaultcurhoplimit=65 1>nul 2>nul
	netsh int tcp set global autotuninglevel=normal 1>nul 2>nul
	netsh int tcp set global chimney=disabled 1>nul 2>nul
	netsh int tcp set global dca=enabled 1>nul 2>nul
	netsh int tcp set global ecncapability=enabled 1>nul 2>nul
	netsh int tcp set global initialRto=1000 1>nul 2>nul
	netsh int tsp set global maxsynretransmissions=2 1>nul 2>nul
	netsh int tcp set global nonsackrttresiliency=disabled 1>nul 2>nul
	netsh int tcp set global rsc=disabled 1>nul 2>nul
	netsh int tcp set global rss=enabled 1>nul 2>nul
	netsh int tcp set global timestamps=disabled 1>nul 2>nul
	netsh int tcp set heuristics disabled 1>nul 2>nul
	netsh int tcp set supplemental Internet congestionprovider=CUBIC 1>nul 2>nul
	netsh int tcp set supplemental template=custom icw=10 1>nul 2>nul
	powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a 1>nul 2>nul
	powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 1>nul 2>nul
	powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 1>nul 2>nul
	powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 3000 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v LowLevelHooksTimeout /t REG_SZ /d 4000 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 10000 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v WaitToKillServiceTimeout /t REG_SZ /d 5000 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /t REG_SZ /d "NotSpecified" /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v explorer.exe /t REG_DWORD /d 8 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v iexplore.exe /t REG_DWORD /d 8 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v explorer.exe /t REG_DWORD /d 8 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v iexplore.exe /t REG_DWORD /d 8 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v DesktopProcess /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackDocs /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v ConfirmFileDelete /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoResolveTrack /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v ActivityHistoryEnabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SYSTEM\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d Y /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v value /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v MaxCachedIcons /t REG_SZ /d 4096 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPer1_0Server /t REG_DWORD /d 10 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPerServer /t REG_DWORD /d 10 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v MemCheckBoxInRunDlg /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowgameDVR /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AllowMUUpdateService /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 5000 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v AutoReboot /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisable8dot3NameCreation /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsMftZoneReservation /t REG_DWORD /d 4 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Windows32PrioritySeparation /t REG_DWORD /d 26 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v remoteregaccess /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 2 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheEntryTtlLimit /t REG_DWORD /d 10800 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheTtl /t REG_DWORD /d 10800 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxNegativeCacheTtl /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v NegativeSoaCacheTime /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v NetFailureCacheTime /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Size /t REG_DWORD /d 3 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DisableTaskOffload /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v NameSrvQueryTimeout /t REG_DWORD /d 3000 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpMaxDupAcks /t REG_DWORD /d 2 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v DnsPriority /t REG_DWORD /d 6 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v HostsPriority /t REG_DWORD /d 5 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v LocalPriority /t REG_DWORD /d 4 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v NetbtPriority /t REG_DWORD /d 7 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WOW" /v DefaultSeparateVDM /t REG_SZ /d Yes /f 1>nul 2>nul
	echo.
	echo Configuration des fonctionnalites de Windows
	dism.exe /online /enable-feature /featurename:NetFX3 /quiet /norestart 1>nul 2>nul
	echo.
	echo Configuration des services Windows
	sc stop RemoteRegistry 1>nul 2>nul
	sc config RemoteRegistry start= Disabled 1>nul 2>nul
	sc stop VSS 1>nul 2>nul
	sc config VSS start= Disabled 1>nul 2>nul
	sc stop WerSvc 1>nul 2>nul
	sc config WerSvc start= Disabled 1>nul 2>nul
	sc stop WSearch 1>nul 2>nul
	sc config WSearch start= Disabled 1>nul 2>nul
	echo.
	echo Configuration du nettoyage de disque Windows
	cleanmgr /sageset:1
	echo.
	echo Desactivation de la veille prolongee
	powercfg -hibernate off 1>nul 2>nul
	echo.
	if not "%build_win%"=="5.0" (
		powershell -command "Get-PhysicalDisk | select MediaType" | find /i "SD" 1>nul 2>nul
		if %errorlevel%==0 (
			echo Optimisation du SSD
			fsutil behavior set DisableDeleteNotify 0 1>nul 2>nul
			fsutil behavior set DisableLastAccess 1 1>nul 2>nul
			reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d N /f 1>nul 2>nul
			reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableBoottrace /t REG_DWORD /d 0 /f 1>nul 2>nul
			reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f 1>nul 2>nul
			reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f 1>nul 2>nul
			sc stop "Superfetch" 1>nul 2>nul
			sc config "Superfetch" start= Disabled 1>nul 2>nul
			sc stop "SysMain" 1>nul 2>nul
			sc config "SysMain" start= Disabled 1>nul 2>nul
			schtasks /Delete /F /TN "Microsoft\Windows\Defrag\ScheduledDefrag" 1>nul 2>nul
			echo.
		)
		echo Optimisation terminee
	)
	echo.
	call :callforrestart
goto main



:: Desactivation de la telemetrie et vie privee Windows
:configuration_privacy
	cls
	echo.
	call :titre
	echo.
	echo Desactivation des services de telemetrie
	sc stop DiagTrack 1>nul 2>nul
	sc stop diagnosticshub.standardcollector.service 1>nul 2>nul
	sc stop dmwappushservice 1>nul 2>nul
	sc stop WMPNetworkSvc 1>nul 2>nul
	sc config DiagTrack start= Disabled 1>nul 2>nul
	sc config diagnosticshub.standardcollector.service start= Disabled 1>nul 2>nul
	sc config dmwappushservice start= Disabled 1>nul 2>nul
	sc config WMPNetworkSvc start= Disabled 1>nul 2>nul
	echo.
	echo Desactivation des tâches planifiees
	schtasks /Change /DISABLE /TN "Microsoft\Windows\SetupSQMTask" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\BthSQM" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\TelTask" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Application Experience\AitAgent" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "Microsoft\Windows\PerfTrack\BackgroundConfigSurveyor" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\SetupSQMTask" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\BthSQM" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\TelTask" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\Application Experience\AitAgent" 1>nul 2>nul
	schtasks /Delete /F /TN "Microsoft\Windows\PerfTrack\BackgroundConfigSurveyor" 1>nul 2>nul
	echo.
	echo Modification du registre
	reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v UsageTracking /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\LocationAndSensors" /v LocationEnabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v ActivityHistoryEnabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v NoExplicitFeedback /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Gwx" /v DisableGwx /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableOSUpgrade /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /v AllowOSUpgrade /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v DiagTrackAuthorization /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v CEIPEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v SqmLoggerRunning /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v CEIPEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v SqmLoggerRunning /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v SqmLoggerRunning /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v DisableOptinExperience /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg delete "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f 1>nul 2>nul
	reg delete "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\Diagtrack-Listener" /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Appraiser" /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Appraiser" /v HaveUploadedForTarget /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\AIT" /v AITEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v DontRetryOnError /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v IsCensusDisabled /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v TaskEnableRun /t REG_DWORD /d 1 /f 1>nul 2>nul
	for %%i in (InstallInfoCheck,ARPInfoCheck,MediaInfoCheck,FileInfoCheck) do reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Tracing" /v %%i /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags" /v UpgradeEligible /f 1>nul 2>nul
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController" /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v AllowRecallEnablement /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowFullControl /t REG_DWORD /d 0 /f 1>nul 2>nul
	echo.
	echo Modifications supplementaires
	del /f /q %ProgramData%\Microsoft\Diagnosis\*.rbs 1>nul 2>nul
	del /f /q /s %ProgramData%\Microsoft\Diagnosis\ETLLogs\* 1>nul 2>nul
	::NVIDIA
	sc stop NvTelemetryContainer 1>nul 2>nul
	sc config NvTelemetryContainer start= Disabled 1>nul 2>nul
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmMon"') do schtasks /Change /DISABLE /TN "%%~t" 1>nul 2>nul
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRep"') do schtasks /Change /DISABLE /TN "%%~t" 1>nul 2>nul
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvTmRepOnLogon"') do schtasks /Change /DISABLE /TN "%%~t" 1>nul 2>nul
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvProfileUpdaterDaily"') do schtasks /Change /DISABLE /TN "%%~t" 1>nul 2>nul
	for /f "tokens=1 delims=," %%t in ('schtasks /Query /FO CSV ^| find /v "TaskName" ^| find "NvProfileUpdaterOnLogon"') do schtasks /Change /DISABLE /TN "%%~t" 1>nul 2>nul
	reg add "HKCU\SOFTWARE\NVIDIA Corporation\NVControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f 1>nul 2>nul
	::Office
	schtasks /Change /DISABLE /TN "\Microsoft\Office\OfficeTelemetryAgentFallBack" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" 1>nul 2>nul
	schtasks /Change /DISABLE /TN "\Microsoft\Office\Office 16 Subscription Heartbeat" 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Mail" /v EnableLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Word\Options" /v EnableLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Mail" /v EnableLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Word\Options" /v EnableLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v VerboseLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v VerboseLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common" /v QMEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Feedback" /v Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common" /v QMEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Feedback" /v Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Calendar" /v EnableCalendarLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Calendar" /v EnableCalendarLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v EnableLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v EnableUpload /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v EnableLogging /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v EnableUpload /t REG_DWORD /d 0 /f 1>nul 2>nul
	echo.
	echo Configuration terminee
	echo Ce script est a appliquer apres chaque mise a jour de Windows
	echo.
	call :callforrestart
goto main



:: Modification des informations OEM Windows
:oem_information
	cls
	echo.
	call :titre
	echo.
	echo Modification des informations OEM Windows
	echo.
	for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer 2^>nul') do set "OEM_FABRICANT=%%B"
	for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model 2^>nul') do set "OEM_MODELE=%%B"
	for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL 2^>nul') do set "OEM_URL=%%B"
	echo.
	echo ===== Informations enregistrees ======
	echo Fabricant      : %OEM_FABRICANT%
	echo Modele         : %OEM_MODELE%
	echo URL du support : %OEM_URL%
	echo ======================================
	echo.
	set /p confirm=Souhaitez-vous modifier ces informations (O/N) : 
	echo.
	if /i "%confirm%" NEQ "O" (
		echo Annulation. Aucune modification n'a ete effectuee.
		echo.
		pause
		goto main
	)
	echo.
	echo.
	set /p manufacturer=Entrez le nom du fabricant : 
	set /p model=Entrez le modele de l'appareil : 
	set /p supportURL=Entrez l'URL du support : 
	echo.
	echo ======== Informations saisies ========
	echo Fabricant      : %manufacturer%
	echo Modele         : %model%
	echo URL du support : %supportURL%
	echo ======================================
	echo.
	set /p confirm=Confirmer ces informations (O/N) : 
	echo.
	if /i "%confirm%" NEQ "O" (
		echo Annulation. Aucune modification n'a ete effectuee.
		echo.
		pause
		goto main
	)
	echo Mise a jour du registre...
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer /t REG_SZ /d "%manufacturer%" /f >nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model /t REG_SZ /d "%model%" /f >nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL /t REG_SZ /d "%supportURL%" /f >nul
	echo.
	echo Les informations OEM ont ete mises a jour
	echo.
	pause
goto main



:: Defragmentation de Windows
:defrag
	cls
	echo.
	call :titre
	echo.
	echo Defragmentation de Windows
	echo.
	defrag /v %SYSTEMDRIVE%
	echo.
	echo La defragmentation est terminee
	echo.
	pause
goto main



:: Nettoyage de disque Windows
:nettoyage
	cls
	echo.
	call :titre
	echo.
	echo Nettoyage des fichiers temporaires
	del "%LOCALAPPDATA%\Microsoft\Windows\WebCache" /f /q /s 1>nul 2>nul
	del "%SYSTEMROOT%\Temp\*" /f /q /s 1>nul 2>nul
	del "%TEMP%\*" /f /q /s 1>nul 2>nul
	echo.
	echo Nettoyage de Windows Update
	net stop wuauserv 1>nul 2>nul
	rd "%SYSTEMROOT%\SoftwareDistribution" /q /s 1>nul 2>nul
	net start wuauserv 1>nul 2>nul
	echo.
	echo Nettoyage de disque Windows
	cleanmgr /sagerun:1 1>nul 2>nul
	echo.
	echo Le nettoyage est termine
	echo.
	call :callforrestart
goto main



:: Reparation du reseau Windows
:reparation_reseau
	cls
	echo.
	call :titre
	echo.
	echo Reparation basique du reseau Windows
	netsh int ip reset 1>nul 2>nul
	netsh winsock reset 1>nul 2>nul
	ipconfig /release 1>nul 2>nul
	ipconfig /renew 1>nul 2>nul
	ipconfig /flushdns 1>nul 2>nul
	echo.
	echo La reparation est terminee
	echo.
	call :callforrestart
goto main



:: Reparation du systeme de fichiers Windows
:reparation_win
	cls
	echo.
	call :titre
	echo.
	if exist "%SYSTEMROOT%\System32\dism.exe" (
		ver | find /i "version 6.1" 1>nul
		if %errorlevel%==1 (
			echo Reparation de l'image systeme Windows (DISM)
			dism /online /cleanup-image /restorehealth
			echo.
		)
	)
	echo Reparation de Windows (SFC)
	sfc -scannow
	echo.
	echo Analyse du systeme de fichiers Windows (CHKDSK)
	set /p confirm=Souhaitez-vous analyser le systeme de fichiers au redemarrage ? [O/N] :
	if /i "%confirm%"=="O" (
		fsutil dirty set %SYSTEMDRIVE%
	)
	echo.
	echo Votre ordinateur doit redemarrer pour terminer le processus de reparation
	echo.
	call :callforrestart
goto main



:: Windows Update
:windows_update
	cls
	echo.
	call :titre
	echo.
	echo Windows Update
	echo.
	echo Le programme va maintenant installer les mises a jour presentes dans le dossier actuel.
	echo En cas d'erreur ou d'incompatibilite, un message s'affichera.
	echo.
	echo Les types de fichier pris en charge sont :
	echo .cab .msu .exe .appx .appxbundle
	echo DirectX_Redist_Repack_x86_x64.exe (abbodi1406)
	echo VisualCppRedist_AIO-arm64.exe (abbodi1406)
	echo VisualCppRedist_AIO_x86_x64.exe (abbodi1406)
	echo.
	echo __________________________________________________________________________________________
	echo.
	set /p confirm=Souhaitez-vous continuer et proceder a l'installation (O/N) : 
	echo.
	if /i "%confirm%" NEQ "O" (
		echo Annulation. Aucune modification n'a ete effectuee.
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
			dism /online /add-package /packagepath:"%~dp0%%i" /quiet /norestart 1>nul 2>nul
			if !errorlevel!==0 (
				echo OK
			) else if !errorlevel!==3010 (
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
			dism /online /add-package /packagepath:"%~dp0%%i" /quiet /norestart 1>nul 2>nul
			if !errorlevel!==0 (
				echo OK
			) else if !errorlevel!==3010 (
				echo OK - redemarrage requis
			) else (
				echo Erreur
			)
		)
	)
	if exist "%~dp0\*.exe" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0\*.exe"') do (
			<nul set /p=Installation de %%i... 
			if "%%i"=="DirectX_Redist_Repack_x86_x64.exe" (
				"%~dp0\%%i" /ai /gm2
			) else if "%%i"=="VisualCppRedist_AIO_x86_x64.exe" (
				"%~dp0\%%i" /ai /gm2
			) else (
				if "%build_win%"=="5.0" (
					"%~dp0\%%i" -q -z
				) else (
					"%~dp0\%%i" /quiet /norestart
				)
			)
			if !errorlevel!==0 (
				echo OK
			) else if !errorlevel!==3010 (
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
			powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path '%~dp0%%i'" 1>nul 2>nul
		)
		echo OK
	)
	if exist "%~dp0*.appxbundle" (
		set found=1
		for /f "delims=" %%i in ('dir /B "%~dp0*.appxbundle"') do (
			<nul set /p=Installation de %%i... 
			powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path '%~dp0%%i'" 1>nul 2>nul
		)
		echo OK
	)
	if %found%==0 (
		echo Aucune mise a jour trouvee dans le dossier actuel.
		echo.
		pause
		goto main
	)
	Endlocal
	echo.
	echo L'installation est terminee
	echo.
	call :callforrestart
goto main



:: Titre
:titre
	echo 			 =====================================
	echo 			 ^|^|  MG Toolkit Legacy (v%toolkit_version%)  ^|^|
	echo 			 =====================================
goto :eof



:: Redemarrage de Windows
:callforrestart
	set /p choix=Voulez-vous redemarrer maintenant ? (O/N) : 
	if /i "%choix%"=="o" (
		shutdown -r -f -t 0
		exit
	)
goto :eof