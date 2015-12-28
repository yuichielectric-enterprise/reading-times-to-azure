# Demonstration guide
This is an example demo flow for code editing. In general you can follow the vanilla demo guide: explain the repository page, discuss issues and talk about Markdown.   

## Basic Flow
Follow these steps for the basic demonstration flow.
### Show the deployed application
Visit the [Heroku App](https://reading-time-app.herokuapp.com/) to show the deployed application before any changes are made.

### Walk through GitHub Flow
The only thing you have to do is to change the [BookService.java](src/main/java/com/github/demo/service/BookService.java) class by editing directly on GitHub and open a pull request. For example change the author or title of one of the books in [BookService.java](src/main/java/com/github/demo/service/BookService.java):

```java
static {
    books.add(new Book("Michael Chabon","Summerland"));
    books.add(new Book("Kurt Vonnegut","Slapstick"));
    books.add(new Book("Michel Faber","Under the Skin"));
    books.add(new Book("Julian Barnes","Flaubert's Parrot"));
    books.add(new Book("Henry David Thoreau","Walden"));
}
```
**Tip:** you can easily locate the file by using the `t` keyboard command.

Once the pull request is opened, Travis CI runs.

**Note:** if Travis CI passes the tests successfully, completing the documentation update can take up to 1:30 minutes to update the `gh-pages` branch. When Travis CI fails, the documentation is not generated.

Compare changes, do some code review, add a couple of comments and then merge the changes back to the `master` branch.

When changes are merged back to the `master` branch, Heroku will deploy the new application. This might take a little while. Check the modified date in the footer to verify the deployment.

### Break the build
You can break the build by adding a sixth book to the [BookService.java](src/main/java/com/github/demo/service/BookService.java) class as there is a unit test that checks if the list returned by `BookService.getBooks()` returns exactly 5 books:

```java
@Test
public void testGetBooks() {
    List<Book> books = bookService.getBooks();
    assertEquals("list length must be 5",5,books.size());
}
```
Fix the broken build on the pull request branch by removing a book from the list so that there are again 5 books in the list.

### Show documentation
Visit the [GitHub Pages site](https://octodemo.com/pages/office-tools/reading-time-app) to show that documentation is updated automatically when Travis CI passes all tests.

### Show the deployed changes
Visit the [Heroku App](https://reading-time-app.herokuapp.com/) to show the deployed application after the changes are merged back to master. A modified date is added to the footer to allow you to check if you are looking at the latest deployment.

**Tip:** if you add the Heroku deployemnt url as repository website, you can easily visit the deployed application.

## Working with a local repository using Git
The following example creates a topic branch, makes changes to the [BookService.java](src/main/java/com/github/demo/service/BookService.java) class and writes the changes back to GitHub:
```
git checkout -b update-book-list
atom src/main/java/com/github/demo/service/BookService.java
git status
git add src/main/java/com/github/demo/service/BookService.java
git commit -m "updated the list of books"
git push origin HEAD
```
When the changed file is pushed to GitHub, create the pull request from the repository page by clicking **Compare & Pull Request**. Demonstrate code review and add some comments. Use for example @mentions and reference an issue with `closes`.

Travis will run the build and test and you can then merge the pull request and delete the branch.

In case you have initially broken the build, go to `BookService.java` remove a book from the list to make sure there are 5 books listed to pass the test and push the changes to the branch. For example:
```
git branch // check if you are on the right branch
git status
git add src/main/java/com/github/demo/service/BookService.java
git commit -m "removed a book from the list to pass the test"
git push origin HEAD
```
Visit the pull request to check if Travis CI passes all tests. Once the changes are merged back to `master` the application is deployed to Heroku.

To run the deployed application you can always run the following command in your terminal:
```
heroku open
```
Make sure you run the command from the project directory. It might take a little while before the changes are deployed. Check the modified date and time in the footer of the web application.

## Using IntelliJ
You can use IntelliJ Community Edition as Java IDE, but it is optional. Editing files is no different from doing any other demo. It can be useful to show the Git and GitHub integration.

### Import local project in IntelliJ
To use IntelliJ import a local Java project:
- Choose File>New>Project from Existing Sources...
- Select the project on the file system and click OK
- Select `import project from external model`, select `maven` and click Next
- Follow the steps and accepts defaults and click Finish to import the project

You can also import the project from GitHub using the [GitHub integration](https://www.jetbrains.com/idea/help/using-github-integration.html).

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
