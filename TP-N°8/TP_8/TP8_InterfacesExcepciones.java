import java.util.Scanner;

// Trabajo Práctico 8: Interfaces y Excepciones - Archivo Integrador
// Este archivo ejecuta todos los ejercicios del TP8
// Todas las clases están definidas en sus archivos separados siguiendo buenas prácticas de Java

public class TP8_InterfacesExcepciones {
    
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("===============================================");
        System.out.println("  TRABAJO PRÁCTICO 8: INTERFACES Y EXCEPCIONES");
        System.out.println("===============================================");
        
        while (true) {
            mostrarMenu();
            System.out.print("\nIngrese su opción: ");
            
            try {
                int opcion = scanner.nextInt();
                scanner.nextLine(); // Consumir el salto de línea
                
                switch (opcion) {
                    case 1:
                        ejecutarSistemaEcommerce();
                        break;
                    case 2:
                        ejecutarDivisionSegura();
                        break;
                    case 3:
                        ejecutarConversionNumero();
                        break;
                    case 4:
                        ejecutarLecturaArchivo();
                        break;
                    case 5:
                        ejecutarValidadorEdad();
                        break;
                    case 6:
                        ejecutarTryWithResources();
                        break;
                    case 7:
                        ejecutarTodosLosEjercicios();
                        break;
                    case 8:
                        mostrarConceptosImplementados();
                        break;
                    case 0:
                        System.out.println("¡Gracias por usar el programa!");
                        scanner.close();
                        return;
                    default:
                        System.out.println("❌ Opción no válida. Intente nuevamente.");
                }
                
            } catch (Exception e) {
                System.out.println("❌ Error: Ingrese un número válido.");
                scanner.nextLine(); // Limpiar buffer
            }
            
            esperarContinuar(scanner);
        }
    }
    
    private static void mostrarMenu() {
        System.out.println("\n" + "=".repeat(50));
        System.out.println("SELECCIONE EL EJERCICIO A EJECUTAR:");
        System.out.println("=".repeat(50));
        System.out.println("PARTE 1: INTERFACES");
        System.out.println("  1. Sistema de E-commerce completo");
        System.out.println();
        System.out.println("PARTE 2: EXCEPCIONES");
        System.out.println("  2. División segura (ArithmeticException)");
        System.out.println("  3. Conversión de número (NumberFormatException)");
        System.out.println("  4. Lectura de archivo (FileNotFoundException)");
        System.out.println("  5. Validador de edad (Excepción personalizada)");
        System.out.println("  6. Try-with-resources (IOException)");
        System.out.println();
        System.out.println("OPCIONES ADICIONALES");
        System.out.println("  7. Ejecutar todos los ejercicios");
        System.out.println("  8. Mostrar conceptos implementados");
        System.out.println("  0. Salir");
        System.out.println("=".repeat(50));
    }
    
    private static void ejecutarSistemaEcommerce() {
        System.out.println("\n🛒 EJECUTANDO: Sistema de E-commerce con Interfaces");
        System.out.println("=".repeat(60));
        EjercicioEcommerce.ejecutarSistemaEcommerce();
    }
    
    private static void ejecutarDivisionSegura() {
        System.out.println("\n➗ EJECUTANDO: División Segura");
        System.out.println("=".repeat(40));
        DivisionSegura.ejecutarDivisionSegura();
    }
    
    private static void ejecutarConversionNumero() {
        System.out.println("\n🔢 EJECUTANDO: Conversión de Número");
        System.out.println("=".repeat(40));
        ConversionNumero.ejecutarConversion();
    }
    
    private static void ejecutarLecturaArchivo() {
        System.out.println("\n📄 EJECUTANDO: Lectura de Archivo (tradicional)");
        System.out.println("=".repeat(50));
        LecturaArchivo.ejecutarLecturaArchivo();
    }
    
    private static void ejecutarValidadorEdad() {
        System.out.println("\n🎂 EJECUTANDO: Validador de Edad");
        System.out.println("=".repeat(40));
        ValidadorEdad.ejecutarValidacionEdad();
    }
    
    private static void ejecutarTryWithResources() {
        System.out.println("\n📂 EJECUTANDO: Try-with-Resources");
        System.out.println("=".repeat(40));
        LecturaArchivoTryWithResources.ejecutarLecturaConTryWithResources();
    }
    
    private static void ejecutarTodosLosEjercicios() {
        System.out.println("\n🚀 EJECUTANDO: TODOS LOS EJERCICIOS");
        System.out.println("=".repeat(50));
        
        System.out.println("Parte 1: Interfaces");
        ejecutarSistemaEcommerce();
        
        System.out.println("\n" + "=".repeat(50));
        System.out.println("Parte 2: Excepciones");
        
        // Nota: Para la demostración completa, se ejecutarían todos los ejercicios
        // En un entorno real, algunos requieren interacción del usuario
        System.out.println("Los ejercicios de excepciones requieren interacción manual.");
        System.out.println("Use las opciones individuales (2-6) para ejecutarlos.");
    }
    
    private static void mostrarConceptosImplementados() {
        System.out.println("\n📚 CONCEPTOS DE JAVA IMPLEMENTADOS EN EL TP8");
        System.out.println("=".repeat(60));
        
        System.out.println("🔹 INTERFACES:");
        System.out.println("  ✅ Definición de contratos (Pagable, Pago, Notificable)");
        System.out.println("  ✅ Implementación múltiple (implements)");
        System.out.println("  ✅ Herencia de interfaces (PagoConDescuento extends Pago)");
        System.out.println("  ✅ Polimorfismo con interfaces");
        System.out.println("  ✅ Métodos abstractos en interfaces");
        
        System.out.println("\n🔹 EXCEPCIONES:");
        System.out.println("  ✅ Try-catch-finally");
        System.out.println("  ✅ Excepciones checked (IOException, FileNotFoundException)");
        System.out.println("  ✅ Excepciones unchecked (ArithmeticException, NumberFormatException)");
        System.out.println("  ✅ Excepciones personalizadas (EdadInvalidaException)");
        System.out.println("  ✅ Try-with-resources");
        System.out.println("  ✅ Throw y throws");
        System.out.println("  ✅ Manejo de múltiples excepciones");
        
        System.out.println("\n🔹 BUENAS PRÁCTICAS:");
        System.out.println("  ✅ Cada clase en su propio archivo");
        System.out.println("  ✅ Separación de responsabilidades");
        System.out.println("  ✅ Código reutilizable y mantenible");
        System.out.println("  ✅ Manejo robusto de errores");
        System.out.println("  ✅ Liberación automática de recursos");
        
        System.out.println("\n🔹 PATRONES DE DISEÑO:");
        System.out.println("  ✅ Strategy Pattern (diferentes métodos de pago)");
        System.out.println("  ✅ Observer Pattern (notificaciones)");
        System.out.println("  ✅ Template Method (estructura común de pagos)");
    }
    
    private static void esperarContinuar(Scanner scanner) {
        System.out.println("\n" + "=".repeat(50));
        System.out.println("Presione Enter para volver al menú principal...");
        scanner.nextLine();
    }
}