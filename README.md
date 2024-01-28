
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

## configuring the application

The config file is located at `src/config/settings.cr`

### @project_name

name of the project as String. It is used where we need to use the project name as a String.

### @auth_token_expiration

it is an integer, and the token expires after n minutes where n is the value of this.

### @auth_token_secret

needed to encript the token, don't share this secret with anyone. It's a String.

### @database_url

how to connect to the database. Currently only postgresql is supported. The format is: `"postgres://username:password@hostname:port/databasename_environment`

### @debug

use more detailed debugging or not. A boolean.

### @default_locale

the default locale of the application. A two-letters String.

### @host

where the server listens on. Hostname or IP address as a String.

### @items_on_page

how many rows are visible at the same time while using the table component. An integer.

### @log_level

the logging level. `::Log::Severity::Trace, ::Log::Severity::Debug, ::Log::Severity::Info, ::Log::Severity::Notice, ::Log::Severity::Warn, ::Log::Severity::Error, ::Log::Severity::Fatal`. It is an object.

### @port

an integer, the port where the server listens on.

### @refresh_token_expiration

it is an integer, and the token expires after n minutes where n is the value of this.


### @refresh_token_secret

needed to encript the token, don't share this secret with anyone. It's a String.

### @time_zone

The time zone as an object. `Time::Location.load("UTC")`

### @x_frame_options

"The X-Frame-Options HTTP response header can be used to indicate whether a browser should be allowed to render a page in a `<frame>`, `<iframe>`, `<embed>` or `<object>`. Sites can use this to avoid click-jacking attacks, by ensuring that their content is not embedded into other sites." By default it is `DENY`.

## running the application

Inside your project folder run `crystal run src/blog.cr`

## generators

generators can be used from the project folder as `crystal run lib/calm/src/generate.cr -- [type] [name] [action]`
With generators a files are generated to start to work from.

### controller type

`crystal run lib/calm/src/generate.cr -- controller post show`

this creates a handler at `src/handlers/post_controller.cr` with the content:

```
class PostController < Calm::Controller::ApplicationController
  def show(render)
    args = {} of String => Any

    render.with args
  end
end
```

You can use `index`, `show`, `add`, `create`, `edit`, `update`, `destroy` as the action name.

Without the action it generates a controller file without any actions.
 
`crystal run lib/calm/src/generate.cr -- controller post`

```
class PostController < Calm::Controller::ApplicationController
end
```

### view type

`crystal run lib/calm/src/generate.cr -- view post show`

this creates a view at `src/views/post/post_controller_view.cr` with the content:

```
class PostControllerView < Calm::Http::BaseView
  def show(context, vars)
    context.ui do
      h1 { t(".title") }

      div(id: "test") do
        "It works!"
      end

      a(href: "#", "hx-get": Calm::Routes.post_controller__show, "hx-target": "#test", "hx-push-url": "true") do
        "Test link"
      end
    end
  end
end
```

You can use `index`, `show`, `add`, `create`, `edit`, `update`, `destroy` as the action name.

#### index action



Without the action it generates a controller file without any actions.
 
`crystal run lib/calm/src/generate.cr -- controller post`

```
class PostController < Calm::Controller::ApplicationController
end
```

### policy type

and creates a policy at `src/views/post/post_controller_view.cr` with the content:

```
class PostControllerPolicy < Calm::Handler::ApplicationControllerPolicy
  def show?
    true
  end
end
```

and adds this to `/src/config/routes.cr`:
`get "/post", PostController.show, PostControllerView.show`

Not a big deal, but it's easier to customize this as to create the file from scratch.

### model type

`crystal run lib/calm/src/generate.cr -- model post`

```
class Post < Calm::Db::Base
  mapping({id: Int32, name: String})

  validates_presence_of([:name])
  # default_values({invalid_sign_in_count: 0})
end
```

### migration type

`crystal run lib/calm/src/generate.cr -- migration create_table_posts`

This generates the file `src/migrations/20240126191339680_create_table_posts.cr` with the following content:

```
class M20240126191339680CreateTablePosts < Calm::Db::Migration
  def up
    # create_table Post
  end

  def down
    pp "down"
  end
end
```

To apply migrations from files in the migrations directory run `crystal src/blog.cr db migrate`. And everything from the migration files will be applied into the database.

## database model methods

models are located at `src/models`. 

* `Post.all.call` - getting every object as an `Array(Post)`
* TODO: pagination???
* yyy
* zzz

