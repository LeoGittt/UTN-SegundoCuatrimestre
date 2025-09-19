// Ejercicio 13: GeneradorQR - Usuario - CódigoQR
// Asociación unidireccional: CódigoQR → Usuario
// Dependencia de creación: GeneradorQR.generar(String, Usuario)

class UsuarioQR {
    String nombre;
    String email;
    public UsuarioQR(String nombre, String email) {
        this.nombre = nombre;
        this.email = email;
    }
}

class CodigoQR {
    String valor;
    UsuarioQR usuario;
    public CodigoQR(String valor, UsuarioQR usuario) {
        this.valor = valor;
        this.usuario = usuario;
    }
}

class GeneradorQR {
    public void generar(String valor, UsuarioQR usuario) {
        CodigoQR qr = new CodigoQR(valor, usuario);
        System.out.println("QR generado para " + usuario.nombre + ": " + qr.valor);
    }
}

public class Ejercicio13 {
    public static void main(String[] args) {
        UsuarioQR usuarioQR = new UsuarioQR("Nico", "nico@mail.com");
        GeneradorQR generador = new GeneradorQR();
        generador.generar("VALORQR123", usuarioQR);
    }
}
