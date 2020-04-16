package com.github.demo.servlet;

import com.github.demo.service.BookService;

import org.apache.http.HttpStatus;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.WebContext;
import org.thymeleaf.templateresolver.ServletContextTemplateResolver;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;

@WebServlet(name = "BookServlet", urlPatterns = { "" })
@WebInitParam(name = "allowedTypes", value = "html")
public class BookServlet extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        StringBuilder sb = new StringBuilder(String.format("ページが見つかりません %s", req.getRequestURI()));
        sb.append("インデックスページに戻る");
        this.notFound(resp, sb.toString());
    }

    prinvate void notFound(HttpServletResponse resp, String errorMessage) {
        resp.sendError(HttpStatus.SC_NOT_FOUND, errorMessage);
    }

}
