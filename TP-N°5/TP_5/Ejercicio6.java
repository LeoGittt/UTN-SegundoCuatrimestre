// Ejercicio 6: Reserva - Cliente - Mesa
// Asociación unidireccional: Reserva → Cliente
// Agregación: Reserva → Mesa

class ClienteReserva {
    String nombre;
    String telefono;
    public ClienteReserva(String nombre, String telefono) {
        this.nombre = nombre;
        this.telefono = telefono;
    }
}

class Mesa {
    int numero;
    int capacidad;
    public Mesa(int numero, int capacidad) {
        this.numero = numero;
        this.capacidad = capacidad;
    }
}

class Reserva {
    String fecha;
    String hora;
    ClienteReserva cliente;
    Mesa mesa;
    public Reserva(String fecha, String hora, ClienteReserva cliente, Mesa mesa) {
        this.fecha = fecha;
        this.hora = hora;
        this.cliente = cliente;
        this.mesa = mesa;
    }
}

public class Ejercicio6 {
    public static void main(String[] args) {
        ClienteReserva cliente = new ClienteReserva("Pedro", "555-1234");
        Mesa mesa = new Mesa(10, 4);
        Reserva reserva = new Reserva("2025-09-20", "21:00", cliente, mesa);
        System.out.println("Reserva para " + cliente.nombre + ", Mesa: " + mesa.numero);
    }
}
