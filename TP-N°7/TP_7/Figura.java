// Clase abstracta Figura
public abstract class Figura {
    protected String nombre;
    
    public Figura(String nombre) {
        this.nombre = nombre;
    }
    
    // Método abstracto que debe ser implementado por las subclases
    public abstract double calcularArea();
    
    // Método concreto disponible para todas las subclases
    public void mostrarInfo() {
        System.out.println("Figura: " + nombre + ", Área: " + calcularArea());
    }
    
    public String getNombre() {
        return nombre;
    }
}