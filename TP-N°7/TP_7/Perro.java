// Subclase Perro
public class Perro extends Animal {
    private String raza;
    
    public Perro(String nombre, int edad, String raza) {
        super(nombre, "Canino", edad);
        this.raza = raza;
    }
    
    @Override
    public void hacerSonido() {
        System.out.println(nombre + " hace: ¡Guau guau!");
    }
    
    // Método específico de Perro
    public void jugar() {
        System.out.println(nombre + " está jugando con la pelota");
    }
    
    @Override
    public void describirAnimal() {
        super.describirAnimal();
        System.out.println("Raza: " + raza);
    }
    
    public String getRaza() {
        return raza;
    }
}