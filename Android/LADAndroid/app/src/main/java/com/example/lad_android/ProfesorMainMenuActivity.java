package com.example.lad_android;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.models.DatosUsuario;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.journeyapps.barcodescanner.BarcodeEncoder;

import java.util.List;

public class ProfesorMainMenuActivity extends AppCompatActivity {

    ViewPager viewPager;
    LinearLayout sliderDotspanel;
    ListView mListV;
    ImageView mImgViewQR, mImgViewCurso;
    private int dotscount;
    private ImageView[] dots;
    private int[] layouts = {R.layout.slides_first_slide, R.layout.slides_second_slide, R.layout.slides_third_slide};
    private MpagerAdapter mpagerAdapter;
    Bundle bundle;
    List<DatosUsuario> listaCursos;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        bundle = getIntent().getExtras();
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_main_menu);
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
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        List<String> list = databaseAccess.getAllGrupo(Integer.toString(bundle.getInt("id")));
        listaCursos = databaseAccess.getAllDatoGrupo(Integer.toString(bundle.getInt("id")));
        databaseAccess.close();
        /*ArrayAdapter<String> itemsAdapter =
                new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, list);
        mListV.setAdapter(itemsAdapter);*/
        MyCustomAdapter myCustomAdapter = new MyCustomAdapter(listaCursos,ProfesorMainMenuActivity.this);
        mListV.setAdapter(myCustomAdapter);



        //dots view
        sliderDotspanel = (LinearLayout)findViewById(R.id.ProfesorMainLinearLayout);

        viewPager = (ViewPager)findViewById(R.id.ProfesorMainViewPager);
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
            String contenido = "hola";
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
            TextView tvGrupo = (TextView) returnView.findViewById(R.id.ProfesorMainSecondSlideGrupo);
            TextView tvDia1 = (TextView)returnView.findViewById(R.id.ProfesorMainSecondSlideHorario1);
            TextView tvDia2 = (TextView)returnView.findViewById(R.id.ProfesorMainSecondslideHorario2);
            tv.setText(datos.getNombreCurso());
            tvGrupo.setText(datos.getNumeroGrupo());
            tvDia1.setText(datos.getDia1());
            tvDia2.setText(datos.getDia2());

            return returnView;
        }

        public View getThirdPanel(LayoutInflater inflater){
            View returnView = inflater.inflate(R.layout.slides_third_slide,null);
            TextView tv = (TextView) returnView.findViewById(R.id.ProfesorMainThirSlideCodCurso);
            tv.setText("hola");
            return returnView;
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
            listItemText.setText(list.get(position).getCodigoCurso()+" Grupo; "+list.get(position).getNumeroGrupo()+" - "+list.get(position).getNombreCurso());
            //listItemText.setBackground(gd);
            //listItemText.setWidth(200);
            //listItemText.setMinHeight(50);
            //listItemText.setBackgroundResource(R.drawable.border);
            //listItemText.setTextColor(Color.parseColor("#FF3E80F1"));
            //listItemText.setPadding(0,10,0,0);
            //listItemText.setBackgroundColor(Color.parseColor("#FF3E80F1"));

            //view.setBackgroundColor(Color.parseColor("#FF3E80F1"));
            listItemText.setOnClickListener(new View.OnClickListener(
                    //sdk version min 16
            ) {
                @Override
                public void onClick(View v) {
                    viewPager = (ViewPager)findViewById(R.id.ProfesorMainViewPager);
                    mpagerAdapter = new MpagerAdapter(layouts,ProfesorMainMenuActivity.this,list.get(position));
                    viewPager.setAdapter(mpagerAdapter);
                    dots[0].setImageDrawable(ContextCompat.getDrawable(getApplicationContext(),R.drawable.active_dot));

                }
            });




            return view;
        }
    }

}


