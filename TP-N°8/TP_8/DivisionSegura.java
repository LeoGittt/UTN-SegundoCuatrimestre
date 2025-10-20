import java.util.Scanner;

// Ejercicio 1: División segura
public class DivisionSegura {
    
    public static void main(String[] args) {
        System.out.println("=== EJERCICIO 1: DIVISIÓN SEGURA ===");
        ejecutarDivisionSegura();
    }
    
    public static void ejecutarDivisionSegura() {
        Scanner scanner = new Scanner(System.in);
        
        try {
            System.out.print("Ingrese el dividendo: ");
            double dividendo = scanner.nextDouble();
            
            System.out.print("Ingrese el divisor: ");
            double divisor = scanner.nextDouble();
            
            double resultado = dividirSeguro(dividendo, divisor);
            System.out.printf("Resultado: %.2f ÷ %.2f = %.4f%n", dividendo, divisor, resultado);
            
        } catch (ArithmeticException e) {
            System.err.println("ERROR: " + e.getMessage());
            System.out.println("No se puede dividir por cero.");
        } catch (Exception e) {
            System.err.println("ERROR inesperado: " + e.getMessage());
        } finally {
            System.out.println("Operación de división finalizada.");
        }
    }
    
    public static double dividirSeguro(double dividendo, double divisor) throws ArithmeticException {
        if (divisor == 0) {
            throw new ArithmeticException("División por cero no permitida");
        }
        return dividendo / divisor;
    }
}