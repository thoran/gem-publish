# gem-publish

## Description

A simple shell script to build, push, and clean up a gem in one step.

From within a gem's root directory, `gem-publish`:

1. Makes all files readable (`chmod -R a+rX .`), so nothing is left out of the build because of restrictive permissions.
2. Builds the gem from the `*.gemspec` (`gem build`).
3. Pushes the built gem to [RubyGems](https://rubygems.org) (`gem push`).
4. Removes the local `*.gem` file left behind by the build (`rm`).


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

This expects exactly one `*.gemspec` in the current directory and that you're authenticated with RubyGems (see `gem signin`).


## Contributing

1. Fork it: `https://github.com/thoran/gem-publish/fork`
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new pull request


## License

MIT
