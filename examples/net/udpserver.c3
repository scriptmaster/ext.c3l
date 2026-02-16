// udpserver.c3

import std::io;
import stdlib;
import ext::net::udp;

fn void main()
{
    UdpSocket? sock = udp::new_bind(5757);
    if (catch err = sock) {
        io::printfn("%s", err);
        return;
    }
    defer (void)sock.close();

    char[1024] buf;
    char[64] ipbuf;
    ushort port;
    while (try sock.recvfrom(&buf, &ipbuf, &port)) {
        String ip = ((ZString)(&ipbuf[0])).str_view();
        String msg = ((ZString)(&buf[0])).str_view();

        io::printfn("%s:%d msg:%s", ip, port, msg);
        msg.convert_to_upper();
        
        (void)sock.sendto((char[])msg, ip, port);
        if (msg == "QUIT") break;
    }
}