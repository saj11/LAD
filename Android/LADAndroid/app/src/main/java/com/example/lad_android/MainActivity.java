package com.example.lad_android;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.StrictMode;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.DatabaseHelper.DatabaseHelper;
import com.example.lad_android.models.Usuario;

public class MainActivity extends AppCompatActivity {

    String url = "jdbc:mysql//35.224.224.166:3306/Lad";
    String  user = "root";
    String pass = "LadDataBase2019";


    ImageView mImageLogo;
    EditText mTextUsuario;
    EditText mTextPass;
    Button mButtonSignin;
    Button mButtonSignup;
    DatabaseHelper dbHelper = null;
    private final static String TAG = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.setTitle("Login");

        mImageLogo = (ImageView) findViewById(R.id.MainImageView);
        mTextUsuario = (EditText) findViewById(R.id.etUsuario);
        mTextPass = (EditText) findViewById(R.id.etPassword);
        mButtonSignin = (Button) findViewById(R.id.btnSignin);
        mButtonSignup = (Button) findViewById(R.id.btnSignup);

        Bitmap bMap = BitmapFactory.decodeResource(getResources(),R.drawable.logov4);
        mImageLogo.setImageBitmap(bMap);


        mButtonSignup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               /* Intent SignupIntent = new Intent(MainActivity.this, RegistroActivity.class);
                startActivity(SignupIntent);
               Intent intent = new Intent(MainActivity.this, MainMenuEstudianteActivity.class);
               startActivity(intent);*/
               Intent intent = new Intent(MainActivity.this, RegistroSeleccionActivity.class);
               startActivity(intent);
            }
        });

        mButtonSignin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!mTextUsuario.getText().toString().trim().equals("")){
                    boolean existeCorreoProfe=false;
                    boolean existeCorreoEstudiante=false;
                    DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                    databaseAccess.openWrite();
                    existeCorreoProfe=databaseAccess.checkCorreo(mTextUsuario.getText().toString().trim());
                    existeCorreoEstudiante = databaseAccess.checkCorreoEstudiante(mTextUsuario.getText().toString());
                    //Toast.makeText(MainActivity.this, usuario.getInfo(), Toast.LENGTH_SHORT).show();
                    databaseAccess.close();
                    if(existeCorreoProfe){
                        boolean contraIgual=false;
                        databaseAccess.openWrite();
                        contraIgual = databaseAccess.checkContra(mTextUsuario.getText().toString().trim(),mTextPass.getText().toString());
                        databaseAccess.close();
                        if(contraIgual){
                            databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                            databaseAccess.openWrite();

                            Usuario usuario = databaseAccess.buscarUsuario(mTextUsuario.getText().toString().toLowerCase().trim());
                            //Toast.makeText(MainActivity.this, usuario.getInfo(), Toast.LENGTH_SHORT).show();

                            databaseAccess.close();

                            //Usuario usuario = dbHelper.buscarUsuario("icerdas@itcr.ac.cr");


                            Intent intent = new Intent(MainActivity.this, ProfesorMainMenuActivity.class);
                            intent.putExtra("usuario", usuario.getUsuario());
                            intent.putExtra("id", usuario.getID());
                            intent.putExtra("apellido", usuario.getApellidos());
                            intent.putExtra("correo",usuario.getCorreo());
                            intent.putExtra("contra",usuario.getCotrasena());
                            //Toast.makeText(MainActivity.this, "usuario: "+ usuario.getID(),Toast.LENGTH_SHORT).show();
                            startActivity(intent);
                        }
                        else{
                            Toast.makeText(MainActivity.this,"La contraseña no coincide",Toast.LENGTH_LONG).show();
                        }
                    }
                    else{

                        if(existeCorreoEstudiante){
                            boolean contraIgual = false;
                            databaseAccess.openWrite();
                            contraIgual = databaseAccess.checkContraEstudiante(mTextUsuario.getText().toString(),mTextPass.getText().toString());
                            databaseAccess.close();
                            if(contraIgual){
                                databaseAccess.openWrite();
                                Usuario estudiante = databaseAccess.buscarUsuarioEstudiante(mTextUsuario.getText().toString().toLowerCase().trim());
                                databaseAccess.close();

                                Intent intent = new Intent(MainActivity.this,MainMenuEstudianteActivity.class);
                                intent.putExtra("usuario", estudiante.getUsuario());
                                intent.putExtra("carne",estudiante.getID());
                                intent.putExtra("correo", estudiante.getCorreo());
                                intent.putExtra("contra",estudiante.getCotrasena());

                                startActivity(intent);

                            }
                            else {
                                Toast.makeText(MainActivity.this,"La contraseña no coincide",Toast.LENGTH_LONG).show();
                            }

                        }
                        else {
                            Toast.makeText(MainActivity.this, "El usuario no existe", Toast.LENGTH_LONG).show();
                        }
                    }


                }
                else{
                    String test = mTextPass.getText().toString();
                    Toast.makeText(MainActivity.this,"Debe ingresar un correo: "+test,Toast.LENGTH_LONG).show();
                }

            }
        });
    }

    @Override
    public void onBackPressed() {
        String res = testDB();
        Toast.makeText(MainActivity.this, res, Toast.LENGTH_SHORT).show();
        //Toast.makeText(MainActivity.this, "Debe iniciar Sesion", Toast.LENGTH_SHORT).show();

    }

    public String testDB(){
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
        String result;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, pass);
            result = "Database con success";
        }
        catch (Exception e){
            result="Error";
        }
        return result;

    }

}
