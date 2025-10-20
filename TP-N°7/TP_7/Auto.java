// Subclase Auto
public class Auto extends Vehiculo {
    private int cantidadPuertas;
    
    public Auto(String marca, String modelo, int cantidadPuertas) {
        super(marca, modelo); // Llamada al constructor de la superclase
        this.cantidadPuertas = cantidadPuertas;
    }
    
    @Override
    public void mostrarInfo() {
        System.out.println("Auto - Marca: " + marca + ", Modelo: " + modelo + 
                          ", Cantidad de puertas: " + cantidadPuertas);
    }
    
    public int getCantidadPuertas() {
        return cantidadPuertas;
    }
}