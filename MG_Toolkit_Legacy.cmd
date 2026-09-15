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
del "%TEMP%\version.txt" 1>nul 2>nul
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/version.txt', '%TEMP%\version.txt')" 1>nul 2>nul
set /p controle_version_toolkit=<%TEMP%\version.txt 1>nul 2>nul
if exist "%TEMP%\version.txt" (
	if not "%controle_version_toolkit%"=="%toolkit_version%" (
		powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/DarkMG86/MG-Toolkit/raw/refs/heads/main/MG_Toolkit.cmd', '%~dp0\MG_Toolkit_new.cmd')"
		if exist "%~dp0\MG_Toolkit_new.cmd" (
			timeout /t 1 >nul
			del /f "%~dp0\MG_Toolkit.cmd"
			rename "%~dp0\MG_Toolkit_new.cmd" "MG_Toolkit.cmd"
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