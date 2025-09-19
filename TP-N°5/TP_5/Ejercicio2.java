// Ejercicio 2: Celular - Batería - Usuario
// Agregación: Celular → Batería
// Asociación bidireccional: Celular ↔ Usuario

class Bateria {
    String modelo;
    int capacidad;
    public Bateria(String modelo, int capacidad) {
        this.modelo = modelo;
        this.capacidad = capacidad;
    }
}

class UsuarioCelular {
    String nombre;
    String dni;
    Celular celular;
    public UsuarioCelular(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setCelular(Celular celular) {
        this.celular = celular;
    }
}

class Celular {
    String imei;
    String marca;
    String modelo;
    Bateria bateria;
    UsuarioCelular usuario;
    public Celular(String imei, String marca, String modelo, Bateria bateria, UsuarioCelular usuario) {
        this.imei = imei;
        this.marca = marca;
        this.modelo = modelo;
        this.bateria = bateria;
        this.usuario = usuario;
        usuario.setCelular(this);
    }
}

public class Ejercicio2 {
    public static void main(String[] args) {
        UsuarioCelular usuario = new UsuarioCelular("Ana", "87654321");
        Bateria bateria = new Bateria("B-1000", 4000);
        Celular celular = new Celular("123456789012345", "Samsung", "S21", bateria, usuario);
        System.out.println("Celular de " + usuario.nombre + ", IMEI: " + celular.imei);
    }
}
