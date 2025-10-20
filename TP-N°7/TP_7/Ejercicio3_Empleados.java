// Ejercicio 3: Empleados y polimorfismo
// Este ejercicio demuestra polimorfismo avanzado e instanceof para clasificación
// Las clases Empleado, EmpleadoPlanta, EmpleadoTemporal y EmpleadoComision están en archivos separados

public class Ejercicio3_Empleados {
    public static void main(String[] args) {
        System.out.println("=== Ejercicio 3: Empleados y polimorfismo ===");
        
        // Crear lista de empleados (polimorfismo)
        Empleado[] empleados = {
            new EmpleadoPlanta("Ana García", "EMP001", 80000, 15000, 5),
            new EmpleadoTemporal("Carlos López", "TEMP001", 180, 500),
            new EmpleadoComision("María Rodríguez", "COM001", 40000, 250000, 3),
            new EmpleadoPlanta("Juan Martínez", "EMP002", 75000, 12000, 3),
            new EmpleadoTemporal("Sofía Fernández", "TEMP002", 120, 450)
        };
        
        // Mostrar información de todos los empleados usando polimorfismo
        System.out.println("Información de empleados:");
        double totalSueldos = 0;
        for (Empleado emp : empleados) {
            emp.mostrarInfo();
            totalSueldos += emp.calcularSueldo();
            System.out.println("-".repeat(40));
        }
        
        // Clasificar empleados usando instanceof
        System.out.println("\n--- Clasificación de empleados ---");
        int countPlanta = 0, countTemporal = 0, countComision = 0;
        
        for (Empleado emp : empleados) {
            if (emp instanceof EmpleadoPlanta) {
                countPlanta++;
                EmpleadoPlanta empPlanta = (EmpleadoPlanta) emp;
                System.out.println("Empleado de planta: " + emp.getNombre() + 
                                 " (Antigüedad: " + empPlanta.getAntiguedad() + " años)");
            } else if (emp instanceof EmpleadoTemporal) {
                countTemporal++;
                EmpleadoTemporal empTemp = (EmpleadoTemporal) emp;
                System.out.println("Empleado temporal: " + emp.getNombre() + 
                                 " (Horas: " + empTemp.getHorasTrabajadas() + ")");
            } else if (emp instanceof EmpleadoComision) {
                countComision++;
                EmpleadoComision empCom = (EmpleadoComision) emp;
                System.out.println("Empleado por comisión: " + emp.getNombre() + 
                                 " (Ventas: $" + empCom.getVentasRealizadas() + ")");
            }
        }
        
        // Estadísticas
        System.out.println("\n--- Estadísticas ---");
        System.out.println("Total empleados: " + empleados.length);
        System.out.println("Empleados de planta: " + countPlanta);
        System.out.println("Empleados temporales: " + countTemporal);
        System.out.println("Empleados por comisión: " + countComision);
        System.out.println("Total sueldos: $" + String.format("%.2f", totalSueldos));
        System.out.println("Promedio sueldo: $" + String.format("%.2f", totalSueldos / empleados.length));
    }
}