# gem-publish

## Description

A simple shell script to build, push, and clean up a gem in one step.

From within a gem's root directory, `gem-publish`:

1. Makes all files readable (`chmod -R a+rX .`), so nothing is left out of the build because of restrictive permissions.
2. Builds a gem from every `*.gemspec` in the directory (`gem build`).
3. Asks once for a multifactor authentication code, where more than one gem was built.
4. Pushes each built gem to [RubyGems](https://rubygems.org) (`gem push`).
5. Removes the local `*.gem` files left behind by the build (`rm`).


## Installation

### 0. Have a recent version of Ruby installed

### 1a. Via Homebrew

```shell
$ brew tap thoran/tap
$ brew install thoran/tap/gem-publish
```

### 1b. Manually

```shell
git clone https://github.com/thoran/gem-publish
cp ./gem-publish/bin/gem-publish to your preferred executable path
chmod +x /path/to/gem-publish
```


## Usage

Run it from the root of the gem you want to publish:

```sh
cd path/to/your/gem
gem-publish
```

This builds and pushes every `*.gemspec` in the current directory, and expects that you're authenticated with RubyGems (see `gem signin`).

### Multifactor authentication

Where the directory holds more than one gemspec, `gem-publish` asks for an OTP code once and passes it to each push with `--otp`:

```
OTP code (leave blank to be asked for each gem):
```

Leave it blank to have RubyGems ask for a code at each push instead, which is what you want if you don't have multifactor authentication turned on, or if the code you entered has expired part way through a run. A code is only good for about a minute, so a directory of many gems can still outrun one.

With a single gemspec there's no prompt: RubyGems asks for itself, once, as it always has.


## Contributing

1. Fork it: `https://github.com/thoran/gem-publish/fork`
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new pull request


## License

MIT
