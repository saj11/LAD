package com.example.lad_android;

import android.content.Context;
import android.content.Intent;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

public class MainMenuActivity extends AppCompatActivity {

    TextView mTextUsuario;
    ListView mListLista;
    FloatingActionButton mButtonCrear;
    Bundle bundle = new Bundle();
    List<String> lista;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);
        this.setTitle("Cursos");
        bundle = getIntent().getExtras();
        Intent i = getIntent();
        mTextUsuario = (TextView) findViewById(R.id.MainMenuUsuario);
        mListLista = (ListView)findViewById(R.id.MainMenuLista);
        mButtonCrear = (FloatingActionButton) findViewById(R.id.MainMenuBtn);
        //String usuario = i.getStringExtra("usuario");
        String usuario = bundle.getString("usuario");
        int id = bundle.getInt("id");
        //Toast.makeText(MainMenuActivity.this, "this user is: "+id,Toast.LENGTH_SHORT).show();
        mTextUsuario.setText(usuario);
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        lista = databaseAccess.getCursos(id);
        List<String> listaNombreCurso = new ArrayList<String>();
        for(int j=0;j<lista.size();j++){
            listaNombreCurso.add(lista.get(j)+" - "+databaseAccess.getNombreCurso(lista.get(j)));
        }
        //Toast.makeText(this, "Cantidad = "+listaNombreCurso.size(),Toast.LENGTH_LONG).show();
        MyCustomAdapter arrayAdapter = new MyCustomAdapter(listaNombreCurso, MainMenuActivity.this);
        databaseAccess.close();
        //ArrayAdapter<String> arrayAdapter = new ArrayAdapter<String>(MainMenuActivity.this, android.R.layout.simple_list_item_1,lista);
        mListLista.setAdapter(arrayAdapter);

        mTextUsuario.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainMenuActivity.this, PerfilActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        mButtonCrear.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainMenuActivity.this, CrearGrupoActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });


    }

    public class MyCustomAdapter extends BaseAdapter implements ListAdapter {

        private List<String> list;
        private Context context;

        public MyCustomAdapter(List<String> list, Context context) {
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
        public View getView(final int position, View convertView, ViewGroup parent) {
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

                    DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                    databaseAccess.openWrite();
                    String nombreCurso = databaseAccess.getNombreCurso(lista.get(position));
                    databaseAccess.close();
                    //Toast.makeText(context,lista.get(position),Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent(context, MenuGrupoActivity.class);
                    intent.putExtra("IDCurso",lista.get(position));
                    intent.putExtra("NombreCurso",nombreCurso);
                    intent.putExtras(bundle);
                    startActivity(intent);
                }
            });

            Button dltBtn = (Button) view.findViewById(R.id.delete_btn);

            dltBtn.setOnClickListener( new View.OnClickListener(){
                                           @Override
                                           public void onClick(View v) {
                                               String eliminar= lista.get(position);
                                               list.remove(position);
                                               //delete in db
                                               try{
                                                   DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                                                   databaseAccess.openWrite();
                                                   databaseAccess.deleteCurso(eliminar);
                                                   databaseAccess.close();
                                                   Toast.makeText(v.getContext(),"Se elimino "+eliminar+" correctamente",Toast.LENGTH_SHORT).show();
                                               }
                                               catch (Exception e){
                                                   Toast.makeText(v.getContext(),"Hubo un error, ID: "+eliminar,Toast.LENGTH_SHORT).show();
                                               }
                                               notifyDataSetChanged();
                                           }
                                       }
            );



            return view;
        }
    }


}
