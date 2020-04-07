# Contributing

## Setup your development environment

You need Opam, you can install it by following [Opam's documentation](https://opam.ocaml.org/doc/Install.html).

With Opam installed, you can install the dependencies with:

```bash
make dev
```

Then, build the project with:

```bash
make
```

To build the Mirage unikernel, run:

```bash
make mirage
```

### Running Unikernel

After building the project, you can run the unikernel that is produced.


```bash
make start
```

Alternatively, you can run the unikernel inside a docker image:

```bash
docker build -t mirage-demo:unix .
docker run -it -p 8080:8080 mirage-demo:unix
```

### Running Tests

You can run the test compiled executable:


```bash
make test
```

### Building documentation

Documentation for the libraries in the project can be generated with:

```bash
make doc
open-cli $(make doc-path)
```

This assumes you have a command like [open-cli](https://github.com/sindresorhus/open-cli) installed on your system.

> NOTE: On macOS, you can use the system command `open`, for instance `open $(make doc-path)`

### Repository Structure

The following snippet describes Mirage Demo's repository structure.

```text
.
├── lib/
|   Source for Mirage Demo's library. Contains Mirage Demo's core functionnalities.
│
├── mirage/
|   Source for mirage-demo's unikernel. This links to the library defined in `lib/`.
│
├── script/
|   Scripts used during development and deployment.
│
├── test/
|   Unit tests and integration tests for Mirage Demo.
│
├── dune-project
|   Dune file used to mark the root of the project and define project-wide parameters.
|   For the documentation of the syntax, see https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
│
├── LICENSE
│
├── Makefile
|   Make file containing common development command.
│
├── README.md
│
└── mirage-demo.opam
    Opam package definition.
    To know more about creating and publishing opam packages, see https://opam.ocaml.org/doc/Packaging.html.
```
