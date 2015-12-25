package com.github.demo.service;

import com.github.demo.model.Book;

import java.util.ArrayList;
import java.util.List;

public class BookService {

    private static List<Book> books = new ArrayList<Book>(5);;

    static {
        books.add(new Book("Michael Chabon","Summerland"));
        books.add(new Book("Kurt Vonnegut","Slapstick"));
        books.add(new Book("Michel Faber","Under the Skin"));
        books.add(new Book("Julian Barnes","Flauberts Parrot"));
        books.add(new Book("Henry David Thoreau","Walden"));
    }

    public List<Book> getBooks() {
        return books;
    }
}
