/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TP_2;

/**
 *
 * 3. Clasificación de Edad.
    Escribe un programa en Java que solicite al usuario su edad y clasifique su
    etapa de vida según la siguiente tabla:
    Menor de 12 años: "Niño"
    Entre 12 y 17 años: "Adolescente"
    Entre 18 y 59 años: "Adulto"
    60 años o más: "Adulto mayor"
    Ejemplo de entrada/salida:
    Ingrese su edad: 25
    Eres un Adulto.
    Ingrese su edad: 10
    Eres un Niño.

 */
import java.util.Scanner;
public class Ejercicio3 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Ingrese su edad: ");
        int edad = scanner.nextInt();
        String etapaDeVida = "";

        if (edad < 12) {
            etapaDeVida = "Niño";
        } else if (edad >= 12 && edad <= 17) {
            etapaDeVida = "Adolescente";
        } else if (edad >= 18 && edad <= 59) {
            etapaDeVida = "Adulto";
        } else if (edad >= 60) {
            etapaDeVida = "Adulto mayor";
        } else {
            etapaDeVida = "Edad inválida";
        }

        if (etapaDeVida.equals("Edad inválida")) {
            System.out.println("Por favor, ingrese una edad válida.");
        } else {
            System.out.println("Eres un " + etapaDeVida + ".");
        }

        scanner.close();
    }
}
