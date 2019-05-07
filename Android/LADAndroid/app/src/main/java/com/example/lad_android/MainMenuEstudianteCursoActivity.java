package com.example.lad_android;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
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
import com.example.lad_android.models.DatosCursoEstudiante;
import com.example.lad_android.models.DatosUsuario;

import java.util.ArrayList;
import java.util.List;

public class MainMenuEstudianteCursoActivity extends AppCompatActivity {

    Bundle bundle;
    TextView mTextPerfil;
    ListView mListViewCurso;
    ImageView mImageViewCamara;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu_estudiante_curso);
        this.setTitle("Cursos");
        List<DatosCursoEstudiante> listaCursos = new ArrayList<DatosCursoEstudiante>();
        bundle = getIntent().getExtras();
        mTextPerfil = (TextView)findViewById(R.id.EstudianteMenuCursoPerfilTV);
        mListViewCurso = (ListView)findViewById(R.id.EstudianteMenuCursoListView);
        mImageViewCamara = (ImageView) findViewById(R.id.EstudianteMainMenuCamara);
        int carne = bundle.getInt("carne");
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        listaCursos = databaseAccess.getCursosEstudiante(carne);
        databaseAccess.close();
        MyCustomAdapter myCustomAdapter = new MyCustomAdapter(listaCursos,MainMenuEstudianteCursoActivity.this);
        mListViewCurso.setAdapter(myCustomAdapter);
        Toast.makeText(MainMenuEstudianteCursoActivity.this,Integer.toString(carne),Toast.LENGTH_LONG).show();

        mTextPerfil.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainMenuEstudianteCursoActivity.this, EstudiantePerfilActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        mImageViewCamara.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainMenuEstudianteCursoActivity.this, MainMenuEstudianteActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });
    }


    public class MyCustomAdapter extends BaseAdapter implements ListAdapter {

        private List<DatosCursoEstudiante> list;
        private Context context;

        public MyCustomAdapter(List<DatosCursoEstudiante> list, Context context) {
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
/*
            view.setBackgroundResource(R.drawable.border);
            GradientDrawable gd = new GradientDrawable();
            // Specify the shape of drawable
            gd.setShape(GradientDrawable.RECTANGLE);
            // Set the fill color of drawable
            gd.setColor(Color.TRANSPARENT); // make the background transparent
            // Create a 2 pixels width red colored border for drawable
            gd.setStroke(4, Color.BLUE); // border width and color
            // Make the border rounded
            gd.setCornerRadius(30.0f);
*/
            TextView listItemText = (TextView) view.findViewById(R.id.list_item_string);
            TextView listItemright = (TextView) view.findViewById(R.id.list_item_string_right);

            listItemText.setText(list.get(position).getIDCurso()+" - "+list.get(position).getNombreCurso());
            listItemright.setText("Grupo:"+list.get(position).getIDGrupo());

            //view.setBackgroundColor(Color.parseColor("#FF3E80F1"));
            listItemText.setOnClickListener(new View.OnClickListener(
                    //sdk version min 16
            ) {
                @Override
                public void onClick(View v) {

                }
            });




            return view;
        }
    }
}
