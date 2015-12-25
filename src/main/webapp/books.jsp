<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <body>
    <h2>Welcome to my reading list of ${books.size()} books</h2>
    <p>${msg}</p>
    <c:forEach var="book" items="${books}" varStatus="status">
        <p>${status.count}. ${book.title} by ${book.author}<p>
    </c:forEach>
    </body>
</html>
