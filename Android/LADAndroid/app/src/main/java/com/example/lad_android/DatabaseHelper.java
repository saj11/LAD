package com.example.lad_android;

import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class DatabaseHelper extends SQLiteOpenHelper {
    private final static String TAG = "DatabaseHelper";
    private final Context myContext;
    private static final String DATABASE_NAME = "lad_Android.db";
    private static final int DATABASE_VERSION = 1;
    private String pathToSaveDBFile;
    private  String DB_PATH = "C:/Users/Andy L/AndroidStudioProjects/LADAndroid/app/src/main/assets/databases/";
    private SQLiteDatabase myDataBase;

    public DatabaseHelper(Context context) throws IOException {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.myContext = context;
        boolean dbexist = checkdatabase();

        if (dbexist) {
            opendatabase();
        } else {
            System.out.println("Database doesn't exist");
            createdatabase();
        }
    }

    public void createdatabase() throws IOException {
        boolean dbexist = checkdatabase();
        if(!dbexist) {
            this.getReadableDatabase();
            try {
                copydatabase();
            } catch(IOException e) {
                throw new Error("Error copying database");
            }
        }
    }

    private boolean checkdatabase() {

        boolean checkdb = false;
        try {
            String myPath = DB_PATH + DATABASE_NAME;
            File dbfile = new File(myPath);
            checkdb = dbfile.exists();
        } catch(SQLiteException e) {
            System.out.println("Database doesn't exist");
        }
        return checkdb;
    }

    private void copydatabase() throws IOException {
        //Open your local db as the input stream
        InputStream myinput = myContext.getAssets().open(DATABASE_NAME);

        // Path to the just created empty db
        String outfilename = myContext.getDatabasePath(DATABASE_NAME).getPath();

        //Open the empty db as the output stream
        OutputStream myoutput = new FileOutputStream(outfilename);

        // transfer byte to inputfile to outputfile
        byte[] buffer = new byte[1024];
        int length;
        while ((length = myinput.read(buffer))>0) {
            myoutput.write(buffer,0,length);
        }

        //Close the streams
        myoutput.flush();
        myoutput.close();
        myinput.close();
    }

    public void opendatabase() throws SQLException {
        //Open the database
        String mypath = myContext.getDatabasePath(DATABASE_NAME).getPath();
        myDataBase = SQLiteDatabase.openDatabase(mypath, null, SQLiteDatabase.OPEN_READWRITE);
    }

    public synchronized void close() {
        if(myDataBase != null) {
            myDataBase.close();
        }
        super.close();
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public Usuario buscarUsuario(String correo){
        String email = "icerdas@itcr.ac.cr";
        String query = "Select * From Profesor where Correo = '"+correo+"'";
        SQLiteDatabase db = SQLiteDatabase.openDatabase(pathToSaveDBFile,null,SQLiteDatabase.OPEN_READONLY);
        String nombre="";
        Cursor c = db.rawQuery(query, null);
        StringBuffer buffer = new StringBuffer();
        Usuario usuario = new Usuario();
        c.moveToFirst();

        usuario.setID(c.getInt(0));
        usuario.setUsuario(c.getString(1));
        usuario.setApellidos(c.getString(2));
        usuario.setCorreo(c.getString(3));
        usuario.setCotrasena(c.getString(4));

        db.close();
        return usuario;
    }
}
