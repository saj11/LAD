package com.example.lad_android.Estudiante;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ListView;
import android.widget.TextView;

import com.example.lad_android.R;

public class EstudianteEstadisticaCursoActivity extends AppCompatActivity {

    ListView mListView;
    TextView mTextPresente, mTextTardia, mTextAusente;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_estudiante_estadistica_curso);

        mListView = (ListView)findViewById(R.id.EstudianteEstadisticaCursoListViewEstudiantes);
        mTextPresente = (TextView) findViewById(R.id.EstudianteEstadisticaCursoNumeroPresenteTV);
        mTextTardia = (TextView) findViewById(R.id.EstudianteEstadisticaCursoNumeroTardiaTV);
        mTextAusente = (TextView) findViewById(R.id.EstudianteEstadisticaCursoNumeroAusenteTV);



    }
}
