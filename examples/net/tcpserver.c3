// tcpserver.c3

import std::io;
import c::stdlib;
import ext::net::tcp;

fn void main()
{
    TcpSocket? sock = tcp::new_listen(5757);
    if (catch err = sock) {
        io::printfn("%s", err);
        return;
    }
    defer (void)sock.close();

    while (true) {
        io::printfn("accepting");
        char[64] ipbuf;
        ushort port;
        TcpSocket? s = sock.accept(&ipbuf, &port);
        if (catch err = s) {
            io::printfn("%s", err);
            break;
        }
    
        String ip = ((ZString)(&ipbuf[0])).str_view();

        char[1024] buf;
        while (try n = s.readline(&buf)) {
            buf[n] = '\0';
            String msg = ((ZString)(&buf[0])).str_view();

            io::printfn("%s:%d msg:%s", ip, port, msg);
            msg.convert_to_upper();
        
            (void)s.send((char[])msg);
            if (catch msg.index_of_char('\n')) {
                (void)s.send("\n");
            }
            
            io::printfn("sent:%s", msg);
            if (msg.starts_with("QUIT")) break;
        }
        (void)s.close();
    }
}
