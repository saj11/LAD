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
    
    func validateUser(typeUser: String, input: String)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        do{
            let table = Table(typeUser)
            var query:Table
            
            if typeUser.elementsEqual("Profesor") {
                let nombre = Expression<String>("Nombre")
                let apellidos = Expression<String>("Apellidos")
                let contraseña = Expression<String>("Contrasena")
                let tiempoTardiaCodigo = Expression<Int>("TiempoTardiaCodigo")
                let tiempoVigenciaCodigo = Expression<Int>("TiempoVigenciaCodigo")
                let correo = Expression<String>("Correo")
                query = table.select(nombre,apellidos, contraseña, tiempoTardiaCodigo, tiempoVigenciaCodigo)
                    .filter(correo == input)
            }else{
                let carne = Expression<Int>("Carne")
                let nombre = Expression<String>("Nombre")
                let apellidos = Expression<String>("Apellidos")
                let correo = Expression<String>("Correo")
                let contraseña = Expression<String>("Contrasena")
                query = table.select(nombre,apellidos, correo, contraseña)
                    .filter(carne == Int(input)!)
            }
            
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
    
    func numberOfCourse(idUser: Int)-> Array<Row>?{
        var result: Array<Row>? = Array<Row>()
        
        do{
            let estudiante = Table("Estudiante")
            let asistenciaPorEstudiante = Table("AsistenciaPorEstudiante")
            let listaAsistencia = Table("ListaAsistencia")
            let curso = Table("Curso")
            let grupo = Table("Grupo")
            let profesor = Table("Profesor")
            let nombre = Expression<String>("Nombre")
            let apellidos = Expression<String>("Apellidos")
            let idCurso = Expression<String>("IDCurso")
            let idGrupo = Expression<Int>("IDGrupo")
            let carne = Expression<Int>("Carne")
            let iDListaAsist = Expression<Int>("IDListaAsist")
            let id = Expression<Int>("ID")
            let codigo = Expression<String>("Codigo")
            let numero = Expression<Int>("Numero")
            let idProfe = Expression<Int>("IDProfe")
            
            let query = estudiante.select(distinct: curso[nombre], listaAsistencia[idCurso], listaAsistencia[idGrupo], profesor[nombre] , profesor[apellidos])
                .join(asistenciaPorEstudiante, on: estudiante[carne] == asistenciaPorEstudiante[carne])
                .join(listaAsistencia, on: asistenciaPorEstudiante[iDListaAsist] == listaAsistencia[id])
                .join(curso, on: curso[codigo] == listaAsistencia[idCurso])
                .join(grupo, on: listaAsistencia[idGrupo] == grupo[numero])
                .join(profesor, on: grupo[idProfe] == profesor[id])
                .filter(estudiante[carne] == idUser)
            
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
            //let key = Expression<String>("Llave")
            
            //let query = grupo.select(grupo[numero], grupo[dia1], grupo[dia2], grupo[cod], grupo[key])
            let query = grupo.select(grupo[numero], grupo[dia1], grupo[dia2], grupo[cod])
                .join(profesor, on: grupo[idProfe] == profesor[id])
                .join(curso, on: grupo[idCurso] == curso[codigo])
                .where(profesor[correo] == email && curso[codigo] == codCurso)
            result = Array((try self.connection?.prepare(query))!)
            
            return result
        }catch{
            print("Select user failed: \(error)")
        }
        return result
    }
    
    func crearLA(idC:String, idG: Int, fech:String, code:String)-> Bool{
        let listaAsistencia = Table("ListaAsistencia")
        let idCurso = Expression<String>("IDCurso")
        let idGrupo = Expression<Int>("IDGrupo")
        let horario = Expression<String>("Horario")
        let fecha = Expression<String>("Fecha")
        
        let grupo = Table("Grupo")
        let numero = Expression<Int>("Numero")
        let idCurs = Expression<String>("IDCurso")
        let codigo = Expression<String>("Codigo")
        
        let date:String
        
        do{
            date = try connection?.scalar("SELECT date('now')") as! String
        }catch{
            print(error)
            return false
        }
        
        let insert = listaAsistencia.insert(idCurso <- idC, idGrupo <- idG, horario <- fech, fecha <- date)
        do{
            try self.connection?.run(insert)
            
            return true
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
    
    func getAttendanceList(idCourse: String, idUser: Int, numberGroup: Int)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        
        let listaAsistencia = Table("ListaAsistencia")
        let asistenciaPorEstudiante = Table("AsistenciaPorEstudiante")
        
        let horario = Expression<String>("Horario")
        let estado = Expression<String>("Estado")
        let id = Expression<Int>("ID")
        let idListaAsist = Expression<Int>("IDListaAsist")
        let idCurso = Expression<String>("IDCurso")
        let idGrupo = Expression<Int>("IDGrupo")
        let carne = Expression<Int>("Carne")
        
        let query = listaAsistencia.select(horario, estado)
                                   .join(asistenciaPorEstudiante, on: listaAsistencia[id] == asistenciaPorEstudiante[idListaAsist])
                                    .where(listaAsistencia[idCurso] == idCourse && asistenciaPorEstudiante[carne] == idUser &&
                                           listaAsistencia[idGrupo] == numberGroup)
        print("##########")
        print("getAttendanceList")
        print(query.asSQL())
        do{
            result = Array((try self.connection?.prepare(query))!)
            return result
        }catch{
            print(error)
            return result
        }
    }
    
    func getDaysOfCourse(idCourse: String, idUser: Int, numberGroup: Int)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        
        let listaAsistencia = Table("ListaAsistencia")
        let asistenciaPorEstudiante = Table("AsistenciaPorEstudiante")
        let grupo = Table("Grupo")
        
        let dia1 = Expression<String>("Dia1")
        let dia2 = Expression<String>("Dia2")
        let id = Expression<Int>("ID")
        let idListaAsist = Expression<Int>("IDListaAsist")
        let idCurso = Expression<String>("IDCurso")
        let carne = Expression<Int>("Carne")
        let idGrupo = Expression<Int>("IDGrupo")
        let numero = Expression<Int>("Numero")
        
        let query = listaAsistencia.select(dia1, dia2)
            .join(asistenciaPorEstudiante, on: listaAsistencia[id] == asistenciaPorEstudiante[idListaAsist])
            .join(grupo, on: listaAsistencia[idCurso] == grupo[idCurso] && listaAsistencia[idGrupo] == grupo[numero])
            .where(listaAsistencia[idCurso] == idCourse && asistenciaPorEstudiante[carne] == idUser && listaAsistencia[idGrupo] == numberGroup)
            .limit(1)
        
        print("##########")
        print("getDaysOfCourse")
        print(query.asSQL())
        do{
            result = Array((try self.connection?.prepare(query))!)
            return result
        }catch{
            print(error)
            return result
        }
    }
    
    func confirmPresence(numberList: Int, userID: Int, state:String)-> Bool{
        let asistenciaPorEstudiante = Table("AsistenciaPorEstudiante")
        let idListaAsist = Expression<Int>("IDListaAsist")
        let carne = Expression<Int>("Carne")
        let estado = Expression<String>("Estado")
        
        let insert = asistenciaPorEstudiante.insert(idListaAsist <- numberList, carne <- userID, estado <- state)
        do{
            try self.connection?.run(insert)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    func getStudentsFromAttendanceList(idAttendanceList: Int)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        do{
            let listaAsistencia = Table("ListaAsistencia")
            let asistenciaPorEstudiante = Table("AsistenciaPorEstudiante")
            let estudiante = Table("Estudiante")
            
            let nombre = Expression<String>("Nombre")
            let apellidos = Expression<String>("Apellidos")
            let estado = Expression<String>("Estado")
            let id = Expression<Int>("ID")
            let idListaAsist = Expression<Int>("IDListaAsist")
            let carne = Expression<Int>("Carne")
            
            let query = listaAsistencia.select(estudiante[nombre], estudiante[apellidos], asistenciaPorEstudiante[estado])
                .join(asistenciaPorEstudiante, on: listaAsistencia[id] == asistenciaPorEstudiante[idListaAsist])
                .join(estudiante, on: asistenciaPorEstudiante[carne] == estudiante[carne])
                .where(listaAsistencia[id] == idAttendanceList)
            result = Array((try self.connection?.prepare(query))!)
            
            return result
        }catch{
            print("Select user failed: \(error)")
        }
        return result
    }
    
    func getStudentsFromAttendanceList(idCurse:String, idGroup:Int)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        
        do{
            let listaAsistencia = Table("ListaAsistencia")
            let asistenciaPorEstudiante = Table("AsistenciaPorEstudiante")
            let estudiante = Table("Estudiante")
            
            let nombre = Expression<String>("Nombre")
            let apellidos = Expression<String>("Apellidos")
            let id = Expression<Int>("ID")
            let idListaAsist = Expression<Int>("IDListaAsist")
            let idCurso = Expression<String>("IDCurso")
            let idGrupo = Expression<Int>("IDGrupo")
            let carne = Expression<Int>("Carne")
            let estado = Expression<String>("Estado")
            
            let query = listaAsistencia.select(estudiante[nombre], estudiante[apellidos], asistenciaPorEstudiante[estado])
                .join(asistenciaPorEstudiante, on: listaAsistencia[id] == asistenciaPorEstudiante[idListaAsist])
                .join(estudiante, on: asistenciaPorEstudiante[carne] == estudiante[carne])
                .where(listaAsistencia[idCurso] == idCurse && listaAsistencia[idGrupo] == idGroup )
            result = Array((try self.connection?.prepare(query))!)
            
            return result
        }catch{
            print("Select user failed: \(error)")
        }
        return result
    }
    
    func getAllCourses(idUser: String)-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        
        do{
            let profesor = Table("Profesor")
            let grupo = Table("Grupo")
            let curso = Table("Curso")
            
            let nombre = Expression<String>("Nombre")
            let idProfe = Expression<String>("IDProfe")
            let id = Expression<String>("ID")
            let idCurso = Expression<String>("IDCurso")
            let curso2 = Expression<String>("Codigo")
            let correo = Expression<String>("Correo")
            
            let query = grupo.select(curso[nombre])
                .join(profesor, on: grupo[idProfe] == profesor[id])
                .join(curso, on: curso[curso2] == grupo[idCurso])
                .where(profesor[correo] == idUser)
            
            result = Array((try self.connection?.prepare(query))!)
            
            return result
        }catch{
            print("Select user failed: \(error)")
            return result
        }
    }
    
    func getAllCourses()-> Array<Row>{
        var result: Array<Row> = Array<Row>()
        
        do{
            let curso = Table("Curso")
            
            let nombre = Expression<String>("Nombre")
            
            let query = curso.select(curso[nombre])
            
            result = Array((try self.connection?.prepare(query))!)
            
            return result
        }catch{
            print("Select user failed: \(error)")
            return result
        }
    }
    
    func getNumberGroups(nombreCurso: String)-> Int{
        let grupo = Table("Grupo")
        let curso = Table("Curso")
        
        let idCurso = Expression<String>("IDCurso")
        let codigo = Expression<String>("Codigo")
        let numero = Expression<Int>("Numero")
        let nombre = Expression<String>("Nombre")
        
        do{
            let count = try connection?.scalar(grupo.select(numero.count)
                .join(curso, on: grupo[idCurso] == curso[codigo])
                .where(curso[nombre] == nombreCurso)) ?? 0
            
            return count+1
        }catch{
            print("Select number of groups failed: \(error)")
            return 0
        }
    }
    
    func getNumberOfLA(idCurse: String, idGroup: Int)-> Int{
        let listaAsistencia = Table("ListaAsistencia")
        
        let id = Expression<Int>("ID")
        let fecha = Expression<String>("Fecha")
        let idCurso = Expression<String>("IDCurso")
        let idGrupo = Expression<Int>("IDGrupo")
        
        do{
            let date = try connection?.scalar("SELECT date('now')") as! String
            
            let idLA = try self.connection?.scalar(listaAsistencia.select(id)
                .where(listaAsistencia[fecha] == date && listaAsistencia[idCurso] == idCurse && listaAsistencia[idGrupo] == idGroup)) ?? 0
            
            return idLA
        }catch{
            print("Select id of listaAsistencia failed: \(error)")
            return 0
        }
    }
    
    func addNewCourse(idCurse: String, number: Int, idProfessor: String, firstDay: String, secondDay: String, code: String)-> Bool{
        let grupo = Table("Grupo")
        let profesor = Table("Profesor")
        let curso = Table("Curso")
        
        let id = Expression<Int>("ID")
        let correo = Expression<String>("Correo")
        let idCurso = Expression<String>("IDCurso")
        let nombreCurso = Expression<String>("Nombre")
        let numero = Expression<Int>("numero")
        let idProfe = Expression<Int>("IDProfe")
        let dia1 = Expression<String>("Dia1")
        let dia2 = Expression<String>("Dia2")
        let codigo = Expression<String>("Codigo")
        
        do{
            let query = try (connection?.scalar(profesor.select(id)
                .where(profesor[correo] == idProfessor)))!
            
            let query2 = try connection?.scalar(curso.select(codigo).where(nombreCurso == idCurse))
            
            try self.connection?.run(grupo.insert(idCurso <- query2!, numero <- number, idProfe <- query, dia1 <- firstDay, dia2 <- secondDay, codigo <- code))
            return true
        }catch{
            print("select user failed: \(error)")
            print("Error: No se pudo ingresar el nuevo grupo a la BD.")
            return false
        }
    }
    
    func getDateOfAvailableLA(idCurse: String, idGroup: Int)-> Array<Row>{
        let listaAsistencia = Table("ListaAsistencia")
        
        let fecha = Expression<String>("Fecha")
        let idCurso = Expression<String>("IDCurso")
        let idGrupo = Expression<Int>("IDGrupo")
        
        var result: Array<Row> = Array<Row>()
        do{
            result = Array(try (self.connection?.prepare(listaAsistencia.select(fecha)
                .where(listaAsistencia[idCurso] == idCurse && listaAsistencia[idGrupo] == idGroup)))!)
            
            return result
        }catch{
            print("Select id of listaAsistencia failed: \(error)")
            return result
        }
    }
    
    func getNumberOfLA(idCurse: String, idGroup: Int, date: String)-> Int{
        let listaAsistencia = Table("ListaAsistencia")
        
        let id = Expression<Int>("ID")
        let fecha = Expression<String>("Fecha")
        let idCurso = Expression<String>("IDCurso")
        let idGrupo = Expression<Int>("IDGrupo")
        
        do{
            let idLA = try self.connection?.scalar(listaAsistencia.select(id)
                .where(listaAsistencia[fecha] == date && listaAsistencia[idCurso] == idCurse && listaAsistencia[idGrupo] == idGroup)) ?? 0
            
            return idLA
        }catch{
            print("Select id of listaAsistencia failed: \(error)")
            return 0
        }
    }
    
    func getStadistics(idCurse: String, idGroup: Int, nameStudent:String = "")-> Array<Array<Any>>{
        var result: Array<Array> = Array< Array<Any> >()
        var query:String
        var stmt: Statement
        
        do{
            if nameStudent.isEmpty{
                query = """
                SELECT estado,count(Estado), strftime('%m', Fecha) as month
                FROM ListaAsistencia la
                INNER JOIN AsistenciaPorEstudiante ae ON(la.ID = ae.IDListaAsist)
                WHERE la.IDCurso = (?) AND la.IDGrupo = (?)
                GROUP BY strftime('%m', Fecha), estado
                """
                stmt = try (self.connection?.run(query, idCurse, idGroup))!
            }else{
                query = """
                SELECT estado,count(Estado), strftime('%m', Fecha) as month
                FROM ListaAsistencia la
                INNER JOIN AsistenciaPorEstudiante ae ON(la.ID = ae.IDListaAsist)
                INNER JOIN Estudiante est ON(ae.Carne = est.Carne)
                WHERE la.IDCurso = (?) AND la.IDGrupo = (?) AND
                      est.Nombre = (?)
                GROUP BY strftime('%m', Fecha), estado
                """
                stmt = try (self.connection?.run(query, idCurse, idGroup, nameStudent))!
            }
            
            for row in stmt{
                result.append([row[0]!, row[1]!, row[2]!])
            }
            
            return result
        }catch{
            print("Select id of listaAsistencia failed: \(error)")
            return result
        }
    }
}
