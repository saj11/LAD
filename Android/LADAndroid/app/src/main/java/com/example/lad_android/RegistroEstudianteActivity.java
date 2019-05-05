package com.example.lad_android;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;

public class RegistroEstudianteActivity extends AppCompatActivity {

    private EditText mTextUsuario;
    private EditText mTextCarne;
    private EditText mTextCorreo;
    private EditText mTextContra;
    private EditText mTextRepitaContra;
    private Button mBtnSignup;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registro_estudiante);

        mTextUsuario = (EditText) findViewById(R.id.registroEstudianteUsuario);
        mTextCarne = (EditText) findViewById(R.id.registroEstudianteCarne);
        mTextCorreo = (EditText) findViewById(R.id.registroEstudianteCorreo);
        mTextContra = (EditText) findViewById(R.id.registroEstudianteContra);
        mTextRepitaContra = (EditText) findViewById(R.id.registroEstudianteRepitaContra);
        mBtnSignup = (Button) findViewById(R.id.registroEstudianteBtnSignup);

        mBtnSignup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                registrarUsuarioEstudiante(mTextCorreo.getText().toString().toLowerCase());
            }
        });

    }

    public void registrarUsuarioEstudiante(String correo){
        String email = correo.toLowerCase().trim();
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        boolean checkCorreo = databaseAccess.checkCorreoEstudiante(correo);
        databaseAccess.close();
        if(!checkCorreo){
            if(!mTextUsuario.getText().toString().trim().equals("")  & !mTextCorreo.getText().toString().trim().equals("")){
                if(!mTextContra.getText().toString().equals("") & !mTextRepitaContra.getText().toString().equals("")){
                    if(mTextContra.getText().toString().equals(mTextRepitaContra.getText().toString())){
                        databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                        databaseAccess.openWrite();
                        String res = databaseAccess.registrarUsuarioEstudiante(mTextCarne.getText().toString(), mTextUsuario.getText().toString(),  mTextCorreo.getText().toString().toLowerCase().trim(), mTextContra.getText().toString());
                        Toast.makeText(this, res, Toast.LENGTH_SHORT).show();
                        databaseAccess.close();
                        Intent intent = new Intent(this, MainActivity.class);
                        startActivity(intent);
                    }
                    else{
                        Toast.makeText(RegistroEstudianteActivity.this,"Las contraseñas deben ser iguales",Toast.LENGTH_LONG).show();
                    }
                }
                else{
                    Toast.makeText(this,"Los campos Contraseña y Repita contraseña deben ser llenados",Toast.LENGTH_LONG).show();
                }
            }
            else{
                Toast.makeText(this,"Los campos Nombre, Carne y Correo deben ser llenados",Toast.LENGTH_LONG).show();
            }
        }
        else{
            Toast.makeText(this,"El correo ya existe",Toast.LENGTH_LONG).show();
        }
    }
}
