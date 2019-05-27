package com.example.lad_android.models;

public class DatosCalendario {

    private int ID;
    private String Fecha;
    
    public DatosCalendario(){}

    public DatosCalendario(int ID, String fecha) {
        this.ID = ID;
        Fecha = fecha;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getFecha() {
        return Fecha;
    }

    public void setFecha(String fecha) {
        Fecha = fecha;
    }
}
