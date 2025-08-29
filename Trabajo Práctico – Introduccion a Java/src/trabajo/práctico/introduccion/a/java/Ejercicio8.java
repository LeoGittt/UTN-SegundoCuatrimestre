
package trabajo.práctico.introduccion.a.java;

/**
 *
 * @author Leonel Gonzalez
 */

import java.util.Scanner;
public class Ejercicio8 {
    public static void main(String[] args){
        Scanner scanner = new Scanner(System.in);

        System.out.println("Ingrese el primer número entero:");
        int numero1 = scanner.nextInt();

        System.out.println("Ingrese el segundo número entero:");
        int numero2 = scanner.nextInt();

        
        int resultado = numero1 / numero2;

        System.out.println("El resultado de la división entera es: " + resultado);

        scanner.close();
    }
}
