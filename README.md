# reading-time-app
The [reading-time-app](https://reading-time-app.herokuapp.com/) is a demo web application using Java and [Maven](https://maven.apache.org/). It lists staff recommended books. The repository allows you to demonstrate GitHub with the following features:

- Demonstrate GitHub Flow by implementing a real feature with the ability to break the build due to lack of coverage and to fix it by adding unit tests.
- As an alternative demonstrate GitHub Flow by making a simple change like changing the background color of the footer or updating the book list.
- Show the value of running continuous integration with multiple status checks.
- Automatically deploy code changes when code is merged to master.
- Optionally show branch based deployments.
- Optionally show protected branches with required status checks.
- Use any editor including Java editors like [IntelliJ](https://www.jetbrains.com/idea/) or [Eclipse](https://eclipse.org/), [Atom](https://atom.io/) or editing directly using GitHub.

The demo uses the following integrations:
- [Travis CI](https://travis-ci.com/) is used for Continuous Integration (CI) with additional statuses:
  - A status check is added for the Maven verify phase including a code style check that just checks method names.
  - A status check is added for the Maven test phase.
  - A status check is added for a code coverage check.
- [Heroku](https://www.heroku.com/) is used to deploy the application when the branch is merged back to master and Travis CI passes all tests.

The application is loosely based on the Heroku tutorial [Create a Java Web Application Using Embedded Tomcat](https://devcenter.heroku.com/articles/create-a-java-web-application-using-embedded-tomcat). It uses an embedded Tomcat servlet container. The project is structured as a standard Java Maven application.

### Documentation
Documentation is in the [solutions engineering repo](https://github.com/github/solutions-engineering/blob/master/guides/demo/custom-scripts/travis-heroku-java-demo.md).
