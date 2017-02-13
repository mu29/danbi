@echo off
title Danbi Server
echo -------------------------------------------------------------------------------
echo 				Danbi Server
echo -------------------------------------------------------------------------------&

:INPUT
set /p port=서버 포트를 입력하세요 : 

if not %port% gtr 1025 goto INPUT
if not %port% leq 65535 goto INPUT

goto Run

:Run
title Danbi Server - PORT %port%
java -jar classes/artifacts/Server_jar/Server.jar %port%
pause