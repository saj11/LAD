package com.example.lad_android.models;

public class DatosCursoEstudiante {

    private String IDCurso;
    private String IDGrupo;
    private String NombreCurso;
    private String Estado;

    public DatosCursoEstudiante(String IDCurso, String IDGrupo, String nombreCurso, String estado) {
        this.IDCurso = IDCurso;
        this.IDGrupo = IDGrupo;
        NombreCurso = nombreCurso;
        Estado = estado;
    }

    public DatosCursoEstudiante() {
    }

    public String getIDCurso() {
        return IDCurso;
    }

    public void setIDCurso(String IDCurso) {
        this.IDCurso = IDCurso;
    }

    public String getIDGrupo() {
        return IDGrupo;
    }

    public void setIDGrupo(String IDGrupo) {
        this.IDGrupo = IDGrupo;
    }

    public String getNombreCurso() {
        return NombreCurso;
    }

    public void setNombreCurso(String nombreCurso) {
        NombreCurso = nombreCurso;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String estado) {
        Estado = estado;
    }
}
