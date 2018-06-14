jyj
===

JSON <-> YAML Converter

# Synopsis

      $ jyj file.json > file.yaml
      $ jyj file.yaml > file.json
      $ cat file.json | jyj > file.yaml
      $ cat file.yaml | jyj | jyj > file2.yaml
      $ jyj file.yaml --compact > file.json       # compact JSON

# Description

The `jyj` tool converts JSON input to YAML, and YAML input to JSON. It takes a file argument or reads from stdin. It always writes to stdout.

# Installation

The `jyj` command is written in NodeJS. To install it, run:

      > npm install -g jyj

# Command Options

The `jyj` command has the following options:

* `-c`, `--compact`
If output is JSON, write it compact. Default JSON output is pretty printed.
