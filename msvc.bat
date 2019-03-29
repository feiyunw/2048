@echo off
setlocal ENABLEEXTENSIONS
set DP0=%~dp0
cd /d %DP0%

set CMAKE="D:\Program Files\CMake\bin\cmake.exe"
set BUILDDIR=%DP0%build\
set DEPINC=%DP0%include\
set DEPLIB=%DP0%lib\
set INSTALLDIR=%DP0%
set CXXFLAGS=/DBOOST_ALL_DYN_LINK /utf-8 %CXXFLAGS%
set MSBUILD=MSBuild.exe /m /p:Configuration=Release;Platform=x64;PlatformToolset=v141;WindowsTargetPlatformVersion=%UCRTVersion%

mkdir %BUILDDIR% 1>NUL 2>&1
mkdir %DEPINC% 1>NUL 2>&1
mkdir %DEPLIB% 1>NUL 2>&1
mkdir %INSTALLDIR% 1>NUL 2>&1

if "%VSCMD_ARG_TGT_ARCH%" NEQ "x64" (
	echo Run this script in a Visual Studio "x64 Native Tools Command Prompt for VS" window.
	goto bye
)

if NOT EXIST %CMAKE% (
	echo Unable to locate camke.exe.
	goto bye
)

:2048
echo ===== Building 2048
cd /d %BUILDDIR%
cd
del /f /q CMakeCache.txt 1>NUL 2>&1
%CMAKE% -G"Visual Studio 15 2017 Win64" -Tv141 -Wno-dev -DBOOST_INCLUDEDIR=%DEPINC%boost-1_69 -DBOOST_LIBRARYDIR=%DEPLIB% -DBoost_NO_SYSTEM_PATHS=ON -DBoost_PROGRAM_OPTIONS_LIBRARY_RELEASE=%DEPLIB%boost_program_options-vc141-mt-x64-1_69.lib -DCMAKE_INSTALL_PREFIX=%INSTALLDIR% %DP0%
%MSBUILD% /p:Configuration=MinSizeRel %BUILDDIR%2048.sln /t:Rebuild

:install
echo ===== Installing 2048
copy /Y %BUILDDIR%\bin\MinSizeRel\*.exe %INSTALLDIR%
copy /Y %DEPLIB%\boost_program_options*.dll %INSTALLDIR%

:bye
endlocal
