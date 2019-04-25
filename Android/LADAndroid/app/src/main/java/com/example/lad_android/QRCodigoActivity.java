package com.example.lad_android;

import android.graphics.Bitmap;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.journeyapps.barcodescanner.BarcodeEncoder;

public class QRCodigoActivity extends AppCompatActivity {

    private ImageView mImageQR;
    private Bundle bundle;
    private TextView mTextProfe, mTextCurso, mTextGrupo, mTextDia1, mTextDia2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_qrcodigo);
        this.setTitle("Codigo QR");
        bundle = getIntent().getExtras();
        mImageQR = (ImageView) findViewById(R.id.QRImageView);
        mTextProfe = (TextView)findViewById(R.id.QRUsuarioText);
        mTextCurso =(TextView)findViewById(R.id.QRCursoText);
        mTextGrupo = (TextView)findViewById(R.id.QRGrupoText);
        mTextDia1 = (TextView)findViewById(R.id.QRDia1Text);
        mTextDia2 = (TextView)findViewById(R.id.QRDia2Text);

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

        mTextProfe.setText(bundle.getString("usuario") +" "+ bundle.getString("apellido"));
        mTextCurso.setText(bundle.getString("IDCurso") + " "+ bundle.getString("NombreCurso"));
        mTextGrupo.setText("Grupo: "+bundle.getString("Numero"));

        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        String horario1 = databaseAccess.getHorario1(bundle.getString("IDCurso"),bundle.getString("Numero"), Integer.toString(bundle.getInt("id")));
        String horario2 = databaseAccess.getHorario2(bundle.getString("IDCurso"),bundle.getString("Numero"), Integer.toString(bundle.getInt("id")));
        databaseAccess.close();
        mTextDia1.setText(horario1);
        mTextDia2.setText(horario2);

    }
}
