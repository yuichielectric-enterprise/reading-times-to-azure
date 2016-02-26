# reading-time-app
[![Build Status](https://travis.octodemo.com/office-tools/reading-time-app.svg?token=4BJC1aYF8GpY15tJT53f&branch=master)](https://travis.octodemo.com/office-tools/reading-time-app)
## About
The [reading-time-app](https://reading-time-app.herokuapp.com/) is a demo web application using Java and [Maven](https://maven.apache.org/). It lists a top 5 of staff recommended books. The repository allows you to demonstrate GitHub with the following integrations:

- It can be used with any editor including Java editors like [IntelliJ](https://www.jetbrains.com/idea/) or [Eclipse](https://eclipse.org/), [Atom](https://atom.io/) or editing directly using GitHub.
- Demonstrate GitHub Flow by editing the [BookService.java](src/main/java/com/github/demo/service/BookService.java) class.
- [Travis CI](https://travis-ci.com/) is used for Continuous Integration (CI).
- A second bogus status check is added to demonstrate multiple status checks.
- When Travis CI passes all tests [documentation](https://octodemo.com/pages/office-tools/reading-time-app/) is generated and published to the `gh-pages` branch.
- A [Checkstyle](https://octodemo.com/pages/office-tools/reading-time-app/checkstyle.html) project report on coding style conventions is included as an example report in the documentation.
- [Heroku](https://dashboard.heroku.com/) is used to deploy the application when the branch is merged back to master and Travis CI passes all tests.

The application is loosely based on the Heroku tutorial [Create a Java Web Application Using Embedded Tomcat](https://devcenter.heroku.com/articles/create-a-java-web-application-using-embedded-tomcat). It uses an embedded Tomcat servlet container. The project is structured as a standard Java Maven application:

```
'.
├── CONTRIBUTING.md
├── Procfile
├── README.md
├── pom.xml
├── reading-time-app.iml
├── scripts
│   ├── deploy-cli.sh
│   ├── deploy.sh
│   └── status-checks.sh
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── github
    │   │           └── demo
    │   │               ├── launch
    │   │               │   └── Main.java
    │   │               ├── model
    │   │               │   └── Book.java
    │   │               ├── service
    │   │               │   └── BookService.java
    │   │               └── servlet
    │   │                   └── BookServlet.java
    │   └── webapp
    │       ├── books.html
    │       ├── books_de.properties
    │       ├── books_en.properties
    │       ├── books_fr.properties
    │       └── books_nl.properties
    └── test
        └── java
            └── com
                └── github
                    └── demo
                        ├── model
                        │   └── BookTest.java
                        └── service
                            └── BookServiceTest.java

```
This code might look a bit complex for what it does, but Java developers love patterns as much as Rails developers love convention over configuration, so it follows the [Model-view-controller (MVC)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) pattern. But no worries! The only class you need to edit in the demo is the [BookService.java](src/main/java/com/github/demo/service/BookService.java) class. :smile:

## Prerequisites
- Install [IntelliJ](https://www.jetbrains.com/idea/) (optional)
- Create a Heroku account
- Install [Heroku Toolbelt CLI](https://toolbelt.heroku.com/)
- Make sure you have Maven installed:
```
mvn -version
```

Java and Maven 3 should be installed by default on Mac OSX.

Using IntelliJ is optional, you can use any editor like Eclipse or Atom or edit directly on GitHub.

## Configuration
This configuration assumes you are using `octodemo.com`.
- Fork and clone the  `reading-time-app` repository.
- Create the Heroku app, execute an initial deploy and open the web application:
```
heroku create
git push heroku master
heroku open
```
- Remember the name of the application. You can also provide one using:
```
heroku create reading-time-app
```
- Create a token for deployment integration:
```
heroku plugins:install https://github.com/heroku/heroku-oauth
heroku authorizations:create --description "For use with octodemo.com"
```
- Add *Travis CI* service hook for end-point `https://travis.octodemo.com/listener`
- Add *GitHub Auto-Deployment* hook for end-point `https://octodemo.com/api/v3` with GitHub token scope `repo` with `continuous-integration/travis-ci` as status context
- Add *HerokuBeta* service hook for end-point `https://octodemo.com/api/v3` with GitHub token scope `repo-deployment`, the created Heroku token and the name of the Heroku application

The deployments integration follows the steps described in [Automating deployments to integrators](https://developer.github.com/guides/automating-deployments-to-integrators/).

## Installing and running on a local machine
To install and run the `reading-time-app` application on your local machine execute the following commands:
```
mvn clean install
sh target/bin/webapp
open http://localhost:8080
```
To skip the tests:
```
mvn -B -DskipTests=true clean install
```
To run the unit tests execute the following command:
```
mvn clean test
```
To create and view the `reading-time-app` reports:
```
mvn site
open target/site/index.html
```

## Travis CI configuration
The minimal Travis CI configuration for Java is a [.travis.yml](.travis.yml) file with the following content:
```
language: java
```
It will execute a standard maven install and test:
```
mvn install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
mvn test -B
```

The Travis CI configuration included also contains a second status check to show multiple status checks by executing `status-checks.sh verify`. It is executed before the Maven install and test and runs a simple checkstyle configuration that checks is a method name starts with a lower case letter. If this is not the case the check fails. You can break the build by changing the name of the method `getDetails()` in class `Book`.

```
before_install:
  - ./scripts/status-checks.sh verify
```
When install and test are successful documentation is generated to the `gh-pages` branch. Another status check is created. Finally a deployment is executed for the branch. It will deploy the changes to the default Heroku app that is also used in production.

```
after_success:
  - ./scripts/status-checks.sh site
  - ./scripts/deploy.sh
```
The Maven documentation is published to a [GitHub Pages site](https://octodemo.com/pages/office-tools/reading-time-app).

Maven `site` creates basic project documentation and generates a   [Checkstyle](https://github.com/checkstyle/checkstyle) project report on coding style conventions as an example report. It generates plenty of errors as the code does not follow the Sun coding guidelines at all.

Other reports like [PMD](https://pmd.github.io/), [FindBugs](http://findbugs.sourceforge.net/) or [Maven JXR](http://maven.apache.org/jxr/) can be included in the Maven [pom.xml](pom.xml).

**Note:** it is not recommended to include Maven Javadoc as it takes several minutes to write about 300 blobs to the `gh-pages` branch which is not very convenient during a live demo.

The `before_install` and `after_success` steps require a token that can be added to the `.travis.yml` configuration as follows:
```
gem install travis
export GITHUB_TOKEN=<TOKEN>
travis encrypt TOKEN=$GITHUB_TOKEN --add  -e https://travis.octodemo.com/api --debug
```
Travis is configured to cache the Maven repository to speed up builds:
```
cache:
  directories:
    - $HOME/.m2
```

## Heroku configuration
The Heroku configuration is in [Procfile](Procfile). It specifies the process to run after a deployment:
```
web: sh target/bin/webapp
```

## Contributing
Read [How to contribute](CONTRIBUTING.md) how to contribute to the `reading-time-app`.
