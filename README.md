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
