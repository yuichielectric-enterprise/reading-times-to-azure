package com.github.demo.service;

import com.github.demo.model.Book;

import java.util.ArrayList;
import java.util.List;

public class BookService {

    private static List<Book> books = new ArrayList<Book>(5);

    static {
        books.add(new Book("Philip K. Dick","The Three Stigmata of Palmer Eldritch"));
        books.add(new Book("Kurt Vonnegut","Galápagos"));
        books.add(new Book("Michel Faber","The Book Of Strange New Things"));
        books.add(new Book("Julian Barnes","A History of the World in 10½ Chapters"));
        //books.add(new Book("Yuval Noah Harari", "Sapiens: A Brief History of Humankind"));
        books.add(new Book("Douglas Adams","The Hitchhiker's Guide to the Galaxy"));
    }

    public List<Book> getBooks() {
        return books;
    }

    public List<Book> getBooks(String query) {
        String queryString = query.toLowerCase();
        List<Book> results = new ArrayList<Book>();
        for(Book book : books){
            if((book.getAuthor() != null && book.getAuthor().toLowerCase().contains(queryString)) ||
                    (book.getTitle() != null && book.getTitle().toLowerCase().contains(queryString)))
                results.add(book);
        }
        return results;
    }
}
