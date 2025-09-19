// 4. Gestión de Gallinas en Granja Digital
// a. Crear una clase Gallina con los atributos: idGallina, edad,
// huevosPuestos.
// Métodos requeridos: ponerHuevo(), envejecer(), mostrarEstado().
// Tarea: Crear dos gallinas, simular sus acciones (envejecer y poner huevos), y
// mostrar su estado.

public class Gallina {

    private int idGallina;
    private int edad;
    private int huevosPuestos;

    public Gallina(int idGallina, int edad) {
        this.idGallina = idGallina;
        this.edad = edad;
        this.huevosPuestos = 0; 
    }

    public void ponerHuevo() {
        this.huevosPuestos += 1;
        System.out.println("La gallina " + this.idGallina + " ha puesto un huevo. Total de huevos: " + this.huevosPuestos);
    }

    public void envejecer() {
        this.edad += 1;
        System.out.println("La gallina " + this.idGallina + " ha envejecido. Su nueva edad es: " + this.edad + " años.");
    }

    public void mostrarEstado() {
        System.out.println("--- Estado de la Gallina " + this.idGallina + " ---");
        System.out.println("Edad: " + this.edad + " años");
        System.out.println("Huevos puestos: " + this.huevosPuestos);
        System.out.println("----------------------------------------");
    }
}

public class Main {
    public static void main(String[] args) {

        Gallina gallina1 = new Gallina(1, 1);
        Gallina gallina2 = new Gallina(2, 2);

        gallina1.mostrarEstado();
        gallina2.mostrarEstado();

        System.out.println("\n--- Simulación de Acciones ---");
        
        gallina1.ponerHuevo();
        gallina1.envejecer();
        
        gallina2.envejecer();
        gallina2.ponerHuevo();
        gallina2.ponerHuevo();

        System.out.println("\n--- Estado Final de las Gallinas ---");
        gallina1.mostrarEstado();
        gallina2.mostrarEstado();
    }
}