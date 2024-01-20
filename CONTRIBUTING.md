# Contributing to `flutter_cohere`

`flutter_cohere` is an open source package.

It is the work of hundreds of contributors. We appreciate your help!

## Contributing code

We welcome contributions to `flutter_cohere` in the form of pull requests.

### Step 1: Fork

Fork the project [on GitHub](https://github.com/abdibrokhim/flutter_cohere) and check out your copy locally.

```sh
git clone https://github.com/abdibrokhim/flutter_cohere.git
cd flutter_cohere
git remote add upstream
```

### Step 2: Branch

Create a feature branch and start hacking:

```sh
git checkout -b my-feature-branch -t origin/master
```

### Step 3: Commit

Make sure git knows your name and email address:

```sh
git config --global user.name "J. Random User"
git config --global user.email "
```

Writing good commit logs is important. A commit log should describe what changed and why.

### Step 4: Rebase

Use git rebase (not git merge) to sync your work from time to time.

```sh
git fetch upstream
git rebase upstream/master
```

### Step 5: Test

Bug fixes and features should come with tests. Add your tests in the `test/` directory.

### Step 6: Push

```sh
git push origin my-feature-branch
```

Go to and click "Compare & pull request" for your feature branch. Then fill in the form and submit the pull request.

## License

By contributing to `flutter_cohere`, you agree that your contributions will be licensed under its BSD license.