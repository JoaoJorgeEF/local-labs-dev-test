# README

## Install and usage

With `Docker` and `docker-compose` installed, you can use the following command to build and run the application:

```sh
docker-compose up --build
```

Now we need to create the database using:

```sh
docker-compose run app bundle exec rails db:create db:migrate
```

After the database was created, for test purposes, we need to create a `Organization` and a few `Users` on the database, so inside the docker, open the rails console using:

```sh
bin/rails console
```

and create the following:

```sh
org = Organization.new(name: "New York News", slug: "NYN").save

u = User.new(email: "jessicapearson@gmail.com", name: "Jessica Pearson", encrypted_password: "$2a$12$m.giAsS/JdLkymOZeN5/jeZ3RUOiKkAhp.supMe9qgk/KHTvr9R4a", organization_slug: "NYN", user_type: "chief_editor").save!(validate: false)

u2 = User.new(email: "katrinabennett@gmail.com", name: "Katrina Bennett", encrypted_password: "$2a$12$m.giAsS/JdLkymOZeN5/jeZ3RUOiKkAhp.supMe9qgk/KHTvr9R4a", organization_slug: "NYN", user_type: "writer").save!(validate: false)

u3 = User.new(email: "louislitt@gmail.com", name: "Louis Litt", encrypted_password: "$2a$12$m.giAsS/JdLkymOZeN5/jeZ3RUOiKkAhp.supMe9qgk/KHTvr9R4a", organization_slug: "NYN", user_type: "writer").save!(validate: false)

```

PS: since Devise was used to create the `User` model, the password field only accepts encrypted values using `Bcrypt`, you can use the value used above wich is the password `123456` or generate your own using  https://bcrypt-generator.com/
