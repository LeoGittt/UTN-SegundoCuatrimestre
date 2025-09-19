// Ejercicio 11: Reproductor - Canción - Artista
// Asociación unidireccional: Canción → Artista
// Dependencia de uso: Reproductor.reproducir(Cancion)

class Artista {
    String nombre;
    String genero;
    public Artista(String nombre, String genero) {
        this.nombre = nombre;
        this.genero = genero;
    }
}

class Cancion {
    String titulo;
    Artista artista;
    public Cancion(String titulo, Artista artista) {
        this.titulo = titulo;
        this.artista = artista;
    }
}

class Reproductor {
    public void reproducir(Cancion cancion) {
        System.out.println("Reproduciendo: " + cancion.titulo + " por " + cancion.artista.nombre);
    }
}

public class Ejercicio11 {
    public static void main(String[] args) {
        Artista artista = new Artista("Charly García", "Rock");
        Cancion cancion = new Cancion("Demoliendo hoteles", artista);
        Reproductor reproductor = new Reproductor();
        reproductor.reproducir(cancion);
    }
}
