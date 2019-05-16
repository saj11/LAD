package com.example.lad_android.Profesor;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.CalendarView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.R;
import com.example.lad_android.models.DatosCalendario;
import com.example.lad_android.models.DatosListaAsistenciaEstudiante;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class ProfesorHistorialCursoActivity extends AppCompatActivity {

    ListView mListaAsistencia;
    CalendarView mCalendarV;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_historial_curso);
        this.setTitle("Historial de listas de asistencia");
        bundle = getIntent().getExtras();
        mListaAsistencia = (ListView)findViewById(R.id.ProfesorHistorialListView);
        mCalendarV = (CalendarView) findViewById(R.id.ProfesorHistorialCalendario);

        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        List<DatosCalendario> listaCalendario = databaseAccess.getListaAsisnteciaProfesorCurso(bundle.getString("IDCurso"),bundle.getString("Numero"));
        List<String> lista = databaseAccess.getListaAsisntenciaProfesorCurso(bundle.getString("IDCurso"),bundle.getString("Numero"));
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1,lista);
        mListaAsistencia.setAdapter(adapter);

        mCalendarV.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
            @Override
            public void onSelectedDayChange(CalendarView view, int year, int month, int dayOfMonth) {
                String date = "";
                int id = 0;
                if(month<10 & dayOfMonth<10){
                    date=""+year+"-0"+(month+1)+"-0"+dayOfMonth;
                }
                else if(month <10 & dayOfMonth>9){
                    date = ""+year+"-0"+(month+1)+"-"+dayOfMonth;
                }
                else if(month>9 & dayOfMonth<10){
                    date = ""+year+"-"+(month+1)+"-0"+dayOfMonth;
                }
                else {
                    date = ""+year+"-"+(month+1)+"-"+dayOfMonth;
                }

                //Toast.makeText(ProfesorHistorialCursoActivity.this, date, Toast.LENGTH_LONG).show();

                for(int i=0; i<listaCalendario.size();i++){
                    try {
                        String listaFecha = listaCalendario.get(i).getFecha();
                        DateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        Date dia = inputFormat.parse(listaFecha);
                        DateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                        String output = outputFormat.format(dia);
                        Toast.makeText(ProfesorHistorialCursoActivity.this, "OUTPUT: "+output+" Date: "+date,Toast.LENGTH_LONG).show();
                        if(output.equals(date)){

                            id = listaCalendario.get(i).getID();
                            databaseAccess.openWrite();
                            List<DatosListaAsistenciaEstudiante> listaEstudiante = databaseAccess.getListaAsistenciaPorEstudiante(id);
                            databaseAccess.close();
                            MyCustomAdapterGrupo myCustomAdapterGrupo = new MyCustomAdapterGrupo(listaEstudiante,ProfesorHistorialCursoActivity.this);
                            mListaAsistencia.setAdapter(myCustomAdapterGrupo);
                            Toast.makeText(ProfesorHistorialCursoActivity.this, "Lo encontre id: "+id,Toast.LENGTH_LONG).show();
                        }

                    }catch (Exception e){
                        Log.d("Profesor","Historial, no parsio bien el dia");
                    }
                }


            }
        });

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

                }
            });

            return view;
        }
    }
}
