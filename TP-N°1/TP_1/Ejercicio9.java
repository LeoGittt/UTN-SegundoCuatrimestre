/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package trabajo.práctico.introduccion.a.java;

/**
 *
 * @author Leonel Gonzalez
 */
import java.util.Scanner;
public class Ejercicio9 {
    public static void main(String[] args){
        Scanner scanner = new Scanner(System.in);
        System.out.print("Ingresa tu nombre: ");
        String nombre = scanner.nextInt(); 
        String nombreCorregido = scanner.nextLine();
        System.out.println("Hola, " + nombre);
        System.out.println("Hola, " + nombreCorregido);
        
        
        /**
        *
        * el error es que se ua la funcion para mostrar un entero y no un string, se deberia usar la funcion next.Line()
        */
        
    }
}
