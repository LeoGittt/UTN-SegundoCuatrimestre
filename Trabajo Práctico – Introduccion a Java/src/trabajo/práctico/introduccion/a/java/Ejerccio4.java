
package trabajo.práctico.introduccion.a.java;

/**
 *
 * @author Leonel Gonzalez 
 
*/

import java.util.Scanner;
public class Ejerccio4 {
    public static void main(String[] args) {
       
        Scanner entrada = new Scanner(System.in);
        
        System.out.println("Por favor, ingrese su nombre:");
        String nombre = entrada.nextLine();

       
        System.out.println("Por favor, ingrese su edad:");
        int edad = entrada.nextInt();

       
        System.out.println("Hola, " + nombre + ". Tienes " + edad + " años.");

      
        entrada.close();
    }
    }

