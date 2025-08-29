
package trabajo.práctico.introduccion.a.java;

/**
 *
 * @author Leonel Gonzalez
 */
public class Ejercicio7 {
    public static void main(String[] args){
        /**
                Analiza el siguiente código y responde: ¿Cuáles son expresiones y cuáles son
                instrucciones? Explica la diferencia en un breve párrafo.
                int x = 10; // Línea 1
                x = x + 5; // Línea 2
                System.out.println(x); // Línea 3
        */
        
        
        int x = 10; // Es una INSTRUCCIÓN. Le dice al programa que declare una variable 'x' y le ASIGNE un valor.
        // El '10' por sí solo es una EXPRESIÓN, ya que produce el valor 10.

       
        x = x + 5; // Es una INSTRUCCIÓN de asignación. Le ordena al programa que guarde un nuevo valor en 'x'.
        // La parte 'x + 5' es una EXPRESIÓN, porque calcula el resultado de la suma, que es 15.

      
        System.out.println(x); // Es una INSTRUCCIÓN. Es una llamada completa a un método para imprimir algo.
        // La 'x' dentro de los paréntesis es una EXPRESIÓN, ya que se evalúa para obtener el valor actual de 'x' (que es 15) y se lo pasa al método.

    }
}
