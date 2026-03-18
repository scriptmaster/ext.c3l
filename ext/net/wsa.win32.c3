module ext::net @if(env::WIN32);

bool __wsa_initialized = false;

module ext::net::wsa @if(env::WIN32);

import c::errno;
import c::winsock2;

fn void? startup() 
{
    if (net::__wsa_initialized) return;
    
    winsock2::WSAData wsa_data;
    int result = winsock2::wsaStartup(0x0202, &wsa_data);
    if (result != 0) {
        return errno::F_SYSNOTREADY~;
    }
    net::__wsa_initialized = true;
}

fn void cleanup() 
{
    if (net::__wsa_initialized) {
        winsock2::wsaCleanup();
        net::__wsa_initialized = false;
    }
}

