// application.c3

struct Config {
    bool prefork; // spawn multiple process
    String server_header;
    bool strict_routing; // /foo != /foo/
    bool case_sensitive; // /Foo == /foo
    bool immutable; // ctx value immutable
    bool unescape_path; // before matching
    bool etag; // auto ETag generation
    usz body_limit; // max req body 4MB
    uint concurrency; // max concurrent connection, 256*1024
    ulong read_timeout; // 0 = no timeout
    ulong write_timeout; // 0 = no timeout
    ulong idle_timeout; // 0 = no timeout 
    usz read_buf_size; // 4096
    usz write_buf_size; // 4096;
    String compressed_file_suffix; // .x.gz
    String proxy_header; // "X-Forwarded-For"
    bool get_only; // false
    ErrorHandler err_handler; // DefaultErrorHandler
    
    bool disable_keepalive; // false
    bool disable_defaultdate; // false
    bool disable_defaultcontenttype; // false
    bool disable_headernormalizing; // false
    bool disable_startupmessage; // false
    
    String app_name;
    
    bool stream_request_body; // false 
    bool enable_trustedproxycheck; // false
    bool enable_ipvalidation; // false
    bool enable_printroutes; // false
    
    String[] request_methods; // "GET","POST","PUT","DELETE","PATCH","HEAD","OPTIONS"
    
    int network; // IPV4, IPV6
}

fn Config* config_new()
{
    Config* conf = mem_alloc(Config);
    *conf = {
        .prefork = false,
        .server_header = "",
        .strict_routing = false,
        .case_sensitive = false,
        .immutable = false,
        .unescape_path = false,
        .etag = false,
        .body_limit = 4*1024*1024, // 4MB
        .concurrency = 256 * 1024,
        .read_timeout = 0,
        .write_timeout = 0,
        .idle_timeout = 0,
        .read_buf_size = 4096,
        .write_buf_size = 4096,
        .compressed_file_suffix = ".gz",
        .proxy_header = "X-Forwarded-For",
        .get_only = false,
        .err_handler = &default_error_handler,

        .disable_keepalive = false,
        .disable_defaultdate = false,
        .disable_defaultcontenttype = false,
        .disable_headernormalizing = false,
        .disable_startupmessage = false,

        .app_name = "",

        .stream_request_body = false,
        .enable_trustedproxycheck = false,
        .enable_ipvalidation = false,
        .enable_printroutes = false,

        .request_methods = { "GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS" },

        .network = IPV4,
    };
    return conf;
}

struct Context {
    Request* req;
    Response* resp;
}

fn String Context.params(&self, String key)
{
    // get value from routing path pattern
    // /path/:id
    // /path/*
    // /path/*1
    // /path/:id<\d+>
    // /path/:id?
    // /user/:uid/proc/:pid
}

alias Handler = fn Error (Context* ctx);

fn Error Context.json_response(&self, Obj o)
{

}

struct Route {
    String name;
    String path_pattern;
    Handler handler;
}


struct Application {
    Config* conf;
    String listen_ip;
    ushort listen_port;
    SslCtx sslctx;
    Route[] routes;
}

struct Group {
    inline Application app;
    String path_prefix;
    Middleware[] middleware; // auth, cors(), logger()
    Route[] routes;
}


/*
Group* v1 := app.group_new("/api/v1")
v1.get("/items", handler)
v1.post("/items", handler)

Group* auth := app.group("/admin", authMiddleware)
auth.get("/users", listUsers)

// Group with middleware
Group* api := app.group("/api", cors(), logger())
api.get("/items", handler)
*/

struct Static {
    bool compress; // true
    bool byte_range; // true Range header support
    bool browse; // false directory listing
    bool lndex; // "index.html"
    uint cache_duration; // 10 * time.Second
    uint max_age; // 3600
}

fn Application* app_new(Config* conf)
{
    Application* app = mem_alloc(Application);
    *app = {
        .conf = conf,
    };
    
    return app;
}

fn void? Application.listen(&self, String ip_port)
{

}

fn void? Application.listen_tls(&self, String ip_port, String cert_pem, String key_pem)
{

}

fn void Application.shutdown(&self)
{

}


fn void Application.add(&self, String method, String path, Handler handler)
{

}


fn void Application.get(&self, String path, Handler handler, handlers...)
{
    // multiple handlers middlewares
    // auth, cache, get_item
}

fn void Application.post(&self, String path, Handler handler, handlers...)
{

}

fn void Application.put(&self, String path, Handler handler)
{

}

fn void Application.patch(&self, String path, Handler handler)
{

}

fn void Application.delete(&self, String path, Handler handler)
{

}

fn void Application.options(&self, String path, Handler handler)
{

}

fn void Application.connect(&self, String path, Handler handler)
{

}

fn void Application.trace(&self, String path, Handler handler)
{

}

fn void Application.static(&self, String root, String path, Static st=null)
{

}

fn Route Application.get_route(&self, String name)
{
    // name = "item_route"
    // /item/:id
}

fn String Route.url(&self, String key, String val)
{
    // "id", "1" => /item/1
}

fn String Context.get_route_url(&self, String name, JSONObj o)
{
    // inside handler
    // "item_route"
    // o = { "id": 1 }
}

