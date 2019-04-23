package com.example.lad_android;

import android.graphics.Bitmap;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ImageView;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.journeyapps.barcodescanner.BarcodeEncoder;

public class QRCodigoActivity extends AppCompatActivity {

    private ImageView mImageQR;
    private Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_qrcodigo);
        this.setTitle("Codigo QR");
        bundle = getIntent().getExtras();
        mImageQR = (ImageView) findViewById(R.id.QRImageView);

        try {

            String contenido = bundle.getString("usuario")+"-"+bundle.getString("apellido")+"-"+bundle.getString("IDCurso")+"-"+bundle.getString("NombreCurso")
                    +"-Grupo-"+bundle.getString("Numero");

            MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
            BitMatrix bitMatrix = multiFormatWriter.encode(contenido, BarcodeFormat.QR_CODE, 1000, 1000);
            BarcodeEncoder barcodeEncoder = new BarcodeEncoder();
            Bitmap bitmap = barcodeEncoder.createBitmap(bitMatrix);
            mImageQR.setImageBitmap(bitmap);
        }
        catch (Exception e){

        }
    }
}
