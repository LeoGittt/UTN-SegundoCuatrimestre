// Subclase EmpleadoTemporal
public class EmpleadoTemporal extends Empleado {
    private int horasTrabajadas;
    private double tarifaPorHora;
    
    public EmpleadoTemporal(String nombre, String id, int horasTrabajadas, double tarifaPorHora) {
        super(nombre, id, 0); // No tiene sueldo base fijo
        this.horasTrabajadas = horasTrabajadas;
        this.tarifaPorHora = tarifaPorHora;
    }
    
    @Override
    public double calcularSueldo() {
        // Pago por horas trabajadas
        double sueldoRegular = Math.min(horasTrabajadas, 160) * tarifaPorHora; // máximo 160 horas regulares
        double horasExtra = Math.max(0, horasTrabajadas - 160);
        double pagoHorasExtra = horasExtra * tarifaPorHora * 1.5; // 50% extra por horas adicionales
        return sueldoRegular + pagoHorasExtra;
    }
    
    @Override
    public void mostrarInfo() {
        super.mostrarInfo();
        System.out.println("Tipo: Empleado Temporal");
        System.out.println("Horas trabajadas: " + horasTrabajadas);
        System.out.println("Tarifa por hora: $" + tarifaPorHora);
    }
    
    public int getHorasTrabajadas() {
        return horasTrabajadas;
    }
    
    public double getTarifaPorHora() {
        return tarifaPorHora;
    }
}