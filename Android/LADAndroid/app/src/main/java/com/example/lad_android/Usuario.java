package com.example.lad_android;

public class Usuario {

    private String Usuario;
    private String Apellidos;
    private int ID;
    private String Correo;
    private String Cotrasena;

    public Usuario(String usuario, String apellidos, int ID, String correo, String cotrasena) {
        Usuario = usuario;
        Apellidos = apellidos;
        this.ID = ID;
        Correo = correo;
        Cotrasena = cotrasena;
    }

    public Usuario(){}

    public String getUsuario() {
        return Usuario;
    }

    public void setUsuario(String usuario) {
        Usuario = usuario;
    }

    public String getApellidos() {
        return Apellidos;
    }

    public void setApellidos(String apellidos) {
        Apellidos = apellidos;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getCorreo() {
        return Correo;
    }

    public void setCorreo(String correo) {
        Correo = correo;
    }

    public String getCotrasena() {
        return Cotrasena;
    }

    public void setCotrasena(String cotrasena) {
        Cotrasena = cotrasena;
    }

    public String getInfo(){
        return this.ID+" /n"+this.Usuario+" /n"+this.Apellidos+"/n"+this.Correo+"/n"+this.Cotrasena;
    }
}
