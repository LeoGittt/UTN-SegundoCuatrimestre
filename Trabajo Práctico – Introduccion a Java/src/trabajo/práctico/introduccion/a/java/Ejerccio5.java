package trabajo.práctico.introduccion.a.java;

/**
 *
 * @author Leonel Gonzalez
 */
import java.util.Scanner;
public class Ejerccio5 {
    public static void main (String[] args){
        Scanner entrada = new Scanner(System.in);
        System.out.println("Ingrese dos numeros enteros");
        int num1 = entrada.nextInt();
        int num2 = entrada.nextInt();
        System.out.println("la suma de los dos numeros es " + (num1 + num2));
        System.out.println("la resta de los dos numeros es " + (num1 - num2));
        System.out.println("la multiplicacion de los dos numeros es " + (num1 * num2));
        System.out.println("la division de los dos numeros es " + (num1 - num2));
        
    }
}
