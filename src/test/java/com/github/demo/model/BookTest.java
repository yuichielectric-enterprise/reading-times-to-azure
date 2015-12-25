package com.github.demo.model;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * Test class for Book.
 */
public class BookTest {

    private Book book;

    @Test
    public void testGetAuthor() {
        String author = book.getAuthor();
        Assert.assertEquals("Kurt Vonnegut",author);
    }

    @Test
    public void testGetTitle() {
        String title = book.getTitle();
        Assert.assertEquals("Slapstick",title);
    }

    @Before
    public void setUp() throws Exception {
        book = new Book();
        book.setAuthor("Kurt Vonnegut");
        book.setTitle("Slapstick");
    }

    @After
    public void tearDown() {
        book = null;
    }
}
