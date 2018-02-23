# *svc*

Tool for managing running and testing HMRC VAT:VC microservices

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

The program `screen` is needed for `svc` to run. Use `make dep` to install automatically or if you would like to do it manually:

```bash
$ sudo apt-get update
$ sudo apt-get install screen
```

### Installing

Clone from github:

```bash
$ git clone git@github.com:ja-green/svc.git
```

Install via make:

```bash
$ make install
```
## Usage

```
svc <subcommand> [options]
svc <subcommand> [microservice] [options]
```

### Subcommands

```
start             start inactive microservice(s)
stop              stop active microservice(s)
list              list microservice(s)
log               print service output
test              run unit and integration tests
utest             run unit tests
itest             run integration tests
clean             clean microservice files
compile           compile the microservice code
populate          populate the services with data
```

### Options

```
-h, --help        display help screen for program / specific subcommand
-p, --port        specify a port to run a microservice on
-a, --all         apply command to all available microservices
-b. --branch      specify a git branch
-v, --version     show version information
```

### Examples

Run `vat-summary-frontend` on it's default port:
```
$ svc start vat-summary-frontend
```

Run `view-vat-returns-frontend` on port `1234`:
```
$ svc start view-vat-returns-frontend -p 1234
```

Stop all running microservies:
```
$ svc stop -a
```

List all microservices and their status:
```
$ svc list -a
```

List currently running microservices and their status:
```
$ svc list
```

### Notes

* Currently `svc` only supports `vat-summary-frontend` and `view-vat-returns-frontend`

## Contributing

#### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/karan/joe/issues) to report any bugs or file feature requests.

#### Developing

Please read [CONTRIBUTING](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the APACHE 2.0 License - see [LICENSE](LICENSE.md) for details
