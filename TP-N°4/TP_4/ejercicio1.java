// Sistema de Gestión de Empleados
// Trabajo Práctico 4: Programación Orientada a Objetos II

class Empleado {
    // Atributos privados (encapsulamiento)
    private int id;
    private String nombre;
    private String puesto;
    private double salario;
    private static int totalEmpleados = 0;
    private static int proximoId = 1;

    // Constructor que recibe todos los atributos
    public Empleado(int id, String nombre, String puesto, double salario) {
        this.id = id;
        this.nombre = nombre;
        this.puesto = puesto;
        this.salario = salario;
        totalEmpleados++;
        if (id >= proximoId) {
            proximoId = id + 1;
        }
    }

    // Constructor que recibe solo nombre y puesto, id automático y salario por defecto
    public Empleado(String nombre, String puesto) {
        this.id = proximoId++;
        this.nombre = nombre;
        this.puesto = puesto;
        this.salario = 50000.0; // Salario por defecto
        totalEmpleados++;
    }

    // Métodos sobrecargados para actualizar salario
    public void actualizarSalario(double porcentaje) {
        if (porcentaje > 0) {
            this.salario += this.salario * (porcentaje / 100);
        }
    }

    public void actualizarSalario(int cantidadFija) {
        if (cantidadFija > 0) {
            this.salario += cantidadFija;
        }
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getPuesto() {
        return puesto;
    }

    public void setPuesto(String puesto) {
        this.puesto = puesto;
    }

    public double getSalario() {
        return salario;
    }

    public void setSalario(double salario) {
        this.salario = salario;
    }

    // Método toString
    @Override
    public String toString() {
        return "Empleado { " +
                "ID: " + id +
                ", Nombre: '" + nombre + '\'' +
                ", Puesto: '" + puesto + '\'' +
                ", Salario: $" + String.format("%.2f", salario) +
                " }";
    }

    // Método estático para mostrar total de empleados
    public static int mostrarTotalEmpleados() {
        return totalEmpleados;
    }
}

public class ejercicio1 {
    public static void main(String[] args) {
        // Instanciar empleados usando ambos constructores
        Empleado emp1 = new Empleado(100, "Ana Torres", "Gerente", 120000);
        Empleado emp2 = new Empleado("Luis Pérez", "Analista");
        Empleado emp3 = new Empleado("María Gómez", "Desarrollador");

        // Actualizar salario con porcentaje
        emp2.actualizarSalario(10.0); // 10% de aumento
        // Actualizar salario con cantidad fija
        emp3.actualizarSalario(8000); // $8000 de aumento

        // Imprimir información de cada empleado
        System.out.println(emp1);
        System.out.println(emp2);
        System.out.println(emp3);

        // Mostrar total de empleados
        System.out.println("Total de empleados creados: " + Empleado.mostrarTotalEmpleados());
    }
}
