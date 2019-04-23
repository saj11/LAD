package com.example.lad_android;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class RegistroSeleccionActivity extends AppCompatActivity {

    private Button mBtnProfe, mBtnEstudiante;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registro_seleccion);
        mBtnProfe = (Button) findViewById(R.id.registroSelectBtnProfe);
        mBtnEstudiante = (Button) findViewById(R.id.registroSelectBtnEstudiante);

        mBtnProfe.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(RegistroSeleccionActivity.this, RegistroActivity.class);
                startActivity(intent);
            }
        });

        mBtnEstudiante.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(RegistroSeleccionActivity.this, RegistroEstudianteActivity.class);
                startActivity(intent);
            }
        });
    }
}
