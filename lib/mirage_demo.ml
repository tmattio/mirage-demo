open Httpaf

let respond_with_text reqd status text =
  let headers =
    Headers.of_list [ "content-length", Int.to_string (String.length text) ]
  in
  Reqd.respond_with_string reqd (Response.create ~headers status) text

let routes =
  let open Routes in
  [ nil @--> Handlers.Hello.callback ]

let all_route_patterns =
  List.map (fun r -> Format.asprintf "%a" Routes.pp_route r) routes

let log_request req (body : string) =
  let meth_as_string = Httpaf.Method.to_string req.Request.meth in
  let path = req.target in
  Logs.info (fun m -> m "%s %s" meth_as_string path);
  if body <> "" then Logs.info (fun m -> m "%s" body)

let request_handler reqd =
  log_request (Reqd.request reqd) "";
  let ({ Request.target; _ } as req) = Reqd.request reqd in
  let router = Routes.one_of routes in
  match Routes.match' ~target router with
  | None ->
    let not_found_message =
      Printf.sprintf "The requested route does not exist %s" target
    in
    Logs.err (fun m -> m "Error: %s" not_found_message);
    respond_with_text reqd `Not_found not_found_message
  | Some f ->
    respond_with_text reqd `OK (f req)

let error_handler ?request:_ error start_response =
  let message =
    match error with
    | `Exn _e ->
      Status.default_reason_phrase `Internal_server_error
    | (#Status.server_error | #Status.client_error) as error ->
      Status.default_reason_phrase error
  in
  let len = Int.to_string (String.length message) in
  let headers = Headers.of_list [ "content-length", len ] in
  let body = start_response headers in
  Body.write_string body message;
  Body.close_writer body
