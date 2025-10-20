// Ejercicio 4: Animales y comportamiento sobrescrito
// Este ejercicio demuestra sobrescritura de métodos con @Override y polimorfismo
// Las clases Animal, Perro, Gato, Vaca y Pajaro están definidas en archivos separados

public class Ejercicio4_Animales {
    public static void main(String[] args) {
        System.out.println("=== Ejercicio 4: Animales y comportamiento sobrescrito ===");
        
        // Crear lista de animales (polimorfismo)
        Animal[] animales = {
            new Perro("Rex", 5, "Pastor Alemán"),
            new Gato("Whiskers", 3, true),
            new Vaca("Lola", 4, 25.5),
            new Pajaro("Tweety", 2, true, "Amarillo"),
            new Perro("Buddy", 7, "Golden Retriever"),
            new Gato("Mittens", 2, false)
        };
        
        // Mostrar sonidos de todos los animales usando polimorfismo
        System.out.println("Concierto de animales:");
        for (Animal animal : animales) {
            animal.hacerSonido();
        }
        
        System.out.println("\n" + "=".repeat(50));
        
        // Mostrar información completa de cada animal
        System.out.println("Información detallada de animales:");
        for (Animal animal : animales) {
            animal.describirAnimal();
            animal.dormir();
            System.out.println("-".repeat(40));
        }
        
        // Demostrar comportamientos específicos usando instanceof
        System.out.println("Comportamientos específicos por tipo:");
        for (Animal animal : animales) {
            System.out.println("\n" + animal.getNombre() + ":");
            
            if (animal instanceof Perro) {
                Perro perro = (Perro) animal;
                perro.jugar();
            } else if (animal instanceof Gato) {
                Gato gato = (Gato) animal;
                gato.trepar();
            } else if (animal instanceof Vaca) {
                Vaca vaca = (Vaca) animal;
                vaca.pastar();
            } else if (animal instanceof Pajaro) {
                Pajaro pajaro = (Pajaro) animal;
                pajaro.volar();
            }
        }
        
        // Estadísticas
        System.out.println("\n--- Estadísticas del zoológico ---");
        int countPerros = 0, countGatos = 0, countVacas = 0, countPajaros = 0;
        int edadTotal = 0;
        
        for (Animal animal : animales) {
            edadTotal += animal.getEdad();
            
            if (animal instanceof Perro) {
                countPerros++;
            } else if (animal instanceof Gato) {
                countGatos++;
            } else if (animal instanceof Vaca) {
                countVacas++;
            } else if (animal instanceof Pajaro) {
                countPajaros++;
            }
        }
        
        System.out.println("Total de animales: " + animales.length);
        System.out.println("Perros: " + countPerros);
        System.out.println("Gatos: " + countGatos);
        System.out.println("Vacas: " + countVacas);
        System.out.println("Pájaros: " + countPajaros);
        System.out.println("Edad promedio: " + String.format("%.1f", (double) edadTotal / animales.length) + " años");
    }
}