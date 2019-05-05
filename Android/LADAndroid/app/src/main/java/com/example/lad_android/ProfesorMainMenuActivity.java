package com.example.lad_android;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.annotation.NonNull;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.example.lad_android.models.DatosUsuario;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.journeyapps.barcodescanner.BarcodeEncoder;

import java.util.List;
import java.util.zip.Inflater;

public class ProfesorMainMenuActivity extends AppCompatActivity {

    ViewPager viewPager;
    LinearLayout sliderDotspanel;

    private int dotscount;
    private ImageView[] dots;
    private int[] layouts = {R.layout.slides_first_slide, R.layout.slides_second_slide};
    private MpagerAdapter mpagerAdapter;
    Bundle bundle;
    List<DatosUsuario> listaCursos;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profesor_main_menu);
        bundle = getIntent().getExtras();
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        listaCursos = databaseAccess.getCursosProfe(bundle.getInt("id"));
        databaseAccess.close();

        viewPager = (ViewPager)findViewById(R.id.ProfesorMainViewPager);
        mpagerAdapter = new MpagerAdapter(layouts,this);
        viewPager.setAdapter(mpagerAdapter);

    }

    public class MpagerAdapter extends PagerAdapter{

        private int[]layouts;
        private LayoutInflater layoutInflater;
        private Context context;

        public MpagerAdapter(int[]layouts, Context context){
            this.layouts = layouts;
            this.context = context;

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
            View viewarr[]={one,two};
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
            tv.setText("hola");
            return returnView;
        }
    }

}


