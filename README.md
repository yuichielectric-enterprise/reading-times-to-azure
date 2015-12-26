# reading-time-app
The `reading-time-app` is a basic Java web application to demo a Java development stack using Java, Maven and optional IntelliJ. The application simply lists a top 5 of favorite books. Travis is used for Continuous Integration (CI) and Heroku is used for deployments. A second bogus status check is added to demonstrate multiple status checks. The application is based on the Heroku tutorial [Create a Java Web Application Using Embedded Tomcat](https://devcenter.heroku.com/articles/create-a-java-web-application-using-embedded-tomcat). It uses an embedded Tomcat servlet container. The project is structured as a standard Java Maven application:

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

IntelliJ  is optional, you can use any editor like Eclipse, Atom or the GitHub online editor.

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

For the deployments integration I simply followed the steps described in [Automating deployments to integrators](https://developer.github.com/guides/automating-deployments-to-integrators/).

## Installing and running
To install and run the `reading-time-app` application fork and clone the application and execute the following commands:
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

## Travis configuration
The  minimal Travis configuration is a `.travis.yml` with the following content:
```
language: java
```
It will execute the standard maven build and test. The Travis configuration included also contains a second status check to show multiple status checks. It is executed before the build and test.
```
before_install:
  - ./bogus-status-check.sh
```
This script requires a token that can be added as follows:
```
gem install travis
export GITHUB_TOKEN=<TOKEN>
travis encrypt TOKEN=$GITHUB_TOKEN --add  -e https://travis.octodemo.com/api --debug
```
As the script currently runs as user `bas` you also have to update the script `bogus-status-check.sh`.

There is a brief [Example Demonstration Guide](docs/example-demo-guide.md) in the docs directory.
