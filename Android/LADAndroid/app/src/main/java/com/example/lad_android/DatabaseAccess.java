package com.example.lad_android;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import android.widget.Toast;

import java.security.spec.ECField;
import java.util.ArrayList;
import java.util.List;

public class DatabaseAccess {
    private SQLiteOpenHelper openHelper;
    private SQLiteDatabase db;
    private static DatabaseAccess instance;
    Cursor c = null;

    //constructor
    private DatabaseAccess(Context context){
        this.openHelper = new DatabaseOpenHelper(context);
    }

    public static DatabaseAccess getInstance(Context context){
        if (instance==null){
            instance = new DatabaseAccess(context);
        }
        return instance;
    }

    //escribir
    public void openWrite(){
        this.db=openHelper.getWritableDatabase();
    }

    public void close(){
        if (db!=null){
            this.db.close();
        }
    }

    public boolean registrarUsuario2(ContentValues contentValues){
        long result = db.insert("Profesor",null,contentValues);
        if(result == -1){
            return false;
        }
        else {
            return true;
        }
    }

    public String registrarUsuario(String nombre, String apellido, String correo, String contra){
        String query = "INSERT INTO Profesor (Nombre, Apellidos, Correo, Contrasena) VALUES ('"+nombre+"', '"+apellido+"', '"+correo+"', '"+contra+"')";
        try {
            db.execSQL(query);
            //db.rawQuery(query,null);
            return "Se ha registrado el usuario: "+correo+" exitosamente";
        }
        catch(Exception e){
            return "el usuario ya existe";
        }
    }

    public Usuario buscarUsuario(String correo){
        String email = "icerdas@itcr.ac.cr";
        String query = "Select * From Profesor where Correo = '"+correo+"'";

        String nombre="";
        c = db.rawQuery(query, null);
        StringBuffer buffer = new StringBuffer();
        Usuario usuario = new Usuario();
        c.moveToFirst();

            usuario.setID(c.getInt(0));
            usuario.setUsuario(c.getString(1));
            usuario.setApellidos(c.getString(2));
            usuario.setCorreo(c.getString(3));
            usuario.setCotrasena(c.getString(4));


        return usuario;
    }

    public boolean checkCorreo(String email, String contra){

        try{
            String correo = email.toLowerCase().trim();
            String query = "Select * From Profesor where Correo ='"+correo+"'";
            c = db.rawQuery(query,null);
            c.moveToFirst();
            String correoResultado = c.getString(3);
            String contraResultado = c.getString(4);
            if(correoResultado==null | correoResultado.equals("")){
                return false;
            }
            else{
                if (correoResultado.toLowerCase().equals(correo) & contraResultado.toLowerCase().equals(contra) ) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        catch (Exception e){
            return false;
        }

    }

    public boolean checkCorreo(String correo){
        try{
            String query = "Select * From Profesor where Correo ='"+correo+"'";
            c=db.rawQuery(query,null);
            c.moveToFirst();
            String correoRes = c.getString(3);
            if (correoRes.toLowerCase().trim().equals(correo)){
                return true;
            }
            else{
                return false;
            }
        }
        catch (Exception e){
            return false;
        }
    }
    public boolean checkContra(String correo, String contra){
        try{
            String query = "Select * From Profesor where Correo ='"+correo+"'";
            c=db.rawQuery(query,null);
            c.moveToFirst();
            String correoRes = c.getString(4);
            if (correoRes.equals(contra)){
                return true;
            }
            else{
                return false;
            }
        }
        catch (Exception e){
            return false;
        }
    }

    //Entrada : ID del Profesor
    //Salida: ID Del Curso
    public List<String> getCursos(int ID){
        List<String> List = new ArrayList<String>();
        //String query = "Select * From Grupo Join Profesor on grupo.IDProfe = Profesor.ID Where Profeor.ID=2";
        String query = "Select DISTINCT IDCurso from Grupo where IDProfe ='"+ID+"'";
        c = db.rawQuery(query, null);

        while(c.moveToNext()){
            List.add(c.getString(0));
        }

        return List;
    }

    //Entrada: ID del Curso, ID profe
    //Saldia:
    public List<String> getGrupo (String curso, String profe){
        List<String> List = new ArrayList<String>();


            String query = "Select * From Grupo where IDCurso = '"+curso+"' and IDProfe = '"+profe+"'";
            c = db.rawQuery(query, null);

            while(c.moveToNext()){
                List.add(Integer.toString(c.getInt(1)));
            }
            return List;


    }

    //Entrada: ID Curso
    //Salid: Nombre del curso
    public String getNombreCurso(String codigoCurso){
        try {
            String query = "Select * From Curso where Codigo='"+codigoCurso+"'";
            //String query = "Select * From Curso where Codigo='CA2125'";
            c = db.rawQuery(query, null);
            c.moveToFirst();
            return c.getString(1);
        }
        catch (Exception e){
            return "Error";
        }

    }

    public int getListaAsistenciaID(String CodigoCurso, String NumeroGrupo){

        try{
            String query = "Select * From ListaAsistencia Where IDCurso= '"+CodigoCurso+"' and IDGrupo='"+NumeroGrupo+ "')";
            c = db.rawQuery(query, null);
            c.moveToFirst();
            int id = c.getInt(0);
            return id;
        }
        catch (Exception e){
            return -1;
        }
    }

    public List<String> getListaAsitenciaEstudiante(int IDListaAsistencia){
        List<String> List = new ArrayList<String>();
        try{
            String query = "Select * From AsistenciaPorEstudiante Where IDListaAsis ='"+IDListaAsistencia+"'";
            c = db.rawQuery(query,null);
            while(c.moveToNext()){
                List.add(Integer.toBinaryString(c.getInt(1)));
            }
            return List;
        }
        catch (Exception e){
            return List;
        }

    }

    public List<String> getListaAsitenciaEstudianteEstado(int IDListaAsistencia){
        List<String> List = new ArrayList<String>();
        try{
            String query = "Select * From AsistenciaPorEstudiante Where IDListaAsis ='"+IDListaAsistencia+"'";
            c = db.rawQuery(query,null);
            while(c.moveToNext()){
                boolean estado = c.getInt(2)>0;
                if(estado){
                    List.add("Presente");
                }
                else{
                    List.add("Ausente");
                }
            }
            return List;
        }
        catch (Exception e){
            return List;
        }

    }


    public List<String> getListaCursosNombre(){
        List<String> List = new ArrayList<String>();
        String query = "Select * From Curso";
        c = db.rawQuery(query,null);
        while(c.moveToNext()){
            List.add(c.getString(1));
        }
        return List;
    }
    public List<String> getListaCursosCodigo(){
        List<String> List = new ArrayList<String>();
        String query = "Select * From Curso";
        c = db.rawQuery(query,null);
        while(c.moveToNext()){
            List.add(c.getString(0));
        }
        return List;
    }

    public int getCantidadGrupoDelCurso(String CodigoCurso){
        List<String> List = new ArrayList<String>();
        String query = "Select * From Grupo where IDCurso='"+CodigoCurso+"'";
        c=db.rawQuery(query,null);
        while(c.moveToNext()){
            List.add(c.getString(0));
        }
        return List.size();

    }

    public void agregarGrupo(String CodigoCurso,String NumeroGrupo, String IDProfe, String Dia1, String Dia2){

        //String query = "INSERT into Grupo VALUES ('IC8842', '1', '1', 'k-9:30-11:20', 'j-9:30-11:20',null)";
        //String tempProfe = "2";
        String query = "INSERT into Grupo  VALUES ('"+CodigoCurso+"','"+NumeroGrupo+"','"+IDProfe+"','"+Dia1+"','"+Dia2+"',null)";
        db.execSQL(query);
    }

    public void cambiarNombre(String nombre, String apellidos, String IDProfe){
        String query = "Update Profesor set Nombre ='"+nombre+"', Apellidos='"+apellidos+"' Where ID='"+IDProfe+"'";
        db.execSQL(query);
    }

    public void cambiarContrasena(String nuevaContraseña, String IDProfe){
        String query = "Update Profesor set Contrasena='"+nuevaContraseña+"' Where ID='"+IDProfe+"'";
        db.execSQL(query);
    }

    public void upDate(){
        /*String query = "ALTER TABLE Grupo";
        db.execSQL(query);
        */
    }

    public void deletePerfilUsuario(String id){
        try {
            String query = "Delete From Profesor Where ID ='" + id + "'";
            db.execSQL(query);
        }
        catch (Exception e) {
            Log.e("errorDeleteUser","Error en borrar");
        }
    }

    public void deleteCurso(String idCurso){
        String query = "Delete from Grupo where IDCurso = '"+idCurso+"'";
        db.execSQL(query);
    }

    public void deleteGrupo(String idCurso, int numero, int idProfe){
        String query = "Delete from Grupo Where (IDCurso='"+idCurso+"' And Numero='"+numero+"' And IDProfe='"+idProfe+"')";
        db.execSQL(query);
    }


}
