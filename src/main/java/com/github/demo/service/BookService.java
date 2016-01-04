package com.github.demo.service;

import com.github.demo.model.Book;

import java.util.ArrayList;
import java.util.List;

public class BookService {

    private static List<Book> books = new ArrayList<Book>(5);;

    static {
        books.add(new Book("Philip K. Dick","The Three Stigmata of Palmer Eldritch"));
        books.add(new Book("Kurt Vonnegut","Galápagos"));
        books.add(new Book("Michel Faber","The Book Of Strange New Things"));
        books.add(new Book("Julian Barnes","A History of the World in 10½ Chapters"));
        books.add(new Book("Yuval Noah Harari", "Sapiens: A Brief History of Humankind etc.."));
    }

    public List<Book> getBooks() {
        return books;
    }
}
