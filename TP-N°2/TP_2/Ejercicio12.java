/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * Arrays y Recursividad:
    12. Modificación de un array de precios y visualización de resultados.
    Crea un programa que:
    a. Declare e inicialice un array con los precios de algunos productos.
    b. Muestre los valores originales de los precios.
    c. Modifique el precio de un producto específico.
    d. Muestre los valores modificados.
    Salida esperada:
    Precios originales:
    Precio: $199.99
    Precio: $299.5
    Precio: $149.75
    Precio: $399.0
    Precio: $89.99
    Precios modificados:
    Precio: $199.99
    Precio: $299.5
    Precio: $129.99
    Precio: $399.0
    Precio: $89.99

 */
public class Ejercicio12 {
    public static void main(String[] args) {
        double[] precios = {199.99, 299.50, 149.75, 399.00, 89.99};

        System.out.println("Precios originales:");
        mostrarPrecios(precios);

        precios[2] = 129.99;

        System.out.println("\nPrecios modificados:");
        mostrarPrecios(precios);
    }

    public static void mostrarPrecios(double[] arrayPrecios) {
        for (double precio : arrayPrecios) {
            System.out.println("Precio: $" + precio);
        }
    }
}
