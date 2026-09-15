@echo off
pushd "%~dp0"
chcp 1252 >nul
setlocal DisableDelayedExpansion
set toolkit_version=20260915
title MG Toolkit Legacy (v%toolkit_version%)
mode con cols=90 lines=40



:: Contrôle des prérequis (minimum Windows XP et maximum Windows 8.1 ainsi que la présence de PowerShell)
for /f "tokens=2 delims==" %%V in ('wmic os get version /value') do @set V=%%V
if not "%V%" GEQ "5.1" if not "%V%" LSS "6.4" (
	goto OSNoOK
)
if not exist "%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe" (
	goto OSNoOK
)



:: Contrôle des droits d'administrateur
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)



:OSNoOK
	echo.
	echo __________________________________________________________________________________________
	echo.
	echo                             Votre OS n'est pas compatible
	echo        Ce programme supporte de Windows XP à 8.1 et nécessite la présence de Powershell
	echo                         Le programme va maintenant se fermer
	echo __________________________________________________________________________________________
	echo.
	pause
exit

:OSOK
	echo.
	echo __________________________________________________________________________________________
	echo.
	echo                                Votre système est compatible
	echo        !!! Il est recommandé de désactiver votre antivirus avant de poursuivre !!!
	echo __________________________________________________________________________________________
	echo.
	pause
goto main



:: Vérification de la présence d'une mise à jour
echo.
call :titre
echo.
echo Vérification de la présence d'une mise à jour...
echo.
del "%TEMP%\version_Legacy.txt" 1>nul 2>nul
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/version_Legacy.txt', '%TEMP%\version_Legacy.txt')" 1>nul 2>nul
set /p controle_version_toolkit=<%TEMP%\version_Legacy.txt 1>nul 2>nul
if exist "%TEMP%\version_Legacy.txt" (
	if not "%controle_version_toolkit%"=="%toolkit_version%" (
		powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/MG_Toolkit_Legacy.cmd', '%~dp0\MG_Toolkit_Legacy_new.cmd')"
		if exist "%~dp0\MG_Toolkit_Legacy_new.cmd" (
			timeout /t 1 >nul
			del /f "%~dp0\MG_Toolkit_Legacy.cmd"
			rename "%~dp0\MG_Toolkit_Legacy_new.cmd" "MG_Toolkit_Legacy.cmd"
			echo La version %controle_version_toolkit% a été téléchargée avec succès
			echo Veuillez exécuter à nouveau le programme
			echo.
			pause
			exit /b
		) else (
			echo Échec du téléchargement de la mise à jour
		)
	)
) else (
	echo Échec de la vérification de la mise à jour
)



:: Controle de la version de Windows utilisée
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
	echo 	Fabricant :              %BIOS_FABRICANT%
	echo 	Version du BIOS :        %BIOS_VERSION%
	echo 	Système d'exploitation : %Caption%
	echo 	Architecture :           %archi%
	echo 	Version :                %major%.%minor%.%build%.%revision%
	for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" 2^>nul ^| Find "BuildLabEx" 2^>nul') do (
		echo 	Build :                  %%b
	)
	goto OSOK



:: Menu principal
:main
	cls
	echo.
	echo.
	echo __________________________________________________________________________________________
	echo.
	set /p choix=Sélectionnez l'opération à effectuer (0 pour quitter): 
	if /i "%choix%"=="1" (goto activation_mas)
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
	if /i "%choix%"=="20" (start https://1drv.ms/f/c/011dbcd351618514/IgAUhWFR07wdIIAB3voDAAAAAcBLZB30-366q14Z-fKgndE)
	if /i "%choix%"=="0" (exit)
goto main




:: Titre
:titre
	echo 			=============================================
	echo 			||         MG Toolkit  (v%toolkit_version%)         ||
	echo 			=============================================
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