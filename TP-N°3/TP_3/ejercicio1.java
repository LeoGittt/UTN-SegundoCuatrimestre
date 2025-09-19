
// 1. Registro de Estudiantes
// a. Crear una clase Estudiante con los atributos: nombre, apellido, curso,
// calificación.
// Métodos requeridos: mostrarInfo(), subirCalificacion(puntos),
// bajarCalificacion(puntos).
// Tarea: Instanciar a un estudiante, mostrar su información, aumentar y disminuir
// calificaciones.


public class Estudiante {

    private String nombre;
    private String apellido;
    private String curso;
    private double calificacion;

    public Estudiante(String nombre, String apellido, String curso, double calificacion) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.curso = curso;
        this.calificacion = calificacion;
    }

    public void mostrarInfo() {
        System.out.println("--- Información del Estudiante ---");
        System.out.println("Nombre: " + this.nombre);
        System.out.println("Apellido: " + this.apellido);
        System.out.println("Curso: " + this.curso);
        System.out.println("Calificación: " + this.calificacion);
        System.out.println("----------------------------------");
    }

    public void subirCalificacion(double puntos) {
        if (puntos > 0) {
            this.calificacion += puntos;
            System.out.println("Se ha subido la calificación en " + puntos + " puntos.");
            System.out.println("Nueva calificación: " + this.calificacion);
        } else {
            System.out.println("Los puntos deben ser un valor positivo.");
        }
    }

    public void bajarCalificacion(double puntos) {
        if (puntos > 0) {
            this.calificacion -= puntos;
            System.out.println("Se ha bajado la calificación en " + puntos + " puntos.");
            System.out.println("Nueva calificación: " + this.calificacion);
        } else {
            System.out.println("Los puntos deben ser un valor positivo.");
        }
    }
}

public class Main {
    public static void main(String[] args) {

        Estudiante estudiante1 = new Estudiante("Ana", "García", "Matemáticas", 8.5);

        estudiante1.mostrarInfo();

        System.out.println("\n--- Aumentando calificación ---");
        estudiante1.subirCalificacion(1.0);

        System.out.println("\n--- Disminuyendo calificación ---");
        estudiante1.bajarCalificacion(0.5);

        System.out.println("\n--- Estado final ---");
        estudiante1.mostrarInfo();
    }
}