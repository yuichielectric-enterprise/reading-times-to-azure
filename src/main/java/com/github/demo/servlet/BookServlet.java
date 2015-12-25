package com.github.demo.servlet;

import com.github.demo.service.BookService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(
        name = "BookServlet",
        urlPatterns = {"/"}
)
public class BookServlet extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        BookService service = new BookService();
        List books = service.getBooks();
        req.setAttribute("books", books);
        req.setAttribute("msg", "These are my 5 favorite books:");

        resp.setContentType("text/html");
        req.getRequestDispatcher("books.jsp").forward(req, resp);
    }

}
