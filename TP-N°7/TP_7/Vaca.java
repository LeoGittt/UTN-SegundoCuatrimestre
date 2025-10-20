// Subclase Vaca
public class Vaca extends Animal {
    private double produccionLeche; // litros por día
    
    public Vaca(String nombre, int edad, double produccionLeche) {
        super(nombre, "Bovino", edad);
        this.produccionLeche = produccionLeche;
    }
    
    @Override
    public void hacerSonido() {
        System.out.println(nombre + " hace: ¡Muuu muuu!");
    }
    
    // Método específico de Vaca
    public void pastar() {
        System.out.println(nombre + " está pastando en el campo");
    }
    
    @Override
    public void describirAnimal() {
        super.describirAnimal();
        System.out.println("Producción de leche: " + produccionLeche + " litros/día");
    }
    
    public double getProduccionLeche() {
        return produccionLeche;
    }
}