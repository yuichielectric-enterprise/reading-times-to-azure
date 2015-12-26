# Demonstration guide
This is an example demo flow for code editing. In general you can follow the vanilla demo guide: explain the repository page, discuss issues and talk about Markdown.   
## Demonstration flow summary
The following flow creates a topic branch, makes changes to the [BookService.java](src/main/java/com/github/demo/service/BookService.java) class using any editor, writes the changes back to GitHub, open a pull requests, optionally fixes the failures detected by Travis and then merges the changes back to master to trigger a deployment to Heroku.
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
**Note:** you can also [edit files directly](https://help.github.com/articles/editing-files-in-your-repository/) on GitHub.

**Tip:** you can break the build by adding a sixth book as there is a unit test that checks if the list returned by `BookService.getBooks()` returns exactly 5 books:
```java
@Test
public void testGetBooks() {
    List<Book> books = bookService.getBooks();
    assertEquals("list length must be 5",5,books.size());
}
```
When the changed file is pushed to GitHub, create the pull request from the repository page by clicking **Compare & Pull Request**. Demonstrate code review and add some comments. Use for example @mentions and reference an issue with `closes`.

Travis will run the build and test and you can then merge the pull request and delete the branch.

In case you have initially broken the build, go to `BookService.java` remove a book from the list to make sure there are 5 books listed to pass the test and push the changes to the branch. For example:
```
git branch // check if you are on the update-book-list branch
git status
git add src/main/java/com/github/demo/service/BookService.java
git commit -m "removed a book from the list to pass the test"
git push origin HEAD
```
Visit the pull request to check if Travis CI passes all tests. Once the changes are merged back to `master` the application is deployed to Heroku.

To run the application you can run the following command in your terminal:
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
