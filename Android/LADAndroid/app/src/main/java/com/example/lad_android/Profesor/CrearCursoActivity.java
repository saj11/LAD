package com.example.lad_android.Profesor;

import android.app.TimePickerDialog;
import android.content.Intent;
import android.graphics.Color;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.MainMenuActivity;
import com.example.lad_android.R;

import java.util.ArrayList;
import java.util.List;

public class CrearCursoActivity extends AppCompatActivity {

    Button mBtnCrear, mBtnLunes, mBtnMartes, mBtnMiercoles, mBtnJueves, mBtnViernes, mBtnSabado;
    EditText mTextInicioHora1, mTextFinalHora1, mTextInicioHora2, mTextFinalHora2;
    TextView mViewDia1, mViewDia2;
    String Dia1="", Dia2="";
    Bundle bundle = new Bundle();
    TimePickerDialog timePickerDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_crear_curso);
        mBtnCrear = (Button) findViewById(R.id.CrearCursoBtnCrear);
        mBtnLunes = (Button) findViewById(R.id.CrearCursoBtnLunes);
        mBtnMartes = (Button) findViewById(R.id.CrearCursoBtnMartes);
        mBtnMiercoles = (Button) findViewById(R.id.CrearCursoBtnMiercoles);
        mBtnJueves = (Button) findViewById(R.id.CrearCursoBtnJueves);
        mBtnViernes = (Button) findViewById(R.id.CrearCursoBtnViernes);
        mBtnSabado = (Button) findViewById(R.id.CrearCursoBtnSabado);
        mViewDia1 = (TextView) findViewById(R.id.CrearCursoTextViewDia1);
        mViewDia2 = (TextView) findViewById(R.id.CrearCursoTextViewDia2);
        mTextInicioHora1 = (EditText) findViewById(R.id.CrearCursoPrimerHoraInicioText);
        mTextFinalHora1 = (EditText) findViewById(R.id.CrearCursoPrimerHoraFinalText);
        mTextInicioHora2 = (EditText) findViewById(R.id.CrearCursoSegundaHoraInicioText);
        mTextFinalHora2 = (EditText) findViewById(R.id.CrearCursoSegundaHoraFinalText);

        mTextInicioHora1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                timePickerDialog = new TimePickerDialog(CrearCursoActivity.this, new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        mTextInicioHora1.setText(hourOfDay+":"+minute);
                    }
                },0,00,true);
                timePickerDialog.show();
            }
        });

        mTextFinalHora1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                timePickerDialog = new TimePickerDialog(CrearCursoActivity.this, new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        mTextFinalHora1.setText(hourOfDay+":"+minute);
                    }
                },0,00,true);
                timePickerDialog.show();
            }
        });

        mTextInicioHora2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                timePickerDialog = new TimePickerDialog(CrearCursoActivity.this, new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        mTextInicioHora2.setText(hourOfDay+":"+minute);
                    }
                },0,00,true);
                timePickerDialog.show();
            }
        });

        mTextFinalHora2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                timePickerDialog = new TimePickerDialog(CrearCursoActivity.this, new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        mTextFinalHora2.setText(hourOfDay+":"+minute);
                    }
                },0,00,true);
                timePickerDialog.show();
            }
        });


        bundle = getIntent().getExtras();
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        List<String> listaNbr = databaseAccess.getListaCursosNombre();
        final List<String> listaCod = databaseAccess.getListaCursosCodigo();
        databaseAccess.close();
        List<String> listaNbrCod = new ArrayList<String>();

        mBtnCrear.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if(Dia1!="" & Dia2!=""){
                    if(!"".equals(mTextInicioHora1.getText().toString()) & !"".equals(mTextInicioHora2.getText().toString()) & !"".equals(mTextFinalHora1.getText().toString()) & !"".equals(mTextFinalHora2.getText().toString()) ){
                        String CodigoCurso = bundle.getString("IDCurso");
                        //String CodigoCurso = listaCod.get(mSpinner.getSelectedItemPosition());

                        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                        databaseAccess.openWrite();
                        String NumeroDeGrupo = Integer.toString(databaseAccess.getCantidadGrupoDelCurso(CodigoCurso)+1);
                        String usuario = Integer.toString(bundle.getInt("id")) ;
                        String horario1 = Dia1+"-"+mTextInicioHora1.getText().toString()+"-"+mTextFinalHora1.getText().toString();
                        String horario2 = Dia2+"-"+mTextInicioHora2.getText().toString()+"-"+mTextFinalHora2.getText().toString();
                        try {
                            databaseAccess.agregarGrupo(CodigoCurso, NumeroDeGrupo, usuario, horario1, horario2);
                        }
                        catch (Exception e){
                            Toast.makeText(CrearCursoActivity.this,"Algo salio mal",Toast.LENGTH_SHORT).show();
                        }
                        databaseAccess.close();

                        //Toast.makeText(CrearGrupoActivity.this,"Hora: "+horario1 +" -"+horario2+"usuario: "+usuario+"numero de grypo: "+NumeroDeGrupo,Toast.LENGTH_LONG).show();
                        Intent intent = new Intent(CrearCursoActivity.this, MainMenuActivity.class);
                        intent.putExtras(bundle);
                        startActivity(intent);
                    }
                    else{
                        Toast.makeText(CrearCursoActivity.this, "Debe escribir las horas", Toast.LENGTH_SHORT).show();
                    }
                }
                else{
                    Toast.makeText(CrearCursoActivity.this, "Debe escoger 2 dias",Toast.LENGTH_SHORT).show();
                }

            }
        });

        mBtnLunes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Dia1=="L" | Dia2 == "L"){
                    mBtnLunes.setBackgroundColor(Color.parseColor("#ff669900"));
                    if (Dia1 == "L"){
                        Dia1="";
                        mViewDia1.setText("Dia1");
                    }
                    else{ Dia2 = "";
                        mViewDia2.setText("Dia2");
                    }
                }
                else{
                    if (Dia1 == ""){
                        mBtnLunes.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia1 = "L";
                        mViewDia1.setText("Lunes");
                    }
                    else if(Dia2==""){
                        mBtnLunes.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia2 = "L";
                        mViewDia2.setText("Lunes");
                    }
                    else{
                        Toast.makeText(CrearCursoActivity.this,"Ya ha seleccionado dos dias",Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });

        mBtnMartes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Dia1=="K" | Dia2 == "K"){
                    mBtnMartes.setBackgroundColor(Color.parseColor("#ff669900"));
                    if (Dia1 == "K"){
                        Dia1="";
                        mViewDia1.setText("Dia1");
                    }
                    else{ Dia2 = "";
                        mViewDia2.setText("Dia2");
                    }
                }
                else{
                    if (Dia1 == ""){
                        mBtnMartes.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia1 = "K";
                        mViewDia1.setText("Martes");
                    }
                    else if(Dia2==""){
                        mBtnMartes.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia2 = "K";
                        mViewDia2.setText("Martes");
                    }
                    else{
                        Toast.makeText(CrearCursoActivity.this,"Ya ha seleccionado dos dias",Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });

        mBtnMiercoles.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Dia1=="M" | Dia2 == "M"){
                    mBtnMiercoles.setBackgroundColor(Color.parseColor("#ff669900"));
                    if (Dia1 == "M"){
                        Dia1="";
                        mViewDia1.setText("Dia1");
                    }
                    else{ Dia2 = "";
                        mViewDia2.setText("Dia2");
                    }
                }
                else{
                    if (Dia1 == ""){
                        mBtnMiercoles.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia1 = "M";
                        mViewDia1.setText("Miercoles");
                    }
                    else if(Dia2==""){
                        mBtnMiercoles.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia2 = "M";
                        mViewDia2.setText("Miercoles");
                    }
                    else{
                        Toast.makeText(CrearCursoActivity.this,"Ya ha seleccionado dos dias",Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });

        mBtnJueves.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Dia1=="J" | Dia2 == "J"){
                    mBtnJueves.setBackgroundColor(Color.parseColor("#ff669900"));
                    if (Dia1 == "J"){
                        Dia1="";
                        mViewDia1.setText("Dia1");
                    }
                    else{ Dia2 = "";
                        mViewDia2.setText("Dia2");
                    }
                }
                else{
                    if (Dia1 == ""){
                        mBtnJueves.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia1 = "J";
                        mViewDia1.setText("Jueves");
                    }
                    else if(Dia2==""){
                        mBtnJueves.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia2 = "J";
                        mViewDia2.setText("Jueves");
                    }
                    else{
                        Toast.makeText(CrearCursoActivity.this,"Ya ha seleccionado dos dias",Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });

        mBtnViernes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Dia1=="V" | Dia2 == "V"){
                    mBtnViernes.setBackgroundColor(Color.parseColor("#ff669900"));
                    if (Dia1 == "V"){
                        Dia1="";
                        mViewDia1.setText("Dia1");
                    }
                    else{ Dia2 = "";
                        mViewDia2.setText("Dia2");
                    }
                }
                else{
                    if (Dia1 == ""){
                        mBtnViernes.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia1 = "V";
                        mViewDia1.setText("Viernes");
                    }
                    else if(Dia2==""){
                        mBtnViernes.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia2 = "V";
                        mViewDia2.setText("Viernes");
                    }
                    else{
                        Toast.makeText(CrearCursoActivity.this,"Ya ha seleccionado dos dias",Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });

        mBtnSabado.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Dia1=="S" | Dia2 == "S"){
                    mBtnSabado.setBackgroundColor(Color.parseColor("#ff669900"));
                    if (Dia1 == "S"){
                        Dia1="";
                        mViewDia1.setText("Dia1");
                    }
                    else{ Dia2 = "";
                        mViewDia2.setText("Dia2");
                    }
                }
                else{
                    if (Dia1 == ""){
                        mBtnSabado.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia1 = "S";
                        mViewDia1.setText("Sabado");
                    }
                    else if(Dia2==""){
                        mBtnSabado.setBackgroundColor(Color.parseColor("#ffcc0000"));
                        Dia2 = "S";
                        mViewDia2.setText("Sabado");
                    }
                    else{
                        Toast.makeText(CrearCursoActivity.this,"Ya ha seleccionado dos dias",Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });
    }
}
