package com.example.lad_android;

import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.Profesor.PerfilActivity;

public class EstudiantePerfilActivity extends AppCompatActivity {

    TextView mTextNbr, mTextCarne, mTextCorreo, mTextCambiarNbr, mTextCambiarContra, mTextCerrarSesion, mTextEliminar;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_estudiante_perfil);
        bundle = getIntent().getExtras();
        mTextNbr = (TextView)findViewById(R.id.EstudiantePerfilNombreTV);
        mTextCarne = (TextView)findViewById(R.id.EstudiantePerfilCarneTV);
        mTextCorreo = (TextView)findViewById(R.id.EstudiantePerfilCorreoTV);
        mTextCambiarNbr = (TextView)findViewById(R.id.EstudiantePerfilCambiarNombreTV);
        mTextCambiarContra = (TextView)findViewById(R.id.EstudiantePerfilCambiarContraTV);
        mTextCerrarSesion = (TextView)findViewById(R.id.EstudiantePerfilCerrarSesionTV);
        mTextEliminar = (TextView)findViewById(R.id.EstudiantePerfilEliminarTV);

        mTextNbr.setText(bundle.getString("usuario"));
        mTextCorreo.setText(bundle.getString("correo"));
        mTextCarne.setText(Integer.toString(bundle.getInt("carne")));

        mTextCambiarNbr.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder alertDialog = new AlertDialog.Builder(EstudiantePerfilActivity.this);
                alertDialog.setTitle("Cambio de Nombre");
                final EditText nuevoNombre = new EditText(EstudiantePerfilActivity.this);
                final EditText nuevoApellido = new EditText(EstudiantePerfilActivity.this);

                nuevoNombre.setHint("Nombre");
                nuevoApellido.setHint("Apellidos");
                LinearLayout layout = new LinearLayout(EstudiantePerfilActivity.this);
                layout.setOrientation(LinearLayout.VERTICAL);
                layout.addView(nuevoNombre);
                layout.addView(nuevoApellido);
                alertDialog.setView(layout);
                alertDialog.setPositiveButton("Yes",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                                databaseAccess.openWrite();
                                databaseAccess.cambiarNombreEstudiante(nuevoNombre.getText().toString()+" "+nuevoApellido.getText().toString(),bundle.getInt("carne"));
                                databaseAccess.close();
                                bundle.putString("usuario",nuevoNombre.getText().toString() + nuevoApellido.getText().toString());
                                mTextNbr.setText(nuevoNombre.getText().toString()+" "+nuevoApellido.getText().toString());
                                dialog.cancel();
                            }
                        });
                alertDialog.setNegativeButton("No",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                dialog.cancel();
                            }
                        });

                AlertDialog alert11 = alertDialog.create();
                alert11.show();
            }
        });

        mTextCambiarContra.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder alertDialog = new AlertDialog.Builder(EstudiantePerfilActivity.this);
                alertDialog.setTitle("Cambio de Contraseña");
                final EditText nuevaContra = new EditText(EstudiantePerfilActivity.this);
                final EditText confirmarContra = new EditText(EstudiantePerfilActivity.this);

                nuevaContra.setTransformationMethod(PasswordTransformationMethod.getInstance());
                confirmarContra.setTransformationMethod(PasswordTransformationMethod.getInstance());
                nuevaContra.setHint("Nueva Contraseña");
                confirmarContra.setHint("Confirmar Contraseña");
                LinearLayout layout = new LinearLayout(EstudiantePerfilActivity.this);
                layout.setOrientation(LinearLayout.VERTICAL);
                layout.addView(nuevaContra);
                layout.addView(confirmarContra);
                alertDialog.setView(layout);
                alertDialog.setPositiveButton("Yes",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                Toast.makeText(EstudiantePerfilActivity.this,"Cambie contraseña a:"+nuevaContra.getText().toString(),Toast.LENGTH_SHORT).show();
                                if(nuevaContra.getText().toString().equals(confirmarContra.getText().toString())){
                                    DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                                    databaseAccess.openWrite();
                                    databaseAccess.cambiarContrasenaEstudiante(nuevaContra.getText().toString(), bundle.getInt("carne"));
                                    databaseAccess.close();
                                    dialog.cancel();
                                }
                                else{
                                    Toast.makeText(EstudiantePerfilActivity.this,"Las contraseñas deben ser iguales",Toast.LENGTH_SHORT).show();
                                }

                            }
                        });
                alertDialog.setNegativeButton("No",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                dialog.cancel();
                            }
                        });

                AlertDialog alert11 = alertDialog.create();
                alert11.show();
            }
        });

        mTextCerrarSesion.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(EstudiantePerfilActivity.this, MainActivity.class);
                startActivity(intent);
            }
        });

        mTextEliminar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                databaseAccess.openWrite();
                databaseAccess.deleteEstudiante(Integer.toString(bundle.getInt("carne")));
                databaseAccess.close();
                Intent intent = new Intent(EstudiantePerfilActivity.this, MainActivity.class);
                startActivity(intent);
            }
        });

    }
}
