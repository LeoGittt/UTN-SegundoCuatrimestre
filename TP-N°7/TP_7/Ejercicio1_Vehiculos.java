// Ejercicio 1: Vehículos y herencia básica
// Este ejercicio demuestra los conceptos de herencia, upcasting, downcasting e instanceof
// Las clases Vehiculo y Auto están definidas en archivos separados

public class Ejercicio1_Vehiculos {
    public static void main(String[] args) {
        System.out.println("=== Ejercicio 1: Vehículos y herencia básica ===");
        
        // Crear instancias
        Vehiculo vehiculo = new Vehiculo("Toyota", "Corolla");
        Auto auto = new Auto("Honda", "Civic", 4);
        
        // Mostrar información
        vehiculo.mostrarInfo();
        auto.mostrarInfo();
        
        // Demostrar upcasting
        System.out.println("\n--- Upcasting ---");
        Vehiculo vehiculoGenerico = new Auto("Ford", "Focus", 5);
        vehiculoGenerico.mostrarInfo(); // Llama al método sobrescrito de Auto
        
        // Demostrar instanceof y downcasting
        System.out.println("\n--- Instanceof y Downcasting ---");
        if (vehiculoGenerico instanceof Auto) {
            Auto autoEspecifico = (Auto) vehiculoGenerico;
            System.out.println("Cantidad de puertas: " + autoEspecifico.getCantidadPuertas());
        }
    }
}