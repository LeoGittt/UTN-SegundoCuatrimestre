// Ejercicio Principal Parte 2: Manejo de Excepciones
public class EjercicioExcepciones {
    
    public static void main(String[] args) {
        System.out.println("=== EJERCICIOS DE MANEJO DE EXCEPCIONES ===");
        ejecutarEjerciciosExcepciones();
    }
    
    public static void ejecutarEjerciciosExcepciones() {
        System.out.println("\n1. DIVISIÓN SEGURA");
        System.out.println("-".repeat(30));
        DivisionSegura.ejecutarDivisionSegura();
        
        esperarEnter();
        
        System.out.println("\n2. CONVERSIÓN DE NÚMERO");
        System.out.println("-".repeat(30));
        ConversionNumero.ejecutarConversion();
        
        esperarEnter();
        
        System.out.println("\n3. LECTURA DE ARCHIVO (TRADICIONAL)");
        System.out.println("-".repeat(40));
        LecturaArchivo.ejecutarLecturaArchivo();
        
        esperarEnter();
        
        System.out.println("\n4. VALIDADOR DE EDAD (EXCEPCIÓN PERSONALIZADA)");
        System.out.println("-".repeat(50));
        ValidadorEdad.ejecutarValidacionEdad();
        
        esperarEnter();
        
        System.out.println("\n5. LECTURA CON TRY-WITH-RESOURCES");
        System.out.println("-".repeat(40));
        LecturaArchivoTryWithResources.ejecutarLecturaConTryWithResources();
        
        System.out.println("\n=== TODOS LOS EJERCICIOS COMPLETADOS ===");
    }
    
    private static void esperarEnter() {
        System.out.println("\nPresione Enter para continuar con el siguiente ejercicio...");
        try {
            System.in.read();
        } catch (Exception e) {
            // Ignorar errores de entrada
        }
    }
}