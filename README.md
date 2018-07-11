## Ecto Intro:

Domain specific language for writing queries and interacting with databases in Elixir.

## Ecto

**Brief contents**

- Ecto.Repo 
- Ecto.Schema 
- Ecto.Changeset
- Ecto.Query
- And Friends

## Ecto Library

Ecto is split into 4 main components:

##### Ecto.Repo - repositories are wrappers around the data store.
##### Ecto.Schema - schemas are used to map any data source into an Elixir struct.
##### Ecto.Changeset - allow developers to filter, cast, and validate changes before we apply them to the data.
##### Ecto.Query - written in Elixir syntax, queries are used to retrieve information from a given repository.

####
Example of the Ecto query

```
query = from w in Weather, where: w.prcp > 0,
where: w.temp < 20, select: w
```

```
post = Repo.get!(Post, 42)

case Repo.delete post do 
	{:ok, struct} -> # Deleted with success
	{:error, changeset} -> # Something went wrong
end
```

### Ecto in not an ORM
(Then what is it?)

*Repositories Via the repository, we can create, update, destroy and query existing database entries.*

#####  Repositories

Ecto.Repo is a wrapper around the database.
We can define a repository as follows (lib\blog\repo.ex):

```
defmodule Blog.Repo do 
	use Ecto.Repo, otp_app: :blog
end
```

Repositories

A repository needs an adapter and credentials to communicate to the database. Configuration for the Repo usually defined in your config/config.exs:

```
config :blog, Blog.Repo, adapter: Ecto.Adapters.Postgres, database: "blog_repo", username: "postgres", password: "postgres", hostname: "localhost"
```

Repositories

Each repository in Ecto defines a start_link/0. Usually this function is invoked as part of your application supervision tree (lib\blog.ex):

```
def start(_type, _args) do import Supervisor.Spec, warn: false
children = [ worker(Blog.Repo, []), ] opts = [strategy: :one_for_one, name: Blog.Supervisor] Supervisor.start_link(children, opts)
end
```

Schema

Schemas allows developers to define the shape of their data. (lib\blog\user.ex) defmodule

```
Blog.User do
use Ecto.Schema schema "users" do end end
field :name, :string field :reputation, :integer, default: 0
has_many :posts, Blog.Post, on_delete: :delete_all timestamps
```

Schema

By defining a schema, Ecto automatically defines a struct:

```
iex> user = %Blog.User{name: "Bill"}
%Blog.User{__meta__: #Ecto.Schema.Metadata<:built, "users">, id: nil, inserted_at: nil, name: "Bill"}, posts: #Ecto.Association.NotLoaded<association :posts is not loaded>, reputation: 0, updated_at: nil}
```

Schema

Using Schema we can interact with a repository:

```
iex> user = %Blog.User{name: "Bill", reputation: 10} %Blog.User{...}
iex> Blog.Repo.insert!(user)
%Blog.User{__meta__: #Ecto.Schema.Metadata<:loaded, "users">, id: 6, inserted_at: ~N[2016-12-13 16:16:35.983000], name: "Bill", posts: #Ecto.Association.NotLoaded<association :posts is not loaded>, reputation: 10, updated_at: ~N[2016-12-13 16:16:36.001000]}
```

### Schema
Get the user back

```
iex> newuser = Blog.Repo.get(Blog.User, 6)
iex> newuser.id 6

```
Delete it

```
iex> Blog.Repo.delete(newuser) {:ok, %Blog.User{..., id: 6,...}}
```

### Schema

We can use pattern matching on Structs created with Schemas:

```
iex> %{name: name, reputation: reputation} = ...> Blog.Repo.get(Blog.User, 1)
iex> name "Alex" iex> reputation 144
```

### Changesets


We can add changesets to our schemas to validate changes before we apply them to the data (lib\blog\user.ex):

```
def changeset(user, params \\ %{}) do user
|> cast(params, [:name, :reputation]) |> validate_required([:name, :reputation]) |> validate_inclusion(:reputation, -999..999)
end
```

### Changesets

```
iex> alina = %Blog.User{name: "Alina"} iex> correct_changeset = Blog.User.changeset(alina, %{reputation: 55})
#Ecto.Changeset<action: nil, changes: %{reputation: 55}, errors: [], data: #Blog.User<>, valid?: true>
iex> invalid_changeset = Blog.User.changeset(alina, %{reputation: 1055})
#Ecto.Changeset<action: nil, changes: %{reputation: 1055}, errors: [reputation: {"is invalid", [validation: :inclusion]}], data: #Blog.User<>, valid?: false>
```

### Changeset with Repository functions

```
iex> valid_changeset.valid? true
iex> Blog.Repo.insert(valid_changeset) {:ok, %Blog.User{..., id: 7, ...}}
```

### Changeset with Repository functions

```
iex> invalid_changeset.valid? false
iex> Blog.Repo.insert(invalid_changeset)
{:error, #Ecto.Changeset<action: :insert, changes: %{reputation: 1055}, errors: [reputation: {"is invalid", [validation: :inclusion]}], data: #Blog.User<>, valid?: false>}
```

Changeset with Repository functions

```
case Blog.Repo.update(changeset) do {:ok, user} ->
         # user updated
{:error, changeset} -> # an error occurred
end
```


We can provide different changeset functions for different use cases

```
def registration_changeset(user, params) do # Changeset on create
end


def update_changeset(user, params) do # Changeset on update
end

```
### Query

Ecto allows you to write queries in Elixir and send them to the repository,
which translates them to the underlying database.

### Query using predefined Schema

#### Query using predefined Schema

```
query = from u in User, where: u.reputation > 35,
select: u # Returns %User{} structs matching the query
Repo.all(query)
[%Blog.User{..., id: 2, ..., name: "Bender", ..., reputation: 42, ...}, %Blog.User{..., id: 1, ..., name: "Alex", ..., reputation: 144, ...}]
Directly querying the “users” table
```

### Directly querying the “users” table

```
query = from u in "users", where: u.reputation > 30, select: %{name: u.name, reputation: u.reputation}
```
### Returns maps as defined in select

```
Repo.all(query) [%{name: "Bender", reputation: 42}, %{name: "Alex", reputation: 144}]
External values in Queries
```

### ^ operator

```
min = 33 query = from u in "users",
where: u.reputation > ^min, select: u.name
```
### casting

```
mins = "33" query = from u in "users",
where: u.reputation > type(^mins, :integer), select: u.name
```

### External values in Queries

If query is created with predefined Schema than Ecto will automatically cast external value

min = "35" 
Repo.all(from u in User, where: u.reputation > ^min)

You can also skip Select to retrieve all fields specified in the Schema
### Associations

schema "users" do field :name, :string field :reputation, :integer, default: 0
has_many :posts, Blog.Post, on_delete: :delete_all timestamps
end

### Associations

alex = Repo.get_by(User, name: "Alex")
%Blog.User{__meta__: #Ecto.Schema.Metadata<:loaded, "users">, id: 1, inserted_at: ~N[2016-12-17 06:36:54.916000], name: "Alex", posts: #Ecto.Association.NotLoaded<association :posts is not loaded>, reputation: 13, updated_at: ~N[2016-12-17 06:36:54.923000]}
### Associations

alex_wposts = Repo.preload(alex, :posts)
%Blog.User{..., id: 1, name: "Alex",
posts: [%Blog.Post{__meta__: #Ecto.Schema.Metadata<:loaded, "posts">, body: "World", comments: #Ecto.Association.NotLoaded<association :comments is not loaded>, id: 1, inserted_at: ~N[2016-12-17 06:36:54.968000], pinned: true,
title: "Hello", updated_at: ~N[2016-12-17 06:36:54.968000], user: #Ecto.Association.NotLoaded<association :user is not loaded>, user_id: 1}], ...}

### Associations
users_wposts = from u in User, where: u.reputation > 10,
order_by: [asc: u.name], preload: [:posts]

### Queries Composition
alex = Repo.get_by(User, name: "Alex") alex_post = from p in Post,
where: p.user_id == ^alex.id
alex_pin = from ap in alex_post, where: ap.pinned == true

### Fragments
title = "hello" from(p in Post,
where: fragment("lower(?)", p.title) == ^title) |> Repo.all()

Ecto official resources
github.com/elixir-ecto/ecto
