import java.util.Scanner;

// Ejercicio 2: Conversión de cadena a número
public class ConversionNumero {
    
    public static void main(String[] args) {
        System.out.println("=== EJERCICIO 2: CONVERSIÓN DE CADENA A NÚMERO ===");
        ejecutarConversion();
    }
    
    public static void ejecutarConversion() {
        Scanner scanner = new Scanner(System.in);
        
        while (true) {
            try {
                System.out.print("Ingrese un texto para convertir a número (o 'salir' para terminar): ");
                String entrada = scanner.nextLine();
                
                if ("salir".equalsIgnoreCase(entrada.trim())) {
                    System.out.println("¡Hasta luego!");
                    break;
                }
                
                int numero = convertirAEntero(entrada);
                System.out.println("Conversión exitosa: " + numero);
                System.out.println("El número multiplicado por 2 es: " + (numero * 2));
                
            } catch (NumberFormatException e) {
                System.err.println("ERROR: '" + e.getMessage().split(":")[1].trim() + 
                                 "' no es un número válido.");
                System.out.println("Por favor, ingrese solo números enteros.");
            } catch (Exception e) {
                System.err.println("ERROR inesperado: " + e.getMessage());
            }
            
            System.out.println(); // Línea en blanco para separar intentos
        }
    }
    
    public static int convertirAEntero(String texto) throws NumberFormatException {
        try {
            return Integer.parseInt(texto.trim());
        } catch (NumberFormatException e) {
            throw new NumberFormatException("Formato inválido: " + texto);
        }
    }
}