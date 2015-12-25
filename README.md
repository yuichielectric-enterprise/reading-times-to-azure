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
This configuraiton assumes you are using `octodemo.com`.
- Fork and clone the GitHub repository.
- Create the Heroku app, execute an initial deploy and open the web application:
```
heroku create
git push heroku master
heroku open
```
- Created a token for deployment integration:
```
heroku plugins:install https://github.com/heroku/heroku-oauth
heroku authorizations:create --description "For use with octodemo.com"
```
- Add Travis CI service hook for end-point `https://travis.octodemo.com/listener`
- Add GitHub Auto-Deployment Service Hook for end-point `https://octodemo.com/api/v3` with GitHub token scope `repo`
- Add HerokuBeta Service Hook for end-point `https://octodemo.com/api/v3` with GitHub token scope `repo-deployment`

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
The basic happy flow can be as follows:
```
git checkout -b update-book-list
atom src/main/java/com/github/demo/service/BookService.java
git status
git add src/main/java/com/github/demo/service/BookService.java
git commit -m "updated the list of books"
git push origin HEAD
```
For example change the author or title of one of the books:
```java
static {
    books.add(new Book("Michael Chabon","Summerland"));
    books.add(new Book("Kurt Vonnegut","Slapstick"));
    books.add(new Book("Michel Faber","Under the Skin"));
    books.add(new Book("Julian Barnes","Flauberts Parrot"));
    books.add(new Book("Henry David Thoreau","Walden"));
}
```
If you first want to break the build you can add another book as there is a unit test that checks if the list returned by `getBooks()` returns exactly 5 books:
```java
@Test
public void testGetBooks() {
    List<Book> books = bookService.getBooks();
    assertEquals("list length must be 5",5,books.size());
}
```
Next go to GitHub and create the pull request to kick-off the discussion. Travis will run the build and test and you can then merge the pull request and delete the branch. Once the changes are merged back to `master` the application is deployed to Heroku. To run the application you can run the following command in your terminal:
```
heroku open

```
Make sure you run the command from the project directory.
