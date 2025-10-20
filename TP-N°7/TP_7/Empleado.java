// Clase abstracta Empleado
public abstract class Empleado {
    protected String nombre;
    protected String id;
    protected double sueldoBase;
    
    public Empleado(String nombre, String id, double sueldoBase) {
        this.nombre = nombre;
        this.id = id;
        this.sueldoBase = sueldoBase;
    }
    
    // Método abstracto que debe ser implementado por las subclases
    public abstract double calcularSueldo();
    
    // Método concreto para mostrar información básica
    public void mostrarInfo() {
        System.out.println("Empleado: " + nombre + " (ID: " + id + ")");
        System.out.println("Sueldo: $" + String.format("%.2f", calcularSueldo()));
    }
    
    // Getters
    public String getNombre() {
        return nombre;
    }
    
    public String getId() {
        return id;
    }
    
    public double getSueldoBase() {
        return sueldoBase;
    }
}