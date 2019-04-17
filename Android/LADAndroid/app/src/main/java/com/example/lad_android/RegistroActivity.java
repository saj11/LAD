package com.example.lad_android;

import android.content.ContentValues;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class RegistroActivity extends AppCompatActivity {

    EditText mTextUsuario;
    EditText mTextApellido;
    EditText mTextCorreo;
    EditText mTextContra;
    EditText mTextRepContra;
    Button mButtonSignup;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registro);

        mTextUsuario = (EditText) findViewById(R.id.registroUsuario);
        mTextApellido = (EditText) findViewById(R.id.registroApellido);
        mTextCorreo = (EditText) findViewById(R.id.registroCorreo);
        mTextContra =(EditText) findViewById(R.id.registroContra);
        mTextRepContra = (EditText) findViewById(R.id.registroRepContra);
        mButtonSignup = (Button) findViewById(R.id.registroBtnSignup);

        mButtonSignup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                registrarUsuario(mTextUsuario.getText().toString(), mTextApellido.getText().toString(), mTextCorreo.getText().toString().trim(),mTextRepContra.getText().toString());
            }
        });
    }


    public void registrarUsuario(String usuario, String apellido, String correo, String contra){
        String email = correo.toLowerCase().trim();
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        boolean checkCorreo = databaseAccess.checkCorreo(correo);
        databaseAccess.close();
        if(!checkCorreo){
            if(!mTextUsuario.getText().toString().trim().equals("") & !mTextApellido.getText().toString().trim().equals("") & !mTextCorreo.getText().toString().trim().equals("")){
                if(!mTextContra.getText().toString().equals("") & !mTextRepContra.getText().toString().equals("")){
                    if(mTextContra.getText().toString().equals(mTextRepContra.getText().toString())){
                        databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                        databaseAccess.openWrite();
                        String res = databaseAccess.registrarUsuario(usuario, apellido, correo, contra);
                        Toast.makeText(this, res, Toast.LENGTH_SHORT).show();
                        databaseAccess.close();
                        Intent intent = new Intent(this, MainActivity.class);
                        startActivity(intent);
                    }
                    else{
                        Toast.makeText(this, "Las contraseñas deben ser iguales",Toast.LENGTH_LONG).show();
                    }
                }
                else{
                    Toast.makeText(this,"Los campos Contraseña y Repita contraseña deben ser llenados",Toast.LENGTH_LONG).show();
                }
            }
            else{
                Toast.makeText(this,"Los campos Nombre, Apellido y Correo deben ser llenados",Toast.LENGTH_LONG).show();
            }
        }
        else{
            Toast.makeText(this,"El correo ya existe",Toast.LENGTH_LONG).show();
        }
    }
}
