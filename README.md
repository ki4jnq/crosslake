## Crosslake Tech Code Challenge

This program takes one or more text files in a well structured format, and
reports a summary of all inputs.

### Running

If you have Ruby installed, you can execute the program directly.
```sh
./report.rb --help
```

If Ruby is not discoverable with `/usr/bin/env`, you can replace `./report.rb`
in the following comamnds with `ruby report.rb`.
```sh
ruby report.rb --help
```

You can pass an input file to the program with the `--input` or its `-i`
shorthand.
```sh
./report.rb --input input.txt
./report.rb -i input.txt
```

STDIN can also be used by specifying `-` as the input filename.
```sh
cat input.txt input-2.txt | ./report.rb -i -
```

Multiple files can be spcified in a single command.
```sh
./report.rb -i input.txt -i input-2.txt
```

By default, the program prints output to stdout to allow easy redirection, but
you can also specify a file with the `--output` flag, or its shorthand `-o`.
```sh
./report.rb -i input.txt -i input-2.txt -o report.out
```

Help text can be displayed by passing `-h` to the program
```sh
./report.rb -h
```

### Testing

The program includes an extensive test suite, which you can run after
installing RSpec with bundle.
```sh
bundle
```

Once that completes, you can execute the tests with:
```sh
rspec spec
```


### Design

The Application is split into two basic pieces:

1. A Document model, and its children, to capture business logic.
2. A Parser that builds the Document from one or more input streams.

A small wrapper script instatiates the parser, collects the input streams, and
directs the output.

#### The Document

The Document model tracks all entities defined within the inputs, and wires
them together at the same time. It exposes a simple, stream-like API that
allows pushing entities into the Document as they are discovered in the
inputs. Coordinating new objects through this API provides an ideal place to
ensure that the inputs are well formed. Specifically, that:

1. A Report must be defined before it is referenced by a Track
2. A Track must be defined before it is referenced by an Indicator
3. All Report, Track, and Indicator IDs are unique across the Document

If one of these conditions is not met, a meaninful error will be thrown with
details as two which entity was invalid. This makes tracking the error back to
a particular record easy.

Each entity in the Document knows how to report its own score from itself or
its children. This design allows for easy testing in isolation from the
smallest entity (the Indicator) up to the entire Document.

Finally, the Document is responsible for generating the report text. It
accepts an IO output object and simply writes out the calculated scores in a
friendly format. By accepting its output as an argument, the report can easily
be written to a location in memory, where it can be tested for correctness.

#### The Parser

The Parser is written to not know specifically where its input is coming from,
it only needs an enumerable object that iterates line-by-line. Ruby's standard
IO objects fit this need perfectly, but this isn't a strict requirement. Since
the Parser is agnostic of its input, it can easily be used in a variety of
contexts, including a web server.

#### The Wrapper Script

By far the smallest piece, the wrapper script simply provides the glue
allowing us to execute the parser and generate the report from the CLI. It
sets up the command line options, opens and closes input files, and directs
the output to its final destination.

Keeping this piece as small as possible allows for maximum code reuse.
