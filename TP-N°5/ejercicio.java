// Trabajo Práctico 5: Relaciones UML 1 a 1 - Todos los ejercicios juntos

// Ejercicio 1
class Foto {
    String imagen;
    String formato;
    public Foto(String imagen, String formato) {
        this.imagen = imagen;
        this.formato = formato;
    }
}
class Titular {
    String nombre;
    String dni;
    Pasaporte pasaporte;
    public Titular(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setPasaporte(Pasaporte pasaporte) {
        this.pasaporte = pasaporte;
    }
}
class Pasaporte {
    String numero;
    String fechaEmision;
    Foto foto;
    Titular titular;
    public Pasaporte(String numero, String fechaEmision, Foto foto, Titular titular) {
        this.numero = numero;
        this.fechaEmision = fechaEmision;
        this.foto = foto;
        this.titular = titular;
        titular.setPasaporte(this);
    }
}

// Ejercicio 2
class Bateria {
    String modelo;
    int capacidad;
    public Bateria(String modelo, int capacidad) {
        this.modelo = modelo;
        this.capacidad = capacidad;
    }
}
class UsuarioCelular {
    String nombre;
    String dni;
    Celular celular;
    public UsuarioCelular(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setCelular(Celular celular) {
        this.celular = celular;
    }
}
class Celular {
    String imei;
    String marca;
    String modelo;
    Bateria bateria;
    UsuarioCelular usuario;
    public Celular(String imei, String marca, String modelo, Bateria bateria, UsuarioCelular usuario) {
        this.imei = imei;
        this.marca = marca;
        this.modelo = modelo;
        this.bateria = bateria;
        this.usuario = usuario;
        usuario.setCelular(this);
    }
}

// Ejercicio 3
class Autor {
    String nombre;
    String nacionalidad;
    public Autor(String nombre, String nacionalidad) {
        this.nombre = nombre;
        this.nacionalidad = nacionalidad;
    }
}
class Editorial {
    String nombre;
    String direccion;
    public Editorial(String nombre, String direccion) {
        this.nombre = nombre;
        this.direccion = direccion;
    }
}
class Libro {
    String titulo;
    String isbn;
    Autor autor;
    Editorial editorial;
    public Libro(String titulo, String isbn, Autor autor, Editorial editorial) {
        this.titulo = titulo;
        this.isbn = isbn;
        this.autor = autor;
        this.editorial = editorial;
    }
}

// Ejercicio 4
class Cliente {
    String nombre;
    String dni;
    TarjetaDeCredito tarjeta;
    public Cliente(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setTarjeta(TarjetaDeCredito tarjeta) {
        this.tarjeta = tarjeta;
    }
}
class Banco {
    String nombre;
    String cuit;
    public Banco(String nombre, String cuit) {
        this.nombre = nombre;
        this.cuit = cuit;
    }
}
class TarjetaDeCredito {
    String numero;
    String fechaVencimiento;
    Cliente cliente;
    Banco banco;
    public TarjetaDeCredito(String numero, String fechaVencimiento, Cliente cliente, Banco banco) {
        this.numero = numero;
        this.fechaVencimiento = fechaVencimiento;
        this.cliente = cliente;
        this.banco = banco;
        cliente.setTarjeta(this);
    }
}

// Ejercicio 5
class PlacaMadre {
    String modelo;
    String chipset;
    public PlacaMadre(String modelo, String chipset) {
        this.modelo = modelo;
        this.chipset = chipset;
    }
}
class Propietario {
    String nombre;
    String dni;
    Computadora computadora;
    public Propietario(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setComputadora(Computadora computadora) {
        this.computadora = computadora;
    }
}
class Computadora {
    String marca;
    String numeroSerie;
    PlacaMadre placaMadre;
    Propietario propietario;
    public Computadora(String marca, String numeroSerie, PlacaMadre placaMadre, Propietario propietario) {
        this.marca = marca;
        this.numeroSerie = numeroSerie;
        this.placaMadre = placaMadre;
        this.propietario = propietario;
        propietario.setComputadora(this);
    }
}

// Ejercicio 6
class ClienteReserva {
    String nombre;
    String telefono;
    public ClienteReserva(String nombre, String telefono) {
        this.nombre = nombre;
        this.telefono = telefono;
    }
}
class Mesa {
    int numero;
    int capacidad;
    public Mesa(int numero, int capacidad) {
        this.numero = numero;
        this.capacidad = capacidad;
    }
}
class Reserva {
    String fecha;
    String hora;
    ClienteReserva cliente;
    Mesa mesa;
    public Reserva(String fecha, String hora, ClienteReserva cliente, Mesa mesa) {
        this.fecha = fecha;
        this.hora = hora;
        this.cliente = cliente;
        this.mesa = mesa;
    }
}

// Ejercicio 7
class Motor {
    String tipo;
    String numeroSerie;
    public Motor(String tipo, String numeroSerie) {
        this.tipo = tipo;
        this.numeroSerie = numeroSerie;
    }
}
class Conductor {
    String nombre;
    String licencia;
    Vehiculo vehiculo;
    public Conductor(String nombre, String licencia) {
        this.nombre = nombre;
        this.licencia = licencia;
    }
    public void setVehiculo(Vehiculo vehiculo) {
        this.vehiculo = vehiculo;
    }
}
class Vehiculo {
    String patente;
    String modelo;
    Motor motor;
    Conductor conductor;
    public Vehiculo(String patente, String modelo, Motor motor, Conductor conductor) {
        this.patente = patente;
        this.modelo = modelo;
        this.motor = motor;
        this.conductor = conductor;
        conductor.setVehiculo(this);
    }
}

// Ejercicio 8
class UsuarioFirma {
    String nombre;
    String email;
    public UsuarioFirma(String nombre, String email) {
        this.nombre = nombre;
        this.email = email;
    }
}
class FirmaDigital {
    String codigoHash;
    String fecha;
    UsuarioFirma usuario;
    public FirmaDigital(String codigoHash, String fecha, UsuarioFirma usuario) {
        this.codigoHash = codigoHash;
        this.fecha = fecha;
        this.usuario = usuario;
    }
}
class Documento {
    String titulo;
    String contenido;
    FirmaDigital firma;
    public Documento(String titulo, String contenido, FirmaDigital firma) {
        this.titulo = titulo;
        this.contenido = contenido;
        this.firma = firma;
    }
}

// Ejercicio 9
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

// Ejercicio 10
class ClaveSeguridad {
    String codigo;
    String ultimaModificacion;
    public ClaveSeguridad(String codigo, String ultimaModificacion) {
        this.codigo = codigo;
        this.ultimaModificacion = ultimaModificacion;
    }
}
class TitularCuenta {
    String nombre;
    String dni;
    CuentaBancaria cuenta;
    public TitularCuenta(String nombre, String dni) {
        this.nombre = nombre;
        this.dni = dni;
    }
    public void setCuenta(CuentaBancaria cuenta) {
        this.cuenta = cuenta;
    }
}
class CuentaBancaria {
    String cbu;
    double saldo;
    ClaveSeguridad clave;
    TitularCuenta titular;
    public CuentaBancaria(String cbu, double saldo, ClaveSeguridad clave, TitularCuenta titular) {
        this.cbu = cbu;
        this.saldo = saldo;
        this.clave = clave;
        this.titular = titular;
        titular.setCuenta(this);
    }
}

// Ejercicio 11
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

// Ejercicio 12
class Contribuyente {
    String nombre;
    String cuil;
    public Contribuyente(String nombre, String cuil) {
        this.nombre = nombre;
        this.cuil = cuil;
    }
}
class Impuesto {
    double monto;
    Contribuyente contribuyente;
    public Impuesto(double monto, Contribuyente contribuyente) {
        this.monto = monto;
        this.contribuyente = contribuyente;
    }
}
class Calculadora {
    public void calcular(Impuesto impuesto) {
        System.out.println("Calculando impuesto de $" + impuesto.monto + " para " + impuesto.contribuyente.nombre);
    }
}

// Ejercicio 13
class UsuarioQR {
    String nombre;
    String email;
    public UsuarioQR(String nombre, String email) {
        this.nombre = nombre;
        this.email = email;
    }
}
class CodigoQR {
    String valor;
    UsuarioQR usuario;
    public CodigoQR(String valor, UsuarioQR usuario) {
        this.valor = valor;
        this.usuario = usuario;
    }
}
class GeneradorQR {
    public void generar(String valor, UsuarioQR usuario) {
        CodigoQR qr = new CodigoQR(valor, usuario);
        System.out.println("QR generado para " + usuario.nombre + ": " + qr.valor);
    }
}

// Ejercicio 14
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

public class ejercicio {
    public static void main(String[] args) {
        // Ejercicio 1
        Titular titular = new Titular("Juan Perez", "12345678");
        Foto foto = new Foto("foto.jpg", "jpg");
        Pasaporte pasaporte = new Pasaporte("A123456", "2025-01-01", foto, titular);
        // Ejercicio 2
        UsuarioCelular usuarioCel = new UsuarioCelular("Ana", "87654321");
        Bateria bateria = new Bateria("B-1000", 4000);
        Celular celular = new Celular("123456789012345", "Samsung", "S21", bateria, usuarioCel);
        // Ejercicio 3
        Autor autor = new Autor("Borges", "Argentina");
        Editorial editorial = new Editorial("Planeta", "CABA");
        Libro libro = new Libro("Ficciones", "978-950-49-1234-5", autor, editorial);
        // Ejercicio 4
        Cliente cliente = new Cliente("Carlos", "11122333");
        Banco banco = new Banco("Banco Nación", "30-12345678-9");
        TarjetaDeCredito tarjeta = new TarjetaDeCredito("1234-5678-9012-3456", "12/30", cliente, banco);
        // Ejercicio 5
        PlacaMadre placa = new PlacaMadre("ASUS B450", "AMD B450");
        Propietario propietario = new Propietario("Lucía", "22233444");
        Computadora compu = new Computadora("HP", "SN12345", placa, propietario);
        // Ejercicio 6
        ClienteReserva clienteRes = new ClienteReserva("Pedro", "555-1234");
        Mesa mesa = new Mesa(10, 4);
        Reserva reserva = new Reserva("2025-09-20", "21:00", clienteRes, mesa);
        // Ejercicio 7
        Motor motor = new Motor("Nafta", "MTR123");
        Conductor conductor = new Conductor("Sofía", "LIC987");
        Vehiculo vehiculo = new Vehiculo("AA123BB", "Fiat Uno", motor, conductor);
        // Ejercicio 8
        UsuarioFirma usuarioFirma = new UsuarioFirma("Mario", "mario@mail.com");
        FirmaDigital firma = new FirmaDigital("HASH123", "2025-09-19", usuarioFirma);
        Documento doc = new Documento("Contrato", "Contenido del contrato", firma);
        // Ejercicio 9
        Paciente paciente = new Paciente("Laura", "OSDE");
        Profesional profesional = new Profesional("Dr. Ruiz", "Cardiología");
        CitaMedica cita = new CitaMedica("2025-09-21", "10:00", paciente, profesional);
        // Ejercicio 10
        TitularCuenta titularCuenta = new TitularCuenta("Marta", "33344555");
        ClaveSeguridad clave = new ClaveSeguridad("CLV123", "2025-09-18");
        CuentaBancaria cuenta = new CuentaBancaria("1230001230001230001234", 10000.0, clave, titularCuenta);
        // Ejercicio 11
        Artista artista = new Artista("Charly García", "Rock");
        Cancion cancion = new Cancion("Demoliendo hoteles", artista);
        Reproductor reproductor = new Reproductor();
        reproductor.reproducir(cancion);
        // Ejercicio 12
        Contribuyente contrib = new Contribuyente("Empresa S.A.", "20-12345678-9");
        Impuesto impuesto = new Impuesto(50000.0, contrib);
        Calculadora calc = new Calculadora();
        calc.calcular(impuesto);
        // Ejercicio 13
        UsuarioQR usuarioQR = new UsuarioQR("Nico", "nico@mail.com");
        GeneradorQR generador = new GeneradorQR();
        generador.generar("VALORQR123", usuarioQR);
        // Ejercicio 14
        Proyecto proyecto = new Proyecto("Video institucional", 15);
        EditorVideo editor = new EditorVideo();
        editor.exportar("mp4", proyecto);
    }
}
