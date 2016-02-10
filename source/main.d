import core.sys.windows.windows;
import core.runtime;

__gshared HINSTANCE g_hInst;

extern (Windows):
BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
{
    switch (ulReason)
    {
	case DLL_PROCESS_ATTACH:
    	Runtime.initialize();
	    break;

	case DLL_PROCESS_DETACH:
		Runtime.terminate();
	    break;

	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	    return false;
    default:
    	break;
    }
    g_hInst = hInstance;
    return true;
}
