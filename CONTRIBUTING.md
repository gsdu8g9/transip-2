We love pull requests. Here's a quick guide:

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bin/rubocop` and `bin/foodcritic`.

3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

4. Make the test pass.

5. Verify a running instance using `bin/kitchen converge`.

5. Push to your fork and submit a pull request.


At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within three business days (and, typically, one business
day). We may suggest some changes or improvements or alternatives.

Some things that will increase the chance that your pull request is accepted:

* Make your changes platform-agnostic
* Try to prevent special use-cases that are better left to a wrapper cookbook
* Be friendly and supportive
* Include tests that fail without your code, and pass with it
* Update the documentation, the surrounding one, examples elsewhere, guides,
  whatever is affected by your contribution

Syntax:

Use the [style guides provided by GitHub]. Specifically the [Ruby] one, but the
others apply as well. Other than that, follow the conventions you see used in
the source already.

And in case we didn't emphasize it enough: we love tests!

[style guides provided by GitHub]: https://github.com/styleguide
[Ruby]: https://github.com/styleguide/ruby
