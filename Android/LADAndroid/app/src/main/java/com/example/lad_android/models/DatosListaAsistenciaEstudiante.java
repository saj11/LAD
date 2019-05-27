package com.example.lad_android.models;

public class DatosListaAsistenciaEstudiante {

    private int carne;
    private String estado;
    private String nombre;
    private String correo;

    public DatosListaAsistenciaEstudiante(){}

    public DatosListaAsistenciaEstudiante(int carne, String estado) {
        this.carne = carne;
        this.estado = estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getEstado() {
        return estado;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public int getCarne() {
        return carne;
    }

    public void setCarne(int carne) {
        this.carne = carne;
    }

}
