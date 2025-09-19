// Ejercicio 14: EditorVideo - Proyecto - Render
// Asociación unidireccional: Render → Proyecto
// Dependencia de creación: EditorVideo.exportar(String, Proyecto)

class Proyecto {
    String nombre;
    int duracionMin;
    public Proyecto(String nombre, int duracionMin) {
        this.nombre = nombre;
        this.duracionMin = duracionMin;
    }
}

class Render {
    String formato;
    Proyecto proyecto;
    public Render(String formato, Proyecto proyecto) {
        this.formato = formato;
        this.proyecto = proyecto;
    }
}

class EditorVideo {
    public void exportar(String formato, Proyecto proyecto) {
        Render render = new Render(formato, proyecto);
        System.out.println("Render exportado en formato " + formato + " para proyecto " + proyecto.nombre);
    }
}

public class Ejercicio14 {
    public static void main(String[] args) {
        Proyecto proyecto = new Proyecto("Video institucional", 15);
        EditorVideo editor = new EditorVideo();
        editor.exportar("mp4", proyecto);
    }
}
