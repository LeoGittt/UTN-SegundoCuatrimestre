// Ejercicio 2: Figuras geométricas y métodos abstractos
// Este ejercicio demuestra los conceptos de clases abstractas, métodos abstractos y polimorfismo
// Las clases Figura, Circulo, Rectangulo y Triangulo están definidas en archivos separados

public class Ejercicio2_Figuras {
    public static void main(String[] args) {
        System.out.println("=== Ejercicio 2: Figuras geométricas y métodos abstractos ===");
        
        // Crear array de figuras (polimorfismo)
        Figura[] figuras = {
            new Circulo(5.0),
            new Rectangulo(4.0, 6.0),
            new Triangulo(3.0, 8.0),
            new Circulo(2.5)
        };
        
        // Mostrar área de cada figura usando polimorfismo
        System.out.println("Áreas de las figuras:");
        for (Figura figura : figuras) {
            figura.mostrarInfo();
        }
        
        // Demostrar uso de instanceof para operaciones específicas
        System.out.println("\n--- Información específica por tipo ---");
        for (Figura figura : figuras) {
            if (figura instanceof Circulo) {
                Circulo c = (Circulo) figura;
                System.out.println("Círculo con radio: " + c.getRadio());
            } else if (figura instanceof Rectangulo) {
                Rectangulo r = (Rectangulo) figura;
                System.out.println("Rectángulo " + r.getAncho() + " x " + r.getAlto());
            } else if (figura instanceof Triangulo) {
                Triangulo t = (Triangulo) figura;
                System.out.println("Triángulo base: " + t.getBase() + ", altura: " + t.getAltura());
            }
        }
        
        // Calcular área total
        double areaTotal = 0;
        for (Figura figura : figuras) {
            areaTotal += figura.calcularArea();
        }
        System.out.println("\nÁrea total de todas las figuras: " + String.format("%.2f", areaTotal));
    }
}