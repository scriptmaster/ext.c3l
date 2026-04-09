# ext::serializer - various encoder/decoder in C3

This module is to fill missing gaps of C3 std lib by providing various encoders/decoders.

# Available module

| Module | Description |
|--------|-------------|
| `ext::serializer::json` | JSON serializer: JsonObject, JsonArray, JsonMap, JsonNull, JsonBool, JsonNumber, String, bool, double, null, decode(), encode() |

* More about [JSON decoder/encoder](./README.json.md)

| Module | Description |
|--------|-------------|
| `ext::serializer::http` | HTTP/1.x parser: `Request`, `Response`, `Url`, `SetCookie`, `FormFile`, `KeyValue`, `parse_request()`, `parse_response()`, decode helpers |

* More about [HTTP parser](./README.http.md)

### Files

* [json.c3](json.c3)
* [http.c3](http.c3)

### Exqmples

* [../../examples/serializer/json_sample.c3](../../examples/serializer/json_sample.c3)
* [../../examples/serializer/http_sample.c3](../../examples/serializer/http_sample.c3)


This is a part of the extended C3 library.
Back to [ext.c3l](../../README.md) library.

