package com.example.lad_android;

import android.content.Context;
import android.content.Intent;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;

public class MenuGrupoActivity extends AppCompatActivity {

    TextView mTextCurso;
    ListView mListGrupos;
    FloatingActionButton mFloatBtn;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu_grupo);
        this.setTitle("Grupos");
        mTextCurso = (TextView)findViewById(R.id.MenuGrupoText);
        mListGrupos = (ListView) findViewById(R.id.MenuGrupoLista);
        mFloatBtn = (FloatingActionButton) findViewById(R.id.MenuGrupoBtn);
        bundle = getIntent().getExtras();
        Intent i = getIntent();
        String curso = i.getStringExtra("IDCurso");
        int idProfe = bundle.getInt("id");
        //Toast.makeText(this,"ID es: "+idProfe,Toast.LENGTH_LONG).show();
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        String nombreCurso = databaseAccess.getNombreCurso(curso);
        List<String> lista = databaseAccess.getGrupo(curso,Integer.toString(idProfe));
        MyCustomAdapterGrupo arrayAdapter = new MyCustomAdapterGrupo(lista, this);

        //ArrayAdapter<String> arrayAdapter = new ArrayAdapter<String>(MainMenuActivity.this, android.R.layout.simple_list_item_1,lista);
        mListGrupos.setAdapter(arrayAdapter);
        mTextCurso.setText(curso+" - "+nombreCurso);

        mFloatBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MenuGrupoActivity.this,CrearCursoActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

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
                    //Toast.makeText(context,list.get(position),Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent(context, MenuListaAsistenciaActivity.class);
                    intent.putExtra("Numero",list.get(position));
                    intent.putExtras(bundle);
                    startActivity(intent);
                }
            });

            Button dltBtn = (Button) view.findViewById(R.id.delete_btn);

            dltBtn.setOnClickListener( new View.OnClickListener(){
                                           @Override
                                           public void onClick(View v) {
                                               int numero = Integer.parseInt(list.get(position));
                                               String curso = getIntent().getExtras().getString("IDCurso");
                                               int idProfe = getIntent().getExtras().getInt("id");
                                               list.remove(position);
                                               //delete in db
                                               try{
                                                   DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                                                   databaseAccess.openWrite();
                                                   databaseAccess.deleteGrupo(curso, numero,idProfe);
                                                   //databaseAccess.deleteCurso(curso);
                                                   databaseAccess.close();
                                                   //Toast.makeText(v.getContext(),"Datos, ID: "+curso+" ,Numero: "+numero+ ", Profe;"+idProfe,Toast.LENGTH_LONG).show();
                                                   //Toast.makeText(v.getContext(),"Se elimino Grupo "+numero+"del Curso"+curso+" correctamente",Toast.LENGTH_SHORT).show();
                                                   Intent intent = new Intent(v.getContext(),MainMenuActivity.class);
                                                   intent.putExtras(bundle);
                                                   startActivity(intent);
                                               }
                                               catch (Exception e){
                                                   Toast.makeText(v.getContext(),"Hubo un error, ID: "+curso+" ,Numero: "+numero+ ", Profe;"+idProfe,Toast.LENGTH_LONG).show();
                                               }

                                               notifyDataSetChanged();
                                           }
                                       }
            );



            return view;
        }
    }
}
