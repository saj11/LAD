package com.example.lad_android;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import java.io.IOException;

public class MainActivity extends AppCompatActivity {

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
                Intent SignupIntent = new Intent(MainActivity.this, RegistroActivity.class);
                startActivity(SignupIntent);
            }
        });

        mButtonSignin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!mTextUsuario.getText().toString().trim().equals("")){
                    boolean existeCorreo;
                    DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                    databaseAccess.openWrite();
                    existeCorreo=databaseAccess.checkCorreo(mTextUsuario.getText().toString());
                    //Toast.makeText(MainActivity.this, usuario.getInfo(), Toast.LENGTH_SHORT).show();
                    databaseAccess.close();
                    if(existeCorreo){
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


                            Intent intent = new Intent(MainActivity.this, MainMenuActivity.class);
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
                        Toast.makeText(MainActivity.this,"El usuario no existe",Toast.LENGTH_LONG).show();
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
        Toast.makeText(MainActivity.this, "Debe iniciar Sesion", Toast.LENGTH_SHORT).show();
    }
}
