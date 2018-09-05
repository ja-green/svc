# *svc*

Tool for managing, running and testing HMRC microservices

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Installing

Clone from github:

```bash
$ git clone git@github.com:ja-green/svc.git
```

Install via make:

```bash
$ make install
```
### Updating

Pull from github:

```bash
$ git pull
```

Update via make:

```bash
$ make update
```

Your bash sources need to be updated after this too:

```bash
$ source ~/.bashrc
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
status            list microservice(s)
log               print service output
```

### Options

```
-h, --help        display help screen for program / specific subcommand
-p, --port        specify a port to run a microservice on
-v, --version     show version information
```

### Examples

Run `vat-summary-frontend` on its default port:
```
$ svc start vat-summary-frontend
```

Run `view-vat-returns-frontend` on port `1234`:
```
$ svc start view-vat-returns-frontend -p 1234
```

Stop the `vat-summary-frontend` microservice:
```
$ svc stop vat-summary-frontend
```

List currently running microservices and their status:
```
$ svc status
```

## Contributing

#### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/ja-green/svc/issues) to report any bugs or file feature requests.

#### Developing

Please read [CONTRIBUTING](https://github.com/ja-green/svc/CONTRIBUTING) for details on code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the APACHE 2.0 License - see [LICENSE](https://github.com/ja-green/svc/LICENSE.md) for details
