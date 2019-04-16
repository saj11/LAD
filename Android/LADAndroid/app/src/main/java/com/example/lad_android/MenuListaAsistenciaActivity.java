package com.example.lad_android;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MenuListaAsistenciaActivity extends AppCompatActivity {

    TextView mTextCurso;
    TextView mTextCodigo;
    Button mBtnListaAsis;
    Button mBtnGenQR;
    Button mBtnHistorial;
    Button mBtnEstadistica;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu_lista_asistencia);
        this.setTitle("");
        mTextCurso = (TextView)findViewById(R.id.MenuListaAsisCursoTV);
        mTextCodigo = (TextView)findViewById(R.id.MenuListaAsisCodigoTV);
        mBtnListaAsis = (Button) findViewById(R.id.MenuListaAsisAsistenciaBtn);
        mBtnGenQR = (Button) findViewById(R.id.MenuListaAsisQRBtn);
        mBtnHistorial = (Button)findViewById(R.id.MenuListaAsisHistorialBtn);
        mBtnEstadistica = (Button)findViewById(R.id.MenuListaAsisEstadisticaBtn);
        bundle = getIntent().getExtras();
        mTextCurso.setText(bundle.getString("NombreCurso"));
        mTextCodigo.setText(bundle.getString("IDCurso"));

        mBtnListaAsis.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MenuListaAsistenciaActivity.this, ListaAsistenciaGrupo.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        mBtnGenQR.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MenuListaAsistenciaActivity.this, QRCodigoActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

    }
}
