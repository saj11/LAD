package com.example.lad_android.Profesor;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.R;
import com.example.lad_android.models.DatosListaAsistenciaEstudiante;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class ProfesorEstadisticaCursoActivity extends AppCompatActivity {

    ListView mListView;
    TextView mTextNumeroPresente, mTextNumeroTardia, mTextNumeroAusente;
    int idListaAsistencia =-1;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_estadistica_curso);
        mListView = (ListView) findViewById(R.id.ProfesorEstadisticaCursoListViewEstudiantes);
        mTextNumeroPresente = (TextView)findViewById(R.id.ProfesorEstadisticaCursoNumeroPresenteTV);
        mTextNumeroTardia = (TextView) findViewById(R.id.ProfesorEstadisticaCursoNumeroTardiaTV);
        mTextNumeroAusente = (TextView) findViewById(R.id.ProfesorEstadisticaCursoNumeroAusenteTV);
        bundle = getIntent().getExtras();
        this.setTitle("Estadisticas");

        Date date = Calendar.getInstance().getTime();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String fechaActual = formatter.format(date);
        Log.d("TAG-Fecha-antes",fechaActual);
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        idListaAsistencia = databaseAccess.getListaAsistenciaID(bundle.getString("IDCurso"),bundle.getString("Numero"),fechaActual);
        List<DatosListaAsistenciaEstudiante> lista = databaseAccess.getListaAsistenciaPorEstudiante(idListaAsistencia);
        //databaseAccess.close();

        MyCustomAdapterGrupo myAdapter = new MyCustomAdapterGrupo(lista, ProfesorEstadisticaCursoActivity.this);
        mListView.setAdapter(myAdapter);
        updateEstadisticas(lista);
        //se agarran todas los estudiantes de esta lista de asistencia y se despliegan

    }

    public void updateEstadisticas(List<DatosListaAsistenciaEstudiante> lista){
        int presentes=0, tardias=0, ausentes=0;
        for(int i=0; i<lista.size(); i++){
            if(lista.get(i).getEstado().equals("Presente")){
                presentes+=1;
            }
            else if(lista.get(i).getEstado().equals("Tardia")){
                tardias+=1;
            }
            else{
                ausentes+=1;
            }
        }
        mTextNumeroPresente.setText(Integer.toString(presentes));
        mTextNumeroTardia.setText(Integer.toString(tardias));
        mTextNumeroAusente.setText(Integer.toString(ausentes));

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
                    //cambiar estado estudiante con carne
                    DatabaseAccess databaseAccess2 = DatabaseAccess.getInstance(getApplicationContext());
                    List<DatosListaAsistenciaEstudiante> lista = databaseAccess2.getListasAsistencias(bundle.getString("IDCurso"),bundle.getString("Numero"));
                    int carne = list.get(position).getCarne();
                    if(lista.size()!=0){
                        String res="";
                        int presente = 0; int tardia=0; int ausente =0;
                        for(int i=0; i<lista.size();i++){
                            res = res+" - "+lista.get(i).getCarne()+" - "+lista.get(i).getEstado()+"\n";
                            if(carne == lista.get(i).getCarne()){
                                if(lista.get(i).getEstado().equals("Presente")){
                                    presente += 1;
                                }
                                else if(lista.get(i).getEstado().equals("Tardia")){
                                    tardia+=1;
                                }
                                else{
                                    ausente+=1;
                                }
                            }
                        }
                        mTextNumeroPresente.setText(Integer.toString(presente));
                        mTextNumeroTardia.setText(Integer.toString(tardia));
                        mTextNumeroAusente.setText(Integer.toString(ausente));
                        Toast.makeText(ProfesorEstadisticaCursoActivity.this, res, Toast.LENGTH_LONG).show();
                    }
                    else{
                        Toast.makeText(ProfesorEstadisticaCursoActivity.this,"Esta vacio",Toast.LENGTH_LONG).show();
                    }
                }
            });

            return view;
        }
    }
}
