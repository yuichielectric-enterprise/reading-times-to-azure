package com.github.demo.servlet;

import com.github.demo.service.BookService;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.WebContext;
import org.thymeleaf.templateresolver.ServletContextTemplateResolver;

import javax.servlet.ServletConfig;
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

    ServletContextTemplateResolver resolver = new ServletContextTemplateResolver();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        resolver.setPrefix("/");
        resolver.setSuffix(".html");
        resolver.setCacheable(true);
        resolver.setCacheTTLMs(60000L);
    }

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

        TemplateEngine engine = new TemplateEngine();
        engine.setTemplateResolver(resolver);

        WebContext ctx =
                new WebContext(req, resp, getServletContext(), req.getLocale());
        ctx.setVariable("books", books);
        engine.process("books", ctx, resp.getWriter());
    }

}
