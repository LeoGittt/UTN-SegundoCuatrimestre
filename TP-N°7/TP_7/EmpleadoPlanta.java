// Subclase EmpleadoPlanta
public class EmpleadoPlanta extends Empleado {
    private double bonificacion;
    private int antiguedad; // años de antigüedad
    
    public EmpleadoPlanta(String nombre, String id, double sueldoBase, double bonificacion, int antiguedad) {
        super(nombre, id, sueldoBase);
        this.bonificacion = bonificacion;
        this.antiguedad = antiguedad;
    }
    
    @Override
    public double calcularSueldo() {
        // Sueldo base + bonificación + 2% por año de antigüedad
        double incrementoAntiguedad = sueldoBase * (antiguedad * 0.02);
        return sueldoBase + bonificacion + incrementoAntiguedad;
    }
    
    @Override
    public void mostrarInfo() {
        super.mostrarInfo();
        System.out.println("Tipo: Empleado de Planta");
        System.out.println("Bonificación: $" + bonificacion);
        System.out.println("Antigüedad: " + antiguedad + " años");
    }
    
    public double getBonificacion() {
        return bonificacion;
    }
    
    public int getAntiguedad() {
        return antiguedad;
    }
}