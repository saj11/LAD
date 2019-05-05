package com.example.lad_android;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class ListaAsistenciaGrupo extends AppCompatActivity {

    TextView mTextCurso;
    TextView mTextCodigo;
    TextView mTextNumero;
    TextView mTextFecha;
    ListView mListListaEstudiante;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lista_asistencia_grupo);
        this.setTitle("Lista de Asistencia");
        bundle = getIntent().getExtras();
        mTextCurso = (TextView) findViewById(R.id.ListaAsisGrupoCursoTV);
        mTextCodigo = (TextView) findViewById(R.id.ListaAsisGrupoCodigoTV);
        mTextNumero = (TextView) findViewById(R.id.ListaAsisGrupoNumeroTV);
        mTextFecha = (TextView) findViewById(R.id.ListaAsisGrupoFechaTV);
        mListListaEstudiante = (ListView) findViewById(R.id.ListaAsisGrupoEstList);
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        int IDListaAsistencia = databaseAccess.getListaAsistenciaID(bundle.getString("IDCurso"),bundle.getString("Numero"));
        List<String> listaAsistenciaEstudiante = new ArrayList<String>();
        List<String> listaAsistenciaEstudianteEstado = new ArrayList<String>();
        String nombreCurso = databaseAccess.getNombreCurso(bundle.getString("IDCurso"));
        if(IDListaAsistencia>=0){
            listaAsistenciaEstudiante= databaseAccess.getListaAsitenciaEstudiante(IDListaAsistencia);
            listaAsistenciaEstudianteEstado = databaseAccess.getListaAsitenciaEstudianteEstado(IDListaAsistencia);
        }
        databaseAccess.close();
        mTextCurso.setText(bundle.getString("NombreCurso"));
        mTextCodigo.setText(bundle.getString("IDCurso"));
        mTextNumero.setText("Grupo: "+bundle.getString("Numero"));
        mTextFecha.setText(bundle.getString("Horario1")+"    "+bundle.getString("Horario2"));
        //mTextCurso.setText(nombreCurso);

        DateFormat day = new SimpleDateFormat("yyyy-mm-dd");
        String hoy = day.format(Calendar.getInstance().getTime());
        databaseAccess.openWrite();
        //String res= databaseAccess.crearListaAsistencia(bundle.getString("IDCurso"),bundle.getString("Numero"));
       // String res = databaseAccess.fetchListaAsistencia(bundle.getString("IDCurso"),bundle.getString("Numero"), hoy);
        String res = databaseAccess.fetchListaTest(bundle.getString("IDCurso"), bundle.getString("Numero"));
        databaseAccess.close();
        mTextCurso.setText(res);

    }

    public class MyCustomAdapterGrupo extends BaseAdapter implements ListAdapter {

        private List<String> list;
        private Context context;

        public MyCustomAdapterGrupo(List<String> list, Context context) {
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
                view = inflater.inflate(R.layout.list_item, null);
            }

            TextView listItemText = (TextView) view.findViewById(R.id.list_item_string);
            listItemText.setText(list.get(position));

            listItemText.setOnClickListener(new View.OnClickListener(

            ) {
                @Override
                public void onClick(View v) {
                    //cambiar estado estudiante con carne
                    Toast.makeText(context,list.get(position),Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent(context, ListaAsistenciaGrupo.class);
                    intent.putExtra("Numero",list.get(position));
                    startActivity(intent);
                }
            });

            return view;
        }
    }


}
