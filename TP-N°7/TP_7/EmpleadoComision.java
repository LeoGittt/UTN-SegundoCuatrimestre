// Subclase EmpleadoComision
public class EmpleadoComision extends Empleado {
    private double ventasRealizadas;
    private double porcentajeComision;
    
    public EmpleadoComision(String nombre, String id, double sueldoBase, double ventasRealizadas, double porcentajeComision) {
        super(nombre, id, sueldoBase);
        this.ventasRealizadas = ventasRealizadas;
        this.porcentajeComision = porcentajeComision;
    }
    
    @Override
    public double calcularSueldo() {
        // Sueldo base + comisión por ventas
        double comision = ventasRealizadas * (porcentajeComision / 100);
        return sueldoBase + comision;
    }
    
    @Override
    public void mostrarInfo() {
        super.mostrarInfo();
        System.out.println("Tipo: Empleado por Comisión");
        System.out.println("Ventas realizadas: $" + ventasRealizadas);
        System.out.println("Porcentaje comisión: " + porcentajeComision + "%");
    }
    
    public double getVentasRealizadas() {
        return ventasRealizadas;
    }
    
    public double getPorcentajeComision() {
        return porcentajeComision;
    }
}