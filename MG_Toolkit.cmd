:: Paramétrage du script
@echo off
pushd "%~dp0"
chcp 1252 >nul
setlocal DisableDelayedExpansion
title MG Toolkit
mode con cols=90 lines=45
set toolkit_version=20250823
for /f "tokens=*" %%f in ('wmic os get Caption /value ^| find "="') do set "%%f"
for /f "tokens=*" %%f in ('wmic os get Version /value ^| find "="') do set "%%f"
for /f "tokens=4,5,6,7 delims=[]. " %%g in ('ver') do (set major=%%g& set minor=%%h& set build=%%i& set revision=%%j)
if %build% LSS 10240 (
	goto OSNoOK
)



:: Contrôle des droits d'administrateur
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)



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
del "%TEMP%\version.txt" 1>nul 2>nul
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/version.txt', '%TEMP%\version.txt')" 1>nul 2>nul
set /p controle_version_toolkit=<%TEMP%\version.txt 1>nul 2>nul
if exist "%TEMP%\version.txt" (
	if not "%controle_version_toolkit%"=="%toolkit_version%" (
		powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/MG_Toolkit.cmd', '%~dp0MG_Toolkit_new.cmd')"
		if exist "%~dp0MG_Toolkit_new.cmd" (
			timeout /t 1 >nul
			del /f "%~dp0MG_Toolkit.cmd"
			rename "%~dp0MG_Toolkit_new.cmd" "MG_Toolkit.cmd"
			echo La version %green%%controle_version_toolkit%%u% a été téléchargée avec succès
			echo Veuillez exécuter à nouveau le programme
			echo.
			pause
			exit /b
		) else (
			echo %red%Échec du téléchargement de la mise à jour%u%
		)
	)
	echo %red%Échec de la vérification%u%
)



:: Test de la version de Windows utilisée
:TestOS
	set build_win=""
	set version_win=""
	ver | find /i "version 10.0.10240" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.10240
		set version_win=1507
	)
	ver | find /i "version 10.0.10586" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.10586
		set version_win=1511
	)
	ver | find /i "version 10.0.14393" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.14393
		set version_win=1607
	)
	ver | find /i "version 10.0.15063" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.15063
		set version_win=1703
	)
	ver | find /i "version 10.0.16299" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.16299
		set version_win=1709
	)
	ver | find /i "version 10.0.17134" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.17134
		set version_win=1803
	)
	ver | find /i "version 10.0.17763" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.17763
		set version_win=1809
	)
	ver | find /i "version 10.0.18362" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.18362
		set version_win=1903
	)
	ver | find /i "version 10.0.18363" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.18362
		set version_win=1909
	)
	ver | find /i "version 10.0.19041" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.19041
		set version_win=2004
	)
	ver | find /i "version 10.0.19042" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.19041
		set version_win=20H2
	)
	ver | find /i "version 10.0.19043" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.19041
		set version_win=21H1
	)
	ver | find /i "version 10.0.19044" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.19041
		set version_win=21H2
	)
	ver | find /i "version 10.0.19045" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.19041
		set version_win=22H2
	)
	ver | find /i "version 10.0.20348" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.20348
		set version_win=21H2
	)
	ver | find /i "version 10.0.20349" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.20348
		set version_win=22H2
	)
	ver | find /i "version 10.0.22000" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.22000
		set version_win=21H2
	)
	ver | find /i "version 10.0.22621" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.22621
		set version_win=22H2
	)
	ver | find /i "version 10.0.22622" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.22621
		set version_win=22H2
	)
	ver | find /i "version 10.0.22623" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.22621
		set version_win=22H2
	)
	ver | find /i "version 10.0.22624" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.22621
		set version_win=22H2
	)
	ver | find /i "version 10.0.22631" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.22621
		set version_win=23H2
	)
	ver | find /i "version 10.0.22635" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.22621
		set version_win=23H2
	)
	ver | find /i "version 10.0.26100" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.26100
		set version_win=24H2
	)
	ver | find /i "version 10.0.26120" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.26100
		set version_win=24H2
	)
	ver | find /i "version 10.0.26200" 1>nul 2>nul
	if %errorlevel%==0 (
		set build_win=10.0.26100
		set version_win=25H2
	)

for /f "tokens=3 usebackq" %%a in (`reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE`) do set "bitness=%%a"
if "%bitness%"=="x86" (
	set archi=x86
)
if "%bitness%"=="AMD64" (
	set archi=x64
)
if "%bitness%"=="ARM" (
	set archi=ARM
)
if "%bitness%"=="ARM64" (
	set archi=ARM64
)
if "%bitness%"=="IA64" (
	set archi=IA64
)
if "%bitness%"=="EM64T" (
	set archi=EM64T
)

:AfterTest
	cls
	echo.
	call :titre
	echo.
	echo.
	echo 	%under%Votre configuration système :%u%
	echo.
	echo 	Système d'exploitation : %Caption%
	echo 	Architecture :           %archi%
	echo 	Version :                %major%.%minor%.%build%.%revision% [%version_win%]
	for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" 2^>nul ^| Find "BuildLabEx" 2^>nul') do (
		echo 	Build :                  %%b
	)
	goto OSOK

:install_not_possible
	echo.
	echo %red%Installation impossible sur ce système !%u%
	echo.
	pause
	if %build% GEQ 22000 (
		goto main_wu_11
	)
	goto main_wu_10

:install_not_required
	echo.
	echo %red%Installation non requise sur ce système !%u%
	echo.
	pause
	if %build% GEQ 22000 (
		goto main_wu_11
	)
	goto main_wu_10

:OSNoOK
	echo.
    echo __________________________________________________________________________________________
	echo.
	echo                    Votre OS n'est pas compatible (minimum Windows 10)
	echo                         Le programme va maintenant se fermer
    echo __________________________________________________________________________________________
	echo.
	pause
exit

:OSOK
	echo.
    echo __________________________________________________________________________________________
	echo.
	echo [ Vérification de la présence d'une mise à jour ]
	del "%TEMP%\version.txt" 1>nul 2>nul
	powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/version.txt', '%TEMP%\version.txt')" 1>nul 2>nul
	set /p controle_version_toolkit=<%TEMP%\version.txt 1>nul 2>nul
	if exist "%TEMP%\version.txt" (
		if "%controle_version_toolkit%"=="%toolkit_version%" (
			echo %green%OK%u%
		) else (
			echo %blink%La version %controle_version_toolkit% est disponible depuis la page d'accueil%u%
		)
	) else (
		echo %red%Échec de la vérification%u%
	)
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
	echo   %gray%%under%Activation Office/Windows%u%
	echo.
	echo 	1.  Activation Windows/Office (KMS)	2.  Status d'activation Windows/Office
	echo.
	echo   %gray%%under%Utilitaires de configuration et maintenance%u%
	echo.
	echo 	3.  Configuration performances		5.  Ajout/suppression fonctionnalités
	echo 	4.  Configuration vie privée		6.  Modification informations OEM
	echo.
	echo   %gray%%under%Utilitaires de maintenance%u%
	echo.
	echo 	7.  Défragmentation système		13. Réparation référentiel WMI
	echo 	8.  Nettoyage système			14. Réparation réseau
	echo 	9.  Nettoyage système complet    %red%/!\%u%	15. Réparation réseau complète
	echo 	10. Nettoyage Windows Installer  %red%/!\%u%	16. Réparation système Windows
	echo 	11. Réparation apps Windows		17. Réparation Windows Installer
	echo 	12. Réparation cache d'icônes		18. Réparation Windows Update
	echo.
	echo 				  19. Windows Update
	echo.
	echo   %gray%%under%Divers%u%
	echo.
	echo 				20. Logithèque en ligne
	echo.
	echo 	21. Télécharger dernière version	22. Télécharger packages Windows Update
	echo.
    echo __________________________________________________________________________________________
	echo.
	set /p choix=Sélectionnez l'opération à effectuer (0 pour quitter): 
	if /i "%choix%"=="1" (goto activation_kms)
	if /i "%choix%"=="2" (goto activation_status)
	if /i "%choix%"=="3" (goto configuration_performances)
	if /i "%choix%"=="4" (goto configuration_privacy)
	if /i "%choix%"=="5" (OptionalFeatures.exe)
	if /i "%choix%"=="6" (goto oem_information)
	if /i "%choix%"=="7" (goto defrag)
	if /i "%choix%"=="8" (goto nettoyage_basique)
	if /i "%choix%"=="9" (goto nettoyage_complet)
	if /i "%choix%"=="10" (goto nettoyage_windows_installer)
	if /i "%choix%"=="11" (goto reparation_apps)
	if /i "%choix%"=="12" (goto reparation_icones)
	if /i "%choix%"=="13" (goto reparation_wmi)
	if /i "%choix%"=="14" (goto reparation_reseau_basique)
	if /i "%choix%"=="15" (goto reparation_reseau_complet)
	if /i "%choix%"=="16" (goto reparation_win)
	if /i "%choix%"=="17" (goto reparation_win_intaller)
	if /i "%choix%"=="18" (goto reparation_wu)
	if /i "%choix%"=="19" (goto Windows_update)
	if /i "%choix%"=="20" (start https://1drv.ms/f/c/011dbcd351618514/EhSFYVHTvB0ggAHe-gMAAAABVx8HKWQvEjg8qcNBmAesMg)
	if /i "%choix%"=="21" (start https://1drv.ms/f/c/011dbcd351618514/EhSFYVHTvB0ggAEGAgQAAAABOMEjMYgnwerK-fsI6Mowaw)
	if /i "%choix%"=="22" (start https://1drv.ms/f/c/011dbcd351618514/EhSFYVHTvB0ggAG56gMAAAABzpb74buvreHFXUhLGtM1Ow)
	if /i "%choix%"=="0" (exit)
goto main



:: Activation de Windows via KMS
:activation_kms
	cls
	echo.
	call :titre
	echo.
	echo %red%Activation de Windows - Office (KMS_VL_ALL - abbodi1406)%u%
	echo.
	echo IMPORTANT :
	echo Une connexion Internet est requise.
	echo Il est nécessaire de désactiver votre antivirus avant de poursuivre.
	echo.
	pause
	powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/abbodi1406/KMS_VL_ALL_AIO/raw/refs/heads/master/KMS_VL_ALL_AIO.cmd', 'add-on\KMS_VL_ALL_AIO.cmd')" 1>nul 2>nul
	call add-on\KMS_VL_ALL_AIO.cmd
	del "add-on\KMS_VL_ALL_AIO.cmd" 1>nul 2>nul
	mode con cols=90 lines=45
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
	cscript //nologo %SYSTEMROOT%\system32\slmgr.vbs /dli
	cscript //nologo %SYSTEMROOT%\system32\slmgr.vbs /xpr
	echo.
	echo %red%Status de l'activation d'Office%u%
	cd /d %~dp0
	set office=
	if exist "%ProgramFiles%\Microsoft Office\Office14\OSPP.VBS" (
		cd /d "%ProgramFiles%\Microsoft Office\Office14"
		echo.
		cscript //nologo OSPP.VBS /dstatus
		echo.
		pause
		cd /d %~dp0
		goto main
	)
	if exist "%ProgramFiles(x86)%\Microsoft Office\Office14\OSPP.VBS" (
		cd /d "%ProgramFiles(x86)%\Microsoft Office\Office14"
		echo.
		cscript //nologo OSPP.VBS /dstatus
		echo.
		pause
		cd /d %~dp0
		goto main
	)
	if exist "%ProgramFiles%\Microsoft Office\Office15\OSPP.VBS" (
		cd /d "%ProgramFiles%\Microsoft Office\Office15"
		echo.
		cscript //nologo OSPP.VBS /dstatus
		echo.
		pause
		cd /d %~dp0
		goto main
	)
	if exist "%ProgramFiles(x86)%\Microsoft Office\Office15\OSPP.VBS" (
		cd /d "%ProgramFiles(x86)%\Microsoft Office\Office15"
		echo.
		cscript //nologo OSPP.VBS /dstatus
		echo.
		pause
		cd /d %~dp0
		goto main
	)
	if exist "%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" (
		cd /d "%ProgramFiles%\Microsoft Office\Office16"
		echo.
		cscript //nologo OSPP.VBS /dstatus
		echo.
		pause
		cd /d %~dp0
		goto main
	)
	if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS" (
		cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16"
		echo.
		cscript //nologo OSPP.VBS /dstatus
		echo.
		pause
		cd /d %~dp0
		goto main
	)
	echo
	echo Aucune version compatible d'Office n'a été détectée.
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
	netsh int ipv4 set glob defaultcurhoplimit=65 1>nul 2>nul
	netsh int ipv6 set glob defaultcurhoplimit=65 1>nul 2>nul
	netsh int tcp set global autotuninglevel=normal 1>nul 2>nul
	netsh int tcp set global chimney=disabled 1>nul 2>nul
	netsh int tcp set global dca=enabled 1>nul 2>nul
	netsh int tcp set global initialRto=1000 1>nul 2>nul
	netsh int tsp set global maxsynretransmissions=2 1>nul 2>nul
	netsh int tcp set global nonsackrttresiliency=disabled 1>nul 2>nul
	netsh int tcp set global rsc=disabled 1>nul 2>nul
	netsh int tcp set global rss=enabled 1>nul 2>nul
	netsh int tcp set global timestamps=disabled 1>nul 2>nul
	netsh int tcp set heuristics disabled 1>nul 2>nul
	netsh int tcp set supplemental Internet congestionprovider=ctcp 1>nul 2>nul
	netsh int tcp set supplemental template=custom icw=10 1>nul 2>nul
	powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a 1>nul 2>nul
	powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 1>nul 2>nul
	powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 1>nul 2>nul
	powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 1>nul 2>nul
	reg add "HKCR\*\shell\Ouvrir avec Notepad" /v Icon /t REG_SZ /d "notepad.exe,-2" /f 1>nul 2>nul
	reg add "HKCR\*\shell\Ouvrir avec Notepad\command" /ve /t REG_SZ /d "notepad.exe %%1" /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 3000 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v LowLevelHooksTimeout /t REG_SZ /d 4000 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 10000 /f 1>nul 2>nul
	reg add "HKCU\Control Panel\Desktop" /v WaitToKillServiceTimeout /t REG_SZ /d 1000 /f 1>nul 2>nul
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
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKCU\SYSTEM\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKCU\SYSTEM\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d Y /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v value /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v MaxCachedIcons /t REG_SZ /d 4096 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v MemCheckBoxInRunDlg /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowgameDVR /t REG_DWORD /d 0 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AllowMUUpdateService /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 1000 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v AutoReboot /t REG_DWORD /d 0 /f 1>nul 2>nul
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
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUBHDetect /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v NameSrvQueryTimeout /t REG_DWORD /d 3000 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpMaxDupAcks /t REG_DWORD /d 2 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v DnsPriority /t REG_DWORD /d 6 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v HostPriority /t REG_DWORD /d 5 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v LocalPriority /t REG_DWORD /d 4 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v NetbtPriority /t REG_DWORD /d 7 /f 1>nul 2>nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WOW" /v DefaultSeparateVDM /t REG_SZ /d Yes /f 1>nul 2>nul
	echo.
	echo %red%Configuration des fonctionnalités de Windows%u%
	dism.exe /online /enable-feature /featurename:DirectPlay /all /quiet /norestart 1>nul 2>nul
	dism.exe /online /enable-feature /featurename:NetFX3 /quiet /norestart 1>nul 2>nul
	dism.exe /online /enable-feature /featurename:SMB1Protocol /all /quiet /norestart 1>nul 2>nul
	echo.
	echo %red%Configuration des services Windows%u%
	sc stop RemoteRegistry 1>nul 2>nul
	sc config RemoteRegistry start=Disabled 1>nul 2>nul
	sc stop VSS 1>nul 2>nul
	sc config VSS start=Disabled 1>nul 2>nul
	sc stop WerSvc 1>nul 2>nul
	sc config WerSvc start=Disabled 1>nul 2>nul
	powershell -command "Get-PhysicalDisk | select MediaType" | find /i "SD" 1>nul
	if %errorlevel%==0 (
		sc stop WSearch 1>nul 2>nul
		sc config WSearch start=Auto 1>nul 2>nul
	) else (
		sc stop WSearch 1>nul 2>nul
		sc config WSearch start=Disabled 1>nul 2>nul
	)
	echo.
	echo %red%Configuration du nettoyage de disque Windows%u%
	cleanmgr /sageset:1
	echo.
	echo %red%Désactivation de la veille prolongée%u%
	powercfg -hibernate off 1>nul 2>nul
	echo.
	powershell -command "Get-PhysicalDisk | select MediaType" | find /i "SD" 1>nul
	if %errorlevel%==0 (
		echo %red%Optimisation du SSD%u%
		fsutil behavior set DisableDeleteNotify 0 1>nul 2>nul
		fsutil behavior set DisableLastAccess 1 1>nul 2>nul
		reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d N /f 1>nul 2>nul
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableBoottrace /t REG_DWORD /d 0 /f 1>nul 2>nul
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f 1>nul 2>nul
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f 1>nul 2>nul
		sc stop "Superfetch" 1>nul 2>nul
		sc config "Superfetch" start=Disabled 1>nul 2>nul
		sc stop "SysMain" 1>nul 2>nul
		sc config "SysMain" start=Disabled 1>nul 2>nul
		schtasks /Delete /F /TN "Microsoft\Windows\Defrag\ScheduledDefrag" 1>nul 2>nul
		echo.
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
	sc stop DiagTrack 1>nul 2>nul
	sc stop diagnosticshub.standardcollector.service 1>nul 2>nul
	sc stop dmwappushservice 1>nul 2>nul
	sc stop WMPNetworkSvc 1>nul 2>nul
	sc config DiagTrack start=Disabled 1>nul 2>nul
	sc config diagnosticshub.standardcollector.service start=Disabled 1>nul 2>nul
	sc config dmwappushservice start=Disabled 1>nul 2>nul
	sc config WMPNetworkSvc start=Disabled 1>nul 2>nul
	echo.
	echo %red%Désactivation des tâches planifiées%u%
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
	echo %red%Modification du registre%u%
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
	echo %red%Modifications supplémentaires%u%
	del /f /q %ProgramData%\Microsoft\Diagnosis\*.rbs 1>nul 2>nul
	del /f /q /s %ProgramData%\Microsoft\Diagnosis\ETLLogs\* 1>nul 2>nul
	::NVIDIA
	sc stop NvTelemetryContainer 1>nul 2>nul
	sc config NvTelemetryContainer start=Disabled 1>nul 2>nul
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
	set /p confirm=Confirmer ces informations (O/N) :
	echo.
	if /i "%confirm%" neq "O" (
		echo Annulation. Aucune modification n'a été effectuée.
		echo.
		pause
		goto main
	)
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
	del "%LOCALAPPDATA%\Microsoft\Windows\WebCache" /f /q /s 1>nul 2>nul
	del "%SYSTEMROOT%\Temp\*" /f /q /s 1>nul 2>nul
	del "%TEMP%\*" /f /q /s 1>nul 2>nul
	echo.
	echo %red%Nettoyage de Windows Update%u%
	net stop wuauserv 1>nul 2>nul
	rd "%SYSTEMROOT%\SoftwareDistribution" /q /s 1>nul 2>nul
	net start wuauserv 1>nul 2>nul
	echo.
	echo %red%Nettoyage de disque Windows%u%
	cleanmgr /sagerun:1 1>nul 2>nul
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
	rd "%SYSTEMDRIVE%\$GetCurrent" /q /s 1>nul 2>nul
	rd "%SYSTEMDRIVE%\$SysReset" /q /s 1>nul 2>nul
	rd "%SYSTEMDRIVE%\$WinREAgent" /q /s 1>nul 2>nul
	rd "%SYSTEMDRIVE%\$Windows.~BT" /q /s 1>nul 2>nul
	rd "%SYSTEMDRIVE%\$Windows.~WS" /q /s 1>nul 2>nul
	rd "%SYSTEMDRIVE%\inetpub" /q /s 1>nul 2>nul
	rd "%SYSTEMDRIVE%\PerfLogs" /q /s 1>nul 2>nul
	rd "%SYSTEMDRIVE%\Windows.old" /q /s 1>nul 2>nul
	echo.
	echo %red%Nettoyage des fichiers temporaires%u%
	reg delete "HKCU\Software\Classes\Local Settings\MuiCache" /f 1>nul 2>nul
	reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /f 1>nul 2>nul
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f 1>nul 2>nul
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f 1>nul 2>nul
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f 1>nul 2>nul
	reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /f 1>nul 2>nul
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f 1>nul 2>nul
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f 1>nul 2>nul
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f 1>nul 2>nul
	del "%APPDATA%\Microsoft\Windows\Recent\*" /f /q 1>nul 2>nul
	del "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" /f /q 1>nul 2>nul
	del "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*" /f /q 1>nul 2>nul
	del "%LOCALAPPDATA%\IconCache.db" /a:h /f /q 1>nul 2>nul
	del "%LOCALAPPDATA%\Microsoft\Windows\Explorer\*.db" /f /q 1>nul 2>nul
	del "%PROGRAMDATA%\Microsoft\RAC\*" /f /q /s 1>nul 2>nul
	del "%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive\*" /f /q /s 1>nul 2>nul
	for /d %%p in ("%PROGRAMDATA%\Microsoft\Windows\WER\ReportArchive\*.*") do rd "%%p" /q /s 1>nul 2>nul
	del "%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue\*" /f /q /s 1>nul 2>nul
	for /d %%p in ("%PROGRAMDATA%\Microsoft\Windows\WER\ReportQueue\*.*") do rd "%%p" /q /s 1>nul 2>nul
	del "%PROGRAMDATA%\Microsoft\Windows\WER\Temp\*" /f /q /s 1>nul 2>nul
	del "%PROGRAMDATA%\Microsoft\Windows Defender\Definition Updates\Backup\*" /f /q /s 1>nul 2>nul
	del "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\Results\Quick\*" /f /q /s 1>nul 2>nul
	del "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\Results\Resource\*" /f /q /s 1>nul 2>nul
	del "%PROGRAMDATA%\Microsoft\Windows Defender\Scans\History\Service\*" /f /q /s 1>nul 2>nul
	del "%SYSTEMROOT%\Installer\$PatchCache$\*" /f /q /s 1>nul 2>nul
	del "%SYSTEMROOT%\LiveKernelReports\WATCHDOG\*" /f /q /s 1>nul 2>nul
	del "%SYSTEMROOT%\WinSxS\Backup\*" /f /q /s 1>nul 2>nul
	taskkill /f /im explorer.exe 1>nul 2>nul
	start explorer.exe 1>nul 2>nul
	del "%TEMP%\*" /f /q /s 1>nul 2>nul
	del "%USERPROFILE%\*.blf" /f /q 1>nul 2>nul
	del "%USERPROFILE%\*.regtrans-ms" /f /q 1>nul 2>nul
	del "%USERPROFILE%\Recent\*" /f /q 1>nul 2>nul
	sc stop TrustedInstaller 1>nul 2>nul
	del "%SYSTEMROOT%\Logs\*" /f /q /s 1>nul 2>nul
	sc start TrustedInstaller 1>nul 2>nul
	del "%SYSTEMROOT%\Prefetch\*" /f /q /s 1>nul 2>nul
	del "%SYSTEMROOT%\Temp\*" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.bad" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.bak" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.chk" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.dmp" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.err" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.etl" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.log" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.old" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\*.tmp" /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\mscreate.dir" /a:h /f /q /s 1>nul 2>nul
	del "%SYSTEMDRIVE%\thumbs.db" /a:h /f /q /s 1>nul 2>nul
	rd "%SYSTEMROOT%\LastGood.tmp" /q /s 1>nul 2>nul
	rd "%SYSTEMROOT%\Minidump" /q /s 1>nul 2>nul
	echo.
	echo %red%Nettoyage de Windows Update%u%
	net stop wuauserv 1>nul 2>nul
	net stop bits 1>nul 2>nul
	dism /online /cleanup-image /spsuperseded
	dism /online /cleanup-image /startcomponentcleanup /resetbase
	rd "%SYSTEMROOT%\SoftwareDistribution\Download" /q /s 1>nul 2>nul
	net start wuauserv 1>nul 2>nul
	net start bits 1>nul 2>nul
	echo.
	echo %red%Nettoyage de disque Windows%u%
	cleanmgr /sagerun:1 1>nul 2>nul
	echo.
	echo %red%Nettoyage des navigateurs Internet Windows (IE & Edge)%u%
	taskkill /f /im iexplore.exe 1>nul 2>nul
	RunDll32 InetCpl.cpl,ClearMyTracksByProcess 4351 1>nul 2>nul
	taskkill /f /im msedge.exe 1>nul 2>nul
	set "edgeUserData=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default"
	del "%edgeUserData%\History" /f /q
	del "%edgeUserData%\History-journal" /f /q
	del "%edgeUserData%\Cookies" /f /q
	del "%edgeUserData%\Cookies-journal" /f /q
	rmdir "%edgeUserData%\Cache" /q /s
	rmdir "%edgeUserData%\Code Cache" /q /s
	rmdir "%edgeUserData%\GPUCache" /q /s
	echo.
	echo %red%Nettoyage des copies de sauvegarde Windows%u%
	vssadmin delete shadows /all /quiet 1>nul 2>nul
	echo.
	echo %red%Nettoyage du cache de l'observateur d'évènements%u%
	for /f "tokens=*" %%1 in ('wevtutil.exe el') do wevtutil.exe cl "%%1" 1>nul 2>nul
	echo.	
	echo %red%Nettoyage du gestionnaire de péripheriques%u%
	rundll32.exe pnpclean.dll,RunDLL_PnpClean /DEVICES /DRIVERS /FILES /MAXCLEAN 1>nul 2>nul
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
	set "orphans_found=0"
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
		del all_installer_files.txt 1>nul 2>nul
		del reg_installer.txt 1>nul 2>nul
		del "%logFile%" 1>nul 2>nul
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
	del all_installer_files.txt 1>nul 2>nul
	del reg_installer.txt 1>nul 2>nul
	del "%logFile%" 1>nul 2>nul
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
	powershell -command "Get-AppxPackage -allusers | foreach {Add-AppxPackage -register ($_.InstallLocation + '\AppXManifest.xml') -DisableDevelopmentMode}"
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
	taskkill /f /im explorer.exe 1>nul 2>nul
	attrib -h %LOCALAPPDATA%\IconCache.db 1>nul 2>nul
	del "%LOCALAPPDATA%\IconCache.db" /f /q 1>nul 2>nul
	attrib -h %LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db 1>nul 2>nul
	del "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" /f /q 1>nul 2>nul
	start explorer.exe 1>nul 2>nul
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
	echo %red%Réparation du référentiel WMI"%u%
	net stop winmgmt /y 1>nul 2>nul
	winmmgmt /salvagerepository 1>nul 2>nul
	winmgmt /resetrepository 1>nul 2>nul
	net start winmgmt 1>nul 2>nul
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
	netsh int ip reset 1>nul 2>nul
	netsh winsock reset 1>nul 2>nul
	ipconfig /release 1>nul 2>nul
	ipconfig /renew 1>nul 2>nul
	ipconfig /flushdns 1>nul 2>nul
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
	netsh int ip reset 1>nul 2>nul
	netsh winsock reset 1>nul 2>nul
	ipconfig /release 1>nul 2>nul
	ipconfig /renew 1>nul 2>nul
	ipconfig /flushdns 1>nul 2>nul
	for /f "usebackq tokens=*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles"') do reg delete "%%a" /f 1>nul 2>nul
	for /f "usebackq tokens=*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Unmanaged"') do reg delete "%%a" /f 1>nul 2>nul
	ver | find /i "version 10" 1>nul
	if %errorlevel%==0 (
		netcfg -d 1>nul 2>nul
	)
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
	echo %red%Analyse du système de fichiers Windows (CHKDSK)%u%
	fsutil dirty set %SYSTEMDRIVE%
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
	net stop msiserver 1>nul 2>nul
	sc config msiserver start=Demand 1>nul 2>nul
	msiexec /unregister 1>nul 2>nul
	msiexec /regserver 1>nul 2>nul
	regsvr32.exe /s %SYSTEMROOT%\System32\msi.dll 1>nul 2>nul
	net start msiserver 1>nul 2>nul
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
	net stop bits 1>nul 2>nul
	net stop wuauserv 1>nul 2>nul
	net stop appidsvc 1>nul 2>nul
	net stop cryptsvc 1>nul 2>nul
	net stop usosvc 1>nul 2>nul
	taskkill /im wuauclt.exe /f 1>nul 2>nul
	echo.
	echo %red%Vérification de l'arrêt des services Windows Update%u%
	sc query bits | findstr /I /C:"STOPPED"
	if %errorlevel% NEQ 0 (
		echo Une erreur a été détectée.
		echo Le processus va s'arreter.
		echo.
		pause
		goto main
	)
	sc query wuauserv | findstr /I /C:"STOPPED"
	if %errorlevel% NEQ 0 (
		echo Une erreur a été détectée.
		echo Le processus va s'arreter.
		echo.
		pause
		goto main
	)
	sc query appidsvc | findstr /I /C:"STOPPED"
	if %errorlevel% NEQ 0 (
		sc query appidsvc | findstr /I /C:"OpenService FAILED 1060"
		if %errorlevel% NEQ 0 (
			echo Une erreur a été détectée.
			echo Le processus va s'arreter.
			echo.
			pause
		goto main
		)
	)
	sc query cryptsvc | findstr /I /C:"STOPPED"
	if %errorlevel% NEQ 0 (
		echo Une erreur a été détectée.
		echo Le processus va s'arreter.
		echo.
		pause
		goto main
	)
	sc query usosvc | findstr /I /C:"STOPPED"
	if %errorlevel% NEQ 0 (
		echo Une erreur a été détectée.
		echo Le processus va s'arreter.
		echo.
		pause
		goto main
	)
	echo.
	echo %red%Suppression des fichiers qmgr.dat%u%
	del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat" /f /q /s 1>nul 2>nul
	del "%ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr*.dat" /f /q /s 1>nul 2>nul
	echo.
	echo %red%Suppression des fichiers temporaires Windows Update%u%
	if exist "%PROGRAMDATA%\USOPrivate\UpdateStore" (
		attrib -r -s -h /s /d "%PROGRAMDATA%\USOPrivate\UpdateStore" 1>nul 2>nul
		del "%PROGRAMDATA%\USOPrivate\UpdateStore\*" /f /q /s 1>nul 2>nul
	)
	if exist "%SYSTEMROOT%\WindowsUpdate.log" (
		attrib -r -s -h /s /d "%SYSTEMROOT%\WindowsUpdate.log" 1>nul 2>nul
		del "%SYSTEMROOT%\WindowsUpdate.log" /f /q /s 1>nul 2>nul
	)
	if exist "%SYSTEMROOT%\WinSxS\pending.xml" (
		takeown /f "%SYSTEMROOT%\WinSxS\pending.xml" 1>nul 2>nul
		attrib -r -s -h /s /d "%SYSTEMROOT%\WinSxS\pending.xml" 1>nul 2>nul
		del "%SYSTEMROOT%\WinSxS\pending.xml" /f /q /s 1>nul 2>nul
	)
	if exist "%SYSTEMROOT%\SoftwareDistribution" (
		attrib -r -s -h /s /d "%SYSTEMROOT%\SoftwareDistribution" 1>nul 2>nul
		rd "%SYSTEMROOT%\SoftwareDistribution" /q /s 1>nul 2>nul
	)
	if exist "%SYSTEMROOT%\System32\Catroot2" (
		attrib -r -s -h /s /d "%SYSTEMROOT%\System32\Catroot2" 1>nul 2>nul
		rd "%SYSTEMROOT%\System32\Catroot2" /q /s 1>nul 2>nul
	)
	echo.
	echo %red%Réinscription des composants BITS et Windows Update%u%
	cd /d %SYSTEMROOT%\System32
	regsvr32 /s atl.dll
	regsvr32 /s urlmon.dll
	regsvr32 /s mshtml.dll
	regsvr32 /s shdocvw.dll
	regsvr32 /s browseui.dll
	regsvr32 /s jscript.dll
	regsvr32 /s vbscript.dll
	regsvr32 /s scrrun.dll
	regsvr32 /s msxml.dll
	regsvr32 /s msxml3.dll
	regsvr32 /s msxml6.dll
	regsvr32 /s actxprxy.dll
	regsvr32 /s softpub.dll
	regsvr32 /s wintrust.dll
	regsvr32 /s dssenh.dll
	regsvr32 /s rsaenh.dll
	regsvr32 /s gpkcsp.dll
	regsvr32 /s sccbase.dll
	regsvr32 /s slbcsp.dll
	regsvr32 /s cryptdlg.dll
	regsvr32 /s oleaut32.dll
	regsvr32 /s ole32.dll
	regsvr32 /s shell32.dll
	regsvr32 /s initpki.dll
	regsvr32 /s wuapi.dll
	regsvr32 /s wuaueng.dll
	regsvr32 /s wuaueng1.dll
	regsvr32 /s wucltui.dll
	regsvr32 /s wups.dll
	regsvr32 /s wups2.dll
	regsvr32 /s wuweb.dll
	regsvr32 /s qmgr.dll
	regsvr32 /s qmgrprxy.dll
	regsvr32 /s wucltux.dll
	regsvr32 /s muweb.dll
	regsvr32 /s wuwebv.dll
	cd /d %~dp0
	echo.
	echo %red%Réinitialisation des paramètres BITS, Winsock et Winhttp%u%
	netsh winsock reset 1>nul 2>nul
	sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU) 1>nul 2>nul
	sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU) 1>nul 2>nul
	echo.
	echo %red%Configuration du démarrage des services%u%
	sc config wuauserv start=auto 1>nul 2>nul
	sc config bits start=delayed-auto 1>nul 2>nul
	sc config cryptsvc start=auto 1>nul 2>nul
	sc config TrustedInstaller start=demand 1>nul 2>nul
	sc config DcomLaunch start=auto 1>nul 2>nul
	echo.
	echo %red%Redémarrage des services Windows Update%u%
	net start bits 1>nul 2>nul
	net start wuauserv 1>nul 2>nul
	net start appidsvc 1>nul 2>nul
	net start cryptsvc 1>nul 2>nul
	net start usosvc 1>nul 2>nul
	net start DcomLaunch 1>nul 2>nul
	echo.
	echo %green%La réparation est terminée%u%
	echo.
	call :callforrestart
goto main



:: Windows Update
:Windows_update
	if exist "windows_update\%build_win%\" (
		if %build% GEQ 22000 (
			goto main_wu_11
		)
		goto main_wu_10
	) else (
		echo.
		echo %red%Windows Update offline n'est pas pris en charge par cette version%u%
		echo %red%Pour une utilisation avec ce script, suivez ces instructions :%u%
		echo %red%1. Créez un dossier 'windows_update' dans le même répertoire que le script%u%
		echo %red%2. Téléchargez les dossiers 'Common' et '%build_win%' depuis le menu principal%u%
		echo %red%3. Placez-les ensuite dans le dossier 'windows_update' précédemment créé%u%
		echo %red%4. Exécutez à nouveau le script et retournez à nouveau dans ce menu%u%
		echo %red%Vous allez maintenant être redirigé vers l'interface de mise à jour de Windows%u%
		echo.
		pause
		explorer ms-settings:windowsupdate
	)
goto main



:: Windows 10 / Server 2016 / Server 2019 / Server 2022 Update
:main_wu_10
	cls
	echo.
	call :titre
	echo.
	echo 	%Caption% (%version_win% - %archi%)
	echo.
	echo 		1. Windows Update
	echo 		2. Packages redistribuables
	echo 		3. Packages UWP
	echo 		4. .NET
	echo 		5. Définitions antivirus
	echo 		0. Retour au menu principal
	echo.
    echo __________________________________________________________________________________________
	echo.
	set /p choix=Sélectionnez la mise à jour à appliquer : 
	if /i "%choix%"=="1" (goto 10_up)
	if /i "%choix%"=="2" (goto 10_redist)
	if /i "%choix%"=="3" (goto 10_uwp)
	if /i "%choix%"=="4" (goto 10_net)
	if /i "%choix%"=="5" (goto 10_definitions)
	if /i "%choix%"=="0" (goto main)
goto main_wu_10

:10_up
	echo.
	echo %red%Installation de la mise à jour de la pile de maintenance%u%
	for /f %%i in ('dir /B windows_update\%build_win%\%archi%\1.SS\') do (
		if exist windows_update\%build_win%\%archi%\1.SS\*.cab (
			dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\1.SS\%%i" /norestart
		)
	)
	echo.
	echo %red%Installation du correctif cumulatif%u%
	for /f %%i in ('dir /B windows_update\%build_win%\%archi%\2.CU\') do (
		if exist windows_update\%build_win%\%archi%\2.CU\*.cab (
			dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\2.CU\%%i" /norestart
		) else if exist windows_update\%build_win%\%archi%\2.CU\*.msu (
			dism /online /add-package="windows_update\%build_win%\%archi%\2.CU\%%i" /norestart
		)
	)
	echo.
	if %build% EQU 18362 (
		echo %red%Installation du Feature Update Windows 10 - 1909%u%
		dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\0.FU\windows10.0-kb4517245-%archi%.cab" /norestart
		echo.
	)
	if %build% GEQ 19041 (
		if %build% LSS 19045 (
			echo %red%Installation du Feature Update Windows 10 - 22H2%u%
			dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\0.FU\windows10.0-kb5015684-%archi%.cab" /norestart
			echo.
		)
	)
	if %build% EQU 20348 (
		echo %red%Installation du Feature Update Windows Server 2022 - 22H2%u%
		dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\0.FU\Windows10.0-KB5016060-%archi%.cab" /norestart
		echo.
	)
	echo %red%Installation du correctif cumulatif .NET%u%
	if %build% GEQ 19042 (
		reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.8.1" 1>nul 2>nul
		if %errorlevel%==1 (
			windows_update\Common\DOTNET\Framework\4_8_1\ndp481-x86-x64-allos-enu.exe /quiet /norestart
			windows_update\Common\DOTNET\Framework\4_8_1\ndp481-x86-x64-allos-fra.exe /quiet /norestart
		)
	)
	for /f %%i in ('dir /B windows_update\%build_win%\%archi%\3.NET\') do (
		if exist windows_update\%build_win%\%archi%\3.NET\*.cab (
			dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\3.NET\%%i" /norestart
		)
	)
	echo.
	echo %green%Installation des correctifs terminée%u%
	echo.
	call :callforrestart
goto main_wu_10

:10_redist
	echo.
	if %archi% EQU ARM64 (
		echo %red%L'architecture ARM64 n'est pas prise en charge%u%
		echo.
		pause
		goto main_wu_10
	)
	echo %red%Installation de DirectX%u%
	windows_update\Common\DirectX\DirectX_Redist_Repack_x86_x64.exe /ai /gm2
	echo.
	echo %red%Installation de MSXML 4 Service Pack 3%u%
	windows_update\Common\MSXML\MSXML4-KB2758694-FRA.exe /quiet /norestart
	echo.
	echo %red%Installation des packages Visual Studio redistribuables%u%
	windows_update\Common\VS_REDIST\VisualCppRedist_AIO_x86_x64.exe /ai /gm2
	echo.
	echo %green%Installation terminée%u%
	echo.
	pause
goto main_wu_10

:10_uwp
	echo.
	if %archi% EQU ARM64 (
		echo %red%L'architecture ARM64 n'est pas prise en charge%u%
		echo.
		pause
		goto main_wu_10
	)
	echo %red%Installation des packages UWP%u%
	cd windows_update\Common\UWP\dvd\
	powershell.exe -executionpolicy bypass -command "Add-AppxProvisionedPackage -Online -PackagePath 50ea4d02e68f4217869d054e06374b74.appxbundle -LicensePath 50ea4d02e68f4217869d054e06374b74_License1.xml" 1>nul 2>nul
	cd ..
	for /f %%i in ('dir /B redist\%archi%\') do (
		powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path 'redist\%archi%\%%i'" 1>nul 2>nul
	)
	if %build% GEQ 17134 (
		for /f %%i in ('dir /B lxp\%build_win%\') do (
			powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path 'lxp\%build_win%\%%i'" 1>nul 2>nul
		)
	)
	for /f %%i in ('dir /B neutral\APPX') do (
		powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path 'neutral\APPX\%%i'" 1>nul 2>nul
	)
	if %build% GEQ 17763 (
		for /f %%i in ('dir /B neutral\MSIX') do (
			powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path 'neutral\MSIX\%%i'" 1>nul 2>nul
		)
	)
	cd /d %~dp0
	echo.
	echo %green%Installation terminée%u%
	echo.
	pause
goto main_wu_10

:10_net
	echo.
	echo %red%Installation de .NET Framework%u%
	dism.exe /online /enable-feature /featurename:NetFX3 /quiet /norestart 1>nul 2>nul
	if %build% GEQ 19042 (
		reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.8.1" 1>nul 2>nul
		if %errorlevel%==1 (
			windows_update\Common\DOTNET\Framework\4_8_1\ndp481-x86-x64-allos-enu.exe /quiet /norestart
			windows_update\Common\DOTNET\Framework\4_8_1\ndp481-x86-x64-allos-fra.exe /quiet /norestart
		)
	)
	echo.
	echo %red%Installation de .NET%u%
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\3_1\') do (
		windows_update\Common\DOTNET\Core\3_1\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\5_0\') do (
		windows_update\Common\DOTNET\Core\5_0\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\6_0\') do (
		windows_update\Common\DOTNET\Core\6_0\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\7_0\') do (
		windows_update\Common\DOTNET\Core\7_0\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\8_0\') do (
		windows_update\Common\DOTNET\Core\8_0\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\9_0\') do (
		windows_update\Common\DOTNET\Core\9_0\%%i /quiet /norestart
	)
	echo.
	echo %green%Installation terminée%u%
	echo %green%Il est maintenant recommandé de redémarrer votre ordinateur%u%
	echo.
	call :callforrestart
goto main_wu_10

:10_definitions
	echo.
	echo %red%Installation de l'outil de supression des logiciels malveillants%u%
	for /f %%i in ('dir /B windows_update\Common\AntiMalware\MSRT\%archi%\') do (
		windows_update\Common\AntiMalware\MSRT\%archi%\%%i /quiet /norestart
	)
	echo.
	echo %red%Installation de la mise jour de la plateforme Microsoft Defender%u%
	windows_update\Common\AntiMalware\Definitions\%archi%\updateplatform.exe
	echo.
	echo %red%Installation de la mise à jour de définitions Microsoft Defender%u%
	windows_update\Common\AntiMalware\Definitions\%archi%\mpam-fe.exe
	echo.
	echo %green%Installation terminée%u%
	echo.
	pause
goto main_wu_10



:: Windows 11 / Server 2025 Update
:main_wu_11
	cls
	echo.
	call :titre
	echo.
	echo 	%Caption% (%version_win% - %archi%)
	echo.
	echo 		1. Windows Update
	echo 		2. Packages redistribuables
	echo 		3. Packages UWP
	echo 		4. .NET
	echo 		5. Définitions antivirus
	echo 		0. Retour au menu principal
	echo.
    echo __________________________________________________________________________________________
	echo.
	set /p choix=Sélectionnez la mise à jour à appliquer : 
	if /i "%choix%"=="1" (goto 11_up)
	if /i "%choix%"=="2" (goto 11_redist)
	if /i "%choix%"=="3" (goto 11_uwp)
	if /i "%choix%"=="4" (goto 11_net)
	if /i "%choix%"=="5" (goto 11_definitions)
	if /i "%choix%"=="0" (goto main)
goto main_wu_11

:11_up
	echo.
	echo %red%Installation du correctif cumulatif%u%
	for /f %%i in ('dir /B windows_update\%build_win%\%archi%\1.CU\') do (
		if exist windows_update\%build_win%\%archi%\1.CU\*.cab (
			dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\1.CU\%%i" /norestart
		) else if exist windows_update\%build_win%\%archi%\1.CU\*.msu (
			dism /online /add-package="windows_update\%build_win%\%archi%\1.CU\%%i" /norestart
		)
	)
	echo.
	if %build% EQU 22621 (
		echo %red%Installation du Feature Update Windows 11 - 23H2%u%
		dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\0.FU\Windows11.0-KB5027397-%archi%.cab" /norestart
		echo.
	)
	echo %red%Installation du correctif cumulatif .NET%u%
	reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.8.1" 1>nul 2>nul
	if %errorlevel%==1 (
		windows_update\Common\DOTNET\Framework\4_8_1\ndp481-x86-x64-allos-enu.exe /quiet /norestart
		windows_update\Common\DOTNET\Framework\4_8_1\ndp481-x86-x64-allos-fra.exe /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\%build_win%\%archi%\2.NET\') do (
		if exist windows_update\%build_win%\%archi%\2.NET\*.cab (
			dism /online /add-package /packagepath:"windows_update\%build_win%\%archi%\2.NET\%%i" /norestart
		)
	)
	echo.
	echo %green%Installation des correctifs terminée%u%
	echo.
	call :callforrestart
goto main_wu_11

:11_redist
	echo.
	if %archi% EQU ARM64 (
		echo %red%L'architecture ARM64 n'est pas prise en charge%u%
		echo.
		pause
		goto main_wu_11
	)
	echo %red%Installation de DirectX%u%
	windows_update\Common\DirectX\DirectX_Redist_Repack_x86_x64.exe /ai /gm2
	echo.
	echo %red%Installation de MSXML 4 Service Pack 3%u%
	windows_update\Common\MSXML\MSXML4-KB2758694-FRA.exe /quiet /norestart
	echo.
	echo %red%Installation des packages Visual Studio redistribuables%u%
	windows_update\Common\VS_REDIST\VisualCppRedist_AIO_x86_x64.exe /ai /gm2
	echo.
	echo %green%Installation terminée%u%
	echo.
	pause
goto main_wu_11

:11_uwp
	echo.
	if %archi% EQU ARM64 (
		echo %red%L'architecture ARM64 n'est pas prise en charge%u%
		echo.
		pause
		goto main_wu_11
	)
	echo %red%Installation des packages UWP%u%
	cd windows_update\Common\UWP\dvd\
	powershell.exe -executionpolicy bypass -command "Add-AppxProvisionedPackage -Online -PackagePath 50ea4d02e68f4217869d054e06374b74.appxbundle -LicensePath 50ea4d02e68f4217869d054e06374b74_License1.xml" 1>nul 2>nul
	cd ..
	for /f %%i in ('dir /B redist\%archi%\') do (
		powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path 'redist\%archi%\%%i'" 1>nul 2>nul
	)
	for /f %%i in ('dir /B lxp\%build_win%\') do (
		powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path 'lxp\%build_win%\%%i'" 1>nul 2>nul
	)
	for /f %%i in ('dir /B neutral\APPX') do (
		powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path 'neutral\APPX\%%i'" 1>nul 2>nul
	)
	for /f %%i in ('dir /B neutral\MSIX') do (
		powershell.exe -executionpolicy bypass -command "Add-AppxPackage -Path 'neutral\MSIX\%%i'" 1>nul 2>nul
	)
	cd /d %~dp0
	echo.
	echo %green%Installation terminée%u%
	echo.
	pause
goto main_wu_11

:11_net
	echo.
	echo %red%Installation de .NET Framework%u%
	dism.exe /online /enable-feature /featurename:NetFX3 /quiet /norestart 1>nul 2>nul
	reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.8.1" 1>nul 2>nul
	if %errorlevel%==1 (
		windows_update\Common\DOTNET\Framework\4_8_1\ndp481-x86-x64-allos-enu.exe /quiet /norestart
		windows_update\Common\DOTNET\Framework\4_8_1\ndp481-x86-x64-allos-fra.exe /quiet /norestart
	)
	echo.
	echo %red%Installation de .NET%u%
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\3_1\') do (
		windows_update\Common\DOTNET\Core\3_1\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\5_0\') do (
		windows_update\Common\DOTNET\Core\5_0\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\6_0\') do (
		windows_update\Common\DOTNET\Core\6_0\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\7_0\') do (
		windows_update\Common\DOTNET\Core\7_0\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\8_0\') do (
		windows_update\Common\DOTNET\Core\8_0\%%i /quiet /norestart
	)
	for /f %%i in ('dir /B windows_update\Common\DOTNET\Core\9_0\') do (
		windows_update\Common\DOTNET\Core\9_0\%%i /quiet /norestart
	)
	echo.
	echo %green%Installation terminée%u%
	echo %green%Il est maintenant recommandé de redémarrer votre ordinateur%u%
	echo.
	call :callforrestart
goto main_wu_11

:11_definitions
	echo.
	echo %red%Installation de l'outil de supression des logiciels malveillants%u%
	for /f %%i in ('dir /B windows_update\Common\AntiMalware\MSRT\%archi%\') do (
		windows_update\Common\AntiMalware\MSRT\%archi%\%%i /quiet /norestart
	)
	echo.
	echo %red%Installation de la mise jour de la plateforme Windows Security%u%
	windows_update\Common\AntiMalware\Definitions\%archi%\securityhealthsetup.exe
	echo.
	echo %red%Installation de la mise jour de la plateforme Microsoft Defender%u%
	windows_update\Common\AntiMalware\Definitions\%archi%\updateplatform.exe
	echo.
	echo %red%Installation de la mise à jour de définitions Microsoft Defender%u%
	windows_update\Common\AntiMalware\Definitions\%archi%\mpam-fe.exe
	echo.
	echo %green%Installation terminée%u%
	echo.
	pause
goto main_wu_11



:: Titre
:titre
	echo 			    %inverse% =============================== %u%
	echo 			    %inverse% ^|^|  MG Toolkit  (v%toolkit_version%)  ^|^| %u%
	echo 			    %inverse% =============================== %u%
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