// Ejercicio 8: Documento - FirmaDigital - Usuario
// Composición: Documento → FirmaDigital
// Agregación: FirmaDigital → Usuario

class UsuarioFirma {
    String nombre;
    String email;
    public UsuarioFirma(String nombre, String email) {
        this.nombre = nombre;
        this.email = email;
    }
}

class FirmaDigital {
    String codigoHash;
    String fecha;
    UsuarioFirma usuario;
    public FirmaDigital(String codigoHash, String fecha, UsuarioFirma usuario) {
        this.codigoHash = codigoHash;
        this.fecha = fecha;
        this.usuario = usuario;
    }
}

class Documento {
    String titulo;
    String contenido;
    FirmaDigital firma;
    public Documento(String titulo, String contenido, FirmaDigital firma) {
        this.titulo = titulo;
        this.contenido = contenido;
        this.firma = firma;
    }
}

public class Ejercicio8 {
    public static void main(String[] args) {
        UsuarioFirma usuario = new UsuarioFirma("Mario", "mario@mail.com");
        FirmaDigital firma = new FirmaDigital("HASH123", "2025-09-19", usuario);
        Documento doc = new Documento("Contrato", "Contenido del contrato", firma);
        System.out.println("Documento: " + doc.titulo + ", Firmado por: " + usuario.nombre);
    }
}
