import java.util.*;

// Clase Pedido - Implementa Pagable y gestiona notificaciones
public class Pedido implements Pagable {
    private static int contadorId = 1;
    private int id;
    private List<Producto> productos;
    private String estado;
    private Cliente cliente;
    private Date fechaCreacion;
    
    public Pedido(Cliente cliente) {
        this.id = contadorId++;
        this.productos = new ArrayList<>();
        this.estado = "CREADO";
        this.cliente = cliente;
        this.fechaCreacion = new Date();
        
        // Notificar al cliente sobre la creación del pedido
        if (cliente != null) {
            cliente.notificar("Su pedido #" + id + " ha sido creado exitosamente.");
        }
    }
    
    public void agregarProducto(Producto producto) {
        productos.add(producto);
        System.out.println("Producto agregado: " + producto.getNombre());
    }
    
    public void removerProducto(Producto producto) {
        if (productos.remove(producto)) {
            System.out.println("Producto removido: " + producto.getNombre());
        } else {
            System.out.println("Producto no encontrado en el pedido");
        }
    }
    
    @Override
    public double calcularTotal() {
        return productos.stream()
                        .mapToDouble(Producto::calcularTotal)
                        .sum();
    }
    
    public void cambiarEstado(String nuevoEstado) {
        String estadoAnterior = this.estado;
        this.estado = nuevoEstado;
        
        // Notificar al cliente sobre el cambio de estado
        if (cliente != null) {
            String mensaje = String.format(
                "Su pedido #%d ha cambiado de estado: %s → %s", 
                id, estadoAnterior, nuevoEstado
            );
            cliente.notificar(mensaje);
        }
        
        System.out.println("Estado del pedido #" + id + " cambiado a: " + nuevoEstado);
    }
    
    public void mostrarDetalle() {
        System.out.println("\n=== DETALLE DEL PEDIDO #" + id + " ===");
        System.out.println("Cliente: " + (cliente != null ? cliente.getNombre() : "Sin cliente"));
        System.out.println("Estado: " + estado);
        System.out.println("Fecha: " + fechaCreacion);
        System.out.println("Productos:");
        
        if (productos.isEmpty()) {
            System.out.println("  No hay productos en el pedido");
        } else {
            for (Producto producto : productos) {
                System.out.println("  - " + producto);
            }
        }
        
        System.out.printf("TOTAL: $%.2f%n", calcularTotal());
        System.out.println("=====================================");
    }
    
    // Getters y setters
    public int getId() {
        return id;
    }
    
    public List<Producto> getProductos() {
        return new ArrayList<>(productos); // Devolver copia para proteger la lista interna
    }
    
    public String getEstado() {
        return estado;
    }
    
    public Cliente getCliente() {
        return cliente;
    }
    
    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }
    
    public Date getFechaCreacion() {
        return fechaCreacion;
    }
}