
module fiber_test;

import ext::thread::fiber;
import std::io;

Fiber[3] thread;

macro void warn(String fmt, args...)
{
  io::printf("%s,%s: ", $$FILE, $$LINE); io::printfn(fmt, ...args);
}

int global_x;
int global_y;
fn void _init(Fiber thread, int param_x, int param_y) 
{
  global_x = param_x;
  global_y = param_y;

  warn("switch to thread");
  fiber::switch_to(thread);
  warn("resume in _init");
}

fn void threadfn() 
{
  int param_x = global_x;
  int param_y = global_y;
  
  warn("threadfn(%d, %d)", param_x, param_y);
  
  warn("yield()");
  fiber::yield();
  warn("resume in threadfn");

  warn("threadfn(%d, %d)", param_x, param_y);
  
  warn("yield()");
  fiber::yield();
  warn("resume in threadfn");
  
  fiber::yield(); // threadfn should always finish as this 
}

fn void main()
{
  warn("Fiber parameterized function example");

  thread[0] = fiber::active();
  thread[1] = fiber::create(65536, &threadfn);
  thread[2] = fiber::create(65536, &threadfn);

  _init(thread[1], 1, 2);
  _init(thread[2], 4, 8);

  warn("goto thread2");
  fiber::switch_to(thread[2]);
  warn("resume in root");
  
  warn("goto thread1");
  fiber::switch_to(thread[1]);
  warn("resume in root");
 
  // fiber::yield();
  warn("goto thread1");
  fiber::switch_to(thread[1]);
  warn("resume in root");
 
  warn("done");
}
