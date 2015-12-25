# reading-time-app
The `reading-time-app` is a basic Java web application to demo a Java development stack using Java, Maven, IntelliJ, Travis and Heroku. The applicaiton simply lists a top 5 of favorite books. Travis is used for Continuous Integration (CI) and Heroku is used for deployments. The application is based on the Heroku tutorial [Create a Java Web Application Using Embedded Tomcat](https://devcenter.heroku.com/articles/create-a-java-web-application-using-embedded-tomcat). It run using an embedded Tomcat servlet container. The project is structured as a standard Java Maven application:

```
.
├── Procfile
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
    │       └── books.jsp
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

IntelliJ  is optional, you can use any editor including for example Atom.

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
To install and run the `reading-time-app` application locally execute the following commands:
```
git clone
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

## Demonstration flow summary
The basic flow can be as follows:
```
git checkout -b update-book-list
atom src/main/java/com/github/demo/service/BookService.java
git status
git add src/main/java/com/github/demo/service/BookService.java
git commit -m "updated the list of books"
git push origin HEAD
```
For example change the author or title of one of the books in [BookService.java](src/main/java/com/github/demo/service/BookService.java):
```java
static {
    books.add(new Book("Michael Chabon","Summerland"));
    books.add(new Book("Kurt Vonnegut","Slapstick"));
    books.add(new Book("Michel Faber","Under the Skin"));
    books.add(new Book("Julian Barnes","Flaubert's Parrot"));
    books.add(new Book("Henry David Thoreau","Walden"));
}
```
If you first want to break the build you can add another book as there is a unit test that checks if the list returned by `BookService.getBooks()` returns exactly 5 books:
```java
@Test
public void testGetBooks() {
    List<Book> books = bookService.getBooks();
    assertEquals("list length must be 5",5,books.size());
}
```
Next go to GitHub and create the pull request from the repository page by clicking **Compare & Pull Request** to kick-off the discussion. Travis will run the build and test and you can then merge the pull request and delete the branch. In case you have initially broken the build, go to `BookService.java` remove a book from the list to make sure there are 5 books listed to pass the test and push the changes to the branch:
```
git branch // check if you are on the update-book-list branch
git status
git add src/main/java/com/github/demo/service/BookService.java
git commit -m "removed a book from the list to pass the test"
git push origin HEAD
```
Visit the pull request to check if Travis CI passes all tests. Once the changes are merged back to `master` the application is deployed to Heroku. To run the application you can run the following command in your terminal:
```
heroku open
```
Make sure you run the command from the project directory. It might take a while before the changes are deployed and you might initially see the results of the previous successful deployment.

## Using IntelliJ
You can use IntelliJ as Java IDE, but it is optional. Editing files is no different from doing any other demo. It can be useful to show the Git and GitHub integration.

### Import project in IntelliJ
To use IntelliJ import the Java project:
- Choose File>New>Project from Existing Sources...
- Select the project on the file system and click OK
- Select `import project from external model`, select `maven` and click Next
- Follow the steps and accepts defaults and click Finish to import the project

### Creating a new branch
- Choose VCS>Git>Branches...
- Click the plus to create a new branch
- Provide a branch name for example `add-julian-barnes-book`
- Click OK

### To commit an push changes
- Choose VCS>Git>Commit File...
- Provide a commit message
- Click Commit to just commit or Commit and Push... to push the changes to GitHub
- Click OK to push the changes to GitHub

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
