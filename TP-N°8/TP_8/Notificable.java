// Interfaz Notificable - Define el contrato para objetos que pueden recibir notificaciones
public interface Notificable {
    void notificar(String mensaje);
    String getIdentificador();
}