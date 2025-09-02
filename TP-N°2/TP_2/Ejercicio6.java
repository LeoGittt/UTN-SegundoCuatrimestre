/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * 6. Contador de Positivos, Negativos y Ceros (for).
    Escribe un programa que pida al usuario ingresar 10 números enteros y
    cuente cuántos son positivos, negativos y cuántos son ceros.
    Ejemplo de entrada/salida:
    Ingrese el número 1: -5
    Ingrese el número 2: 3
    Ingrese el número 3: 0
    Ingrese el número 4: -1
    Ingrese el número 5: 6
    Ingrese el número 6: 0
    Ingrese el número 7: 9
    Ingrese el número 8: -3
    Ingrese el número 9: 4
    Ingrese el número 10: -8
    Resultados:
    Positivos: 4
    Negativos: 4
    Ceros: 2
 */
import java.util.Scanner;
public class Ejercicio6 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int positivos = 0;
        int negativos = 0;
        int ceros = 0;

        for (int i = 1; i <= 10; i++) {
            System.out.print("Ingrese el número " + i + ": ");
            int numero = scanner.nextInt();

            if (numero > 0) {
                positivos++;
            } else if (numero < 0) {
                negativos++;
            } else {
                ceros++;
            }
        }

        System.out.println("\nResultados:");
        System.out.println("Positivos: " + positivos);
        System.out.println("Negativos: " + negativos);
        System.out.println("Ceros: " + ceros);

        scanner.close();
    }
}
