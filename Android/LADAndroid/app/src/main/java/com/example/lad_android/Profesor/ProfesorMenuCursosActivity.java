package com.example.lad_android.Profesor;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.ProfesorMainMenuActivity;
import com.example.lad_android.R;
import com.example.lad_android.models.DatosUsuario;

import java.util.List;

public class ProfesorMenuCursosActivity extends AppCompatActivity {

    TextView mTextUsuario;
    ListView mListLista;
    FloatingActionButton mButtonCrear;
    Bundle bundle;
    List<DatosUsuario> listaCursos;
    ImageView mImgViewQR;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_menu_cursos);
        this.setTitle("Cursos");
        bundle = getIntent().getExtras();
        mTextUsuario = (TextView)findViewById(R.id.ProfesorMenuCursosUsuario);
        mTextUsuario.setText(bundle.getString("usuario")+" "+bundle.getString("apellido"));
        mTextUsuario.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfesorMenuCursosActivity.this, PerfilActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });


        mListLista = (ListView)findViewById(R.id.ProfesorMenuCursosListView);
        //crear Cursos
        mButtonCrear = (FloatingActionButton)findViewById(R.id.ProfesorMenuCursosFloatingBtn);
        mButtonCrear.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfesorMenuCursosActivity.this, CrearGrupoActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        mImgViewQR = (ImageView)findViewById(R.id.ProfesorMenuCursoImageViewQR);
        bundle = getIntent().getExtras();

        mImgViewQR.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent=new Intent(ProfesorMenuCursosActivity.this, ProfesorMainMenuActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        listaCursos = databaseAccess.getAllDatoGrupo(Integer.toString(bundle.getInt("id")));
        databaseAccess.close();

        MyCustomAdapter myCustomAdapter = new MyCustomAdapter(listaCursos,ProfesorMenuCursosActivity.this);
        mListLista.setAdapter(myCustomAdapter);

    }

    public class MyCustomAdapter extends BaseAdapter implements ListAdapter {

        private List<DatosUsuario> list;
        private Context context;

        public MyCustomAdapter(List<DatosUsuario> list, Context context) {
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
                view = inflater.inflate(R.layout.list_item_profesor, null);
            }
            view.setBackgroundResource(R.drawable.border);

            Button listDeleteBtn = (Button) view.findViewById(R.id.list_btn_delete);
            listDeleteBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    new AlertDialog.Builder(context)
                            .setTitle("Eliminar Curso")
                            .setMessage("¿Está seguro de borrar este curso?")

                            // Specifying a listener allows you to take an action before dismissing the dialog.
                            // The dialog is automatically dismissed when a dialog button is clicked.
                            .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // Continue with delete operation
                                    int numero = Integer.parseInt(list.get(position).getNumeroGrupo());
                                    String curso = list.get(position).getCodigoCurso();
                                    int idProfe = getIntent().getExtras().getInt("id");
                                    list.remove(position);

                                    try{
                                        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                                        databaseAccess.openWrite();
                                        databaseAccess.deleteGrupo(curso, numero,idProfe);
                                        databaseAccess.close();
                                        notifyDataSetChanged();
                                    }catch (Exception e){
                                        Log.d("Delete-btn","Error en borrar");
                                    }
                                }
                            })

                            // A null listener allows the button to dismiss the dialog and take no further action.
                            .setNegativeButton(android.R.string.no, null)
                            .setIcon(android.R.drawable.ic_dialog_alert)
                            .show();



                }
            });

            TextView listItemText = (TextView) view.findViewById(R.id.list_item_string);
            TextView listItemright = (TextView) view.findViewById(R.id.list_item_string_right);
            listItemright.setText("Grupo: "+list.get(position).getNumeroGrupo());
            listItemText.setText(list.get(position).getCodigoCurso()+" - "+list.get(position).getNombreCurso());
            listItemText.setOnClickListener(new View.OnClickListener(
                    //sdk version min 16
            ) {
                @Override
                public void onClick(View v) {
                    //gurda en el intent - todos son string
                    Intent intent = new Intent(context, ProfesorMenuListaAsistenciaActivity.class);
                    intent.putExtra("IDCurso",list.get(position).getCodigoCurso());
                    intent.putExtra("NombreCurso",list.get(position).getNombreCurso());
                    intent.putExtra("Numero",list.get(position).getNumeroGrupo());
                    intent.putExtra("Horario1",list.get(position).getDia1());
                    intent.putExtra("Horario2",list.get(position).getDia2());
                    intent.putExtras(bundle);
                    startActivity(intent);
                }
            });




            return view;
        }
    }
}
