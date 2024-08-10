@echo off
setlocal enabledelayedexpansion

:: Cambiar al directorio del script
cd /d "%~dp0"

:: Mostrar banner ASCII
echo.
echo    UPDATE HOSTS
echo    ============
echo.

:: Configurar el archivo de registro
set "logfile=%~dp0update_hosts.log"
echo [%date% %time%] Iniciando script > %logfile%

:: Comprobar si HOSTS.txt existe
if not exist "HOSTS.txt" (
    echo Error: El archivo HOSTS.txt no se encuentra en el directorio actual.
    echo [%date% %time%] Error: HOSTS.txt no encontrado >> %logfile%
    echo Directorio actual: %CD%
    echo Contenido del directorio:
    dir
    echo.
    echo Asegurese de que HOSTS.txt este en el mismo directorio que este script.
    echo Presione cualquier tecla para salir...
    pause >nul
    exit /b 1
)

:menu
:: Mostrar opciones al usuario
echo Seleccione una opcion:
echo 1. Agregar contenido al archivo hosts
echo 2. Sobrescribir el archivo hosts
echo 3. Salir
set /p opcion="Ingrese el numero de la opcion (1, 2 o 3): "

:: Validar la entrada del usuario
if "%opcion%"=="3" goto :eof
if "%opcion%" neq "1" if "%opcion%" neq "2" (
    echo Opcion invalida. Por favor, intente de nuevo.
    echo [%date% %time%] Opcion invalida seleccionada. >> %logfile%
    pause
    cls
    goto menu
)

:: Definir la accion basada en la opcion del usuario
if "%opcion%"=="1" (
    set "action=agregar"
    set "command=type "%~dp0HOSTS.txt" >> C:\Windows\System32\drivers\etc\hosts"
) else (
    set "action=sobrescribir"
    set "command=type "%~dp0HOSTS.txt" > C:\Windows\System32\drivers\etc\hosts"
)

:: Informar al usuario y registrar la accion
echo.
echo Se va a %action% el contenido del archivo hosts.
echo [%date% %time%] Usuario eligio %action% el contenido >> %logfile%

:: Comprobar si el archivo hosts existe y es accesible
if not exist "C:\Windows\System32\drivers\etc\hosts" (
    echo Error: No se puede acceder al archivo hosts del sistema.
    echo [%date% %time%] Error: Archivo hosts del sistema no accesible >> %logfile%
    echo Asegurese de ejecutar este script como administrador.
    goto error_exit
)

:: Ejecutar la accion
echo Ejecutando la accion...
%command% 2>nul

:: Verificar si la accion fue exitosa
if %errorlevel% equ 0 (
    echo La accion se completo correctamente.
    echo [%date% %time%] Accion completada con exito >> %logfile%
) else (
    echo Hubo un error al ejecutar la accion.
    echo [%date% %time%] Error al ejecutar la accion. Codigo de error: %errorlevel% >> %logfile%
    echo Es posible que no tenga permisos suficientes. Asegurese de ejecutar como administrador.
    goto error_exit
)

echo.
echo El proceso ha terminado. Revise el archivo %logfile% para mas detalles.
echo [%date% %time%] Accion finalizada >> %logfile%

echo.
echo Presione cualquier tecla para volver al menu principal...
pause >nul
cls
goto menu

:error_exit
echo.
echo Presione cualquier tecla para volver al menu principal...
pause >nul
cls
goto menu