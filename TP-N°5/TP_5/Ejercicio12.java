// Ejercicio 12: Impuesto - Contribuyente - Calculadora
// Asociación unidireccional: Impuesto → Contribuyente
// Dependencia de uso: Calculadora.calcular(Impuesto)

class Contribuyente {
    String nombre;
    String cuil;
    public Contribuyente(String nombre, String cuil) {
        this.nombre = nombre;
        this.cuil = cuil;
    }
}

class Impuesto {
    double monto;
    Contribuyente contribuyente;
    public Impuesto(double monto, Contribuyente contribuyente) {
        this.monto = monto;
        this.contribuyente = contribuyente;
    }
}

class Calculadora {
    public void calcular(Impuesto impuesto) {
        System.out.println("Calculando impuesto de $" + impuesto.monto + " para " + impuesto.contribuyente.nombre);
    }
}

public class Ejercicio12 {
    public static void main(String[] args) {
        Contribuyente contrib = new Contribuyente("Empresa S.A.", "20-12345678-9");
        Impuesto impuesto = new Impuesto(50000.0, contrib);
        Calculadora calc = new Calculadora();
        calc.calcular(impuesto);
    }
}
