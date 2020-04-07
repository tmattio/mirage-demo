module type HTTP = Httpaf_mirage.Server

(** Server boilerplate *)
module Make (Http : HTTP) (Clock : Mirage_clock.PCLOCK) = struct
  
  module Logs_reporter = Mirage_logs.Make(Clock)

  let callback =
    Http.create_connection_handler
      ?config:None
      ~request_handler:Mirage_demo.request_handler
      ~error_handler:Mirage_demo.error_handler

  let start http _clock =
    Logs.(set_level (Some Info));
    Logs_reporter.(create () |> run) @@ fun () ->
    let http_port = Key_gen.http_port () in
    let host = Key_gen.host () in
    Logs.info (fun f -> f "Server listening on http://%s:%d" host http_port);
    http (`TCP http_port) callback
end
