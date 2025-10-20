// Subclase Pájaro
public class Pajaro extends Animal {
    private boolean puedeVolar;
    private String colorPlumaje;
    
    public Pajaro(String nombre, int edad, boolean puedeVolar, String colorPlumaje) {
        super(nombre, "Ave", edad);
        this.puedeVolar = puedeVolar;
        this.colorPlumaje = colorPlumaje;
    }
    
    @Override
    public void hacerSonido() {
        System.out.println(nombre + " hace: ¡Pío pío!");
    }
    
    // Método específico de Pájaro
    public void volar() {
        if (puedeVolar) {
            System.out.println(nombre + " está volando por el cielo");
        } else {
            System.out.println(nombre + " no puede volar");
        }
    }
    
    @Override
    public void describirAnimal() {
        super.describirAnimal();
        System.out.println("Color del plumaje: " + colorPlumaje);
        System.out.println("Puede volar: " + (puedeVolar ? "Sí" : "No"));
    }
    
    public boolean isPuedeVolar() {
        return puedeVolar;
    }
    
    public String getColorPlumaje() {
        return colorPlumaje;
    }
}