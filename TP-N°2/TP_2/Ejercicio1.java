/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * 1. Verificación de Año Bisiesto.
    Escribe un programa en Java que solicite al usuario un año y determine si es
    bisiesto. Un año es bisiesto si es divisible por 4, pero no por 100, salvo que sea
    divisible por 400.
    Ejemplo de entrada/salida:
    Ingrese un año: 2024
    El año 2024 es bisiesto.
    Ingrese un año: 1900
    El año 1900 no es bisiesto.
 */
import java.util.Scanner;
public class Ejercicio1 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Ingrese un año: ");
        int año = scanner.nextInt();

        boolean esBisiesto = false;

        if (año % 4 == 0) {
            if (año % 100 != 0) {
                esBisiesto = true;
            } else {
                if (año % 400 == 0) {
                    esBisiesto = true;
                }
            }
        }

        if (esBisiesto) {
            System.out.println("El año " + año + " es bisiesto.");
        } else {
            System.out.println("El año " + año + " no es bisiesto.");
        }

        scanner.close();
    }
}