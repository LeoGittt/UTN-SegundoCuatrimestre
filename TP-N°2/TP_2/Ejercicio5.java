/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * Estructuras de Repetición:
    5. Suma de Números Pares (while).
    Escribe un programa que solicite números al usuario y sume solo los
    números pares. El ciclo debe continuar hasta que el usuario ingrese el número
    0, momento en el que se debe mostrar la suma total de los pares ingresados.
    Ejemplo de entrada/salida:
    Ingrese un número (0 para terminar): 4
    Ingrese un número (0 para terminar): 7
    Ingrese un número (0 para terminar): 2
    Ingrese un número (0 para terminar): 0
    La suma de los números pares es: 6
 */
import java.util.Scanner;
public class Ejercicio5 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int numero;
        int sumaPares = 0;

        System.out.println("Suma de números pares. Ingrese 0 para terminar.");

        do {
            System.out.print("Ingrese un número: ");
            numero = scanner.nextInt();

            if (numero != 0 && numero % 2 == 0) {
                sumaPares += numero; 
            }
        } while (numero != 0);

        System.out.println("La suma de los números pares es: " + sumaPares);
        scanner.close();
    }
}
