// Clase Cliente - Implementa Notificable
public class Cliente implements Notificable {
    private String nombre;
    private String email;
    private String telefono;
    
    public Cliente(String nombre, String email, String telefono) {
        this.nombre = nombre;
        this.email = email;
        this.telefono = telefono;
    }
    
    @Override
    public void notificar(String mensaje) {
        System.out.println("=== NOTIFICACIÓN PARA " + nombre.toUpperCase() + " ===");
        System.out.println("Email: " + email);
        System.out.println("Mensaje: " + mensaje);
        System.out.println("Enviado también por SMS al: " + telefono);
        System.out.println("=======================================");
    }
    
    @Override
    public String getIdentificador() {
        return email;
    }
    
    // Getters y setters
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getTelefono() {
        return telefono;
    }
    
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }
    
    @Override
    public String toString() {
        return String.format("Cliente: %s (%s)", nombre, email);
    }
}