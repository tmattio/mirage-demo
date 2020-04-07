# Mirage Demo

[![Actions Status](https://github.com/tmattio/mirage-demo/workflows/CI/badge.svg)](https://github.com/tmattio/mirage-demo/actions)

Demo of an HTTP server built with MirageOS

## API

The server serves the following endpoints.

### `GET /`

Returns the string `Hello World`.

```bash
$ curl http://35.224.1.215/
Hello World
```

## Contributing

Take a look at our [Contributing Guide](CONTRIBUTING.md).

## TODO

- Build image with commit ID
- Add integration test
- Add CI/CD
- Add terraform
  - IP addr
  - Compute instance
- Use auto scaling groups
