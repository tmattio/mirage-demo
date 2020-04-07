FROM alpine:3.11 as build

# Install system dependencies
RUN apk add --update \
    ocaml ocaml-compiler-libs ocaml-ocamldoc ocaml-findlib opam \
    make m4 musl-dev git perl pkgconfig gmp-dev
ENV OPAMYES=1
RUN opam init --auto-setup --disable-sandboxing

RUN mkdir /opt/app
WORKDIR /opt/app

# Install dev dependencies
RUN eval $(opam env) && opam install mirage mirage-unix
ADD mirage-demo.opam mirage-demo.opam
RUN eval $(opam env) && opam install --deps-only .

# Build project and unikernel
ADD . .
RUN eval $(opam env) && opam install .
RUN eval $(opam env) && cd mirage && mirage configure -t unix -vv --net=socket --dhcp=false
RUN eval $(opam env) && cd mirage && make depend
RUN eval $(opam env) && cd mirage && make

FROM alpine:3.11 as docker

RUN apk add --update gmp

COPY --from=build /opt/app/mirage/main.native /bin/server

ENTRYPOINT /bin/server --http-port 8080
EXPOSE 8080
