// Ejercicio 7: Vehículo - Motor - Conductor
// Agregación: Vehículo → Motor
// Asociación bidireccional: Vehículo ↔ Conductor

class Motor {
    String tipo;
    String numeroSerie;
    public Motor(String tipo, String numeroSerie) {
        this.tipo = tipo;
        this.numeroSerie = numeroSerie;
    }
}

class Conductor {
    String nombre;
    String licencia;
    Vehiculo vehiculo;
    public Conductor(String nombre, String licencia) {
        this.nombre = nombre;
        this.licencia = licencia;
    }
    public void setVehiculo(Vehiculo vehiculo) {
        this.vehiculo = vehiculo;
    }
}

class Vehiculo {
    String patente;
    String modelo;
    Motor motor;
    Conductor conductor;
    public Vehiculo(String patente, String modelo, Motor motor, Conductor conductor) {
        this.patente = patente;
        this.modelo = modelo;
        this.motor = motor;
        this.conductor = conductor;
        conductor.setVehiculo(this);
    }
}

public class Ejercicio7 {
    public static void main(String[] args) {
        Motor motor = new Motor("Nafta", "MTR123");
        Conductor conductor = new Conductor("Sofía", "LIC987");
        Vehiculo vehiculo = new Vehiculo("AA123BB", "Fiat Uno", motor, conductor);
        System.out.println("Vehículo de " + conductor.nombre + ", Patente: " + vehiculo.patente);
    }
}
