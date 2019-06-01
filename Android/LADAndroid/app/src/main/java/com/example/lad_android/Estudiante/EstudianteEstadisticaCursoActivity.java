package com.example.lad_android.Estudiante;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.Profesor.ProfesorEstadisticaCursoActivity;
import com.example.lad_android.R;
import com.example.lad_android.models.DatosCursoEstudiante;
import com.example.lad_android.models.DatosListaAsistenciaEstudiante;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class EstudianteEstadisticaCursoActivity extends AppCompatActivity {

    ListView mListView;
    TextView mTextPresente, mTextTardia, mTextAusente;
    Bundle bundle;
    ImageView mImageViewCamara;
    int idListaAsistencia =-1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_estudiante_estadistica_curso);
        bundle = getIntent().getExtras();
        mListView = (ListView)findViewById(R.id.EstudianteEstadisticaCursoListViewEstudiantes);
        mTextPresente = (TextView) findViewById(R.id.EstudianteEstadisticaCursoNumeroPresenteTV);
        mTextTardia = (TextView) findViewById(R.id.EstudianteEstadisticaCursoNumeroTardiaTV);
        mTextAusente = (TextView) findViewById(R.id.EstudianteEstadisticaCursoNumeroAusenteTV);
        mImageViewCamara = (ImageView) findViewById(R.id.EstudianteEstadisticaCursoImageViewCamara);

        Date date = Calendar.getInstance().getTime();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String fechaActual = formatter.format(date);
        Log.d("TAG-Fecha-antes",fechaActual);
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        idListaAsistencia = databaseAccess.getListaAsistenciaID(bundle.getString("IDCurso"),bundle.getString("Numero"),fechaActual);
        List<DatosListaAsistenciaEstudiante> lista = databaseAccess.getListaAsistenciaPorEstudiante(idListaAsistencia);
        MyCustomAdapterGrupo myAdapter = new MyCustomAdapterGrupo(lista, EstudianteEstadisticaCursoActivity.this);
        mListView.setAdapter(myAdapter);
        updateEstadistica();

    }

    public void updateEstadistica(){
        DatabaseAccess databaseAccess2 = DatabaseAccess.getInstance(getApplicationContext());
        int presente=0, tardia=0, ausente=0;
        List<DatosCursoEstudiante> lista = databaseAccess2.getEstadisticasEstudiante(bundle.getInt("carne"));
        for(int i=0;i<lista.size();i++){
            if(lista.get(i).getEstado().equals("Presente")){
                presente+=1;
            }
            else if(lista.get(i).getEstado().equals("Tardia")){
                tardia+=1;
            }
            else{
                ausente+=1;
            }
        }
        mTextPresente.setText(Integer.toString(presente));
        mTextTardia.setText(Integer.toString(tardia));
        mTextAusente.setText(Integer.toString(ausente));
    }

    public class MyCustomAdapterGrupo extends BaseAdapter implements ListAdapter {

        private List<DatosListaAsistenciaEstudiante> list;
        private Context context;

        public MyCustomAdapterGrupo(List<DatosListaAsistenciaEstudiante> list, Context context) {
            this.list = list;
            this.context = context;
        }

        @Override
        public int getCount() {
            return list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return 0;
        }

        @Override
        public View getView(final int position, final View convertView, ViewGroup parent) {
            View view = convertView;
            if(view == null){
                LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                view = inflater.inflate(R.layout.list_item_asistencia, null);
            }

            TextView listItemEstudiante = (TextView) view.findViewById(R.id.list_item_asis_estudiante);
            TextView listItemEstado = (TextView) view.findViewById(R.id.list_item_asis_estado);
            //listItemText.setText(list.get(position));
            //view.setBackgroundResource(R.drawable.border);

            listItemEstudiante.setText(list.get(position).getNombre()+" - "+list.get(position).getCarne());
            listItemEstado.setText(list.get(position).getEstado());

            listItemEstudiante.setOnClickListener(new View.OnClickListener(

            ) {
                @Override
                public void onClick(View v) {

                }
            });

            return view;
        }
    }
}
