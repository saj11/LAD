package com.example.lad_android.Profesor;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.R;

import java.util.List;

public class ProfesorHistorialCursoActivity extends AppCompatActivity {

    ListView mListaAsistencia;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_historial_curso);
        this.setTitle("Historial de listas de asistencia");
        bundle = getIntent().getExtras();
        mListaAsistencia = (ListView)findViewById(R.id.ProfesorHistorialListView);

        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        List<String> lista = databaseAccess.getListaAsisntenciaProfesorCurso(bundle.getString("IDCurso"),bundle.getString("Numero"));
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1,lista);
        mListaAsistencia.setAdapter(adapter);

    }
}
