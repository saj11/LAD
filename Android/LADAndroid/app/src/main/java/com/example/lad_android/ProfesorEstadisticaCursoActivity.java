package com.example.lad_android;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class ProfesorEstadisticaCursoActivity extends AppCompatActivity {

    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_estadistica_curso);
        bundle = getIntent().getExtras();

    }
}