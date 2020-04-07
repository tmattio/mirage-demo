FROM alpine:3.11

# Install system dependencies
RUN apk add --update \
    ocaml ocaml-compiler-libs ocaml-ocamldoc ocaml-findlib opam \
    make m4 musl-dev git perl pkgconfig gmp-dev sfdisk syslinux \
    coreutils
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
RUN eval $(opam env) && cd mirage && mirage configure -t virtio -vv --net=direct --dhcp=true
RUN eval $(opam env) && cd mirage && make depend
RUN eval $(opam env) && cd mirage && make

# Build an MBR-partitioned disk image with the unikernel
RUN eval $(opam env) && solo5-virtio-mkimage -f tar mirage/mirage-demo-latest.tar.gz mirage/mirage_demo.virtio
