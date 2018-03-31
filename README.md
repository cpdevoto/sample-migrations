## Quick Start

### Initial Setup

Make sure that you have Docker installed on your Mac.

If you do not already have Gradle installed, install it using the following command:

```
brew install gradle
```

Within your user root directory (e.g. ```~/cdevoto```), locate the folder named ```.gradle```. If it does not exist, create it.

Within the ```.gradle``` folder, create a file named ```gradle.properties``` with the following contents:

```
shrine_artifactory_user=<YOUR_ARTIFACTORY_USERNAME>
shrine_artifactory_password=<YOUR_ARTIFACTORY_ENCRYPTED_PASSWORD>
shrine_artifactory_contextUrl=https://shrinedevelopment.jfrog.io/shrinedevelopment
```

Your encrypted password can be obtained as follows
1. use a browser to navigate to the https://shrinedevelopment.jfrog.io/ page, 
2. log in with your Artifactory credentials
3. click on the dropdown list next to your username in the upper left corner of the home page and select "Edit Profile" from the resulting context menu.
4. type your password in the "Current Password" field and click the "Unlock" button.
5. click on the little eye icon that appears to the right of the "Encrypted Password" field to view your encrypted password
6. copy the contents of the "Encrypted Password" field to your ```gradle.properties``` file.

Within a Terminal window, execute the following commands.  Note that, in each case, you will be prompted to supply your Artifactory Online user credentials:

```
docker login shrinedevelopment-docker-develop.jfrog.io
docker login shrinedevelopment-docker-stable.jfrog.io
docker login shrinedevelopment-docker-ext.jfrog.io
```

Edit your ```~/.bash_profile``` to include the following aliases and functions:

```
alias migrations-create='docker-compose -f docker/docker-compose.yml run migrations-app rake db:create'
alias migrations-drop='docker-compose -f docker/docker-compose.yml run migrations-app rake db:drop'
alias migrations-up='docker-compose -f docker/docker-compose.yml up'
alias migrations-migrate='docker-compose -f docker/docker-compose.yml run migrations-app rake db:migrate'
alias migrations-rollback='docker-compose -f docker/docker-compose.yml run migrations-app rake db:rollback'
migrations-new_migration () {
	docker-compose -f docker/docker-compose.yml run migrations-app rake db:new_migration name=$1
}

alias wantify-postgres-latest='docker pull shrinedevelopment-docker-develop.jfrog.io/postgres-schema'
alias wantify-postgres='docker run -it --rm -p 5432:5432 -h localhost --name wantify-db shrinedevelopment-docker-develop.jfrog.io/postgres-schema'
```
After editing this file, execute by running

```
source ~/.bash_profile
```

### Creating new migrations

Within the same Terminal window, navigate to the root directory of the cloned ```wantify-migrations``` repository, and execute the following command to create the migrations database, and to bring it up:

```
migrations-create
migrations-up
```

Open a new tab in your Terminal application, make sure your are still in the root directory of the ```wantify-migrations``` repository, and execute the following command to execute all of the existing migrations:

```
migrations-migrate
```
To create a new migration execute the following command:

```
migrations-new_migration <my-migration-name>
```

This will create a new file that you can edit to include your migration logic within the ```db/migrate``` folder. Once you have edited this file, you should run the ```migrations-migrate``` command again to execute the new migration.

To publish the new migration, you should manually increment value of the ```buildNum``` property within the ```wantify-migrations/gradle.properties``` file, and then execute the following command:

```
./gradlew clean build artifactoryPublish --refresh-dependencies
```

This will create a new version of the ```migrations-app``` Docker image, and the ```postgres-schema``` Docker and publish both of these to Artifactory, where they will become available to other members of the team.

### Using the Wantify PosgreSQL database for local development

If you are not performing any migrations, and simply want to use a local copy of the database which already includes the latest migrations, you can use the following two commands:

```
wantify-postgres-latest
wantify-postgres
```

You should now be able to connect to the migrated PostgreSQL database with any SQL client software using the following information:

```
HOST: localhost
PORT: 5432
DATABASE: wantify_dev
USERNAME: postgres
PASSWORD:
```




