# gem-publish

## Description

A simple shell script to build, push, and clean up gems in one step.

Given a list of directories, or the current one where none is named, `gem-publish`:

1. Stops, building and pushing nothing, unless every directory is a git checkout in which nothing its gems are built from is uncommitted or untracked (`git status --porcelain`).
2. Makes all files readable (`chmod -R a+rX .`) in each, so nothing is left out of a build because of restrictive permissions.
3. Builds a gem from every `*.gemspec` in each directory (`gem build`).
4. Asks once for a multifactor authentication code, where more than one gem was built in total.
5. Pushes each built gem to [RubyGems](https://rubygems.org) (`gem push`).
6. Removes the local `*.gem` files left behind by the build (`rm`).


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

Or name the directories, from wherever you happen to be:

```sh
gem-publish git.rb monotonic.rb WebAccount
```

Either way it expects that you're authenticated with RubyGems (see `gem signin`).

Everything is built before anything is pushed, so a run which is going to fail for want of a gemspec or a permission does so before the first push rather than part way down the list.

### Uncommitted changes

`gem build` packages whatever is on disk, so an edit not yet committed, or a stray file a gemspec's globs pick up, would go out in a version which no commit or tag holds. So before building anything `gem-publish` loads every gemspec in each directory named and checks what it's built from: the files it lists, the gemspec itself, and any file it reads while loading, such as a version file shared across a monorepo. Where any of those is modified or untracked it stops, naming them:

```
gem-publish: Nothing built or pushed. There are files that need to be committed first:
duration.rb
 M duration.rb.gemspec
?? lib/Duration/Parser.rb
```

Other files don't count: notes kept beside the code, another component of the same repository, or ignored files such as built `*.gem`s. A directory which isn't in a git repository, or which has no gemspec or one which doesn't load, stops it too.

It's all or nothing: one dirty directory stops the whole run, clean ones included, so a sweep never publishes part of its list. Commit, stash, or remove the files and run it again.

### Multifactor authentication

Where more than one gem was built in total, `gem-publish` asks for an OTP code once and passes it to each push with `--otp`:

```
OTP code (leave blank to be asked for each gem):
```

The total is what counts, not the directory: one directory holding two gemspecs and eleven holding one apiece are the same case, and both get a single prompt.

Leave it blank to have RubyGems ask for a code at each push instead, which is what you want if you don't have multifactor authentication turned on, or if the code you entered has expired part way through a run. A code is only good for about a minute, so a long enough list can still outrun one.

With a single gem there's no prompt: RubyGems asks for itself, once, as it always has.

### After a run which didn't finish

Name only the directories still outstanding:

```sh
gem-publish poloniex.rb WebAccount
```

Naming them all again is safe but noisy — RubyGems refuses to accept a version twice, so the ones which already went through fail on the second run.


## Contributing

1. Fork it: `https://github.com/thoran/gem-publish/fork`
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new pull request


## License

MIT
