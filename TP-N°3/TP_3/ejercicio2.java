// 2. Registro de Mascotas
// a. Crear una clase Mascota con los atributos: nombre, especie, edad.
// Métodos requeridos: mostrarInfo(), cumplirAnios().
// Tarea: Crear una mascota, mostrar su información, simular el paso del tiempo y
// verificar los cambios.

public class Mascota {

    private String nombre;
    private String especie;
    private int edad;

    public Mascota(String nombre, String especie, int edad) {
        this.nombre = nombre;
        this.especie = especie;
        this.edad = edad;
    }

    public void mostrarInfo() {
        System.out.println("--- Información de la Mascota ---");
        System.out.println("Nombre: " + this.nombre);
        System.out.println("Especie: " + this.especie);
        System.out.println("Edad: " + this.edad + " años");
        System.out.println("----------------------------------");
    }

    public void cumplirAnios() {
        this.edad += 1;
        System.out.println(this.nombre + " ha cumplido años! Su nueva edad es: " + this.edad + " años.");
    }
}

public class Main {
    public static void main(String[] args) {

        Mascota mascota1 = new Mascota("Firulais", "Perro", 3);

        mascota1.mostrarInfo();

        System.out.println("\n--- Simulando el paso del tiempo ---");
        mascota1.cumplirAnios();

        System.out.println("\n--- Estado final ---");
        mascota1.mostrarInfo();
    }
}