# iglu-lint

Github Action to Lint [Iglu JSON Schemas](https://github.com/snowplow/iglu/wiki/Self-describing-JSON-Schemas)

## Usage

```yml
name: Iglu Lint Review
on: [pull_request]
jobs:
  iglulint:
    runs-on: ubuntu-latest

    steps:
      - name: Clone repo
        uses: actions/checkout@v2

      - name: iglulint
        uses: mrchief/iglu-lint@1.0.0 # or any tagged release
        with:
          path_to_schemas: "path/to/schema"
          github_token: ${{ secrets.github_token }}
```

For a complete list of options, see [action.yml](./action.yml)

## Validations

It can currently validate:

- if your schema is valid JSON or not
- if valid, then run it against [`igluctl lint`](https://docs.snowplowanalytics.com/docs/open-source/iglu/#lint-1) to further check for errors and inconsistencies against Iglu Schema Registries

### Review comments

Errors are posted as review comments. Some examples are:

**JSON Lint errors**

![json lint errors](https://user-images.githubusercontent.com/781818/77257804-eeec4f80-6c4c-11ea-9284-16bbc1afc83e.png)

**Igluctl lint errors**

![igluctl lint errors](https://user-images.githubusercontent.com/781818/77257750-a339a600-6c4c-11ea-846f-980e8908f0d9.png)

## Known issues

- This action relies on underlying tools [jsonlint](https://github.com/zaach/jsonlint) and [igluctl](https://docs.snowplowanalytics.com/docs/open-source/iglu/#igluctl) to perform the actual validations. As such, the actual error messages are only as useful as what the tool provides.

  E.g. in the JSON Lint Error screenshot, the problem is an extra trailing comma but the error message from the tool is not so helpful in identifying that.

- Igluctl lint doesn't provide the line numbers of the offending code. This action performs a crude implmentation to figure out the line number. As such, the comments may sometime be placed against incorrect line numbers. If that happens, please feel free to report an _issue_ here. I can not guarantee it can be fixed but I'll definitely try. PRs would be welcome too!

- jsonlint doesn't report all errors at once, so you may have to make multiple passes if your JSON Schema file contains multiple errors.

- Currently, this action doesn't prevent duplicate comments on multiple runs, or reruns of your workflow. In other words, if you have an error for `file A` and you make more changes to your PR without fixing `file A`, then subsequent runs will post another comment for `file A`. Fixing this is on the roadmap and PRs are welcome.

## Roadmap

[ ] - Do not report multiple comments on subsequent runs.

## Contributing

We welcome all kind of contributions, as long as they are not violating our Code of Conduct. You can contribute by:

- reporting a bug ([submit one here](https://github.com/mrchief/aws-creds-okta/issues))
- proposing new feature ([submit one here](https://github.com/mrchief/aws-creds-okta/issues))
- submitting new features or bug fixes ([send a PR](#sending-a-pr))

By contributing, you agree that your contributions will be licensed under the project's [license](#license)

### Sending a PR

We use [Github Flow](https://guides.github.com/introduction/flow/index.html) method so please follow these steps:

- Fork the repo and create your branch from master.
- If you've added code that should be tested, add tests.
- If you've changed APIs, update the documentation.
- Issue that pull request!

NOTE: Ensure that you merge the latest from "upstream" before making a pull request!

## Code of Conduct

Please see [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)

## License

This action is released under [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0). Docker container images built in this project include third party materials. See [THIRD_PARTY_NOTICE.md](THIRD_PARTY_NOTICE.md) for details.
