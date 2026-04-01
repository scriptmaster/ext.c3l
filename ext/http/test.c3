import std::io;

int $n = 0;
struct Request {
  String method;
  String path;
}
struct Response {
  String body;
}
alias Handler = fn Response(Request, Response);
struct Route {
  String method;
  String path;
  Handler body;
}
Route[$n] routes;

macro @route(method, path; @body(req, resp))
{
  Route[$n] = { method, path, @body };
  $n++;
}

@route("GET", "/"; req, resp) 
{
    io::printfn("%s", req.method);
    resp.body = "Hello";
    return resp;
};

fn void drain_output(Response resp)
{
    io::printfn("%s", resp.body);
}

fn bool match(Route route, String method, String path)
{
    if (route.method == method && route.path == path) return true;
    return false;
}

fn void call_route(String real_method, String real_path)
{
    @pool() {
        Request req = { real_method, real_path };
        Respponse resp = {};

        foreach (route: routes) {
            if (match(route, real_method, real_path)) {
                resp = route.body(req, resp);
                drain_output(resp);
                return;
            }
        }
        
        resp = default_body(req, resp);
        drain_output(resp);
    };
}