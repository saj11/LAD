package com.example.lad_android.Profesor;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.example.lad_android.ProfesorMainMenuActivity;
import com.example.lad_android.R;

public class ProfesorMenuListaAsistenciaActivity extends AppCompatActivity {

    TextView mTextCurso, mTextGrupo;
    Button mBtnListaAsis, mBtnEstadistica, mBtnHistorial;
    Bundle bundle;
    ImageView mImgViewQR;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_menu_lista_asistencia);
        this.setTitle("Menu Lista Asistencia");
        mTextCurso = (TextView)findViewById(R.id.ProfesorMenuAsisCodCursoTV);
        mTextGrupo = (TextView)findViewById(R.id.ProfesorMenuAsisGrupoTV);
        mBtnListaAsis = (Button)findViewById(R.id.ProfesorMenuAsisListaAsisBtn);
        mBtnEstadistica = (Button)findViewById(R.id.ProfesorMenuAsisEstadisticaBtn);
        mBtnHistorial = (Button)findViewById(R.id.ProfesorMenuAsisHistorialBtn);
        mImgViewQR = (ImageView)findViewById(R.id.ProfesorMenuAsisImageViewQR);
        bundle = getIntent().getExtras();
        //mTextCurso.setText(bundle.getString("IDCurso")+" - "+bundle.getString("NombreCurso"));
        //mTextGrupo.setText("Grupo: "+bundle.getString("Numero"));
        mImgViewQR.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfesorMenuListaAsistenciaActivity.this, ProfesorMainMenuActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        mBtnListaAsis.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfesorMenuListaAsistenciaActivity.this, ListaAsistenciaGrupo.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        mBtnEstadistica.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfesorMenuListaAsistenciaActivity.this, ProfesorEstadisticaCursoActivity.class );
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        mBtnHistorial.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfesorMenuListaAsistenciaActivity.this, ProfesorHistorialCursoActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

    }
}
