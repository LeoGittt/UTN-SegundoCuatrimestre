// 3. Encapsulamiento con la Clase Libro
// a. Crear una clase Libro con atributos privados: titulo, autor,
// añoPublicacion.
// Métodos requeridos: Getters para todos los atributos. Setter con validación
// para añoPublicacion.
// Tarea: Crear un libro, intentar modificar el año con un valor inválido y luego con
// uno válido, mostrar la información final.

public class Libro {
    
    private String titulo;
    private String autor;
    private int anioPublicacion;

    public Libro(String titulo, String autor, int anioPublicacion) {
        this.titulo = titulo;
        this.autor = autor;
        this.anioPublicacion = anioPublicacion;
    }

    public String getTitulo() {
        return this.titulo;
    }

    public String getAutor() {
        return this.autor;
    }

    public int getAnioPublicacion() {
        return this.anioPublicacion;
    }

    public void setAnioPublicacion(int nuevoAnio) {
        if (nuevoAnio > 0 && nuevoAnio <= 2025) { 
            this.anioPublicacion = nuevoAnio;
            System.out.println("El año de publicación ha sido actualizado a " + nuevoAnio + ".");
        } else {
            System.out.println("Error: El año de publicación " + nuevoAnio + " no es válido. No se realizó la actualización.");
        }
    }

    public void mostrarInfo() {
        System.out.println("--- Información del Libro ---");
        System.out.println("Título: " + this.getTitulo());
        System.out.println("Autor: " + this.getAutor());
        System.out.println("Año de Publicación: " + this.getAnioPublicacion());
        System.out.println("-----------------------------");
    }
}

public class Main {
    public static void main(String[] args) {

        Libro libro1 = new Libro("El Principito", "Antoine de Saint-Exupéry", 1943);

        libro1.mostrarInfo();

        System.out.println("\n--- Intentando modificar el año de publicación ---");
        libro1.setAnioPublicacion(2026);  // Año inválido
        libro1.setAnioPublicacion(2020);  // Año válido

        System.out.println("\n--- Estado final ---");
        libro1.mostrarInfo();
    }
}