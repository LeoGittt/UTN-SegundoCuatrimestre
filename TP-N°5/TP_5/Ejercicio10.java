// Ejercicio 10: CuentaBancaria - ClaveSeguridad - Titular
// Composición: CuentaBancaria → ClaveSeguridad
// Asociación bidireccional: CuentaBancaria ↔ Titular

class ClaveSeguridad {
    String codigo;
    String ultimaModificacion;
    public ClaveSeguridad(String codigo, String ultimaModificacion) {
        this.codigo = codigo;
        this.ultimaModificacion = ultimaModificacion;
    }
}

class TitularCuenta {
    String nombre;
    String dni;
    CuentaBancaria cuenta;
    public TitularCuenta(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setCuenta(CuentaBancaria cuenta) {
        this.cuenta = cuenta;
    }
}

class CuentaBancaria {
    String cbu;
    double saldo;
    ClaveSeguridad clave;
    TitularCuenta titular;
    public CuentaBancaria(String cbu, double saldo, ClaveSeguridad clave, TitularCuenta titular) {
        this.cbu = cbu;
        this.saldo = saldo;
        this.clave = clave;
        this.titular = titular;
        titular.setCuenta(this);
    }
}

public class Ejercicio10 {
    public static void main(String[] args) {
        TitularCuenta titular = new TitularCuenta("Marta", "33344555");
        ClaveSeguridad clave = new ClaveSeguridad("CLV123", "2025-09-18");
        CuentaBancaria cuenta = new CuentaBancaria("1230001230001230001234", 10000.0, clave, titular);
        System.out.println("Cuenta de " + titular.nombre + ", CBU: " + cuenta.cbu);
    }
}
