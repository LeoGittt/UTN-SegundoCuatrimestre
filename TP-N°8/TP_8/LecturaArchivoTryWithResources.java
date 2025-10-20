import java.io.*;
import java.util.Scanner;

// Ejercicio 5: Uso de try-with-resources
public class LecturaArchivoTryWithResources {
    
    public static void main(String[] args) {
        System.out.println("=== EJERCICIO 5: TRY-WITH-RESOURCES ===");
        ejecutarLecturaConTryWithResources();
    }
    
    public static void ejecutarLecturaConTryWithResources() {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Ingrese la ruta del archivo a leer: ");
        String rutaArchivo = scanner.nextLine();
        
        try {
            leerArchivoConTryWithResources(rutaArchivo);
        } catch (FileNotFoundException e) {
            System.err.println("ERROR: El archivo '" + rutaArchivo + "' no fue encontrado.");
            crearArchivoEjemplo(rutaArchivo);
        } catch (IOException e) {
            System.err.println("ERROR de E/S: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("ERROR inesperado: " + e.getMessage());
        }
    }
    
    public static void leerArchivoConTryWithResources(String rutaArchivo) throws IOException {
        // Try-with-resources: Los recursos se cierran automáticamente
        try (FileReader fileReader = new FileReader(rutaArchivo);
             BufferedReader bufferedReader = new BufferedReader(fileReader)) {
            
            System.out.println("\n=== CONTENIDO DEL ARCHIVO (Try-with-Resources) ===");
            String linea;
            int numeroLinea = 1;
            int totalCaracteres = 0;
            int totalPalabras = 0;
            
            while ((linea = bufferedReader.readLine()) != null) {
                System.out.printf("%3d: %s%n", numeroLinea++, linea);
                totalCaracteres += linea.length();
                totalPalabras += linea.split("\\s+").length;
            }
            
            System.out.println("=== ESTADÍSTICAS DEL ARCHIVO ===");
            System.out.println("Total de líneas: " + (numeroLinea - 1));
            System.out.println("Total de caracteres: " + totalCaracteres);
            System.out.println("Total de palabras (aproximado): " + totalPalabras);
            
        } // Los recursos FileReader y BufferedReader se cierran automáticamente aquí
    }
    
    public static void crearArchivoEjemplo(String rutaArchivo) {
        System.out.println("\n¿Desea crear un archivo de ejemplo? (s/n): ");
        Scanner scanner = new Scanner(System.in);
        String respuesta = scanner.nextLine();
        
        if ("s".equalsIgnoreCase(respuesta.trim())) {
            try (FileWriter fileWriter = new FileWriter(rutaArchivo);
                 BufferedWriter bufferedWriter = new BufferedWriter(fileWriter)) {
                
                bufferedWriter.write("=== ARCHIVO DE EJEMPLO ===");
                bufferedWriter.newLine();
                bufferedWriter.write("Este es un archivo creado automáticamente.");
                bufferedWriter.newLine();
                bufferedWriter.write("Contiene varias líneas para demostrar");
                bufferedWriter.newLine();
                bufferedWriter.write("el funcionamiento del try-with-resources.");
                bufferedWriter.newLine();
                bufferedWriter.write("¡Java maneja los recursos automáticamente!");
                bufferedWriter.newLine();
                bufferedWriter.write("Fecha de creación: " + new java.util.Date());
                
                System.out.println("✓ Archivo creado exitosamente: " + rutaArchivo);
                System.out.println("Ahora puede ejecutar el programa nuevamente.");
                
            } catch (IOException e) {
                System.err.println("ERROR al crear el archivo: " + e.getMessage());
            }
        }
    }
}