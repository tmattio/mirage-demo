(lang dune 1.11)
(name mirage-demo)
(source (github tmattio/mirage-demo))
(license MIT)
(authors "Thibaut Mattio")
(maintainers "Thibaut Mattio")

(generate_opam_files true)
(implicit_transitive_deps false)

(package
 (name mirage-demo)
 (synopsis "Demo of an HTTP server built with MirageOS")
 (description "\
Demo of an HTTP server built with MirageOS
")
 (depends
  (ocaml (>= 4.06.0))
  (dune (>= 2.0))
  (alcotest :with-test)
  (odoc :with-doc)
  httpaf
  httpaf-lwt
  httpaf-lwt-unix
  lwt
  routes
  logs))
