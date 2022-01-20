# Inventory Manager

Inventory Manager (inv-mngr) is a Rails app that allows for the tracking of items in inventory, plus purchases and sales of those items.

## Setup

### Copy this Repo

First things first, you need a copy of this repository to your local machine.

#### Clone With Git

If you have Git installed on your machine and SSH keys configured with GitHub:

Open your terminal and `cd` to wherever you'd like to save this repo and run:

`git clone git@github.com:philmccarthy/inv-mngr.git`

Then, `cd` into the `inv-mngr` directory.

#### Without Git

If you don't have Git installed or SSH keys configured with GitHub:

Click the `Code` button at the [top of this GitHub repo](#top) and select `Download ZIP`.

Once downloaded, unzip the file and note the location of `inv-mngr-main`.

Then, in your terminal, move into the new directory with `cd path/to/inv-mngr-main`.

### Running the app

Having been exposed to containerization recently, I wanted to explore Dockerizing this Rails app. Because Rails relies on two servers (web and database), I used Docker Compose to simplify and standardize the local setup of this app.

One challenge I overcame while Dockerizing this app was to enable running it with Docker _or_ in the more traditional way: installing all dependencies to the local machine and running from the command line.

You have the option of using Docker (which is recommended), or setting up the project locally. I've outlined steps for each approach below.

## Run With Docker (Recommended)

1. Install Docker Desktop (or confirm it's already installed). See Docker's [Get Started](https://www.docker.com/get-started) page to download and install.
    > Running Linux? Unlike Docker Desktop for MacOS and Windows, Linux requires Docker Engine and Docker Compose to be installed separately. Follow these [step-by-step Linux instructions](https://docs.docker.com/compose/install/#prerequisites).
2. Next, open the Docker Desktop application. The app is not running if you see an error like `Cannot connect to the Docker daemon` when running the next Docker commands.
3. Finally, from the command line, run the following commands in order:

`docker compose build`

  > This could take a couple minutes while dependencies are retrieved.

`docker compose run web rails db:setup`

  > This will stand up the database container, create tables, and insert seed data.

`docker compose up`

You will see output like this:

```
[+] Running 2/2
 ⠿ Container inv-mngr-db-1   Running
 ⠿ Container inv-mngr-web-1  Running
Attaching to inv-mngr-db-1, inv-mngr-web-1
inv-mngr-web-1  | => Booting Puma
inv-mngr-web-1  | => Rails 7.0.1 application starting in development
inv-mngr-web-1  | => Run `bin/rails server --help` for more startup options
inv-mngr-web-1  | Puma starting in single mode...
inv-mngr-web-1  | * Puma version: 5.5.2 (ruby 3.1.0-p0) ("Zawgyi")
inv-mngr-web-1  | *  Min threads: 5
inv-mngr-web-1  | *  Max threads: 5
inv-mngr-web-1  | *  Environment: development
inv-mngr-web-1  | *          PID: 1
inv-mngr-web-1  | * Listening on http://0.0.0.0:3000
inv-mngr-web-1  | Use Ctrl-C to stop
```

Which means the database and web servers are now up and running.

You're ready to check out the app by visiting [http://localhost:3000](http://localhost:3000) (FYI: The root path routes to the `items#index` action).

### Troubleshooting Docker

You may receive a `401: Unauthorized` response from Docker when attempting to build the container from Ruby 3.1.x if you're logged into a Docker account. Docker recently made changes to their Desktop client access/pricing model. Logging out of should resolve this issue temporarily.

On one machine I tested on, `docker compose run web rails db:setup` returned `LoadError`s for several Ruby gems. Running `docker compose run web rails bundle install` resolved this error.

### Run Tests in Docker

This app was developed using Test Driven Development. The full RSpec test suite can be run using Docker Compose:

1. If the app is running, use `control + c` to stop it (or open a new terminal session).
2. Make sure your `pwd` is `path/to/inv-mngr`.  (`cd` to the correct directory if needed.)
3. Run `docker compose run web rspec` to execute the RSpec test suite.

Output will look like this, with each dot representing a passing test:

```
.....................

Finished in 3.46 seconds (files took 10.98 seconds to load)
21 examples, 0 failures

Coverage report generated for RSpec to /inv-mngr/coverage. 262 / 262 LOC (100.0%) covered.
```

### Skip to Takeaways

If you ran the app with Docker, please jump ahead to the [Takeaways](#takeaways) section.

## Run Locally (Without Docker)

[Running With Docker](#run-with-docker-recommended) is a more seamless process and highly recommended. But if you'd prefer to _not_ use Docker, you can follow these steps.

> These steps are specific to MacOS, so if you're on Windows or Linux, please use Docker.

### Install Ruby

If you don't have Ruby >= 2.7 installed, this is where you should start. If you're already familiar with switching Ruby versions, activate Ruby 3.1 (or >=2.7) locally in the `/inv-mngr` directory and skip to the [Install Dependencies](#install-dependencies-and-create-database) section.

Otherwise, to get the right version of Ruby running we'll need to install Homebrew and rbenv.

#### Install Homebrew

Homebrew is a package management system that allows us to install and run various programs on MacOS. We'll use it to install `postgresql` and `rbenv` in the next steps.

Run `brew doctor` in your terminal. If the output is `Ready to Brew`, skip to the [install PostgreSQL section](#install-postgresql).

If you see an error, follow these steps to install Homebrew:

  1. Run the following command:
  ```
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
  1. When prompted, enter the password you use to log in to your computer.
  1. When it has completed the installation, which may take some time, follow the output directions to run two commands to add brew to your PATH.
  1. Quit the terminal using `command + q` then start a new terminal session. Run `brew doctor`. The output should tell you that everything is fine:
  ```
  $ brew doctor
  Your system is ready to brew.
  ```

  If you instead get a note about needing to run Software Update, follow its advice. Once done, check that `brew doctor` returns `ready to brew`.

#### Install PostgreSQL

The app uses PostgreSQL as its database, and we need to install it (and its dependencies) to our system.

Run `brew install postgresql` and let the installation complete.

Then, run `brew services start postgresql` to start the PostgreSQL service.

#### Install rbenv

To avoid conflicts with the version of Ruby installed natively with your operating system, it's preferable to use a Ruby environment manager like `rbenv`. On MacOs, we can use Homebrew to install rbenv.

  1. In your terminal, run `brew update`
  1. Run `brew install rbenv`
  1. Run `rbenv init`. The output should be _something_ like:
    ```
    # Load rbenv automatically by appending
    # the following to ~/.zshrc
    .
    eval "$(rbenv init -)"
    ```
  1. Open `~/.zshrc` or (`~/.bash_profile` if bash is your default shell) in your favored text edit. Inside this file, type or copy-and-paste in: `eval "$(rbenv init -)"` 
  1. Close your terminal using `command + q`
  1. Re-open your terminal, and run `rbenv versions`. As long as you don't get an error message, `rbenv` has been installed correctly

#### Change Ruby Version

Use `rbenv` to change Ruby versions:
  1. In the Terminal, run `rbenv install 3.1.0`. This may take several minutes.
  1. Run `rbenv versions`. You should now see `3.1.0` listed
  1. Run `rbenv rehash` to update your path. You should not expect any output.
  1. cd into the `inv-mngr` directory
  1. Run `ruby -v`. The output should be something like `ruby 3.1.0p0 ...` (the `.ruby-version` file tells rbenv to use `3.1.0`)
    - If `ruby -v` still returns a different version, run `rbenv local 3.1.0`
  
  If you still aren't seeing `ruby -v` return `ruby 3.1.0`, check that you correctly edited your `~/.zshrc` (or `~/.bash_profile`) file, restarted your terminal, and ran `rbenv rehash`.

### Install Dependencies and Create Database

Next, with the `inv-mngr` repository as your `pwd`, run these commands in order:

Run bundle to install gems `inv-mngr` depends on:

`bundle install`

> If you get an error from bundler related to `pg`, double check that you [installed PostgreSQL](#install-postgresql) with Homebrew.

Create, migrate and seed the database:

`bundle exec rails db:setup`

If you receive a `PG::ConnectionBad` error, run `brew services start postgresql`.

### Start the App

You're now all set to run the app:

`bundle exec rails server`

You will see output like this:

```
=> Booting Puma
=> Rails 7.0.1 application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 5.5.2 (ruby 3.1.0-p0) ("Zawgyi")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 37198
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```

Which means the app is now up and running.

You're ready to check out the app by visiting [http://localhost:3000](http://localhost:3000) (FYI: The root path routes to the `items#index` action).

### Run Tests Locally

This app was developed using Test Driven Development. The full RSpec test suite can be run locally.

1. If the app is running, use `control + c` to stop it (or open a new terminal session).
2. Make sure your `pwd` is `path/to/inv-mngr`. `cd` to the correct directory if needed.
3. Run `bundle exec rspec` to execute the RSpec test suite.

Output will look like this, with each dot representing a passing test:

```
.....................

Finished in 3.46 seconds (files took 10.98 seconds to load)
21 examples, 0 failures

Coverage report generated for RSpec to /inv-mngr/coverage. 262 / 262 LOC (100.0%) covered.
```

## Takeaways

As I worked on this application, I reflected on a few areas of growth:

### Database buildout

I started this project by defining a simple schema and implementing it using Test Driven Development to ensure relationships were properly defined. This approach also allowed me to consider what data validations should be added initially.

- Started by adding Items table, which includes columns name, description, category, and an initial stock level.
- Sales table, each record references an Item. Quantity attribute represents inventory out.
- Purchases table, each record references an Item as well. Quantity attribute represents stock in.

Were this application to expand, a first step might be to adjust the Items, Sales and Purchases associations to be `many to many` instead of `one to many`, because, realistically, purchases and sales could involve many items. In this scenario, "through" tables like `ItemPurchases` and `ItemSales` could be added.

### Implementing "Undelete"

I was excited to tackle "undeletion" because I've learned that production applications rarely permanently delete data. I hadn't explored how to make this work, and I was happy to implement a fairly simple solution in adding an `enabled` column to the Items table.

When the user `deletes` an item, the record is updated so that the `enabled` value is set to `false`. Presentation logic allows deleted items to be shown to the user, but item details are hidden and only an `undelete this item` button is visible.

The `undelete` button then triggers the inverse update, where the `enabled` value is set to `true`.

### Containerization

I've been exposed to a heavily containerized system architecture in my current role. While I'm not responsible for the management of our infrastructure, I work closely with a nimble DevOps team and I've developed interest in site reliability and platform engineering. Containerizing this Rails app was a small exploration in how to work with Docker Compose to stand up multiple containers with a dependent relationship.

Additionally, I realized the value of containers when putting together instructions to run this application with or without Docker. I feel that it's important to provide good documentation—and doing so with Docker felt easier and less likely to fail.

### Setting UUID as Default Primary Key

A new idea that I implemented on this application was changing the default ID for all tables to be UUIDs instead of incrementing from 1. In production applications, I more often see secure, hard-to-guess IDs in dynamic URLs.

I've been curious about the process for defining a more secure primary key and wanted to explore this during this project. I was able to search and find config options to enable UUID as default primary key in PostgreSQL, and learned that my original database choice (SQLite3) didn't support using UUIDs. So I adjusted to using a PostgreSQL database instead.

To set UUIDs as the default primary key, I added the below code to the `config/initializers/generators.rb` file:

```rb
Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: :uuid
end
```

Then, I solved an issue with ActiveRecord's `first` and `last` methods, which rely on the implicit ordering of records by the `:id` column. UUIDs aren't orderly, so I added the below line to the `ApplicationRecord` class to order by records by the `:created_at` column:

```rb
self.implicit_order_column = 'created_at'
```

Which fixed the issue with the `first` and `last` methods.

## Thank You

Thanks for taking a look at my app! I welcome any feedback.

You can find me on [LinkedIn](https://linkedin.com/in/pjmcc), check out my [website](https://philmccarthy.dev), or shoot me an email: `hi (at) philmccarthy.dev`.
