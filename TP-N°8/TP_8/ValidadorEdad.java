import java.util.Scanner;

// Ejercicio 4: Excepción personalizada para validar edad
public class ValidadorEdad {
    
    public static void main(String[] args) {
        System.out.println("=== EJERCICIO 4: VALIDADOR DE EDAD ===");
        ejecutarValidacionEdad();
    }
    
    public static void ejecutarValidacionEdad() {
        Scanner scanner = new Scanner(System.in);
        
        while (true) {
            try {
                System.out.print("Ingrese una edad (o -999 para salir): ");
                int edad = scanner.nextInt();
                
                if (edad == -999) {
                    System.out.println("¡Hasta luego!");
                    break;
                }
                
                validarEdad(edad);
                System.out.println("✓ Edad válida: " + edad + " años");
                
                // Mostrar categoría de edad
                mostrarCategoriaEdad(edad);
                
            } catch (EdadInvalidaException e) {
                System.err.println("ERROR: " + e.getMessage());
                System.out.println("Detalle: " + e.getDetalleError());
                System.out.println("Edad ingresada: " + e.getEdadIngresada());
            } catch (Exception e) {
                System.err.println("ERROR inesperado: " + e.getMessage());
                scanner.nextLine(); // Limpiar buffer
            }
            
            System.out.println(); // Línea en blanco para separar intentos
        }
    }
    
    public static void validarEdad(int edad) throws EdadInvalidaException {
        if (edad < 0) {
            throw new EdadInvalidaException(edad, 
                "La edad no puede ser negativa: " + edad);
        }
        
        if (edad > 120) {
            throw new EdadInvalidaException(edad, 
                "La edad no puede ser mayor a 120 años: " + edad);
        }
        
        // Si llegamos aquí, la edad es válida
    }
    
    public static void mostrarCategoriaEdad(int edad) {
        String categoria;
        
        if (edad >= 0 && edad <= 2) {
            categoria = "Bebé";
        } else if (edad <= 12) {
            categoria = "Niño/a";
        } else if (edad <= 17) {
            categoria = "Adolescente";
        } else if (edad <= 64) {
            categoria = "Adulto/a";
        } else {
            categoria = "Adulto/a Mayor";
        }
        
        System.out.println("Categoría: " + categoria);
    }
}