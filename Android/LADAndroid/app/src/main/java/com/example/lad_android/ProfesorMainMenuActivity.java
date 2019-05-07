package com.example.lad_android;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.CountDownTimer;
import android.support.annotation.NonNull;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.Profesor.CrearGrupoActivity;
import com.example.lad_android.Profesor.PerfilActivity;
import com.example.lad_android.models.DatosUsuario;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.journeyapps.barcodescanner.BarcodeEncoder;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class ProfesorMainMenuActivity extends AppCompatActivity {

    ViewPager viewPager;
    LinearLayout sliderDotspanel;
    ListView mListV;
    ImageView mImgViewQR, mImgViewCurso;
    TextView mTextPerfil, thirdPanelTV;
    boolean mTimerRunning;

    private int dotscount;
    private ImageView[] dots;
    private int[] layouts = {R.layout.slides_first_slide, R.layout.slides_second_slide, R.layout.slides_third_slide};
    private MpagerAdapter mpagerAdapter;
    private CountDownTimer countDownTimer;
    private long mTimeLeftinMillis = START_TIME_MILLIS;
    Bundle bundle;
    List<DatosUsuario> listaCursos;
    private static final long START_TIME_MILLIS = 600000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        bundle = getIntent().getExtras();
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_main_menu);
        //Text view
        mTextPerfil = (TextView)findViewById(R.id.ProfesorMainPerfil);
        mTextPerfil.setText(bundle.getString("usuario")+" "+bundle.getString("apellido"));
        mTextPerfil.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfesorMainMenuActivity.this, PerfilActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        //Image view
        mImgViewQR = (ImageView) findViewById(R.id.ProfesorMainImageViewQR);


        mImgViewCurso = (ImageView)findViewById(R.id.ProfesorMainImageCursos);

        mImgViewCurso.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfesorMainMenuActivity.this, ProfesorMenuCursosActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });
        //list view
        mListV = (ListView)findViewById(R.id.ProfesorMainFirsListView);
        final DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        List<String> list = databaseAccess.getAllGrupo(Integer.toString(bundle.getInt("id")));
        listaCursos = databaseAccess.getAllDatoGrupo(Integer.toString(bundle.getInt("id")));
        /*ArrayAdapter<String> itemsAdapter =
                new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, list);
        mListV.setAdapter(itemsAdapter);*/
        MyCustomAdapter myCustomAdapter = new MyCustomAdapter(listaCursos,ProfesorMainMenuActivity.this);
        mListV.setAdapter(myCustomAdapter);


        //dots view
        sliderDotspanel = (LinearLayout)findViewById(R.id.ProfesorMainLinearLayout);

        viewPager = (ViewPager)findViewById(R.id.ProfesorMainViewPager);

        //Entrada: Paso un objeto de DatosUsuario especifico

        mpagerAdapter = new MpagerAdapter(layouts,this,listaCursos.get(0));
        viewPager.setAdapter(mpagerAdapter);

        dotscount = mpagerAdapter.getCount();
        dots= new ImageView[dotscount];
        for(int i=0; i<dotscount;i++){
            dots[i] = new ImageView(this);
            dots[i].setImageDrawable(ContextCompat.getDrawable(getApplicationContext(),R.drawable.nonactive_dot));

            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            params.setMargins(8,0,8,0);
            sliderDotspanel.addView(dots[i],params);
        }
        dots[0].setImageDrawable(ContextCompat.getDrawable(getApplicationContext(),R.drawable.active_dot));

        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {

            }

            @Override
            public void onPageSelected(int i) {
                for(int j =0; j<dotscount; j++){
                    dots[j].setImageDrawable(ContextCompat.getDrawable(getApplicationContext(),R.drawable.nonactive_dot));
                }
                dots[i].setImageDrawable(ContextCompat.getDrawable(getApplicationContext(),R.drawable.active_dot));
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });

    }

    public class MpagerAdapter extends PagerAdapter{

        private int[]layouts;
        private LayoutInflater layoutInflater;
        private Context context;
        private DatosUsuario datos;

        public MpagerAdapter(int[]layouts, Context context){
            this.layouts = layouts;
            this.context = context;

        }

        public MpagerAdapter(int[]layouts, Context context, DatosUsuario datos){
            this.layouts = layouts;
            this.context = context;
            this.datos = datos;
        }


        @Override
        public int getCount() {
            return layouts.length;
        }

        @Override
        public boolean isViewFromObject(@NonNull View view, @NonNull Object o) {
            return view==o;
        }

        @NonNull
        @Override
        public Object instantiateItem(@NonNull ViewGroup container, int position) {
            layoutInflater = (LayoutInflater)this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

            View one= getFirstPanel(layoutInflater);
            View two= getSecondPanel(layoutInflater);
            View three = getThirdPanel(layoutInflater);
            View viewarr[]={one,two,three};
            container.addView(viewarr[position]);
            updateCountDownText();
            return viewarr[position];
        }

        @Override
        public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
            View view = (View)object;
            container.removeView(view);
        }

        public View getFirstPanel(LayoutInflater inflater){
            View returnView = inflater.inflate(R.layout.slides_first_slide,null);
            ImageView codigoQr = (ImageView) returnView.findViewById(R.id.ProfesorMainFirstSlideImage);
            //formato de lectura del qr = codigo.nombre.grupo.dia1.dia2
            String contenido = datos.getCodigoCurso()+"!"+datos.getNombreCurso()+"!"+datos.getNumeroGrupo()+"!"+datos.getProfesor()+"!"+datos.getDia1()+"!"+datos.getDia2();
            MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
            BitMatrix bitMatrix = null;
            try {
                bitMatrix = multiFormatWriter.encode(contenido, BarcodeFormat.QR_CODE, 1000, 1000);
                BarcodeEncoder barcodeEncoder = new BarcodeEncoder();
                Bitmap bitmap = barcodeEncoder.createBitmap(bitMatrix);
                codigoQr.setImageBitmap(bitmap);
            } catch (WriterException e) {
                e.printStackTrace();
            }

            return returnView;

        }

        public View getSecondPanel(LayoutInflater inflater){
            View returnView = inflater.inflate(R.layout.slides_second_slide,null);
            TextView tv = (TextView) returnView.findViewById(R.id.ProfesorMainSecondSlideCodCurso);
            //tv.setTextColor(Color.parseColor("#fffff"));
            TextView tvGrupo = (TextView) returnView.findViewById(R.id.ProfesorMainSecondSlideGrupo);
            TextView tvDia1 = (TextView)returnView.findViewById(R.id.ProfesorMainSecondSlideHorario1);
            tvDia1.setTextColor(Color.parseColor("#010203"));
            TextView tvDia2 = (TextView)returnView.findViewById(R.id.ProfesorMainSecondslideHorario2);
            tvDia2.setTextColor(Color.parseColor("#010203"));
            tv.setText(datos.getNombreCurso());
            tvGrupo.setText("Grupo: "+ datos.getNumeroGrupo());
            String[] horario1 = datos.getDia1().split("-");
            String[] horario2 = datos.getDia2().split("-");
            tvDia1.setText("       "+horario1[0]+"\n"+horario1[1]+"-"+horario1[2]);
            tvDia2.setText("       "+horario2[0]+"\n"+horario2[1]+"-"+horario2[2]);

            return returnView;
        }

        public View getThirdPanel(LayoutInflater inflater){
            View returnView = inflater.inflate(R.layout.slides_third_slide,null);
            thirdPanelTV = (TextView) returnView.findViewById(R.id.ProfesorMainThirSlideTimer);
            Button mBtnStart = (Button) returnView.findViewById(R.id.ProfesorMainThirdSlideBtnStart);

            mBtnStart.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    String[] horario1 = datos.getDia1().split("-");
                    String[] horario2 = datos.getDia2().split("-");

                    if(checkDiaListaAsistencia(horario1[0],horario2[0])){
                        if(mTimerRunning){
                            mTimeLeftinMillis = START_TIME_MILLIS;
                            mTimerRunning = false;
                            countDownTimer.cancel();
                            updateCountDownText();
                        }
                        else {
                            Date date = Calendar.getInstance().getTime();
                            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            String fechaActual = formatter.format(date);
                            Log.d("TAG-Fecha-antes",fechaActual);
                            DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                            databaseAccess.openWrite();
                            int idListaAsistencia = databaseAccess.getListaAsistenciaID(datos.getCodigoCurso(),datos.getNumeroGrupo(),fechaActual);
                            databaseAccess.close();
                            if(idListaAsistencia==-1){
                                databaseAccess.openWrite();
                                databaseAccess.crearListaAsistencia(datos.getCodigoCurso(),datos.getNumeroGrupo());
                                databaseAccess.close();
                                Toast.makeText(ProfesorMainMenuActivity.this, "La lista de asistencia ha sido iniciada con exito", Toast.LENGTH_LONG).show();
                                startTimer();
                            }
                            else if(idListaAsistencia == -2){
                                Toast.makeText(ProfesorMainMenuActivity.this, "Hubo un error, cod:"+datos.getCodigoCurso()+", grupo: "+datos.getNumeroGrupo(),Toast.LENGTH_LONG).show();
                            }
                            else if(idListaAsistencia == -3){
                                Toast.makeText(ProfesorMainMenuActivity.this,"Nulo",Toast.LENGTH_LONG).show();
                            }
                            else{
                                Toast.makeText(ProfesorMainMenuActivity.this, "La lista de asistencia ya existe", Toast.LENGTH_LONG).show();
                                startTimer();
                            }
                            //startTimer();
                        }
                    }

                    else{
                        Toast.makeText(ProfesorMainMenuActivity.this,"No se encuentra en el horario establecido", Toast.LENGTH_LONG).show();
                    }
                }
            });

            return returnView;


        }

        private void startTimer(){
            countDownTimer = new CountDownTimer(mTimeLeftinMillis, 1000) {
                @Override
                public void onTick(long millisUntilFinished) {
                    mTimeLeftinMillis = millisUntilFinished;
                    updateCountDownText();
                }

                @Override
                public void onFinish() {
                    mTimerRunning = false;
                }
            }.start();
            mTimerRunning = true;
        }
        public void updateCountDownText(){
            int minutes =(int) (mTimeLeftinMillis/1000) /60;
            int seconds =(int) (mTimeLeftinMillis/1000) %60;
            String timeLeftFormatted = String.format(Locale.getDefault(),"%02d:%02d",minutes,seconds);
            thirdPanelTV.setText(timeLeftFormatted);
        }


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

            TextView listItemRightText = (TextView) view.findViewById(R.id.list_item_string_right);
            final TextView listItemText = (TextView) view.findViewById(R.id.list_item_string);
            listItemText.setText(list.get(position).getCodigoCurso( )+" - "+list.get(position).getNombreCurso());
            listItemRightText.setText("Grupo: "+list.get(position).getNumeroGrupo());

            listItemText.setOnClickListener(new View.OnClickListener(
                    //sdk version min 16
            ) {
                @Override
                public void onClick(View v) {
                    viewPager = (ViewPager) findViewById(R.id.ProfesorMainViewPager);
                    mpagerAdapter = new MpagerAdapter(layouts,ProfesorMainMenuActivity.this,list.get(position));
                    viewPager.setAdapter(mpagerAdapter);
                    dots[0].setImageDrawable(ContextCompat.getDrawable(getApplicationContext(),R.drawable.active_dot));
                    if(mTimerRunning){
                        countDownTimer.cancel();
                    }
                    mTimerRunning = false;

                    /*
                    try{
                        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                        databaseAccess.openWrite();
                        String res = databaseAccess.crearListaAsistencia(list.get(position).getCodigoCurso(),list.get(position).getNumeroGrupo());
                        databaseAccess.close();
                        Toast.makeText(context,"Resultado: "+res,Toast.LENGTH_LONG).show();
                    }catch (Exception e){
                        Toast.makeText(context,"Erro en catch",Toast.LENGTH_LONG).show();
                    }*/

                }
            });

            return view;
        }
    }

    //Entrada: Letra del horario del curso
    //Salida: True si el dia concuerda
    public boolean checkDiaListaAsistencia(String letraDia1, String letraDia2){
        Date date = Calendar.getInstance().getTime();
        String dia = (String) android.text.format.DateFormat.format("EEEE",date);
        if(dia.equals(getDia(letraDia1)) | dia.equals(getDia(letraDia2))){
            return true;
        }

        return false;



    }

    //entrada: letra del horario
    //salida: Dia asociada con la letra
    public String getDia(String letraDia){
        String dia = letraDia.toLowerCase();
        switch (dia){
            case "l":
                return "Monday";
            case "k":
                return "Tuesday";
            case "m":
                return "Wednesday";
            case "j":
                return "Thursday";
            case "v":
                return "Friday";
            case "s":
                return "Saturday";
            default:
                return "Domingo";
        }
    }

}


