/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * Funciones:
    8. Cálculo del Precio Final con impuesto y descuento.
    Crea un método calcularPrecioFinal(double impuesto, double
    descuento) que calcule el precio final de un producto en un e-commerce. La
    fórmula es:
    PrecioFinal = PrecioBase + (PrecioBase×Impuesto) − (PrecioBase×Descuento)
    PrecioFinal = PrecioBase + (PrecioBase \times Impuesto) - (PrecioBase \times
    Descuento)
    Desde main(), solicita el precio base del producto, el porcentaje de
    impuesto y el porcentaje de descuento, llama al método y muestra el precio
    final.
    Ejemplo de entrada/salida:
    Ingrese el precio base del producto: 100
    Ingrese el impuesto en porcentaje (Ejemplo: 10 para 10%): 10
    Ingrese el descuento en porcentaje (Ejemplo: 5 para 5%): 5
    El precio final del producto es: 105.0
 */
import java.util.Scanner;
public class Ejercicio9 {
    public static double calcularPrecioFinal(double precioBase, double impuesto, double descuento) {
        double montoImpuesto = precioBase * (impuesto / 100);
        double montoDescuento = precioBase * (descuento / 100);
        
        return precioBase + montoImpuesto - montoDescuento;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Ingrese el precio base del producto: ");
        double precioBase = scanner.nextDouble();

        System.out.print("Ingrese el impuesto en porcentaje (Ejemplo: 10 para 10%): ");
        double impuesto = scanner.nextDouble();

        System.out.print("Ingrese el descuento en porcentaje (Ejemplo: 5 para 5%): ");
        double descuento = scanner.nextDouble();

        double precioFinal = calcularPrecioFinal(precioBase, impuesto, descuento);
        System.out.println("El precio final del producto es: " + precioFinal);

        scanner.close();
    }
}
