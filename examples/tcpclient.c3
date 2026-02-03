// tcpclient.c3

import std::io;
import stdlib;
import stdio;
import ext::net::tcp;

fn void main(String[] args)
{
    if (args.len <= 1) {
        io::printfn("Usage: %s 'msg'", args[0]);
        return;
    }
    
    TcpSocket? sock = tcp::new_connect("127.0.0.1", 5757);
    if (catch err = sock) {
        io::printfn("%s", err);
        stdlib::exit(1);
        return;
    }
    defer (void)sock.close();

    while (true) {
        io::printf(">> ");
        String? line = io::readline(mem);
        if (catch err = line) {
            io::printfn("%s", err);
            break;
        }
        if (catch err = sock.send(line)) {
            io::printfn("%s", err);
            break;
        }
        if (catch line.index_of_char('\n')) {
            (void)sock.send("\n");
        }
        
        char[1024] buf;
        if (catch err = sock.readline(&buf)) {
            io::printfn("%s", err);
            break;
        }

        stdio::printf("%s\n", &buf[0]);
    }
}