package com.example.lad_android.DatabaseHelper;

import android.content.Context;

import com.readystatesoftware.sqliteasset.SQLiteAssetHelper;

public class DatabaseOpenHelper extends SQLiteAssetHelper {
    private static final String DATABASE_NAME="LAD_Android_Testing.db";
    private static int DATABASE_VERSION=1;

    public DatabaseOpenHelper(Context context){
        super (context, DATABASE_NAME, null, DATABASE_VERSION);
    }
}
