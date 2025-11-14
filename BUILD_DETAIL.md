# The CI build, in detail

The CI build runs many verification steps to prevent regressions and
ensure high-quality code. To run the build locally, run:

```
bin/ci
```

It can be useful to run the build steps individually
to reproduce a failing part of a build. Let's break
the build down into the individual steps.

## Specs

```
bundle exec rspec
```

## RuboCop

We use [RuboCop](https://github.com/rubocop/rubocop) to enforce style
conventions on the project so that the code has stylistic consistency
throughout. Run with:

```
bundle exec rubocop

# or, if you would like it to auto-correct safe issues, run

bundle exec rubocop --autocorrect
```

Our RuboCop configuration is a work-in-progress, so if you get a failure
due to a RuboCop default, feel free to ask about changing the
configuration. Otherwise, you'll need to address the RuboCop failure,
or, as a measure of last resort, by wrapping the offending code in
comments like `# rubocop:disable SomeCheck` and `# rubocop:enable SomeCheck`.
