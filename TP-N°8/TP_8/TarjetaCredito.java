// Clase TarjetaCredito - Implementa PagoConDescuento
public class TarjetaCredito implements PagoConDescuento {
    private String numero;
    private String titular;
    private String fechaVencimiento;
    private double porcentajeDescuento;
    
    public TarjetaCredito(String numero, String titular, String fechaVencimiento, double porcentajeDescuento) {
        this.numero = numero;
        this.titular = titular;
        this.fechaVencimiento = fechaVencimiento;
        this.porcentajeDescuento = porcentajeDescuento;
    }
    
    @Override
    public boolean procesarPago(double monto) {
        System.out.println("=== PROCESANDO PAGO CON TARJETA DE CRÉDITO ===");
        System.out.println("Tarjeta: ****-****-****-" + numero.substring(numero.length()-4));
        System.out.println("Titular: " + titular);
        System.out.println("Vencimiento: " + fechaVencimiento);
        
        // Simular validación
        if (monto <= 0) {
            System.out.println("ERROR: Monto inválido");
            return false;
        }
        
        if (monto > 50000) {
            System.out.println("ERROR: Monto excede el límite de la tarjeta");
            return false;
        }
        
        double montoConDescuento = aplicarDescuento(monto);
        System.out.printf("Monto original: $%.2f%n", monto);
        System.out.printf("Descuento aplicado: %.1f%%%n", porcentajeDescuento);
        System.out.printf("Monto a cobrar: $%.2f%n", montoConDescuento);
        System.out.println("Pago procesado exitosamente");
        System.out.println("===========================================");
        
        return true;
    }
    
    @Override
    public double aplicarDescuento(double monto) {
        return monto * (1 - porcentajeDescuento / 100);
    }
    
    @Override
    public String getTipo() {
        return "Tarjeta de Crédito";
    }
    
    @Override
    public double getPorcentajeDescuento() {
        return porcentajeDescuento;
    }
    
    // Getters y setters
    public String getNumero() {
        return numero;
    }
    
    public void setNumero(String numero) {
        this.numero = numero;
    }
    
    public String getTitular() {
        return titular;
    }
    
    public void setTitular(String titular) {
        this.titular = titular;
    }
    
    public String getFechaVencimiento() {
        return fechaVencimiento;
    }
    
    public void setFechaVencimiento(String fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }
    
    public void setPorcentajeDescuento(double porcentajeDescuento) {
        this.porcentajeDescuento = porcentajeDescuento;
    }
}