# Contribution guidelines

First of all, thanks for thinking of contributing to this project. :smile:

Before sending a Pull Request, please make sure that you're assigned the task on a GitHub issue.

- If a relevant issue already exists, discuss on the issue and get it assigned to yourself on GitHub.
- If no relevant issue exists, open a new issue and get it assigned to yourself on GitHub.

Please proceed with a Pull Request only after you're assigned. It'd be sad if your Pull Request (and your hardwork) isn't accepted just because it isn't idealogically compatible.

# Developing the gem

1. Fork this repository and clone it and install all the required gem dependencies.

    ```sh
    git clone https://github.com/`your_github_user_id`/networkx.rb.git
    cd networkx.rb
    gem install bundler
    bundle install
    ```

2. Checkout to a different git branch (say, `adds-new-feature`).

3. Add code (, test, and YARD documentation).

4. Run the rspec test-suite.
    ```sh
    # Runs test suite for all files
    bundle exec rspec

    # Runs test-suite only for a particular file
    bundle exec rspec spec/networkx/filename_spec.rb
    ```

5. Run the rubocop for static code quality comments.

    ```sh
    # Runs rubocop test for all files
    bundle exec rubocop

    # Runs rubocop test only for a particular file
    bundle exec rubocop lib/networkx/filename.rb
    ```

6. Send a Pull Request back to this repository. :tada:

# Note: YARD Document

You can create YARD documentation

1. Create Document for `doc` directory with `yard` command
2. Create server via `yard server` command
3. open Browser with `open http://0.0.0.0:8808` e.t.c.

```
$ yard
$ yard server
$ open http://0.0.0.0:8808   
```
