// Clase PayPal - Implementa Pago (sin descuentos)
public class PayPal implements Pago {
    private String email;
    private String password;
    
    public PayPal(String email, String password) {
        this.email = email;
        this.password = password;
    }
    
    @Override
    public boolean procesarPago(double monto) {
        System.out.println("=== PROCESANDO PAGO CON PAYPAL ===");
        System.out.println("Cuenta PayPal: " + email);
        
        // Simular validación
        if (monto <= 0) {
            System.out.println("ERROR: Monto inválido");
            return false;
        }
        
        if (!validarCredenciales()) {
            System.out.println("ERROR: Credenciales inválidas");
            return false;
        }
        
        System.out.printf("Monto a cobrar: $%.2f%n", monto);
        System.out.println("Conectando con PayPal...");
        System.out.println("Pago procesado exitosamente");
        System.out.println("Recibo enviado a: " + email);
        System.out.println("===============================");
        
        return true;
    }
    
    @Override
    public String getTipo() {
        return "PayPal";
    }
    
    private boolean validarCredenciales() {
        // Simulación simple de validación
        return email != null && !email.isEmpty() && 
               password != null && password.length() >= 6;
    }
    
    // Getters y setters
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
}