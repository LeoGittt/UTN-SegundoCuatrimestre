/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * 4. Calculadora de Descuento según categoría.
    Escribe un programa que solicite al usuario el precio de un producto y
    su categoría (A, B o C).
    Luego, aplique los siguientes descuentos:
    Categoría A: 10% de descuento
    Categoría B: 15% de descuento
    Categoría C: 20% de descuento
    El programa debe mostrar el precio original, el descuento aplicado y el
    precio final
    Ejemplo de entrada/salida:
    Ingrese el precio del producto: 1000
    Ingrese la categoría del producto (A, B o C): B
    Descuento aplicado: 15%
    Precio final: 850.0

 */
import java.util.Scanner;
public class Ejercicio4 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Ingrese el precio del producto: ");
        double precioOriginal = scanner.nextDouble();

        System.out.print("Ingrese la categoría del producto (A, B o C): ");
        char categoria = scanner.next().toUpperCase().charAt(0); // Leer la primera letra y convertirla a mayúscula

        double descuento = 0.0;
        double porcentajeDescuento = 0.0;

        if (categoria == 'A') {
            porcentajeDescuento = 10;
        } else if (categoria == 'B') {
            porcentajeDescuento = 15;
        } else if (categoria == 'C') {
            porcentajeDescuento = 20;
        } else {
            System.out.println("Categoría no válida. No se aplicará descuento.");
        }

        descuento = precioOriginal * (porcentajeDescuento / 100);
        double precioFinal = precioOriginal - descuento;

        System.out.println("Precio original: " + precioOriginal);
        System.out.println("Descuento aplicado: " + porcentajeDescuento + "%");
        System.out.println("Precio final: " + precioFinal);

        scanner.close();
    }
}
