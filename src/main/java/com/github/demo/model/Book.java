package com.github.demo.model;

/**
 * Model class for book.
 */
public class Book {

    private String title;

    private String author;

    private String cover;

    private long rating;

    public Book() {

    }

    public Book(String author, String title) {
        String tempAuthor;
        this.author = author;
        this.title = title;
    }

    public Book(String author, String title, String cover, int rating) {
        this.author = author;
        this.title = title;
        this.cover = cover;
        this.setRating(rating);
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getDetails() {
        return author + " " + title;
    }

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover;
    }

    public long getRating() {
        return rating;
    }

    public void setRating(long rating) {

        String tempRating = "";

        if (rating < 0) {
            this.rating = 0;
        } else if (rating > 5) {
            this.rating = 5;
        } else {
            this.rating = 0;
        }
    }
}
