// Interfaz PagoConDescuento - Extiende Pago agregando funcionalidad de descuentos
public interface PagoConDescuento extends Pago {
    double aplicarDescuento(double monto);
    double getPorcentajeDescuento();
}