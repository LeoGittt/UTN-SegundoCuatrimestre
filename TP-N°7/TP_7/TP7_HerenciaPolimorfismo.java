// Trabajo Práctico 7: Herencia y Polimorfismo - Archivo Integrador
// Este archivo ejecuta todos los ejercicios del TP7
// Todas las clases están definidas en sus archivos separados siguiendo buenas prácticas de Java

import java.util.*;

public class TP7_HerenciaPolimorfismo {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("===============================================");
        System.out.println("  TRABAJO PRÁCTICO 7: HERENCIA Y POLIMORFISMO");
        System.out.println("===============================================");
        
        while (true) {
            System.out.println("\nSeleccione el ejercicio que desea ejecutar:");
            System.out.println("1. Vehículos y herencia básica");
            System.out.println("2. Figuras geométricas y métodos abstractos");
            System.out.println("3. Empleados y polimorfismo");
            System.out.println("4. Animales y comportamiento sobrescrito");
            System.out.println("5. Demostración completa de conceptos");
            System.out.println("0. Salir");
            System.out.print("\nIngrese su opción: ");
            
            int opcion = scanner.nextInt();
            
            switch (opcion) {
                case 1:
                    ejecutarEjercicio1();
                    break;
                case 2:
                    ejecutarEjercicio2();
                    break;
                case 3:
                    ejecutarEjercicio3();
                    break;
                case 4:
                    ejecutarEjercicio4();
                    break;
                case 5:
                    demostracionCompleta();
                    break;
                case 0:
                    System.out.println("¡Gracias por usar el programa!");
                    scanner.close();
                    return;
                default:
                    System.out.println("Opción no válida. Intente nuevamente.");
            }
            
            System.out.println("\nPresione Enter para continuar...");
            scanner.nextLine();
            scanner.nextLine();
        }
    }
    
    // Método para ejecutar el Ejercicio 1
    public static void ejecutarEjercicio1() {
        System.out.println("\n=== EJERCICIO 1: VEHÍCULOS Y HERENCIA BÁSICA ===");
        
        // Instanciar vehículos
        Auto auto1 = new Auto("Toyota", "Corolla", 4);
        Auto auto2 = new Auto("Honda", "Civic", 2);
        
        System.out.println("Creación de instancias directas:");
        auto1.mostrarInfo();
        auto2.mostrarInfo();
        
        // Demostrar upcasting
        System.out.println("\nDemostración de UPCASTING:");
        Vehiculo vehiculoGenerico = new Auto("Ford", "Focus", 5);
        vehiculoGenerico.mostrarInfo(); // Polimorfismo en acción
        
        // Demostrar instanceof y downcasting
        System.out.println("\nDemostración de INSTANCEOF y DOWNCASTING:");
        if (vehiculoGenerico instanceof Auto) {
            Auto autoConvertido = (Auto) vehiculoGenerico;
            System.out.println("Downcasting exitoso - Puertas: " + autoConvertido.getCantidadPuertas());
        }
    }
    
    // Método para ejecutar el Ejercicio 2
    public static void ejecutarEjercicio2() {
        System.out.println("\n=== EJERCICIO 2: FIGURAS GEOMÉTRICAS Y MÉTODOS ABSTRACTOS ===");
        
        // Array polimórfico de figuras
        Figura[] figuras = {
            new Circulo(5.0),
            new Rectangulo(4.0, 6.0),
            new Triangulo(3.0, 8.0)
        };
        
        System.out.println("Cálculo de áreas usando polimorfismo:");
        double areaTotal = 0;
        for (Figura figura : figuras) {
            System.out.printf("%s: %.2f unidades cuadradas%n", 
                            figura.getNombre(), figura.calcularArea());
            areaTotal += figura.calcularArea();
        }
        
        System.out.printf("\nÁrea total de todas las figuras: %.2f%n", areaTotal);
    }
    
    // Método para ejecutar el Ejercicio 3
    public static void ejecutarEjercicio3() {
        System.out.println("\n=== EJERCICIO 3: EMPLEADOS Y POLIMORFISMO ===");
        
        // Lista polimórfica de empleados
        List<Empleado> empleados = Arrays.asList(
            new EmpleadoPlanta("Ana García", "EMP001", 80000, 15000, 5),
            new EmpleadoTemporal("Carlos López", "TEMP001", 180, 500),
            new EmpleadoComision("María Rodríguez", "COM001", 40000, 250000, 3)
        );
        
        System.out.println("Cálculo de sueldos usando polimorfismo:");
        double totalNomina = 0;
        
        for (Empleado emp : empleados) {
            double sueldo = emp.calcularSueldo();
            System.out.printf("%s: $%.2f%n", emp.getNombre(), sueldo);
            totalNomina += sueldo;
            
            // Usar instanceof para clasificación
            if (emp instanceof EmpleadoPlanta) {
                System.out.println("  -> Empleado de planta");
            } else if (emp instanceof EmpleadoTemporal) {
                System.out.println("  -> Empleado temporal");
            } else if (emp instanceof EmpleadoComision) {
                System.out.println("  -> Empleado por comisión");
            }
        }
        
        System.out.printf("\nNómina total: $%.2f%n", totalNomina);
    }
    
    // Método para ejecutar el Ejercicio 4
    public static void ejecutarEjercicio4() {
        System.out.println("\n=== EJERCICIO 4: ANIMALES Y COMPORTAMIENTO SOBRESCRITO ===");
        
        // Array polimórfico de animales
        Animal[] animales = {
            new Perro("Rex", 5, "Pastor Alemán"),
            new Gato("Whiskers", 3, true),
            new Vaca("Lola", 4, 25.5)
        };
        
        System.out.println("Sonidos de animales usando polimorfismo:");
        for (Animal animal : animales) {
            System.out.print(animal.getNombre() + " - ");
            animal.hacerSonido(); // Método sobrescrito
        }
        
        System.out.println("\nComportamientos específicos:");
        for (Animal animal : animales) {
            if (animal instanceof Perro) {
                ((Perro) animal).jugar();
            } else if (animal instanceof Gato) {
                ((Gato) animal).trepar();
            } else if (animal instanceof Vaca) {
                ((Vaca) animal).pastar();
            }
        }
    }
    
    // Demostración completa de todos los conceptos
    public static void demostracionCompleta() {
        System.out.println("\n=== DEMOSTRACIÓN COMPLETA DE CONCEPTOS OOP ===");
        
        System.out.println("\n1. HERENCIA - Relación 'es-un':");
        Auto miAuto = new Auto("BMW", "X3", 4);
        System.out.println("Un Auto ES-UN Vehículo: " + (miAuto instanceof Vehiculo));
        
        System.out.println("\n2. POLIMORFISMO - Mismo método, diferente comportamiento:");
        Animal[] zoologico = {
            new Perro("Bobby", 3, "Beagle"),
            new Gato("Salem", 2, false)
        };
        
        for (Animal animal : zoologico) {
            animal.hacerSonido(); // Mismo método, comportamiento diferente
        }
        
        System.out.println("\n3. CLASES ABSTRACTAS - No se pueden instanciar:");
        System.out.println("No podemos hacer: new Animal() o new Figura()");
        System.out.println("Pero sí podemos usar referencias de tipo abstracto");
        
        System.out.println("\n4. UPCASTING AUTOMÁTICO:");
        Vehiculo vehiculo = new Auto("Tesla", "Model 3", 4); // Upcasting implícito
        System.out.println("Referencia tipo Vehiculo apuntando a Auto");
        
        System.out.println("\n5. DOWNCASTING CON INSTANCEOF:");
        if (vehiculo instanceof Auto) {
            Auto autoEspecifico = (Auto) vehiculo; // Downcasting explícito
            System.out.println("Downcasting seguro realizado");
            System.out.println("Puertas: " + autoEspecifico.getCantidadPuertas());
        }
        
        System.out.println("\n6. MODIFICADORES DE ACCESO:");
        System.out.println("- protected: Accesible en subclases");
        System.out.println("- private: Solo en la misma clase");
        System.out.println("- public: Accesible desde cualquier lugar");
        
        System.out.println("\n7. SUPER - Llamada al constructor padre:");
        System.out.println("En Auto: super(marca, modelo) llama al constructor de Vehículo");
        
        System.out.println("\n¡Conceptos de OOP demostrados exitosamente!");
    }
}