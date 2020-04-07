open Httpaf

let maybe_serialize_body f body =
  match body with None -> () | Some body -> Faraday.write_string f body

let request_to_string ?body r =
  let f = Faraday.create 0x1000 in
  Httpaf_private.Serialize.write_request f r;
  maybe_serialize_body f body;
  Faraday.serialize_to_string f

let response_to_string ?body r =
  let f = Faraday.create 0x1000 in
  Httpaf_private.Serialize.write_response f r;
  maybe_serialize_body f body;
  Faraday.serialize_to_string f

module Write_operation = struct
  type 'fd t =
    [ `Write of Bigstringaf.t IOVec.t list
    | `Upgrade of Bigstringaf.t IOVec.t list * ('fd -> unit)
    | `Yield
    | `Close of int
    ]

  let iovecs_to_string iovecs =
    let len = IOVec.lengthv iovecs in
    let bytes = Bytes.create len in
    let dst_off = ref 0 in
    List.iter
      (fun { IOVec.buffer; off = src_off; len } ->
        Bigstringaf.unsafe_blit_to_bytes
          buffer
          ~src_off
          bytes
          ~dst_off:!dst_off
          ~len;
        dst_off := !dst_off + len)
      iovecs;
    Bytes.unsafe_to_string bytes

  let to_write_as_string t =
    match t with
    | `Write iovecs | `Upgrade (iovecs, _) ->
      Some (iovecs_to_string iovecs)
    | `Close _ | `Yield ->
      None
end

let feed_string t str =
  let len = String.length str in
  let input = Bigstringaf.of_string str ~off:0 ~len in
  Server_connection.read t input ~off:0 ~len

let read_string t str =
  let c = feed_string t str in
  Alcotest.(check int) "read consumes all input" (String.length str) c

let read_request t r =
  let request_string = request_to_string r in
  read_string t request_string

let write_string ?(msg = "output written") t str =
  let len = String.length str in
  Alcotest.(check (option string))
    msg
    (Some str)
    (Server_connection.next_write_operation t
    |> Write_operation.to_write_as_string);
  Server_connection.report_write_result t (`Ok len)

let write_response ?(msg = "response written") ?body t r =
  let response_string = response_to_string ?body r in
  write_string ~msg t response_string

let test_query ?body request response =
  let t = Server_connection.create Mirage_demo.request_handler in
  read_request t request;
  write_response ?body t response
