// Clase base Animal
public class Animal {
    protected String nombre;
    protected String especie;
    protected int edad;
    
    public Animal(String nombre, String especie, int edad) {
        this.nombre = nombre;
        this.especie = especie;
        this.edad = edad;
    }
    
    // Método que será sobrescrito por las subclases
    public void hacerSonido() {
        System.out.println("El animal hace un sonido");
    }
    
    // Método concreto para describir el animal
    public void describirAnimal() {
        System.out.println("Animal: " + nombre + " (" + especie + "), Edad: " + edad + " años");
        hacerSonido(); // Polimorfismo: llama al método sobrescrito si existe
    }
    
    // Método común para todos los animales
    public void dormir() {
        System.out.println(nombre + " está durmiendo... zzz");
    }
    
    // Getters
    public String getNombre() {
        return nombre;
    }
    
    public String getEspecie() {
        return especie;
    }
    
    public int getEdad() {
        return edad;
    }
}