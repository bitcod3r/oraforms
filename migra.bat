@echo off
REM **********************************************************************************************************************
REM
REM 	Bloquea (Lock) de los archivos en el repositorio de SVN
REM
REM 	Uso:  C:\RepositorioPruebas\subversionsubir\FPC10G\Formas\migra.bat
REM		Requisitos: Tener un archivo de entrada con un nombre por linea (sin la extension)
REM
REM 	Entrada:  files.txt (Archivo con todos los nombres de las formas del modulo a migrar)
REM 	Salida:		
REM 		1.  locked_files.txt		Archivo que contiene las formas que ya estan lock por otro usuario (en desarrollo)
REM			2.  compare_files.txt		Todos los archivos a ser bloqueados (no subidos y sin bloqueo)
REM 		3.  nonlocked_files.txt		Archivos que no han sido subidos aun a SVN. No se encuentran en el repositorio.
REM 		4.  svnlocked_files.txt		Archivos que lograron bloquearse exitosamente
REM 		5.  unlocked_files.txt		Archivos que si existen en SVN y esta a punto de bloquearse
REM
REM
REM 	NOTA: Se crea un archivo temporal que luego es borrado:  temp.txt
REM **********************************************************************************************************************



SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F %%A in (files.txt) do (

	set result=

	svn info http://10.10.20.137:8082/svn/RepositorioPruebas/subversionsubir/FPC10G/Formas/%%A.fmb | findstr Owner: > temp.txt
	
	set /p result=<temp.txt
	
	if "!result!"=="" (
		REM Listado para comparar fechas unlocked + nonlocked 
		echo %%A%>> compare_files.txt
		
		REM
		REM Bloquear los archivos en SVN con el comando 
		REM 
		if exist %%A%.fmb (
			echo %%A%>> unlocked_files.txt
			svn lock %%A%.fmb -m "Migrando 11g..." >> svnlocked_files.txt
		) else (
			REM Archivo que no existe aun en el repo de SVN
			echo %%A%>> nonlocked_files.txt
		)
		
	) else (
		REM Listado de archivos que estan bloqueados
		echo %%A% !result! >> locked_files.txt
	)
		
	del temp.txt
)
ENDLOCAL
