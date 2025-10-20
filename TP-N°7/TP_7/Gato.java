// Subclase Gato
public class Gato extends Animal {
    private boolean esIndoor;
    
    public Gato(String nombre, int edad, boolean esIndoor) {
        super(nombre, "Felino", edad);
        this.esIndoor = esIndoor;
    }
    
    @Override
    public void hacerSonido() {
        System.out.println(nombre + " hace: ¡Miau miau!");
    }
    
    // Método específico de Gato
    public void trepar() {
        System.out.println(nombre + " está trepando por el árbol");
    }
    
    @Override
    public void describirAnimal() {
        super.describirAnimal();
        System.out.println("Tipo: " + (esIndoor ? "Gato de interior" : "Gato de exterior"));
    }
    
    public boolean isEsIndoor() {
        return esIndoor;
    }
}