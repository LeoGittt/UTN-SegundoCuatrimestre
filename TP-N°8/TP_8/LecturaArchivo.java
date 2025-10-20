import java.io.*;
import java.util.Scanner;

// Ejercicio 3: Lectura de archivo
public class LecturaArchivo {
    
    public static void main(String[] args) {
        System.out.println("=== EJERCICIO 3: LECTURA DE ARCHIVO ===");
        ejecutarLecturaArchivo();
    }
    
    public static void ejecutarLecturaArchivo() {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Ingrese la ruta del archivo a leer: ");
        String rutaArchivo = scanner.nextLine();
        
        try {
            leerArchivo(rutaArchivo);
        } catch (FileNotFoundException e) {
            System.err.println("ERROR: El archivo '" + rutaArchivo + "' no fue encontrado.");
            System.out.println("Verifique que:");
            System.out.println("1. La ruta sea correcta");
            System.out.println("2. El archivo exista");
            System.out.println("3. Tenga permisos de lectura");
        } catch (IOException e) {
            System.err.println("ERROR de E/S al leer el archivo: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("ERROR inesperado: " + e.getMessage());
        }
    }
    
    public static void leerArchivo(String rutaArchivo) throws IOException {
        FileReader fileReader = null;
        BufferedReader bufferedReader = null;
        
        try {
            fileReader = new FileReader(rutaArchivo);
            bufferedReader = new BufferedReader(fileReader);
            
            System.out.println("\n=== CONTENIDO DEL ARCHIVO ===");
            String linea;
            int numeroLinea = 1;
            
            while ((linea = bufferedReader.readLine()) != null) {
                System.out.printf("%3d: %s%n", numeroLinea++, linea);
            }
            
            System.out.println("=== FIN DEL ARCHIVO ===");
            System.out.println("Total de líneas leídas: " + (numeroLinea - 1));
            
        } finally {
            // Cerrar recursos manualmente (sin try-with-resources)
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException e) {
                    System.err.println("Error al cerrar BufferedReader: " + e.getMessage());
                }
            }
            if (fileReader != null) {
                try {
                    fileReader.close();
                } catch (IOException e) {
                    System.err.println("Error al cerrar FileReader: " + e.getMessage());
                }
            }
        }
    }
}