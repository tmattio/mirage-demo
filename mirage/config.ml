open Mirage

(* Network configuration *)

let stack = generic_stackv4 default_network

(* Arguments *)

let http_port =
  let doc = Key.Arg.info
      ~doc:"Port to listen on for plain HTTP connections"
      ~docv:"PORT" ["http-port"]
  in
  Key.(create "http-port" Arg.(opt ~stage:`Both int 80 doc))

let host_key =
  let doc = Key.Arg.info
      ~doc:"Hostname of the unikernel."
      ~docv:"URL" ~env:"HOST" ["host"]
  in
  Key.(create "host" Arg.(opt string "localhost" doc))

let keys = Key.([ abstract host_key ;
  abstract http_port ])

(* Dependencies *)

let http =
  foreign ~keys "Unikernel.Make"
    (http @-> pclock @-> job)

let dispatch =
  (http $ httpaf_server (conduit_direct stack))

let packages =
  [ package ~sublibs:[ "lib" ] "mirage-demo"
  ; package "mirage-logs"
  ; package ~pin:"git+https://github.com/anmonteiro/httpaf#fork" "httpaf"
  ; package ~pin:"git+https://github.com/anmonteiro/httpaf#fork" "httpaf-lwt"
  ; package
      ~pin:"git+https://github.com/anmonteiro/httpaf#fork"
      "httpaf-lwt-unix"
  ; package ~pin:"git+https://github.com/anmonteiro/httpaf#fork" "httpaf-mirage"
  ]

let () = register ~packages "mirage_demo" [ dispatch $ default_posix_clock ]
