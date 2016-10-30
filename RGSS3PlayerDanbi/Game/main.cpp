/**
 * @file  Main.cpp
 *
 * @desc  第三方 RGSS3 Player
 *
 * @author  灼眼的夏娜
 * @modify  jubin-park

 * @history 2011/12/02 初版
 *			2016/10/30
 */

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>

static const wchar_t* pWndClassName  = L"RGSS Player";
static const wchar_t* pDefaultLibrary = L"RGSS103J.dll";
static const wchar_t* pDefaultTitle  = L"Danbi";
static const wchar_t* pDefaultScripts = L"Data\\Scripts.rxdata";

static const int nScreenWidth   = 544;
static const int nScreenHeight   = 416;
static const int nEvalErrorCode   = 6;
typedef int  (*RGSSEval)(const char* pScripts);
static HWND  hWnd     = NULL;
RGSSEval pRGSSEval   = NULL;
HMODULE hRgssCore = NULL;

LRESULT CALLBACK GameProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

extern "C" __declspec(dllexport) HWND __rgss_get_hwnd()
{
	return hWnd;
}
 
static void ShowErrorMsg(HWND hWnd, const wchar_t* szTitle, const wchar_t* szFormat, ...)
{
	static wchar_t szError[1024];
	va_list ap;
	va_start(ap, szFormat);
	vswprintf_s(szError, szFormat, ap);
	va_end(ap);
	MessageBoxW(hWnd, szError, szTitle, MB_ICONERROR);
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	wchar_t szAppPath[MAX_PATH], szIniPath[MAX_PATH], szRgssadPath[MAX_PATH];
    wchar_t szLibrary[MAX_PATH], szTitle[MAX_PATH], szScripts[MAX_PATH];
    wchar_t* pRgssad = 0;
 
    WNDCLASSW winclass;
    winclass.style = CS_DBLCLKS | CS_OWNDC | CS_HREDRAW | CS_VREDRAW;
    winclass.lpfnWndProc = DefWindowProc;
    winclass.cbClsExtra  = 0;
    winclass.cbWndExtra  = 0;
    winclass.hInstance  = hInstance;
    winclass.hIcon   = LoadIcon(hInstance, MAKEINTRESOURCE(101));
    winclass.hCursor  = LoadCursor(NULL, IDC_ARROW);
    winclass.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
    winclass.lpszMenuName = NULL; 
    winclass.lpszClassName = pWndClassName;

    if (!RegisterClassW(&winclass))
    {
		ShowErrorMsg(hWnd, szTitle, L"윈도우 클래스 %s를 등록하는데 실패했습니다.", pWndClassName);
		return 0;
    }
 
    int width = nScreenWidth + GetSystemMetrics(SM_CXFIXEDFRAME) * 2;
    int height = nScreenHeight + GetSystemMetrics(SM_CYFIXEDFRAME) * 2 + GetSystemMetrics(SM_CYCAPTION);
 
    RECT rt;
    {
		rt.left  = (GetSystemMetrics(SM_CXSCREEN) - width) / 2;
		rt.top  = (GetSystemMetrics(SM_CYMAXIMIZED) - nScreenHeight) / 2 - GetSystemMetrics(SM_CYCAPTION);
		rt.right = rt.left + width;
		rt.bottom = rt.top + height;
    }


	// 응용 프로그램 경로
    DWORD len = ::GetModuleFileNameW(hInstance, szAppPath, MAX_PATH);
    for (--len; len > 0; --len)
    {
    if (szAppPath[len] == L'\\' || szAppPath[len] == L'/')
    {
    szAppPath[len] = 0;
    break;
    }
    }
    ::SetCurrentDirectoryW(szAppPath);

    // INI 파일 경로
    len = ::GetModuleFileNameW(hInstance, szIniPath, MAX_PATH);
    szIniPath[len - 1] = L'i';
    szIniPath[len - 2] = L'n';
    szIniPath[len - 3] = L'i';

	// ini 파일 읽기
    if (GetFileAttributesW(szIniPath) != INVALID_FILE_ATTRIBUTES)
    {
		wcscpy_s(szLibrary, pDefaultLibrary);
        //GetPrivateProfileStringW(L"Game", L"Library", pDefaultLibrary, szLibrary, MAX_PATH, szIniPath);
        GetPrivateProfileStringW(L"Game", L"Title",  pDefaultTitle,   szTitle, MAX_PATH, szIniPath);
        GetPrivateProfileStringW(L"Game", L"Scripts", pDefaultScripts, szScripts, MAX_PATH, szIniPath);
    }
    else
    {
        wcscpy_s(szLibrary, pDefaultLibrary);
        wcscpy_s(szTitle, pDefaultTitle);
        wcscpy_s(szScripts, pDefaultScripts);
    }

    DWORD dwStyle = WS_POPUP | WS_CAPTION | WS_MINIMIZEBOX | WS_VISIBLE | WS_SYSMENU; //| 
 
    hWnd = ::CreateWindowEx(WS_EX_WINDOWEDGE, pWndClassName, szTitle, dwStyle,
    rt.left, rt.top, rt.right - rt.left, rt.bottom - rt.top, 0, 0, hInstance, 0);
 
    if (!hWnd)
    {
        ShowErrorMsg(hWnd, szTitle, L"윈도우 생성에 실패했습니다.", szTitle);
        goto exit;
    }

    // 암호화 패키지 경로
    len = ::GetModuleFileNameW(hInstance, szRgssadPath, MAX_PATH);
    for (--len; len > 0; --len)
    {
        if (szRgssadPath[len] == L'.')
        {
            szRgssadPath[len + 1] = L'r';
            szRgssadPath[len + 2] = L'g';
            szRgssadPath[len + 3] = L's';
            szRgssadPath[len + 4] = L's';
            szRgssadPath[len + 5] = L'3';
            szRgssadPath[len + 6] = L'a';
            szRgssadPath[len + 7] = 0;
            break;
        }
    }
 
    if (GetFileAttributesW(szRgssadPath) != INVALID_FILE_ATTRIBUTES)
        pRgssad = szRgssadPath;

    // 콘솔
	if (strcmp(lpCmdLine, "console") == 0)
	{
		if (AllocConsole())
		{
			SetConsoleTitle(L"RGSS Console");
			FILE* frw = NULL;
			freopen_s(&frw, "conout$", "w", stdout);
		}
	}
 
    ShowWindow(hWnd, SW_SHOW);
 
    // RGSS 코어 라이브러리를 로드
    hRgssCore = ::LoadLibraryW(szLibrary);
    if (!hRgssCore)
    {
        DWORD e = ::GetLastError();
        ShowErrorMsg(hWnd, szTitle, L"RGSS 코어 라이브러리 %s를 로드하는데 실패했습니다.", szLibrary);
        goto exit;
    }
 
    //타입 (함수포인터)
    typedef BOOL (*RGSSSetupRTP)(const wchar_t* pIniPath, wchar_t* pErrorMsgBuffer, int iBufferLength);
    typedef void (*RGSSSetupFonts)();
    typedef void (*RGSSGetInt)(LONG l);
    typedef void (*RGSSInitialize3)(HMODULE hRgssDll);
    typedef void (*RGSSGameMain)(HWND hWnd, const wchar_t* pScriptNames, wchar_t** pRgssadName);
    typedef BOOL (*RGSSExInitialize)(HWND hWnd);
 
    //타입 선언 = NULL
    RGSSSetupRTP  pRGSSSetupRTP  = NULL;
    RGSSSetupFonts  pRGSSSetupFonts  = NULL;
    RGSSInitialize3  pRGSSInitialize3 = NULL;
    RGSSGameMain  pRGSSGameMain  = NULL;
    RGSSGetInt pRGSSGetInt = NULL;
    RGSSExInitialize pRGSSExInitialize = (RGSSExInitialize)::GetProcAddress(hRgssCore, "RGSSExInitialize");
    
    // \ 개행, ## 결합, #치환
    #define __get_check(fn) \
    do \
    { \
    p##fn = (fn)::GetProcAddress(hRgssCore, #fn); \
    if (!p##fn) \
    { \
	ShowErrorMsg(hWnd, szTitle, L"RGSS 코어 라이브러리 %s을 가져오는데 실패했습니다.", #fn); \
    goto exit; \
    } \
    } while (0)
    {
        __get_check(RGSSSetupRTP);
        __get_check(RGSSSetupFonts);
        __get_check(RGSSInitialize3);
        __get_check(RGSSEval);
        __get_check(RGSSGetInt);
        __get_check(RGSSGameMain);
    }
    #undef __get_check{
 
 
    // 1. RTP Setup
    wchar_t szRtpName[1024];
    if (!pRGSSSetupRTP(szIniPath, szRtpName, 1024))
    {
        ShowErrorMsg(hWnd, szTitle, L"RGSS-RTP %s을 찾을 수 없습니다.", szRtpName);
        goto exit;
    }
 
    // 2. RGSS 초기화
    pRGSSInitialize3(hRgssCore);
    // 2.1 확장 라이브러리 초기화 ( 패치 모드)
    if (pRGSSExInitialize)
    {
        if (!pRGSSExInitialize(hWnd))
        {
            ShowErrorMsg(hWnd, szTitle, L"RGSS 확장 라이브러리 %s 초기화 실패", L"RGSSExInitialize");
            goto exit;
        }
    }
 
    pRGSSSetupFonts();

    if (strcmp(lpCmdLine, "btest") == 0)
    {
        pRgssad = 0;
		pRGSSEval("$DEBUG=$TEST=$BTEST=true");
    }
    else 
    {
        if (strcmp(lpCmdLine, "debug") == 0)
        {
            pRgssad = 0;
            pRGSSEval("$DEBUG=$TEST=$DEBUG=true");
        }
        else
        {
			pRGSSEval("$DEBUG=$TEST=$BTEST=false");
        }
    }

	char szStr[256];
	sprintf(szStr,"module Game;def self.SubClassing;Win32API.new('user32.dll','SetWindowLongW','ill','l').call(%d,-4,%d);end;end", hWnd, &GameProc);
	pRGSSEval(szStr);
	pRGSSEval("module Graphics;def self.focus;@focus;end;def self.focus=(b);@focus=b;end;end");
	pRGSSEval("Graphics.focus=true");
    pRGSSGameMain(hWnd, szScripts, (pRgssad ? (wchar_t**)pRgssad : &pRgssad));

exit:

    if (hRgssCore)
    {  
        FreeLibrary(hRgssCore);
        hRgssCore = NULL;
    }
    if (hWnd)
    {
        DestroyWindow(hWnd);
        hWnd = NULL;
    }
    UnregisterClassW(pWndClassName, hInstance);
    return 0;
}
 

LRESULT CALLBACK GameProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch(msg)
    {
	case WM_INITMENUPOPUP:
		if (lParam | 0xFFFF0000 != 0)
			SendMessageW(hWnd, WM_CANCELMODE, 0, 0);
			return 0;
	case WM_SYSKEYDOWN:
		switch(wParam)
		{
		case VK_MENU:
			return 0;
		}
	case WM_SYSKEYUP:
		switch(wParam)
		{
		case VK_MENU:
			return 0;
		}
    case WM_SETFOCUS:
		ShowCursor(0);
        pRGSSEval("Graphics.focus=true");
        return 0;
    case WM_KILLFOCUS:
		ShowCursor(1);
        pRGSSEval("Graphics.focus=false");
        return 0;
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    }
    return(DefWindowProc(hWnd, msg, wParam, lParam));
}