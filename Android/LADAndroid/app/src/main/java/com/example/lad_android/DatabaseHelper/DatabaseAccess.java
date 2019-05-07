package com.example.lad_android.DatabaseHelper;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import com.example.lad_android.models.DatosCursoEstudiante;
import com.example.lad_android.models.DatosListaAsistenciaEstudiante;
import com.example.lad_android.models.DatosUsuario;
import com.example.lad_android.models.Usuario;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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


    //Registro usuario profesor
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

    //registro usuario estudiante
    public String registrarUsuarioEstudiante(String nombre, int carne, String correo, String contra){
        String query = "INSERT INTO Estudiante (Carne, Nombre, Correo, Contrasena) VALUES ('"+carne+"', '"+nombre+"', '"+correo+"', '"+contra+"')";
        try{
            db.execSQL(query);
            return "Se ha registrado el usuario: "+correo+" exitosamente";
        }catch (Exception e){
            return "el usuario ya existe";
        }
    }

    //profe
    public Usuario buscarUsuario(String correo){

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
    //estudiante
    public Usuario buscarUsuarioEstudiante(String correo){
        String query = "Select * From Estudiante where Correo = '"+correo+"'";
        Usuario usuario = new Usuario();
        try {
            c = db.rawQuery(query, null);
            c.moveToFirst();
            usuario.setID(c.getInt(0));
            usuario.setUsuario(c.getString(1));
            usuario.setCorreo(c.getString(2));
            usuario.setCotrasena(c.getString(3));
            return usuario;
        }
        catch (Exception e){
            return usuario;
        }
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

    public boolean checkCorreoEstudiante(String correo){
        try{
            String query = "Select * From Estudiante where Correo ='"+correo+"'";
            c = db.rawQuery(query,null);
            c.moveToFirst();
            String correoRes = c.getString(2);
            if(correoRes.toLowerCase().trim().equals(correo)){
                return true;
            }
            else{
                return false;
            }
        }catch (Exception e){
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
    //contraseña de profe
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

    public boolean checkContraEstudiante(String correo, String contra){
        try{
            String query = "Select * From Estudiante where Correo ='"+correo+"'";
            c=db.rawQuery(query,null);
            c.moveToFirst();
            String correoRes = c.getString(3);
            if(correoRes.equals(contra)){
                return true;
            }
            return false;

        } catch (Exception e){
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

    public List<String> getAllGrupo(String profe){
        List<String> lista = new ArrayList<String>();
        String query = "Select * From Grupo inner join Curso on Grupo.IDCurso = Curso.Codigo where IDProfe='"+profe+"'";
        c = db.rawQuery(query,null);
        while (c.moveToNext()){
            lista.add(c.getString(0)+", Grupo: "+Integer.toString(c.getInt(1))+" - "+c.getString(7));
        }
        return lista;
    }

    public List<DatosUsuario> getAllDatoGrupo(String profe){
        String query = "Select * From Profesor where ID='" + profe + "'";
        String nbrProfe="" ;
        try {
            c = db.rawQuery(query, null);
            c.moveToFirst();
            nbrProfe = c.getString(1)+" "+c.getString(2);
        }catch (Exception e){
            nbrProfe = "hubo un error";
        }

        List<DatosUsuario> lista = new ArrayList<DatosUsuario>();
        query = "Select * From Grupo inner join Curso on Grupo.IDCurso = Curso.Codigo where IDProfe='"+profe+"'";
        c = db.rawQuery(query,null);

        while (c.moveToNext()){
            DatosUsuario datos = new DatosUsuario();
            datos.setCodigoCurso(c.getString(0));
            datos.setNombreCurso(c.getString(7));
            datos.setNumeroGrupo(Integer.toString(c.getInt(1)));
            datos.setProfesor(nbrProfe);
            datos.setDia1(c.getString(3));
            datos.setDia2(c.getString(4));
            lista.add(datos);
        }


        return lista;
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
            String query = "Select * From ListaAsistencia Where IDCurso= '"+CodigoCurso+"' and IDGrupo='"+NumeroGrupo+"'";
            c = db.rawQuery(query, null);
            c.moveToFirst();
            int id = c.getInt(0);
            return id;
        }
        catch (Exception e){
            return -2;
        }
    }

    public List<String> getListaAsitenciaEstudiante(int IDListaAsistencia){
        List<String> List = new ArrayList<String>();
        try{
            String query = "Select * From AsistenciaPorEstudiante Where IDListaAsis ='"+IDListaAsistencia+"'";
            c = db.rawQuery(query,null);
            while(c.moveToNext()){
                List.add(Integer.toString(c.getInt(1)));
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

    public String getHorario1(String idCurso, String numGrupo, String idProfe){
        String query = "Select * From Grupo where IDCurso='"+idCurso+"' and Numero='"+numGrupo+"' and IDProfe='"+idProfe+"'";
        c = db.rawQuery(query,null);
        c.moveToFirst();
        String dia = c.getString(3);
        return dia;
    }
    public String getHorario2(String idCurso, String numGrupo, String idProfe){
        String query = "Select * From Grupo where IDCurso='"+idCurso+"' and Numero='"+numGrupo+"' and IDProfe='"+idProfe+"'";
        c = db.rawQuery(query,null);
        c.moveToFirst();
        String dia = c.getString(4);
        return dia;
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

    public void cambiarNombreEstudiante(String usuario, int carne){
        String query = "Update Estudiante set Nombre='"+usuario+"' Where Carne='"+Integer.toString(carne)+"'";
        db.execSQL(query);
    }

    public void cambiarContrasena(String nuevaContraseña, String IDProfe){
        String query = "Update Profesor set Contrasena='"+nuevaContraseña+"' Where ID='"+IDProfe+"'";
        db.execSQL(query);
    }

    public void cambiarContrasenaEstudiante(String nuevaContra, int carne){
        String query = "Update Estudiante set Contrasena='"+nuevaContra+"' Where Carne='"+Integer.toString(carne)+"'";
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

    public void deleteEstudiante(String carne){
        try{
            String query = "Delete From Estudiante Where Carne='"+carne+"'";
            db.execSQL(query);
        }catch (Exception e){
            Log.e("errorDeleteEstudiante","Error en borrar base");
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

    public DatosUsuario getDatosUsuario(String idCurso, String numGrupo, String idProf){
        DatosUsuario datosUsuario = new DatosUsuario();
        String query = "Select * from Grupo where IDCurso='"+idCurso+"' and Numero='"+numGrupo+"' and IDProfe='"+idProf+"'";
        c=db.rawQuery(query,null);
        c.moveToFirst();
        String curso = c.getString(0);
        String grupo = Integer.toString(c.getInt(1));
        String dia1 = c.getString(3);
        String dia2 = c.getString(4);

        datosUsuario.setCodigoCurso(curso);
        datosUsuario.setNumeroGrupo(grupo);
        datosUsuario.setDia1(dia1);
        datosUsuario.setDia2(dia2);
        datosUsuario.setNombreCurso("Not available");

        return datosUsuario;
    }

    public List<DatosUsuario> getCursosProfe(int ID){
        List<DatosUsuario> List = new ArrayList<DatosUsuario>();
        //String query = "Select * From Grupo Join Profesor on grupo.IDProfe = Profesor.ID Where Profeor.ID=2";
        String query = "Select * from Grupo where IDProfe ='"+ID+"'";
        c = db.rawQuery(query, null);

        while(c.moveToNext()){
            DatosUsuario datosCurso = new DatosUsuario();
            datosCurso.setCodigoCurso(c.getString(0));
            datosCurso.setNumeroGrupo(Integer.toString(c.getInt(1)));
            datosCurso.setDia1(c.getString(3));
            datosCurso.setDia2(c.getString(4));
            List.add(datosCurso);
        }

        return List;
    }

    public String crearListaAsistencia(String idCurso, String idGrupo){
        String query = "Insert into ListaAsistencia (IDCurso, IDGrupo, Fecha) Values ('"+idCurso+"','"+idGrupo+"',datetime('now'))";
        int i = 1;
        try {
            Date date = Calendar.getInstance().getTime();
            String dia = (String) android.text.format.DateFormat.format("EEEE",date);
            //if(checkDiaCurso(idCurso,idGrupo,dia)) {
             if(true){
                 db.execSQL(query);
                return "Exitoso";
            }
            else{
                return "La lista de asistencia no esta disponible";
            }
        }
        catch (Exception e){
            return "Hubo un error";
        }
    }
    //INSERT into ListaAsistencia (IDCurso, IDGrupo, Fecha) Values ('IC8842','1',datetime('now'))

    public String fetchListaAsistencia(String idCurso, String idGrupo, String fecha){
        String query = "Select * from ListaAsistencia where IDCurso='"+idCurso+"' and IDGrupo='"+idGrupo+"'";
        c = db.rawQuery(query,null);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date d=new Date();

        while(c.moveToNext()){
            try{
                String diaListaAsistencia = c.getString(3);
                String[] fechaLista=diaListaAsistencia.split(" ");
                String hoy = dateFormat.format(d);
                if (hoy.equals(fechaLista[0])){
                    return Integer.toString(c.getInt(0));
                }

            } catch (Exception e){
                return "Error";
            }
        }
        return "NotExist";

    }

    public String fetchListaTest(String idCurso, String idGrupo){
        String query = "Select * from ListaAsistencia where IDCurso='"+idCurso+"' and IDGrupo='"+idGrupo+"'";
        c = db.rawQuery(query,null);
        c.moveToFirst();

        Date date = new Date();
        String dia = (String) android.text.format.DateFormat.format("EEEE",date);

        return dia;

    }
    //Entrada: Dia de la semana
    //Salida: True si el dia de la semana concuerda con el dia de la lista de asistencia
    public boolean checkDiaListaAsistencia(String idListaAsistencia, String dia){
        String query = "Select * from ListaAsistencia where ID='"+idListaAsistencia+"'";
        c = db.rawQuery(query,null);
        String dia1,dia2;
        return  true;
    }

    public boolean checkDiaCurso(String idCurso, String idGrupo, String dia){
        String query = "Select * from Grupo where IDCurso='"+idCurso+"', and Numero='"+idGrupo+"'";
        c = db.rawQuery(query,null);
        c.moveToFirst();
        String dia1,dia2;
        dia1 = c.getString(3);
        dia2 = c.getString(4);
        String[]letra1=dia1.split("-");
        String[]letra2=dia2.split("-");
        String currentDay;
        if(dia=="Monday"){
            currentDay="m";
        }
        else if(dia.equals("Tuesday")){
            currentDay="k";
        }
        else if(dia.equals("Wednesday")){
            currentDay="m";
        }
        else if(dia.equals("Thursday")){
            currentDay="j";
        }
        else if(dia.equals("Friday")){
            currentDay="v";
        }
        else{
            currentDay="s";
        }

        if(letra1[0].toLowerCase().equals(currentDay) | letra2[0].toLowerCase().equals(currentDay)){
            return true;
        }
        else{
            return false;
        }
    }

    public String registrarAsistenciaEstudiante(int idListaAsistencia, int carneEstudiante, String estado) {
        String query = "Insert into AsistenciaPorEstudiante VALUES ('"+Integer.toString(idListaAsistencia)+"','"+Integer.toString(carneEstudiante)+"','"+estado+"')";
        try {
            db.execSQL(query);
            return "Se agrego correctamente";
        }
        catch (Exception e){
            return "Ya estas registrado. Datos: "+Integer.toString(idListaAsistencia)+" carne: "+Integer.toString(carneEstudiante);
        }

    }


    public List<DatosListaAsistenciaEstudiante> getListaAsistenciaPorEstudiante(int idListaAsistencia){
        List<DatosListaAsistenciaEstudiante> lista = new ArrayList<DatosListaAsistenciaEstudiante>();
        String query = "Select * from AsistenciaPorEstudiante inner join Estudiante on AsistenciaPorEstudiante.Carne = Estudiante.Carne where IDListaAsist ='"+idListaAsistencia+"'";
        c = db.rawQuery(query,null);
        while (c.moveToNext()){
            DatosListaAsistenciaEstudiante datos = new DatosListaAsistenciaEstudiante();
            datos.setCarne(c.getInt(1));
            datos.setEstado(c.getString(2));
            datos.setNombre(c.getString(4));
            datos.setCorreo(c.getString(5));
            lista.add(datos);
        }

        return lista;
    }

    public List<String> getListaAsisntenciaProfesorCurso(String codCurso, String numGrupo){
        List<String> lista = new ArrayList<String>();
        String query = "Select * from ListaAsistencia Where IDCurso ='"+codCurso+"' and IDGrupo='"+numGrupo+"'";
        c = db.rawQuery(query,null);
        while(c.moveToNext()){
            String id = Integer.toString(c.getInt(0));
            String curso = c.getString(1);
            String grupo = Integer.toString(2);
            String fecha = c.getString(3);
            lista.add(id+" - "+curso+" - "+grupo+" - "+fecha);
        }
        return lista;

    }


    public String getCountTable(){
        String query = "delete from ListaAsistencia";
        try {
            //db.execSQL(query);
            return "Exiuto";
        }catch (Exception e){
            return "error";
        }

    }

    public int getRowCount(){
        String query = "Select count(*) from AsistenciaPorEstudiante";
        c = db.rawQuery(query,null);
        c.moveToFirst();
        return c.getInt(0);
    }

    public String getTest(){
        String query = "Select * from ListaAsistencia";

        try {
            c = db.rawQuery(query, null);
            c.moveToFirst();
            String res = c.getString(1);
            return res;
        }catch (Exception e){
            return "esta vacio";
        }
    }

    //entrada: carne
    //salida: lista de cursos y grupos
    public List<DatosCursoEstudiante> getCursosEstudiante(int carne){
        String query = "select * from AsistenciaPorEstudiante inner join ListaAsistencia on AsistenciaPorEstudiante.IDListaAsist = ListaAsistencia.ID inner join Curso on ListaAsistencia.IDCurso = Curso.Codigo where Carne = '"+Integer.toString(carne)+"'";
        c = db.rawQuery(query,null);
        List<DatosCursoEstudiante> lista = new ArrayList<DatosCursoEstudiante>();
        while(c.moveToNext()){
            DatosCursoEstudiante datos = new DatosCursoEstudiante();
            datos.setIDCurso(c.getString(4));
            datos.setIDGrupo(Integer.toString(c.getInt(5)));
            datos.setNombreCurso(c.getString(8));
            lista.add(datos);
        }
        return lista;

    }


}
