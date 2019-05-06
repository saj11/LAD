package com.example.lad_android.models;

public class DatosUsuario {
    private String codigoCurso;
    private String nombreCurso;
    private String numeroGrupo;
    private String profesor;
    private String dia1;
    private String dia2;

    public DatosUsuario(){}

    public DatosUsuario(String codigoCurso, String nombreCurso, String numeroGrupo, String profesor, String dia1, String dia2) {
        this.codigoCurso = codigoCurso;
        this.nombreCurso = nombreCurso;
        this.numeroGrupo = numeroGrupo;
        this.profesor = profesor;
        this.dia1 = dia1;
        this.dia2 = dia2;
    }

    public String getProfesor() {
        return profesor;
    }

    public void setProfesor(String profesor) {
        this.profesor = profesor;
    }

    public String getCodigoCurso() {
        return codigoCurso;
    }

    public void setCodigoCurso(String codigoCurso) {
        this.codigoCurso = codigoCurso;
    }

    public String getNombreCurso() {
        return nombreCurso;
    }

    public void setNombreCurso(String nombreCurso) {
        this.nombreCurso = nombreCurso;
    }

    public String getNumeroGrupo() {
        return numeroGrupo;
    }

    public void setNumeroGrupo(String numeroGrupo) {
        this.numeroGrupo = numeroGrupo;
    }

    public String getDia1() {
        return dia1;
    }

    public void setDia1(String dia1) {
        this.dia1 = dia1;
    }

    public String getDia2() {
        return dia2;
    }

    public void setDia2(String dia2) {
        this.dia2 = dia2;
    }

}
