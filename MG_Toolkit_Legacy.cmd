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
net session >nul 2>&1
if %errorlevel%==1 (
    echo.
	echo Ce script nécessite des droits d'administrateur !
    echo.
    pause
    exit
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
	echo 	Votre configuration systeme :
	echo 	-----------------------------
	echo.
	for /f "tokens=*" %%f in ('wmic os get Caption /value ^| find "="') do set "%%f"
	echo 	Systeme d'exploitation : %Caption%
	for /f "tokens=*" %%f in ('wmic os get CSDVersion /value ^| find "="') do set "%%f"
	if "%CSDVersion%" NEQ "" (
		echo 	Service Pack :           %CSDVersion%
	) else (
		echo 	Service Pack :           RTM
	)
	echo 	Architecture :           %archi%
	for /f "tokens=*" %%f in ('wmic os get Version /value ^| find "="') do set "%%f"
	for /f "tokens=4,5,6,7 delims=[]. " %%g in ('ver') do (set major=%%g& set minor=%%h& set build=%%i& set revision=%%j)
	echo 	Version :                %Version%
    ver | find /i "version 5.1" 1>nul 2>nul
	if %errorlevel%==0 (
		for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" 2^>nul ^| Find "BuildLab" 2^>nul') do (
			echo 	Build :                  %%b
		)
	) else (
		for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" 2^>nul ^| Find "BuildLabEx" 2^>nul') do (
			echo 	Build :                  %%b
		)
	)
	goto OSOK

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
	echo 			     ==============================
	echo 			     ^|^|  MG Toolkit (v%toolkit_version%)  ^|^|
	echo 			     ==============================
goto :eof



:: Redémarrage de Windows
:callforrestart
	set /p choix=Voulez-vous redémarrer maintenant ? (O/N) : 
	if /i "%choix%"=="o" (
		shutdown -r -f -t 0
		exit
	)
goto :eof