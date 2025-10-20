// Ejercicio Principal Parte 1: Sistema de E-commerce con Interfaces
public class EjercicioEcommerce {
    
    public static void main(String[] args) {
        System.out.println("=== SISTEMA DE E-COMMERCE CON INTERFACES ===");
        ejecutarSistemaEcommerce();
    }
    
    public static void ejecutarSistemaEcommerce() {
        // Crear cliente
        Cliente cliente1 = new Cliente("Juan Pérez", "juan@email.com", "555-1234");
        
        // Crear productos
        Producto producto1 = new Producto("Laptop Gaming", 1500.00, 1);
        Producto producto2 = new Producto("Mouse Gamer", 75.50, 2);
        Producto producto3 = new Producto("Teclado Mecánico", 120.00, 1);
        
        // Mostrar productos individualmente
        System.out.println("\n=== PRODUCTOS DISPONIBLES ===");
        System.out.println(producto1);
        System.out.println(producto2);
        System.out.println(producto3);
        
        // Crear pedido
        Pedido pedido1 = new Pedido(cliente1);
        
        // Agregar productos al pedido
        pedido1.agregarProducto(producto1);
        pedido1.agregarProducto(producto2);
        pedido1.agregarProducto(producto3);
        
        // Mostrar detalle del pedido
        pedido1.mostrarDetalle();
        
        // Cambiar estados del pedido (esto activa las notificaciones)
        pedido1.cambiarEstado("CONFIRMADO");
        pedido1.cambiarEstado("EN_PREPARACION");
        pedido1.cambiarEstado("ENVIADO");
        
        // Procesar pagos con diferentes métodos
        System.out.println("\n=== PROCESAMIENTO DE PAGOS ===");
        
        // Pago con tarjeta de crédito (con descuento)
        TarjetaCredito tarjeta = new TarjetaCredito("1234567890123456", "Juan Pérez", "12/25", 5.0);
        boolean pagoTarjeta = tarjeta.procesarPago(pedido1.calcularTotal());
        
        if (pagoTarjeta) {
            pedido1.cambiarEstado("PAGADO");
        }
        
        System.out.println("\n" + "=".repeat(50));
        
        // Crear segundo pedido para demostrar PayPal
        Cliente cliente2 = new Cliente("María García", "maria@email.com", "555-5678");
        Pedido pedido2 = new Pedido(cliente2);
        
        Producto producto4 = new Producto("Smartphone", 800.00, 1);
        pedido2.agregarProducto(producto4);
        
        pedido2.mostrarDetalle();
        
        // Pago con PayPal (sin descuento)
        PayPal paypal = new PayPal("maria@email.com", "password123");
        boolean pagoPayPal = paypal.procesarPago(pedido2.calcularTotal());
        
        if (pagoPayPal) {
            pedido2.cambiarEstado("PAGADO");
            pedido2.cambiarEstado("COMPLETADO");
        }
        
        // Demostrar polimorfismo con diferentes tipos de pago
        System.out.println("\n=== DEMOSTRACIÓN DE POLIMORFISMO ===");
        Pago[] metodosPago = {
            new TarjetaCredito("9876543210987654", "Ana López", "06/26", 3.0),
            new PayPal("ana@email.com", "securepass")
        };
        
        double montoEjemplo = 500.00;
        for (Pago metodo : metodosPago) {
            System.out.println("Procesando con: " + metodo.getTipo());
            metodo.procesarPago(montoEjemplo);
            System.out.println();
        }
        
        System.out.println("=== SISTEMA E-COMMERCE FINALIZADO ===");
    }
}