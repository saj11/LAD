package com.example.lad_android.Profesor;

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
import com.example.lad_android.MainActivity;
import com.example.lad_android.R;

public class PerfilActivity extends AppCompatActivity {

    TextView mTextUsuario;
    TextView mTextCorreo;
    EditText mEditTiempoCod;
    EditText mEditTiempoEst;
    TextView mTextCambNombre;
    TextView mTextCambContra;
    TextView mTextCerrarSesion;
    TextView mTextEliminar;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_perfil);
        this.setTitle("Perfil");
        mTextUsuario = (TextView)findViewById(R.id.PerfilUsuario);
        mTextCorreo = (TextView) findViewById(R.id.PerfilCorreoTV);
        mEditTiempoCod = (EditText)findViewById(R.id.PerfilTiempoCodigo);
        mEditTiempoEst = (EditText)findViewById(R.id.PerfilTiempoEstudiante);
        mTextCambNombre = (TextView)findViewById(R.id.PerfilCambiarNombre);
        mTextCambContra = (TextView)findViewById(R.id.PerfilCambiarContra);
        mTextCerrarSesion = (TextView)findViewById(R.id.PerfilCerrarSesion);
        mTextEliminar = (TextView)findViewById(R.id.PerfilEliminarPerfil);
        bundle = getIntent().getExtras();
        String user = bundle.getString("usuario")+" "+bundle.getString("apellido");
        String correo = bundle.getString("correo");
        mTextUsuario.setText(user);
        mTextCorreo.setText(correo);

        mTextCambNombre.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder alertDialog = new AlertDialog.Builder(PerfilActivity.this);
                alertDialog.setTitle("Cambio de Nombre");
                final EditText nuevoNombre = new EditText(PerfilActivity.this);
                final EditText nuevoApellido = new EditText(PerfilActivity.this);

                nuevoNombre.setHint("Nombre");
                nuevoApellido.setHint("Apellidos");
                LinearLayout layout = new LinearLayout(PerfilActivity.this);
                layout.setOrientation(LinearLayout.VERTICAL);
                layout.addView(nuevoNombre);
                layout.addView(nuevoApellido);
                alertDialog.setView(layout);
                alertDialog.setPositiveButton("Yes",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                                databaseAccess.openWrite();
                                databaseAccess.cambiarNombre(nuevoNombre.getText().toString(),nuevoApellido.getText().toString(), Integer.toString(bundle.getInt("id")));
                                databaseAccess.close();
                                bundle.putString("usuario",nuevoNombre.getText().toString());
                                bundle.putString("apellido",nuevoApellido.getText().toString());
                                mTextUsuario.setText(nuevoNombre.getText().toString()+" "+nuevoApellido.getText().toString());
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

        mTextCambContra.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder alertDialog = new AlertDialog.Builder(PerfilActivity.this);
                alertDialog.setTitle("Cambio de Contraseña");
                final EditText nuevaContra = new EditText(PerfilActivity.this);
                final EditText confirmarContra = new EditText(PerfilActivity.this);

                nuevaContra.setTransformationMethod(PasswordTransformationMethod.getInstance());
                confirmarContra.setTransformationMethod(PasswordTransformationMethod.getInstance());
                nuevaContra.setHint("Nueva Contraseña");
                confirmarContra.setHint("Confirmar Contraseña");
                LinearLayout layout = new LinearLayout(PerfilActivity.this);
                layout.setOrientation(LinearLayout.VERTICAL);
                layout.addView(nuevaContra);
                layout.addView(confirmarContra);
                alertDialog.setView(layout);
                alertDialog.setPositiveButton("Yes",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                Toast.makeText(PerfilActivity.this,"Cambie contraseña a:"+nuevaContra.getText().toString(),Toast.LENGTH_SHORT).show();
                                if(nuevaContra.getText().toString().equals(confirmarContra.getText().toString())){
                                    DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                                    databaseAccess.openWrite();
                                    databaseAccess.cambiarContrasena(nuevaContra.getText().toString(), Integer.toString(bundle.getInt("id")));
                                    databaseAccess.close();
                                    dialog.cancel();
                                }
                                else{
                                    Toast.makeText(PerfilActivity.this,"Las contraseñas deben ser iguales",Toast.LENGTH_SHORT).show();
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
                Intent intent = new Intent(PerfilActivity.this, MainActivity.class);
                startActivity(intent);
            }
        });

        mTextEliminar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                databaseAccess.openWrite();
                databaseAccess.deletePerfilUsuario(Integer.toString(bundle.getInt("id")));
                databaseAccess.close();
                Intent intent = new Intent(PerfilActivity.this, MainActivity.class);
                startActivity(intent);
            }
        });


    }
}
