// Ejercicio 5: Computadora - PlacaMadre - Propietario
// Composición: Computadora → PlacaMadre
// Asociación bidireccional: Computadora ↔ Propietario

class PlacaMadre {
    String modelo;
    String chipset;
    public PlacaMadre(String modelo, String chipset) {
        this.modelo = modelo;
        this.chipset = chipset;
    }
}

class Propietario {
    String nombre;
    String dni;
    Computadora computadora;
    public Propietario(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setComputadora(Computadora computadora) {
        this.computadora = computadora;
    }
}

class Computadora {
    String marca;
    String numeroSerie;
    PlacaMadre placaMadre;
    Propietario propietario;
    public Computadora(String marca, String numeroSerie, PlacaMadre placaMadre, Propietario propietario) {
        this.marca = marca;
        this.numeroSerie = numeroSerie;
        this.placaMadre = placaMadre;
        this.propietario = propietario;
        propietario.setComputadora(this);
    }
}

public class Ejercicio5 {
    public static void main(String[] args) {
        PlacaMadre placa = new PlacaMadre("ASUS B450", "AMD B450");
        Propietario propietario = new Propietario("Lucía", "22233444");
        Computadora compu = new Computadora("HP", "SN12345", placa, propietario);
        System.out.println("Computadora de " + propietario.nombre + ", Marca: " + compu.marca);
    }
}
