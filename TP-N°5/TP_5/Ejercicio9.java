// Ejercicio 9: CitaMédica - Paciente - Profesional
// Asociación unidireccional: CitaMédica → Paciente, CitaMédica → Profesional

class Paciente {
    String nombre;
    String obraSocial;
    public Paciente(String nombre, String obraSocial) {
        this.nombre = nombre;
        this.obraSocial = obraSocial;
    }
}

class Profesional {
    String nombre;
    String especialidad;
    public Profesional(String nombre, String especialidad) {
        this.nombre = nombre;
        this.especialidad = especialidad;
    }
}

class CitaMedica {
    String fecha;
    String hora;
    Paciente paciente;
    Profesional profesional;
    public CitaMedica(String fecha, String hora, Paciente paciente, Profesional profesional) {
        this.fecha = fecha;
        this.hora = hora;
        this.paciente = paciente;
        this.profesional = profesional;
    }
}

public class Ejercicio9 {
    public static void main(String[] args) {
        Paciente paciente = new Paciente("Laura", "OSDE");
        Profesional profesional = new Profesional("Dr. Ruiz", "Cardiología");
        CitaMedica cita = new CitaMedica("2025-09-21", "10:00", paciente, profesional);
        System.out.println("Cita médica de " + paciente.nombre + " con " + profesional.nombre);
    }
}
