package com.example.lad_android;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.widget.Toast;

import com.example.lad_android.DatabaseHelper.DatabaseAccess;
import com.example.lad_android.Estudiante.MainMenuEstudianteCursoActivity;
import com.google.zxing.Result;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import me.dm7.barcodescanner.zxing.ZXingScannerView;

import static android.Manifest.permission.CAMERA;

public class MainMenuEstudianteActivity extends AppCompatActivity implements ZXingScannerView.ResultHandler, GestureDetector.OnGestureListener {

    private static final int REQUEST_CAMERA = 1;
    private ZXingScannerView scannerView;
    private GestureDetector gestureDetector;
    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setTitle("LAD-Estudiante");
        scannerView = new ZXingScannerView(this);
        setContentView(scannerView);
        bundle = getIntent().getExtras();
        gestureDetector = new GestureDetector(this);

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
            if (checkPermission()){
                Toast.makeText(MainMenuEstudianteActivity.this, "Permission granted", Toast.LENGTH_LONG).show();
            }
            else{
                requestPermissions(new String[]{CAMERA}, REQUEST_CAMERA);
            }
        }
    }

    private Boolean checkPermission(){
        return (ContextCompat.checkSelfPermission(MainMenuEstudianteActivity.this, CAMERA)) == PackageManager.PERMISSION_GRANTED;
    }

    public void onRequestPermissionsResult(int requestCode, String permission[], int grantResults[]){
        switch (requestCode){
            case REQUEST_CAMERA:
                if (grantResults.length > 0){
                    boolean cameraAccepted = grantResults[0] == PackageManager.PERMISSION_GRANTED;
                    if (cameraAccepted){
                        Toast.makeText(MainMenuEstudianteActivity.this, "Permission granted",Toast.LENGTH_LONG).show();
                    }
                    else{
                        Toast.makeText(MainMenuEstudianteActivity.this,"Permission denied",Toast.LENGTH_LONG).show();
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
                            if(shouldShowRequestPermissionRationale(CAMERA)){
                                displayAlertMessage("You need to allow access for both permissions", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        requestPermissions(new String[]{CAMERA},REQUEST_CAMERA);
                                    }
                                });
                                return;
                            }
                        }
                    }
                }
                break;
        }
    }

    @Override
    public void onResume(){
        super.onResume();
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
            if(checkPermission()){
                if(scannerView == null){
                    scannerView = new ZXingScannerView(this);
                    setContentView(scannerView);
                }
                scannerView.setResultHandler(this);
                scannerView.startCamera();
            }
            else{
                requestPermissions(new String[]{CAMERA}, REQUEST_CAMERA);
            }
        }
    }

    @Override
    public void onDestroy(){
        super.onDestroy();
        scannerView.stopCamera();
    }

    public void displayAlertMessage(String message, DialogInterface.OnClickListener Listener){
        new AlertDialog.Builder(MainMenuEstudianteActivity.this).setMessage(message)
                .setPositiveButton("OK", Listener)
                .setNegativeButton("Cancel",null)
                .create().show();
    }


    @Override
    public void handleResult(Result result) {
        String scanResult = result.getText();
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Curso");
        final String[] split = scanResult.split("!");
        builder.setPositiveButton("Ok", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                databaseAccess.openWrite();
                int id = databaseAccess.getListaAsistenciaID(split[0],split[2]);
                if(id>0){
                    //String res = databaseAccess.registrarAsistenciaEstudiante(id, bundle.getInt("carne"),"Presente");
                    String res = checkPresente(id,split[4],split[5]);
                    Toast.makeText(MainMenuEstudianteActivity.this,res,Toast.LENGTH_LONG).show();
                }
                else{
                    Toast.makeText(MainMenuEstudianteActivity.this,"La lista de asistencia no se encuentra disponible, id:"+Integer.toString(id)+"splite "+split[0]+","+split[2]
                            ,Toast.LENGTH_LONG).show();
                }
                databaseAccess.close();
                scannerView.resumeCameraPreview(MainMenuEstudianteActivity.this);
            }
        });

        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
                databaseAccess.openWrite();
                int id = databaseAccess.getListaAsistenciaID(split[0],split[2]);
                databaseAccess.close();
                String res = checkPresente(id, split[4],split[5]);
                Toast.makeText(MainMenuEstudianteActivity.this, res, Toast.LENGTH_LONG).show();
                scannerView.resumeCameraPreview(MainMenuEstudianteActivity.this);
            }
        });


        //String res = split[0]+"/n"+split[1]+"/n"+split[2]+"/n"+split[3]+"/n"+split[4];

        builder.setMessage(split[3]+"\n"+split[0]+"\n"+split[1]+"\n"+split[2]+"\n"+split[4]+"\n"+split[5]);
        AlertDialog alert = builder.create();
        alert.show();
        //aqui va el codigo
    }

    // DEBERIA AGARRAR LA HORA DE LA BD CUANDO SE CREA LA LISTA DE ASISTENCIA, PÉRO POR EL MOMENTO USA LA HORA ESTABLECIDA POR EL CURSO
    public String checkPresente(int idListaAsistencia, String hora1, String hora2){

        String[] primerHora  = hora1.split("-");
        String[] segundaHora = hora2.split("-");
        if(checkDiaListaAsistencia(primerHora[0])){
            SimpleDateFormat df = new SimpleDateFormat("HH:mm");
            try{
                Date d = df.parse(primerHora[1]);
                Calendar cal = Calendar.getInstance();
                cal.setTime(d);
                cal.add(Calendar.MINUTE, 10);
                String newTime = df.format(cal.getTime());
                Date newT = df.parse(newTime);

                Calendar currentTime = Calendar.getInstance();
                String currentT = df.format(currentTime.getTime());

                long duration = d.getTime() - newT.getTime();

                if(duration>=0){
                    return "Presente";
                }
                else if(duration<0 && duration>=-30){
                    return "Tardia";
                }
                else{
                    return "Ausente";
                }


            }
            catch (Exception e){
                Log.d("Estudiante", "Error en pasrser 1");
                return "Error";
            }
        }
        else if (checkDiaListaAsistencia(segundaHora[0])){
            SimpleDateFormat df = new SimpleDateFormat("HH:mm");
            try{
                Date d = df.parse(segundaHora[1]);
                Calendar cal = Calendar.getInstance();
                cal.setTime(d);
                cal.add(Calendar.MINUTE, 10);
                String newTime = df.format(cal.getTime());
                Date newT = df.parse(newTime);

                Calendar currentTime = Calendar.getInstance();
                String currentT = df.format(currentTime.getTime());

                long duration = d.getTime() - newT.getTime();

                if(duration>=0){
                    return "Presente";
                }
                else if(duration<0 && duration>=-30){
                    return "Tardia";
                }
                else{
                    return "Ausente";
                }
            }
            catch (Exception e){
                Log.d("Estudiante", "Error en pasrser 2");
                return "Error";
            }
        }
        else{
            return "NA";
        }
    }

    @Override
    public boolean onDown(MotionEvent e) {
        return false;
    }

    @Override
    public void onShowPress(MotionEvent e) {

    }

    @Override
    public boolean onSingleTapUp(MotionEvent e) {
        return false;
    }

    @Override
    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
        return false;
    }

    @Override
    public void onLongPress(MotionEvent e) {

    }

    @Override
    public boolean onFling(MotionEvent downEvent, MotionEvent moveEvent, float velocityX, float velocityY) {
        boolean result = false;

        float diffY = moveEvent.getY()-downEvent.getY();
        float diffX = moveEvent.getX() - downEvent.getX();

        if(Math.abs(diffX)> Math.abs(diffY) ){
            //right or left swipe
            if(Math.abs(diffX) > 100 && Math.abs(velocityX) >50){
                if (diffX > 0){
                    onSwipeRight();
                }
                else{
                    onSwipeLeft();
                }
                return result = true;
            }
            return result;
        }
        else {
            //down or up swipe
            return result;
        }
    }

    private void onSwipeLeft() {
        Toast.makeText(MainMenuEstudianteActivity.this,"Izquireda",Toast.LENGTH_LONG).show();
        Intent intent = new Intent(MainMenuEstudianteActivity.this, MainMenuEstudianteCursoActivity.class);
        intent.putExtras(bundle);
        startActivity(intent);
    }


    private void onSwipeRight() {
        int res = bundle.getInt("carne");
        DatabaseAccess databaseAccess = DatabaseAccess.getInstance(getApplicationContext());
        databaseAccess.openWrite();
        String stringR = databaseAccess.getListaAsistenciaFecha(13);
        databaseAccess.close();
        Toast.makeText(MainMenuEstudianteActivity.this,"Resultado"+Integer.toString(res)+"..."+stringR,Toast.LENGTH_LONG).show();
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        gestureDetector.onTouchEvent(event);
        return super.onTouchEvent(event);
    }

    public boolean checkDiaListaAsistencia(String letraDia){
        Date date = Calendar.getInstance().getTime();
        String dia = (String) android.text.format.DateFormat.format("EEEE",date);
        if(dia.equals(getDia(letraDia))){
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
