package com.example;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class CalculatorTest {

    @Test
    public void testAdd() {
        Calculator calc = new Calculator();
        Assertions.assertEquals(5, calc.add(2, 3));
    }

    @Test
    public void testSubtract() {
        Calculator calc = new Calculator();
        Assertions.assertEquals(1, calc.subtract(3, 2));
    }

    @Test
    public void testMultiply() {
        Calculator calc = new Calculator();
        Assertions.assertEquals(6, calc.multiply(2, 3));
    }

    @Test
    public void testDivideByZero() {
        Calculator calc = new Calculator();
        Exception exception = Assertions.assertThrows(IllegalArgumentException.class, () -> {
            calc.divide(5, 0);
        });
        Assertions.assertEquals("Division by zero is not allowed", exception.getMessage());
    }


}
