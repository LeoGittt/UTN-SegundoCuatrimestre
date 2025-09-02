/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * 13. Impresión recursiva de arrays antes y después de modificar un elemento.
    Crea un programa que:
    a. Declare e inicialice un array con los precios de algunos productos.
    b. Use una función recursiva para mostrar los precios originales.
    c. Modifique el precio de un producto específico.
    d. Use otra función recursiva para mostrar los valores modificados.
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
public class Ejercicio13 {
    public static void imprimirArrayRecursivo(double[] arr, int index) {
        if (index >= arr.length) {
            return;
        }

        System.out.println("Precio: $" + arr[index]);

        imprimirArrayRecursivo(arr, index + 1);
    }

    public static void main(String[] args) {
        double[] precios = {199.99, 299.50, 149.75, 399.00, 89.99};

        System.out.println("Precios originales:");
        imprimirArrayRecursivo(precios, 0); // La recursión inicia en el índice 0

        precios[2] = 129.99;

        System.out.println("\nPrecios modificados:");
        imprimirArrayRecursivo(precios, 0);
    }
}
