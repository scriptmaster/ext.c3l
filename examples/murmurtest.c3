import std::io;

import murmur;

fn void main() 
{
  {
    char[] key = "hello world";
    uint seed = 123;

    uint h32 = murmur::hash3_x86_32(key, seed);

    io::printfn("%s", h32);
  }
  {
    char[] key = "hello world!";
    uint seed = 123;

    uint h32 = murmur::hash3_x86_32(key, seed);

    io::printfn("%s", h32);
  }
}