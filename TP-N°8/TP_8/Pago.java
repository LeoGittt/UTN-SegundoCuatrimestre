// Interfaz Pago - Define el contrato para procesar pagos
public interface Pago {
    boolean procesarPago(double monto);
    String getTipo();
}