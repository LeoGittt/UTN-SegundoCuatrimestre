import java.util.*;

// ==============================
// EJERCICIO 1: SISTEMA DE STOCK
// ==============================

// Enum CategoriaProducto
enum CategoriaProducto {
    ALIMENTOS("Productos comestibles"),
    ELECTRONICA("Dispositivos electrónicos"),
    ROPA("Prendas de vestir"),
    HOGAR("Artículos para el hogar");

    private final String descripcion;

    CategoriaProducto(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getDescripcion() {
        return descripcion;
    }
}

// Clase Producto
class Producto {
    private String id;
    private String nombre;
    private double precio;
    private int cantidad;
    private CategoriaProducto categoria;

    public Producto(String id, String nombre, double precio, int cantidad, CategoriaProducto categoria) {
        this.id = id;
        this.nombre = nombre;
        this.precio = precio;
        this.cantidad = cantidad;
        this.categoria = categoria;
    }

    public void mostrarInfo() {
        System.out.println("ID: " + id + " | Nombre: " + nombre + " | Precio: $" + precio + 
                          " | Cantidad: " + cantidad + " | Categoría: " + categoria + 
                          " (" + categoria.getDescripcion() + ")");
    }

    // Getters y Setters
    public String getId() { return id; }
    public String getNombre() { return nombre; }
    public double getPrecio() { return precio; }
    public int getCantidad() { return cantidad; }
    public CategoriaProducto getCategoria() { return categoria; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
}

// Clase Inventario
class Inventario {
    private ArrayList<Producto> productos;

    public Inventario() {
        this.productos = new ArrayList<>();
    }

    public void agregarProducto(Producto p) {
        productos.add(p);
        System.out.println("Producto agregado: " + p.getNombre());
    }

    public void listarProductos() {
        System.out.println("\n=== LISTADO DE PRODUCTOS ===");
        if (productos.isEmpty()) {
            System.out.println("No hay productos en el inventario.");
        } else {
            for (Producto p : productos) {
                p.mostrarInfo();
            }
        }
    }

    public Producto buscarProductoPorId(String id) {
        for (Producto p : productos) {
            if (p.getId().equals(id)) {
                return p;
            }
        }
        return null;
    }

    public boolean eliminarProducto(String id) {
        Producto producto = buscarProductoPorId(id);
        if (producto != null) {
            productos.remove(producto);
            System.out.println("Producto eliminado: " + producto.getNombre());
            return true;
        } else {
            System.out.println("Producto con ID " + id + " no encontrado.");
            return false;
        }
    }

    public boolean actualizarStock(String id, int nuevaCantidad) {
        Producto producto = buscarProductoPorId(id);
        if (producto != null) {
            int cantidadAnterior = producto.getCantidad();
            producto.setCantidad(nuevaCantidad);
            System.out.println("Stock actualizado para " + producto.getNombre() + 
                             ": " + cantidadAnterior + " → " + nuevaCantidad);
            return true;
        } else {
            System.out.println("Producto con ID " + id + " no encontrado.");
            return false;
        }
    }

    public void filtrarPorCategoria(CategoriaProducto categoria) {
        System.out.println("\n=== PRODUCTOS DE CATEGORÍA: " + categoria + " ===");
        boolean encontrado = false;
        for (Producto p : productos) {
            if (p.getCategoria() == categoria) {
                p.mostrarInfo();
                encontrado = true;
            }
        }
        if (!encontrado) {
            System.out.println("No hay productos en la categoría " + categoria);
        }
    }

    public int obtenerTotalStock() {
        int total = 0;
        for (Producto p : productos) {
            total += p.getCantidad();
        }
        return total;
    }

    public Producto obtenerProductoConMayorStock() {
        if (productos.isEmpty()) {
            return null;
        }
        
        Producto mayorStock = productos.get(0);
        for (Producto p : productos) {
            if (p.getCantidad() > mayorStock.getCantidad()) {
                mayorStock = p;
            }
        }
        return mayorStock;
    }

    public void filtrarProductosPorPrecio(double min, double max) {
        System.out.println("\n=== PRODUCTOS CON PRECIO ENTRE $" + min + " Y $" + max + " ===");
        boolean encontrado = false;
        for (Producto p : productos) {
            if (p.getPrecio() >= min && p.getPrecio() <= max) {
                p.mostrarInfo();
                encontrado = true;
            }
        }
        if (!encontrado) {
            System.out.println("No hay productos en ese rango de precios.");
        }
    }

    public void mostrarCategoriasDisponibles() {
        System.out.println("\n=== CATEGORÍAS DISPONIBLES ===");
        for (CategoriaProducto categoria : CategoriaProducto.values()) {
            System.out.println(categoria + ": " + categoria.getDescripcion());
        }
    }
}

// ======================================
// EJERCICIO 2: BIBLIOTECA Y LIBROS
// ======================================

// Clase Autor
class Autor {
    private String id;
    private String nombre;
    private String nacionalidad;

    public Autor(String id, String nombre, String nacionalidad) {
        this.id = id;
        this.nombre = nombre;
        this.nacionalidad = nacionalidad;
    }

    public void mostrarInfo() {
        System.out.println("Autor - ID: " + id + " | Nombre: " + nombre + " | Nacionalidad: " + nacionalidad);
    }

    // Getters
    public String getId() { return id; }
    public String getNombre() { return nombre; }
    public String getNacionalidad() { return nacionalidad; }
}

// Clase Libro
class Libro {
    private String isbn;
    private String titulo;
    private int anioPublicacion;
    private Autor autor;

    public Libro(String isbn, String titulo, int anioPublicacion, Autor autor) {
        this.isbn = isbn;
        this.titulo = titulo;
        this.anioPublicacion = anioPublicacion;
        this.autor = autor;
    }

    public void mostrarInfo() {
        System.out.println("Libro - ISBN: " + isbn + " | Título: " + titulo + 
                          " | Año: " + anioPublicacion + " | Autor: " + autor.getNombre());
    }

    // Getters
    public String getIsbn() { return isbn; }
    public String getTitulo() { return titulo; }
    public int getAnioPublicacion() { return anioPublicacion; }
    public Autor getAutor() { return autor; }
}

// Clase Biblioteca
class Biblioteca {
    private String nombre;
    private List<Libro> libros;

    public Biblioteca(String nombre) {
        this.nombre = nombre;
        this.libros = new ArrayList<>();
    }

    public void agregarLibro(String isbn, String titulo, int anioPublicacion, Autor autor) {
        Libro libro = new Libro(isbn, titulo, anioPublicacion, autor);
        libros.add(libro);
        System.out.println("Libro agregado a la biblioteca: " + titulo);
    }

    public void listarLibros() {
        System.out.println("\n=== LIBROS EN LA BIBLIOTECA " + nombre + " ===");
        if (libros.isEmpty()) {
            System.out.println("No hay libros en la biblioteca.");
        } else {
            for (Libro libro : libros) {
                libro.mostrarInfo();
            }
        }
    }

    public Libro buscarLibroPorIsbn(String isbn) {
        for (Libro libro : libros) {
            if (libro.getIsbn().equals(isbn)) {
                return libro;
            }
        }
        return null;
    }

    public boolean eliminarLibro(String isbn) {
        Libro libro = buscarLibroPorIsbn(isbn);
        if (libro != null) {
            libros.remove(libro);
            System.out.println("Libro eliminado: " + libro.getTitulo());
            return true;
        } else {
            System.out.println("Libro con ISBN " + isbn + " no encontrado.");
            return false;
        }
    }

    public int obtenerCantidadLibros() {
        return libros.size();
    }

    public void filtrarLibrosPorAnio(int anio) {
        System.out.println("\n=== LIBROS PUBLICADOS EN " + anio + " ===");
        boolean encontrado = false;
        for (Libro libro : libros) {
            if (libro.getAnioPublicacion() == anio) {
                libro.mostrarInfo();
                encontrado = true;
            }
        }
        if (!encontrado) {
            System.out.println("No hay libros publicados en " + anio);
        }
    }

    public void mostrarAutoresDisponibles() {
        System.out.println("\n=== AUTORES DISPONIBLES EN LA BIBLIOTECA ===");
        Set<String> autoresUnicos = new HashSet<>();
        for (Libro libro : libros) {
            autoresUnicos.add(libro.getAutor().getNombre());
        }
        for (String autorNombre : autoresUnicos) {
            System.out.println("- " + autorNombre);
        }
    }

    // Getter
    public String getNombre() { return nombre; }
}

// ======================================================
// EJERCICIO 3: UNIVERSIDAD, PROFESOR Y CURSO
// ======================================================

// Clase Profesor
class Profesor {
    private String id;
    private String nombre;
    private String especialidad;
    private List<Curso> cursos;

    public Profesor(String id, String nombre, String especialidad) {
        this.id = id;
        this.nombre = nombre;
        this.especialidad = especialidad;
        this.cursos = new ArrayList<>();
    }

    public void agregarCurso(Curso c) {
        if (!cursos.contains(c)) {
            cursos.add(c);
            // Sincronizar el lado del curso
            if (c.getProfesor() != this) {
                c.setProfesor(this);
            }
        }
    }

    public void eliminarCurso(Curso c) {
        if (cursos.contains(c)) {
            cursos.remove(c);
            // Sincronizar el lado del curso
            if (c.getProfesor() == this) {
                c.setProfesor(null);
            }
        }
    }

    public void listarCursos() {
        System.out.println("Cursos dictados por " + nombre + ":");
        if (cursos.isEmpty()) {
            System.out.println("  No dicta cursos actualmente.");
        } else {
            for (Curso curso : cursos) {
                System.out.println("  - " + curso.getCodigo() + ": " + curso.getNombre());
            }
        }
    }

    public void mostrarInfo() {
        System.out.println("Profesor - ID: " + id + " | Nombre: " + nombre + 
                          " | Especialidad: " + especialidad + " | Cursos: " + cursos.size());
    }

    // Getters
    public String getId() { return id; }
    public String getNombre() { return nombre; }
    public String getEspecialidad() { return especialidad; }
    public List<Curso> getCursos() { return cursos; }
}

// Clase Curso
class Curso {
    private String codigo;
    private String nombre;
    private Profesor profesor;

    public Curso(String codigo, String nombre) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.profesor = null;
    }

    public void setProfesor(Profesor p) {
        // Si tenía profesor previo, quitarse de su lista
        if (this.profesor != null && this.profesor != p) {
            this.profesor.eliminarCurso(this);
        }
        
        // Asignar nuevo profesor
        this.profesor = p;
        
        // Sincronizar el lado del profesor
        if (p != null && !p.getCursos().contains(this)) {
            p.agregarCurso(this);
        }
    }

    public void mostrarInfo() {
        String profesorNombre = (profesor != null) ? profesor.getNombre() : "Sin asignar";
        System.out.println("Curso - Código: " + codigo + " | Nombre: " + nombre + 
                          " | Profesor: " + profesorNombre);
    }

    // Getters
    public String getCodigo() { return codigo; }
    public String getNombre() { return nombre; }
    public Profesor getProfesor() { return profesor; }
}

// Clase Universidad
class Universidad {
    private String nombre;
    private List<Profesor> profesores;
    private List<Curso> cursos;

    public Universidad(String nombre) {
        this.nombre = nombre;
        this.profesores = new ArrayList<>();
        this.cursos = new ArrayList<>();
    }

    public void agregarProfesor(Profesor p) {
        profesores.add(p);
        System.out.println("Profesor agregado: " + p.getNombre());
    }

    public void agregarCurso(Curso c) {
        cursos.add(c);
        System.out.println("Curso agregado: " + c.getNombre());
    }

    public void asignarProfesorACurso(String codigoCurso, String idProfesor) {
        Curso curso = buscarCursoPorCodigo(codigoCurso);
        Profesor profesor = buscarProfesorPorId(idProfesor);
        
        if (curso != null && profesor != null) {
            curso.setProfesor(profesor);
            System.out.println("Profesor " + profesor.getNombre() + 
                             " asignado al curso " + curso.getNombre());
        } else {
            System.out.println("No se pudo realizar la asignación. Verifique códigos/IDs.");
        }
    }

    public void listarProfesores() {
        System.out.println("\n=== PROFESORES DE " + nombre + " ===");
        if (profesores.isEmpty()) {
            System.out.println("No hay profesores registrados.");
        } else {
            for (Profesor p : profesores) {
                p.mostrarInfo();
            }
        }
    }

    public void listarCursos() {
        System.out.println("\n=== CURSOS DE " + nombre + " ===");
        if (cursos.isEmpty()) {
            System.out.println("No hay cursos registrados.");
        } else {
            for (Curso c : cursos) {
                c.mostrarInfo();
            }
        }
    }

    public Profesor buscarProfesorPorId(String id) {
        for (Profesor p : profesores) {
            if (p.getId().equals(id)) {
                return p;
            }
        }
        return null;
    }

    public Curso buscarCursoPorCodigo(String codigo) {
        for (Curso c : cursos) {
            if (c.getCodigo().equals(codigo)) {
                return c;
            }
        }
        return null;
    }

    public boolean eliminarCurso(String codigo) {
        Curso curso = buscarCursoPorCodigo(codigo);
        if (curso != null) {
            // Romper la relación con su profesor si la hubiera
            if (curso.getProfesor() != null) {
                curso.getProfesor().eliminarCurso(curso);
            }
            cursos.remove(curso);
            System.out.println("Curso eliminado: " + curso.getNombre());
            return true;
        } else {
            System.out.println("Curso con código " + codigo + " no encontrado.");
            return false;
        }
    }

    public boolean eliminarProfesor(String id) {
        Profesor profesor = buscarProfesorPorId(id);
        if (profesor != null) {
            // Antes de remover, dejar null los cursos que dictaba
            List<Curso> cursosDelProfesor = new ArrayList<>(profesor.getCursos());
            for (Curso curso : cursosDelProfesor) {
                curso.setProfesor(null);
            }
            profesores.remove(profesor);
            System.out.println("Profesor eliminado: " + profesor.getNombre());
            return true;
        } else {
            System.out.println("Profesor con ID " + id + " no encontrado.");
            return false;
        }
    }

    public void mostrarReporteCursosPorProfesor() {
        System.out.println("\n=== REPORTE: CANTIDAD DE CURSOS POR PROFESOR ===");
        for (Profesor p : profesores) {
            System.out.println(p.getNombre() + " (" + p.getEspecialidad() + "): " + 
                             p.getCursos().size() + " cursos");
        }
    }

    // Getter
    public String getNombre() { return nombre; }
}

// ==============================
// CLASE PRINCIPAL CON MAIN
// ==============================

public class Ejercicios {
    public static void main(String[] args) {
        System.out.println("=".repeat(60));
        System.out.println("TRABAJO PRÁCTICO 6: COLECCIONES Y SISTEMA DE STOCK");
        System.out.println("=".repeat(60));
        
        // Ejecutar todos los ejercicios
        ejecutarEjercicio1();
        ejecutarEjercicio2();
        ejecutarEjercicio3();
    }

    // ==============================
    // EJECUCIÓN EJERCICIO 1: SISTEMA DE STOCK
    // ==============================
    public static void ejecutarEjercicio1() {
        System.out.println("\n" + "=".repeat(40));
        System.out.println("EJERCICIO 1: SISTEMA DE STOCK");
        System.out.println("=".repeat(40));

        // Crear inventario
        Inventario inventario = new Inventario();

        // 1. Crear al menos cinco productos con diferentes categorías
        System.out.println("\n1. Creando productos...");
        Producto p1 = new Producto("P001", "Arroz Integral", 1500.0, 50, CategoriaProducto.ALIMENTOS);
        Producto p2 = new Producto("P002", "Smartphone Samsung", 250000.0, 15, CategoriaProducto.ELECTRONICA);
        Producto p3 = new Producto("P003", "Camisa Formal", 2800.0, 25, CategoriaProducto.ROPA);
        Producto p4 = new Producto("P004", "Lámpara LED", 3500.0, 30, CategoriaProducto.HOGAR);
        Producto p5 = new Producto("P005", "Leche Descremada", 800.0, 100, CategoriaProducto.ALIMENTOS);

        inventario.agregarProducto(p1);
        inventario.agregarProducto(p2);
        inventario.agregarProducto(p3);
        inventario.agregarProducto(p4);
        inventario.agregarProducto(p5);

        // 2. Listar todos los productos
        System.out.println("\n2. Listando todos los productos...");
        inventario.listarProductos();

        // 3. Buscar un producto por ID
        System.out.println("\n3. Buscando producto por ID (P002)...");
        Producto encontrado = inventario.buscarProductoPorId("P002");
        if (encontrado != null) {
            System.out.println("Producto encontrado:");
            encontrado.mostrarInfo();
        }

        // 4. Filtrar productos por categoría
        System.out.println("\n4. Filtrando productos por categoría ALIMENTOS...");
        inventario.filtrarPorCategoria(CategoriaProducto.ALIMENTOS);

        // 5. Eliminar un producto por ID
        System.out.println("\n5. Eliminando producto P003...");
        inventario.eliminarProducto("P003");
        System.out.println("Productos restantes:");
        inventario.listarProductos();

        // 6. Actualizar stock de un producto
        System.out.println("\n6. Actualizando stock del producto P001...");
        inventario.actualizarStock("P001", 75);

        // 7. Mostrar total de stock
        System.out.println("\n7. Total de stock disponible: " + inventario.obtenerTotalStock());

        // 8. Obtener producto con mayor stock
        System.out.println("\n8. Producto con mayor stock:");
        Producto mayorStock = inventario.obtenerProductoConMayorStock();
        if (mayorStock != null) {
            mayorStock.mostrarInfo();
        }

        // 9. Filtrar productos por rango de precio
        System.out.println("\n9. Filtrando productos con precios entre $1000 y $3000...");
        inventario.filtrarProductosPorPrecio(1000, 3000);

        // 10. Mostrar categorías disponibles
        System.out.println("\n10. Mostrando categorías disponibles...");
        inventario.mostrarCategoriasDisponibles();
    }

    // ==============================
    // EJECUCIÓN EJERCICIO 2: BIBLIOTECA Y LIBROS
    // ==============================
    public static void ejecutarEjercicio2() {
        System.out.println("\n" + "=".repeat(40));
        System.out.println("EJERCICIO 2: BIBLIOTECA Y LIBROS");
        System.out.println("=".repeat(40));

        // 1. Crear una biblioteca
        System.out.println("\n1. Creando biblioteca...");
        Biblioteca biblioteca = new Biblioteca("Biblioteca Central UTN");
        System.out.println("Biblioteca creada: " + biblioteca.getNombre());

        // 2. Crear al menos tres autores
        System.out.println("\n2. Creando autores...");
        Autor autor1 = new Autor("A001", "Gabriel García Márquez", "Colombiana");
        Autor autor2 = new Autor("A002", "Isabel Allende", "Chilena");
        Autor autor3 = new Autor("A003", "Jorge Luis Borges", "Argentina");

        autor1.mostrarInfo();
        autor2.mostrarInfo();
        autor3.mostrarInfo();

        // 3. Agregar 5 libros asociados a alguno de los autores
        System.out.println("\n3. Agregando libros a la biblioteca...");
        biblioteca.agregarLibro("978-84-376-0494-7", "Cien años de soledad", 1967, autor1);
        biblioteca.agregarLibro("978-84-204-8531-1", "El amor en los tiempos del cólera", 1985, autor1);
        biblioteca.agregarLibro("978-84-8346-932-1", "La casa de los espíritus", 1982, autor2);
        biblioteca.agregarLibro("978-84-8346-978-9", "Eva Luna", 1987, autor2);
        biblioteca.agregarLibro("978-84-9759-392-1", "Ficciones", 1944, autor3);

        // 4. Listar todos los libros con su información y la del autor
        System.out.println("\n4. Listando todos los libros...");
        biblioteca.listarLibros();

        // 5. Buscar un libro por su ISBN
        System.out.println("\n5. Buscando libro por ISBN (978-84-376-0494-7)...");
        Libro libroEncontrado = biblioteca.buscarLibroPorIsbn("978-84-376-0494-7");
        if (libroEncontrado != null) {
            System.out.println("Libro encontrado:");
            libroEncontrado.mostrarInfo();
        }

        // 6. Filtrar libros por año específico
        System.out.println("\n6. Filtrando libros publicados en 1987...");
        biblioteca.filtrarLibrosPorAnio(1987);

        // 7. Eliminar un libro por ISBN
        System.out.println("\n7. Eliminando libro con ISBN 978-84-8346-978-9...");
        biblioteca.eliminarLibro("978-84-8346-978-9");
        System.out.println("Libros restantes:");
        biblioteca.listarLibros();

        // 8. Mostrar cantidad total de libros
        System.out.println("\n8. Cantidad total de libros en la biblioteca: " + 
                          biblioteca.obtenerCantidadLibros());

        // 9. Listar todos los autores disponibles
        System.out.println("\n9. Autores disponibles en la biblioteca:");
        biblioteca.mostrarAutoresDisponibles();
    }

    // ==============================
    // EJECUCIÓN EJERCICIO 3: UNIVERSIDAD, PROFESOR Y CURSO
    // ==============================
    public static void ejecutarEjercicio3() {
        System.out.println("\n" + "=".repeat(40));
        System.out.println("EJERCICIO 3: UNIVERSIDAD, PROFESOR Y CURSO");
        System.out.println("=".repeat(40));

        // Crear universidad
        Universidad universidad = new Universidad("Universidad Tecnológica Nacional");
        System.out.println("Universidad creada: " + universidad.getNombre());

        // 1. Crear al menos 3 profesores y 5 cursos
        System.out.println("\n1. Creando profesores y cursos...");
        
        // Crear profesores
        Profesor prof1 = new Profesor("PROF001", "Dr. Juan Pérez", "Programación");
        Profesor prof2 = new Profesor("PROF002", "Dra. María González", "Matemáticas");
        Profesor prof3 = new Profesor("PROF003", "Ing. Carlos López", "Sistemas");

        // Crear cursos
        Curso curso1 = new Curso("PROG101", "Programación I");
        Curso curso2 = new Curso("PROG102", "Programación II");
        Curso curso3 = new Curso("MAT101", "Análisis Matemático I");
        Curso curso4 = new Curso("SIS101", "Sistemas Operativos");
        Curso curso5 = new Curso("SIS102", "Base de Datos");

        // 2. Agregar profesores y cursos a la universidad
        System.out.println("\n2. Agregando profesores y cursos a la universidad...");
        universidad.agregarProfesor(prof1);
        universidad.agregarProfesor(prof2);
        universidad.agregarProfesor(prof3);

        universidad.agregarCurso(curso1);
        universidad.agregarCurso(curso2);
        universidad.agregarCurso(curso3);
        universidad.agregarCurso(curso4);
        universidad.agregarCurso(curso5);

        // 3. Asignar profesores a cursos
        System.out.println("\n3. Asignando profesores a cursos...");
        universidad.asignarProfesorACurso("PROG101", "PROF001");
        universidad.asignarProfesorACurso("PROG102", "PROF001");
        universidad.asignarProfesorACurso("MAT101", "PROF002");
        universidad.asignarProfesorACurso("SIS101", "PROF003");
        universidad.asignarProfesorACurso("SIS102", "PROF003");

        // 4. Listar cursos con su profesor y profesores con sus cursos
        System.out.println("\n4. Listando información actual...");
        universidad.listarCursos();
        universidad.listarProfesores();
        
        System.out.println("\nDetalle de cursos por profesor:");
        prof1.listarCursos();
        prof2.listarCursos();  
        prof3.listarCursos();

        // 5. Cambiar el profesor de un curso
        System.out.println("\n5. Cambiando profesor del curso SIS102...");
        System.out.println("Antes del cambio:");
        curso5.mostrarInfo();
        prof3.listarCursos();
        
        universidad.asignarProfesorACurso("SIS102", "PROF002");
        
        System.out.println("Después del cambio:");
        curso5.mostrarInfo();
        prof2.listarCursos();
        prof3.listarCursos();

        // 6. Remover un curso
        System.out.println("\n6. Removiendo curso MAT101...");
        System.out.println("Antes de remover:");
        prof2.listarCursos();
        
        universidad.eliminarCurso("MAT101");
        
        System.out.println("Después de remover:");
        prof2.listarCursos();

        // 7. Remover un profesor
        System.out.println("\n7. Removiendo profesor PROF003...");
        System.out.println("Antes de remover:");
        curso4.mostrarInfo();
        
        universidad.eliminarProfesor("PROF003");
        
        System.out.println("Después de remover:");
        curso4.mostrarInfo();

        // 8. Mostrar reporte final
        System.out.println("\n8. Reporte final: cantidad de cursos por profesor");
        universidad.mostrarReporteCursosPorProfesor();
        
        System.out.println("\nEstado final de la universidad:");
        universidad.listarProfesores();
        universidad.listarCursos();
    }
}
