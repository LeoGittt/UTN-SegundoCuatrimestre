// Ejercicio 4: TarjetaDeCrédito - Cliente - Banco
// Asociación bidireccional: TarjetaDeCrédito ↔ Cliente
// Agregación: TarjetaDeCrédito → Banco

class Cliente {
    String nombre;
    String dni;
    TarjetaDeCredito tarjeta;
    public Cliente(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setTarjeta(TarjetaDeCredito tarjeta) {
        this.tarjeta = tarjeta;
    }
}

class Banco {
    String nombre;
    String cuit;
    public Banco(String nombre, String cuit) {
        this.nombre = nombre;
        this.cuit = cuit;
    }
}

class TarjetaDeCredito {
    String numero;
    String fechaVencimiento;
    Cliente cliente;
    Banco banco;
    public TarjetaDeCredito(String numero, String fechaVencimiento, Cliente cliente, Banco banco) {
        this.numero = numero;
        this.fechaVencimiento = fechaVencimiento;
        this.cliente = cliente;
        this.banco = banco;
        cliente.setTarjeta(this);
    }
}

public class Ejercicio4 {
    public static void main(String[] args) {
        Cliente cliente = new Cliente("Carlos", "11122333");
        Banco banco = new Banco("Banco Nación", "30-12345678-9");
        TarjetaDeCredito tarjeta = new TarjetaDeCredito("1234-5678-9012-3456", "12/30", cliente, banco);
        System.out.println("Tarjeta de " + cliente.nombre + ", Banco: " + banco.nombre);
    }
}
