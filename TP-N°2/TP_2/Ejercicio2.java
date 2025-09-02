/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * 2. Determinar el Mayor de Tres Números.
    Escribe un programa en Java que pida al usuario tres números enteros y
    determine cuál es el mayor.
    Ejemplo de entrada/salida:
    Ingrese el primer número: 8
    Ingrese el segundo número: 12
    Ingrese el tercer número: 5
    El mayor es: 12

 */
import java.util.Scanner;
public class Ejercicio2 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Ingrese el primer número: ");
        int numero1 = scanner.nextInt();

        System.out.print("Ingrese el segundo número: ");
        int numero2 = scanner.nextInt();

        System.out.print("Ingrese el tercer número: ");
        int numero3 = scanner.nextInt();

        int mayor = numero1; 

        if (numero2 > mayor) {
            mayor = numero2;
        }

        if (numero3 > mayor) {
            mayor = numero3;
        }

        System.out.println("El mayor es: " + mayor);

        scanner.close();
    }
}
