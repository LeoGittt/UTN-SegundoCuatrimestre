
class NaveEspacial {
	private String nombre;
	private int combustible;
	private int combustibleMaximo;
	private boolean haDespegado;

	public NaveEspacial(String nombre, int combustibleInicial, int combustibleMaximo) {
		this.nombre = nombre;
		this.combustible = combustibleInicial;
		this.combustibleMaximo = combustibleMaximo;
		this.haDespegado = false;
	}

	public void despegar() {
		if (!haDespegado && combustible > 0) {
			haDespegado = true;
			System.out.println(nombre + " ha despegado!");
		} else if (haDespegado) {
			System.out.println(nombre + " ya ha despegado.");
		} else {
			System.out.println("No hay suficiente combustible para despegar.");
		}
	}

	public void avanzar(int distancia) {
		if (!haDespegado) {
			System.out.println("La nave debe despegar antes de avanzar.");
			return;
		}
		if (distancia <= 0) {
			System.out.println("La distancia debe ser mayor a cero.");
			return;
		}
		if (combustible >= distancia) {
			combustible -= distancia;
			System.out.println(nombre + " avanzó " + distancia + " unidades.");
		} else {
			System.out.println("No hay suficiente combustible para avanzar " + distancia + " unidades.");
		}
	}

	public void recargarCombustible(int cantidad) {
		if (cantidad <= 0) {
			System.out.println("La cantidad a recargar debe ser mayor a cero.");
			return;
		}
		if (combustible + cantidad > combustibleMaximo) {
			System.out.println("No se puede superar el límite de combustible (" + combustibleMaximo + ").");
			combustible = combustibleMaximo;
		} else {
			combustible += cantidad;
			System.out.println("Combustible recargado en " + cantidad + " unidades.");
		}
	}

	public void mostrarEstado() {
		System.out.println("Nave: " + nombre);
		System.out.println("Combustible: " + combustible + "/" + combustibleMaximo);
		System.out.println("Estado: " + (haDespegado ? "En vuelo" : "En tierra"));
	}
}

public class ejercicio5 {
	public static void main(String[] args) {
		NaveEspacial nave = new NaveEspacial("Apolo", 50, 100);
		nave.mostrarEstado();
		nave.avanzar(30); 
		nave.despegar();
		nave.avanzar(60); 
		nave.recargarCombustible(40); 
		nave.avanzar(60); 
		nave.mostrarEstado();
	}
}
