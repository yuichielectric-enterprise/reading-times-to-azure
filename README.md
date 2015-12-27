# reading-time-app
## About
The `reading-time-app` is a basic Java web application to demo a Java development stack using Java, [Maven](https://maven.apache.org/) and optional [IntelliJ](https://www.jetbrains.com/idea/) as Java code editor. The application simply lists a top 5 of favorite books.

![](https://octodemo.com/github-enterprise-assets/0000/0133/0000/0025/c3eb7396-acb2-11e5-9e0a-61cc1f1deaf3.png)

It uses [Thymeleaf](http://www.thymeleaf.org/) as template engine. The application does not use [Spring](https://spring.io/). Spring is a Java application framework that is used for most Java applications, but for this demo it would make the code unnecessary complex.

The following integrations are included:
- [Travis CI](https://travis-ci.com/) is used for Continuous Integration (CI).
- A second bogus status check is added to demonstrate multiple status checks.
- When Travis CI passes all tests documentation is generated and published to the `gh-pages` branch.
- A Checkstyle project report on coding style conventions is included as an example report in the documentation.
- [Heroku](https://dashboard.heroku.com/) is used to deploy the application when the branch is merged back to master and Travis CI passes all tests.

The application is loosely based on the Heroku tutorial [Create a Java Web Application Using Embedded Tomcat](https://devcenter.heroku.com/articles/create-a-java-web-application-using-embedded-tomcat). It uses an embedded Tomcat servlet container. The project is structured as a standard Java Maven application:

```
.
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
This code might look a bit complex for what it does, but Java developers love patterns as much as Rails developers love [convention over configuration](https://en.wikipedia.org/wiki/Convention_over_configuration), so it follows the [Model-view-controller (MVC)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) pattern. The only class you need to edit in the demo is the [BookService.java](src/main/java/com/github/demo/service/BookService.java) class.
## Prerequisites
- Install [IntelliJ](https://www.jetbrains.com/idea/)
- Create a Heroku account
- Install [Heroku Toolbelt CLI](https://toolbelt.heroku.com/)
- Make sure you have Maven installed:
```
mvn -version
```

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
The Maven documentation is published to [GitHub Pages](https://octodemo.com/pages/office-tools/reading-time-app).

Maven `site` creates basic project documentation and generates a   [Checkstyle](https://github.com/checkstyle/checkstyle) project report on coding style conventions as an example report.

Other reports like [PMD](https://pmd.github.io/), [FindBugs](http://findbugs.sourceforge.net/) or [Maven JXR](http://maven.apache.org/jxr/) can be included in the Maven [pom.xml](pom.xml).

**Note:** it is not recommended to include Maven Javadoc as it takes several minutes to complete which is not very convenient during a live demo.

The `before_install` and `after_success` require a token that can be added to the `.travis.yml` configuration as follows:
```
gem install travis
export GITHUB_TOKEN=<TOKEN>
travis encrypt TOKEN=$GITHUB_TOKEN --add  -e https://travis.octodemo.com/api --debug
```

## Heroku configuration
The Heroku configuration is in [Procfile](Procfile). It specifies the process to run after a deployment:
```
web: sh target/bin/webapp
```
## Demonstration guide
There is a brief [Example Demonstration Guide](docs/example-demo-guide.md) in the docs directory.
