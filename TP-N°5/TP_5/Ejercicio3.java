// Ejercicio 3: Libro - Autor - Editorial
// Asociación unidireccional: Libro → Autor
// Agregación: Libro → Editorial

class Autor {
    String nombre;
    String nacionalidad;
    public Autor(String nombre, String nacionalidad) {
        this.nombre = nombre;
        this.nacionalidad = nacionalidad;
    }
}

class Editorial {
    String nombre;
    String direccion;
    public Editorial(String nombre, String direccion) {
        this.nombre = nombre;
        this.direccion = direccion;
    }
}

class Libro {
    String titulo;
    String isbn;
    Autor autor;
    Editorial editorial;
    public Libro(String titulo, String isbn, Autor autor, Editorial editorial) {
        this.titulo = titulo;
        this.isbn = isbn;
        this.autor = autor;
        this.editorial = editorial;
    }
}

public class Ejercicio3 {
    public static void main(String[] args) {
        Autor autor = new Autor("Borges", "Argentina");
        Editorial editorial = new Editorial("Planeta", "CABA");
        Libro libro = new Libro("Ficciones", "978-950-49-1234-5", autor, editorial);
        System.out.println("Libro: " + libro.titulo + ", Autor: " + autor.nombre);
    }
}
