// Ejercicio 1: Pasaporte - Foto - Titular
// Composición: Pasaporte → Foto
// Asociación bidireccional: Pasaporte ↔ Titular

class Foto {
    String imagen;
    String formato;
    public Foto(String imagen, String formato) {
        this.imagen = imagen;
        this.formato = formato;
    }
}

class Titular {
    String nombre;
    String dni;
    Pasaporte pasaporte;
    public Titular(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setPasaporte(Pasaporte pasaporte) {
        this.pasaporte = pasaporte;
    }
}

class Pasaporte {
    String numero;
    String fechaEmision;
    Foto foto;
    Titular titular;
    public Pasaporte(String numero, String fechaEmision, Foto foto, Titular titular) {
        this.numero = numero;
        this.fechaEmision = fechaEmision;
        this.foto = foto;
        this.titular = titular;
        titular.setPasaporte(this);
    }
}

public class Ejercicio1 {
    public static void main(String[] args) {
        Titular titular = new Titular("Juan Perez", "12345678");
        Foto foto = new Foto("foto.jpg", "jpg");
        Pasaporte pasaporte = new Pasaporte("A123456", "2025-01-01", foto, titular);
        System.out.println("Pasaporte de " + titular.nombre + ", número: " + pasaporte.numero);
    }
}
