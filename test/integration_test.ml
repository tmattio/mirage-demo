open Httpaf

let test_single_get () =
  Test_utils.test_query
    (Request.create `GET "/")
    (Response.create
       `OK
       ~headers:(Headers.of_list [ "content-length", string_of_int 11 ]))
    ~body:"Hello World"

let suite = [ "single GET", `Quick, test_single_get ]
