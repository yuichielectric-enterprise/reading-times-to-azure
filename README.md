# reading-time-app
## About
The `reading-time-app` is a basic Java web application to demo a Java development stack using Java, [Maven](https://maven.apache.org/) and optional [IntelliJ](https://www.jetbrains.com/idea/) as Java code editor. The application simply lists a top 5 of favorite books. It uses [Thymeleaf](http://www.thymeleaf.org/) as template engine. The application does not use [Spring](https://spring.io/). Spring is a widely used Java application framework. [Travis CI](https://travis-ci.com/) is used for Continuous Integration (CI) and [Heroku](https://dashboard.heroku.com/) is used for deployments. A second bogus status check is added to demonstrate multiple status checks.

The application is loosely based on the Heroku tutorial [Create a Java Web Application Using Embedded Tomcat](https://devcenter.heroku.com/articles/create-a-java-web-application-using-embedded-tomcat). It uses an embedded Tomcat servlet container. The project is structured as a standard Java Maven application:

```
..
├── Procfile
├── README.md
├── bogus-status-check.sh
├── pom.xml
├── reading-time-app.iml
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
    │       └── books_en.properties
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
## Prerequisites
- Install [IntelliJ](https://www.jetbrains.com/idea/)
- Create a Heroku account
- Install [Heroku Toolbelt CLI](https://toolbelt.heroku.com/)
- Make sure you have Maven installed:
```
mvn -version
```

IntelliJ  is optional, you can use any editor like Eclipse, Atom or edit directly on GitHub.

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
Apart from [Junit](http://junit.org/), the following additional code analysis and reporting plug-ins are installed: [PMD](https://pmd.github.io/), [FindBugs](http://findbugs.sourceforge.net/), [Checkstyle](https://github.com/checkstyle/checkstyle) and [Maven JXR](http://maven.apache.org/jxr/).

## Travis CI configuration
The  minimal Travis CI configuration is a `.travis.yml` with the following content:
```
language: java
```
It will execute a standard maven install and test:
```
mvn install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
mvn test -B
```

The Travis CI configuration included also contains a second status check to show multiple status checks by executing [bogus-status-check.sh](bogus-status-check.sh). It is executed before the Maven install and test.
```
before_install:
  - ./bogus-status-check.sh
```
When install and test are successful documentation is generated to the `gh-pages` branch:
```
after_success:
  - mvn clean site
```
The Maven documentation is published to [GitHub Pages](https://octodemo.com/pages/office-tools/reading-time-app)

The `before_install` and `after_success` require a token that can be added to the `.travis.yml` configuration as follows:
```
gem install travis
export GITHUB_TOKEN=<TOKEN>
travis encrypt TOKEN=$GITHUB_TOKEN --add  -e https://travis.octodemo.com/api --debug
```

There is a brief [Example Demonstration Guide](docs/example-demo-guide.md) in the docs directory.
