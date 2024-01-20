
# calm 0.1.0

Calm is an easy to use web framework written in [crystal](https://crystal-lang.org).

## installing crystal

see [installing crystal](https://crystal-lang.org/install) for details.

## creating a new project

```
$ crystal init app blog
    create  /blog/.gitignore
    create  /blog/.editorconfig
    create  /blog/LICENSE
    create  /blog/README.md
    create  /blog/shard.yml
    create  /blog/src/blog.cr
    create  /blog/spec/spec_helper.cr
    create  /blog/spec/blog_spec.cr
Initialized empty Git repository in /blog/.git/
```

change directory `cd blog`

edit `shard.yml` and add `calm` to it as a dependency:

```
dependencies:
  calm:
    path: "???????????????"
    version: 0.1.0
```

then run `shards install` to download dependencies.

Initialize your application with `crystal run lib/calm/src/init.cr`

Run migrations with `crystal run src/blog.cr -- db migrate`

## running the application

Inside your project folder run `crystal run src/blog.cr`

