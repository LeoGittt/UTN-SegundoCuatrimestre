// Excepción personalizada para validación de edad
public class EdadInvalidaException extends Exception {
    private int edadIngresada;
    
    public EdadInvalidaException(int edad) {
        super("Edad inválida: " + edad + ". La edad debe estar entre 0 y 120 años.");
        this.edadIngresada = edad;
    }
    
    public EdadInvalidaException(int edad, String mensaje) {
        super(mensaje);
        this.edadIngresada = edad;
    }
    
    public int getEdadIngresada() {
        return edadIngresada;
    }
    
    public String getDetalleError() {
        if (edadIngresada < 0) {
            return "La edad no puede ser negativa";
        } else if (edadIngresada > 120) {
            return "La edad no puede ser mayor a 120 años";
        } else {
            return "Edad inválida por razones desconocidas";
        }
    }
}