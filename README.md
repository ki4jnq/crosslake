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

Multiple files can be spcified to a single command.
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
