#────────────────────────────────────────────────────────────────────────────

# * Win32API

#────────────────────────────────────────────────────────────────────────────



NoF1                      = Win32API.new(Config::DLL_PATH + 'NoInput', 'NoF1', 'l', 'v')

NoF12                     = Win32API.new(Config::DLL_PATH + 'NoInput', 'NoF12', 'l', 'v')

NoAltEnter                = Win32API.new(Config::DLL_PATH + 'NoInput', 'NoAltEnter', 'l', 'v')

DrawMapsBitmap            = Win32API.new(Config::DLL_PATH + 'Tilemap', 'DrawMapsBitmap', 'pppp', 'i')

DrawMapsBitmap2           = Win32API.new(Config::DLL_PATH + 'Tilemap', 'DrawMapsBitmap2', 'pppp', 'i')

UpdateAutotiles           = Win32API.new(Config::DLL_PATH + 'Tilemap', 'UpdateAutotiles', 'pppp', 'i')

InitEmptyTile             = Win32API.new(Config::DLL_PATH + 'Tilemap', 'InitEmptyTile', 'l', 'i')

Wheel                     = Win32API.new(Config::DLL_PATH + 'Wheel', 'intercept', 'v', 'l')

FindFirstFile             = Win32API.new(Config::DLL_PATH + 'RTP', 'FFF', 'p', 'p')

MultiByteToWideChar       = Win32API.new('kernel32', 'MultiByteToWideChar', 'llplpl', 'l')

WideCharToMultiByte       = Win32API.new('kernel32', 'WideCharToMultiByte', 'llplplpp', 'l')

GetPrivateProfileString   = Win32API.new('kernel32', 'GetPrivateProfileString', 'pppplp', 'l')

WritePrivateProfileString = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp', 'l')

DeleteFile                = Win32API.new('kernel32', 'DeleteFile', 'p', 'l')

GetActiveWindow           = Win32API.new('user32', 'GetActiveWindow', 'v', 'l')

GetForegroundWindow       = Win32API.new('user32', 'GetForegroundWindow', 'v', 'l')

GetWindowText             = Win32API.new('user32', 'GetWindowText', 'lpl', 'l')

GetWindowTextLength       = Win32API.new('user32', 'GetWindowTextLength', 'l', 'l')

MessageBox                = Win32API.new('user32', 'MessageBox', 'lppl', 'l')

SendMessage               = Win32API.new('user32', 'SendMessageA', 'llll', 'l')

LoadImageA                = Win32API.new('user32', 'LoadImageA', 'lpllll', 'l')

LoadImageW                = Win32API.new('user32', 'LoadImageW', 'lpllll', 'l')

FlashWindow               = Win32API.new('user32', 'FlashWindow', 'll', 'l')

FindWindow                = Win32API.new('user32', 'FindWindow', 'pp', 'l')

GetWindowRect             = Win32API.new('user32', 'GetWindowRect', 'lp', 'l')

GetSystemMetrics          = Win32API.new('user32', 'GetSystemMetrics', 'l', 'l')

GetAsyncKeyState          = Win32API.new('user32', 'GetAsyncKeyState', 'l', 'l')

AdjustWindowRect          = Win32API.new('user32', 'AdjustWindowRect', 'pll', 'l')

GetClientRect             = Win32API.new('user32', 'GetClientRect', 'lp','i')

ChangeDisplaySettings     = Win32API.new('user32', 'ChangeDisplaySettingsW', 'pl', 'l')

EnumDisplaySettings       = Win32API.new('user32', 'EnumDisplaySettings', 'llp', 'l')

SetWindowLong             = Win32API.new('user32', 'SetWindowLongA', 'pll', 'l')

GetWindowLong             = Win32API.new('user32', 'GetWindowLongA', 'll', 'l')

SetWindowPos              = Win32API.new('user32', 'SetWindowPos', 'lllllll', 'l')

RegisterHotKey            = Win32API.new('user32', 'RegisterHotKey', 'llll', 'l')

ScreenToClient            = Win32API.new('user32', 'ScreenToClient', 'lp', 'i')

ClientToScreen            = Win32API.new('user32', 'ClientToScreen', 'lp', 'i')

ClipCursor                = Win32API.new('user32', 'ClipCursor', 'p', 'l')

GetCursorPos              = Win32API.new('user32', 'GetCursorPos', 'p', 'i')

SetCursorPos              = Win32API.new('user32', 'SetCursorPos', 'll', 'l')

ShowCursor                = Win32API.new('user32', 'ShowCursor', 'l', 'l')

ImmGetDefaultIMEWnd       = Win32API.new('Imm32', 'ImmGetDefaultIMEWnd', 'l', 'l')  

ImmGetContext             = Win32API.new('imm32','ImmGetContext', 'l', 'l')

ImmSetConversionStatus    = Win32API.new('imm32','ImmSetConversionStatus','lll','l')

ImmReleaseContext         = Win32API.new('imm32','ImmReleaseContext','ll','l')

URLDownloadToFile         = Win32API.new('urlmon', 'URLDownloadToFile', 'lppll', 'l')

DeleteUrlCacheEntry       = Win32API.new('Wininet', 'DeleteUrlCacheEntry', 'p', 'l')

GetLastError              = Win32API.new('kernel32', 'GetLastError', 'v', 'l')

CopyFile                  = Win32API.new('kernel32', 'CopyFile', 'ppl', 'l')

ShellExecute              = Win32API.new('shell32', 'ShellExecute', 'lppppl','l')

AllocConsole              = Win32API.new('kernel32', 'AllocConsole', 'v', 'l')

SetForegroundWindow       = Win32API.new('user32', 'SetForegroundWindow', 'l', 'l')

SetConsoleTitle           = Win32API.new('kernel32','SetConsoleTitleA', 'p', 'l')

GetConsoleWindow          = Win32API.new('kernel32', 'GetConsoleWindow', 'v', 'l')

PathFileExists            = Win32API.new('Shlwapi', 'PathFileExists', 'p', 'l')

PathIsDirectory           = Win32API.new('Shlwapi', 'PathIsDirectory', 'p', 'l')

CreateFile                = Win32API.new('kernel32', 'CreateFile', 'pllllll', 'l')

GetFileSize               = Win32API.new('kernel32', 'GetFileSize', 'll', 'l')

CloseHandle               = Win32API.new('kernel32', 'CloseHandle', 'l', 'l')

GetOpenFileName           = Win32API.new('comdlg32', 'GetOpenFileName', 'p', 'l')

IsWindowEnabled           = Win32API.new('user32', 'IsWindowEnabled', 'l', 'l')

IsWindowVisible           = Win32API.new('user32', 'IsWindowVisible', 'l', 'l')

GetWindowPlacement        = Win32API.new('user32', 'GetWindowPlacement', 'lp', 'l')

GetKeyState               = Win32API.new('user32', 'GetAsyncKeyState', 'i', 'i')

GetKeyboardState          = Win32API.new('user32', 'GetKeyState', 'i', 'i')

GetSetKeyState            = Win32API.new('user32', 'SetKeyboardState', 'i', 'i')

SendNotifyMessage         = Win32API.new('user32', 'SendNotifyMessage', 'llll', 'l')

AddFontResource           = Win32API.new('gdi32', 'AddFontResource', 'p', 'l')

AddFontResourceEx         = Win32API.new('gdi32', 'AddFontResourceEx', 'PLL', 'L')

RemoveFontResource        = Win32API.new('gdi32', 'RemoveFontResource', 'p', 'l')

RemoveFontResourceEx      = Win32API.new('gdi32', 'RemoveFontResourceEx', 'pll', 'l')

RegCreateKey              = Win32API.new('advapi32', 'RegCreateKey', 'lpp', '')

RegSetValueEx             = Win32API.new('advapi32', 'RegSetValueEx', 'ppllpl', 'l')

RegCloseKey               = Win32API.new('advapi32', 'RegCloseKey', 'p', 'l')

GetParent                 = Win32API.new('user32', 'GetParent', 'l', 'l')

GetMenu                   = Win32API.new('user32', 'GetMenu', 'l', 'l')

RegOpenKeyEx              = Win32API.new('advapi32', 'RegOpenKeyEx', 'lpllp', 'l')

RegQueryValueExW          = Win32API.new('advapi32', 'RegQueryValueExW', 'lplppp', 'l')

FindNextFile              = Win32API.new('kernel32', 'FindNextFileW', 'lp', 'i')