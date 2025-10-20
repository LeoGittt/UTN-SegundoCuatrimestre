// Clase base Vehiculo
public class Vehiculo {
    protected String marca;
    protected String modelo;
    
    public Vehiculo(String marca, String modelo) {
        this.marca = marca;
        this.modelo = modelo;
    }
    
    public void mostrarInfo() {
        System.out.println("Vehículo - Marca: " + marca + ", Modelo: " + modelo);
    }
    
    // Getters
    public String getMarca() {
        return marca;
    }
    
    public String getModelo() {
        return modelo;
    }
}