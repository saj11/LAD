//
//  SQLite.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 3/24/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import SQLite
import UIKit

class SQLiteManager: DataBaseManager {
    private var dbName:String!
    private var connection: Connection?
    private var dbUrlPath: URL!
    private var dbPath: String!
    
    func copyDatabaseIfNeeded() -> String{
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return ""// Could not find documents URL
        }
        
        self.dbUrlPath = documentsUrl.first!.appendingPathComponent(self.dbName)
        do {
            try fileManager.removeItem(at: self.dbUrlPath)
        }catch{
            print(error)
        }
        
        if !( (try? self.dbUrlPath.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(self.dbName)
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: self.dbUrlPath.path)
                //return documentsURL!.path
                return self.dbUrlPath.path
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
                return ""
            }
            
        } else {
            print("Database file found at path: \(self.dbUrlPath.path)")
            return self.dbUrlPath.path
        }
    }
    
    func copyDbToRoot() -> Bool{
        let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(self.dbName)
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.copyItem(atPath: self.dbPath, toPath: (documentsURL?.path)!)
            //return documentsURL!.path
            return true
        } catch let error as NSError {
            print("Couldn't copy file to final location! Error:\(error.description)")
            return false
        }
    }
    
    init(databaseName: String) {
        self.dbName = databaseName
        self.dbPath = self.copyDatabaseIfNeeded()
        self.connection = nil
    }
    
    func openDataBase() -> Bool{
        do{
            self.connection = try Connection(self.dbPath)
            return true
        } catch{
            return false
        }
    }
    
    func selectUser(typeUser: String)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        let table: Table
        do{
            if typeUser.elementsEqual("P"){ table = Table("Profesor") }
            else { table = Table("Estudiante") }
            
            let correo = Expression<String>("Correo")
            let query = table.select(correo)
            
            result = Array((try self.connection?.prepare(query))!)
        }catch{
            print("select user failed: \(error)")
        }
        return result
    }
    
    func addUser(typeUser: String, dataArray:Array<Any>)->Bool{
        let table: Table
        let nombre = Expression<String>("Nombre")
        let apellidos = Expression<String>("Apellidos")
        let correo = Expression<String>("Correo")
        let contraseña = Expression<String>("Contrasena")
        
        do{
            if typeUser.elementsEqual("P"){
                table = Table("Profesor")
                let tiempoTardiaCodigo = Expression<Int>("TiempoTardiaCodigo")
                let tiempoVigenciaCodigo = Expression<Int>("TiempoVigenciaCodigo")
                try self.connection?.run(table.insert(nombre <- dataArray[0] as! String, apellidos <- dataArray[1] as! String, correo <- dataArray[2] as! String, contraseña <- dataArray[3] as! String, tiempoTardiaCodigo <- dataArray[4] as! Int, tiempoVigenciaCodigo <- dataArray[5]  as! Int))
                return true
            }else{
                table = Table("Estudiante")
                let carne = Expression<Int>("Carne")
                try self.connection?.run(table.insert(carne <- dataArray[2] as! Int, nombre <- dataArray[0] as! String, apellidos <- dataArray[1] as! String, correo <- dataArray[3] as! String, contraseña <- dataArray[4] as! String))
                return true
            }
        }catch{
                print("select user failed: \(error)")
                print("Error: No se pudo ingresar el nuevo usuario a la BD.")
                return false
        }
    }
    
    func validateUser(input: String)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        do{
            let profesor = Table("Profesor")
            let nombre = Expression<String>("Nombre")
            let apellidos = Expression<String>("Apellidos")
            let contraseña = Expression<String>("Contrasena")
            let tiempoTardiaCodigo = Expression<Int>("TiempoTardiaCodigo")
            let tiempoVigenciaCodigo = Expression<Int>("TiempoVigenciaCodigo")
            let correo = Expression<String>("Correo")
            let query = profesor.select(nombre,apellidos, contraseña, tiempoTardiaCodigo, tiempoVigenciaCodigo)
                                .filter(correo == input)
            result = Array((try self.connection?.prepare(query))!)
        }catch{
            print("select user failed: \(error)")
        }
        return result
    }
    
    func numberOfCourse(email: String)-> Array<Row>?{
        var result: Array<Row>? = Array<Row>()
        do{
            let grupo = Table("Grupo")
            let profesor = Table("Profesor")
            let curso = Table("Curso")
            let id = Expression<Int64?>("ID")
            let idProfe = Expression<Int64?>("IDProfe")
            let correo = Expression<String?>("Correo")
            let nombre = Expression<String?>("Nombre")
            let idCurso = Expression<String?>("IDCurso")
            let codigo = Expression<String?>("Codigo")

            let query = grupo.select(curso[nombre], curso[codigo])
                             .join(profesor, on: grupo[idProfe] == profesor[id])
                             .join(curso, on: grupo[idCurso] == curso[codigo])
                .filter(profesor[correo] == email)

            result = Array(try (self.connection?.prepare(query))!)
            
            return result
        }catch{
            print("select user failed: \(error)")
        }
        return result
    }
    
    func groupOf(codCurso: String, email: String)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        do{
            let grupo = Table("Grupo")
            let profesor = Table("Profesor")
            let curso = Table("Curso")
            let id = Expression<Int64>("ID")
            let idProfe = Expression<Int64>("IDProfe")
            let correo = Expression<String>("Correo")
            let idCurso = Expression<String>("IDCurso")
            let codigo = Expression<String>("Codigo")
            let numero = Expression<Int>("Numero")
            let dia1 = Expression<String>("Dia1")
            let dia2 = Expression<String>("Dia2")
            let cod = Expression<String>("Codigo")
            let key = Expression<String>("Llave")
            
            let query = grupo.select(grupo[numero], grupo[dia1], grupo[dia2], grupo[cod], grupo[key])
                .join(profesor, on: grupo[idProfe] == profesor[id])
                .join(curso, on: grupo[idCurso] == curso[codigo])
                .where(profesor[correo] == email && curso[codigo] == codCurso)
            result = Array((try self.connection?.prepare(query))!)
            
            print(result)
            return result
        }catch{
            print("select user failed: \(error)")
        }
        return result
    }
    
    func crearLA(idC:String, idG: Int, fech:String, code:String)-> Bool{
        let listaAsistencia = Table("ListaAsistencia")
        let idCurso = Expression<String>("IDCurso")
        let idGrupo = Expression<Int>("IDGrupo")
        let fecha = Expression<String>("Fecha")
        
        let grupo = Table("Grupo")
        let numero = Expression<Int>("Numero")
        let idCurs = Expression<String>("IDCurso")
        let codigo = Expression<String>("Codigo")
        
        let insert = listaAsistencia.insert(idCurso <- idC, idGrupo <- idG, fecha <- fech)
        let update = grupo.filter(numero == idG && idCurs == idC).update(codigo <- code)
        do{
            try self.connection?.run(insert)
            do{
                try self.connection?.run(update)
                return true
            }catch{
                print(error)
                return false
            }
        }catch{
            print(error)
            return false
        }
    }
    
    func setTimeMaxPresence(email: String, time: Int) -> Bool{
        let profesor = Table("Profesor")
        let tiempoTardiaCodigo = Expression<Int>("TiempoTardiaCodigo")
        let correo = Expression<String>("Correo")
        
        let update = profesor.filter(correo == email).update(tiempoTardiaCodigo <- time)
        
        do{
            try self.connection?.run(update)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    func setTimeCodeAvailable(email: String, time: Int) -> Bool{
        let profesor = Table("Profesor")
        let tiempoVigenciaCodigo = Expression<Int>("TiempoVigenciaCodigo")
        let correo = Expression<String>("Correo")
        
        let update = profesor.filter(correo == email).update(tiempoVigenciaCodigo <- time)
        
        do{
            try self.connection?.run(update)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    func setNewPassword(email: String, password: String) -> Bool{
        let profesor = Table("Profesor")
        let contraseña = Expression<String>("Contrasena")
        let correo = Expression<String>("Correo")
        
        let update = profesor.filter(correo == email).update(contraseña <- password)
        
        do{
            try self.connection?.run(update)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    func updateCode(idC: String, idG: Int, code: String, key: String)-> Bool{
        let grupo = Table("Grupo")
        let numero = Expression<Int>("Numero")
        let idCurs = Expression<String>("IDCurso")
        let codigo = Expression<String>("Codigo")
        let llave = Expression<String>("Llave")
        
        let update = grupo.filter(numero == idG && idCurs == idC).update(codigo <- code, llave <- key)
        
        do{
            try self.connection?.run(update)
            return true
        }catch{
            print(error)
            return false
        }
    }

}
