//
//  MasterController.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 3/31/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import SQLite
import UIKit

class MasterController{
    //MARK: Properties
    private let dbManager: SQLiteManager
    private let encrypter: NativeEncryption
    private var usuario: Usuario!
    private var profesor: Profesor!
    private var estudiante: Estudiante!
    private var curso: Curso!
    private var nuevoCurso: Curso!
    private var grupo: Grupo!
    private var listGroup: [Grupo]
    private var info: String!
    private var timeAlive: (Int, Int)!
    private var createGroup: Bool = false
    
    static let shared = MasterController()
    
    //Initialization
    private init(){
        self.dbManager = SQLiteManager(databaseName: "lad.db")
        //self.encrypter = Encryption()
        self.encrypter = NativeEncryption()
        if(!self.dbManager.openDataBase()){
            print("Error: No se pudo establecer comunicación con la Base de Datos")
        }
        
        listGroup = [Grupo]()
    }
    
    func setCurso(curso:Curso){ self.curso = curso }
    
    func setGrupo(grupo:Grupo){ self.grupo = grupo }
    
    func setInfo(info:String){ self.info = info }
    
    func setTimeAlive(hour: Int, minute: Int){ timeAlive = (hour, minute) }
    
    func setCreateGroup(value: Bool) { createGroup = value }
    
    func getProfesor()-> Profesor{ return profesor }
    
    func getCurso()-> Curso { return curso }
    
    func getGrupo()-> Grupo { return grupo }
    
    func getTimeAlive() -> (Int, Int)? { return timeAlive }
    
    func getUsuario() -> Usuario { return usuario }
    
    func getListGroup() -> [Grupo]? { return listGroup }
    
    func getCreateGroup() -> Bool { return createGroup }
    
    func timeToBePresent(profesorName: String, profesorLastName: String) -> Int { return dbManager.timeToBePresent(name: profesorName, lastName: profesorLastName)}
    
    func removeGroup(pos:Int) {
        listGroup.remove(at: pos)
    }
    
    func deleteUser()-> Bool{
        return dbManager.removeUser(email: usuario.correo, type: usuario.tipo)
    }
    
    func deleteGroup()-> Bool{
        return dbManager.removeGroup(idCourse: grupo.getCurse().codigo, idGroup: grupo.getNumber())
    }
    
    func validateNewUser(typeUser: String, input: String)-> Bool{
        let emailArray:Array<Row> = dbManager.selectUser(typeUser: typeUser)
        let correo = Expression<String>("Correo")
        if(!emailArray.isEmpty){
            for email in emailArray{
                if(input.elementsEqual(email[correo])){
                    return false
                }
            }
            return true
        }
        return true
    }
    
    func addNewUser(typeUser: String, data: Array<Any>)-> Bool{
        var dataList:Array<Any> = data
        
        if typeUser.elementsEqual("P") {
            dataList.append(15)
            dataList.append(120)
        }

        if(self.dbManager.addUser(typeUser: typeUser, dataArray: dataList)){
            if typeUser.elementsEqual("P"){
                self.profesor = Profesor(tipo: .Profesor, nombre: dataList[0] as! String, apellidos: dataList[1] as! String, correo: dataList[2] as! String, tiempoTardiaCodigo: dataList[4] as! Int, tiempoVigenciaCodigo: dataList[5] as! Int)
            }else{
                self.estudiante = Estudiante(tipo: .Estudiante, nombre: dataList[0] as! String, apellidos: dataList[1] as! String, id: dataList[2] as! Int, correo: dataList[3] as! String)
            }
            return true
        }
        return false
    }
    
    func validateUser(typeUser: String, email: String, password: String)-> Bool{
        let nombre = Expression<String>("Nombre")
        let apellidos = Expression<String>("Apellidos")
        let contraseña = Expression<String>("Contrasena")
        let correo = Expression<String>("Correo")
        let tiempoTardiaCodigo = Expression<Int>("TiempoTardiaCodigo")
        let tiempoVigenciaCodigo = Expression<Int>("TiempoVigenciaCodigo")
        
        let result: Array<Row> = self.dbManager.validateUser(typeUser: typeUser, input: email)
        
        if result.isEmpty { return false }
        
        var dbDecrypPass: String!
            
        DispatchQueue.global(qos: .background).sync {
            dbDecrypPass = self.encrypter.decrypt(message: result[0][contraseña])
        }
        
        if(!result.isEmpty && password.elementsEqual(dbDecrypPass)){
            if typeUser.elementsEqual("Profesor"){
                self.profesor = Profesor(tipo: .Profesor, nombre: result[0][nombre],apellidos: result[0][apellidos], correo: email, tiempoTardiaCodigo: result[0][tiempoTardiaCodigo], tiempoVigenciaCodigo: result[0][tiempoVigenciaCodigo])
                usuario = self.profesor
                usuario.tipo = .Profesor
            }else{
                self.estudiante = Estudiante(tipo: .Estudiante, nombre: result[0][nombre], apellidos: result[0][apellidos], id: Int(email)!, correo: result[0][correo])
                usuario = self.estudiante
                usuario.tipo = .Estudiante
            }
            return true
        }else{
            return false
        }
    }
    
    func numberOfCourse() -> (Int, Array<Curso>) {
        let nombre = Expression<String>("Nombre")
        let codigo = Expression<String>("Codigo")
        
        var listaCursos:Array<Curso> = Array<Curso>()
        let courses = self.dbManager.numberOfCourse(email: self.profesor.correo)
        
        for curso in courses!{
            listaCursos.append(Curso(codigo: curso[codigo], nombre: curso[nombre]))
        }
        
        if listaCursos.isEmpty {
            return (listaCursos.count, listaCursos)
        }

        return (listaCursos.count, listaCursos)
    }
    
    func numberOfCourse() -> (Int, Array<(Curso, Int, String)>) {
        let cursoT = Table("Curso")
        let profesor = Table("Profesor")
        let nombre = Expression<String>("Nombre")
        let codigo = Expression<String>("IDCurso")
        let grupo = Expression<Int>("IDGrupo")
        let apellidos = Expression<String>("Apellidos")
        
        var listaCursos:Array<(Curso, Int, String)> = Array<(Curso, Int, String)>()
        
        let courses = self.dbManager.numberOfCourse(idUser: self.estudiante.id)
        
        for curso in courses!{
            listaCursos.append((Curso(codigo: curso[codigo], nombre: curso[cursoT[nombre]]), curso[grupo], String("\(curso[profesor[nombre]]) \(curso[apellidos])")))
        }
        
        if listaCursos.isEmpty {
            return (listaCursos.count, listaCursos)
        }
        
        return (listaCursos.count, listaCursos)
    }
    
    func groupsOf() -> Array<Grupo> {
        let numero = Expression<Int>("Numero")
        let dia1 = Expression<String>("Dia1")
        let dia2 = Expression<String>("Dia2")
        let codigo = Expression<String>("Codigo")
        //let key = Expression<String>("Llave")

        let grupos = self.dbManager.groupOf(codCurso: self.curso.codigo, email: self.profesor.correo)
        
        for grupo in grupos{
            //Day saca el dia del mes, no el dia de la semana!!! Corregir
                if(grupo[codigo].isEmpty){
                    listGroup.append(Grupo(curso: self.curso!, num: grupo[numero], profesor: self.profesor!, horario1: grupo[dia1], horario2: grupo[dia2]))
                }else{
                    
                    listGroup.append(Grupo(curso: self.curso, num: grupo[numero], profesor: self.profesor, horario1: grupo[dia1], horario2: grupo[dia2], code: grupo[codigo]))
            }
        }
        return listGroup
    }
    
    func crearCodigo(data: String){
        //let encryptedInformation:String
        //let key:String
        //(encryptedInformation, key) = try self.encrypter.encrypt(data: data)
        //encryptedInformation = self.encrypter.encrypt(message: data)
        //print("Encrypted Information \(data)")
        if((self.getGrupo().getCode()?.getData().isEmpty)!){
            self.getGrupo().getCode()?.setData(data: data)
            
            let group = self.getGrupo()
            
            //if(self.dbManager.updateCode(idC: self.curso.codigo, idG: group.getNumber(), code: (self.getGrupo().getCode()?.getQRCode())!, key: key)){
            if(self.dbManager.updateCode(idC: self.curso.codigo, idG: group.getNumber(), code: (self.getGrupo().getCode()?.getQRCode())!, key: "")){
                print("Code Updated Succesfully")
            }else{
                print("Error: Code Updated Unsuccesfully")
            }
            //self.codigo.createImage()
        }
    }
    
    func crearListaAsistencia(fecha:String)-> Bool{
        if(dbManager.crearLA(idC: grupo.getCurse().codigo, idG: grupo.getNumber(), fech: fecha, code: (grupo.getCode()?.getQRCode())!)){
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let formattedDate = format.string(from: Date())
            
            grupo.setNumberAL(number: dbManager.getNumberOfLA(idCurse: grupo.getCurse().codigo, idGroup: grupo.getNumber(), date: formattedDate))
            
            return true
        }
        
        return false
    }
    
    func setTimeMaxPresence(time:Int){
        if(dbManager.setTimeMaxPresence(email: self.profesor.correo, time: time)){
            profesor.tiempoTardiaCodigo = time
            print("Change Time Max Presence Succesfully")
        }else{
            print("Error: Change Time Max Presence Unsuccesfully")
        }
    }
    
    func setTimeCodeAvailable(time: Int){
        if(dbManager.setTimeCodeAvailable(email: self.profesor.correo, time: time)){
            print("Change Time Code Available Succesfully")
        }else{
            print("Error: Change Time Code Available Unsuccesfully")
        }
    }
    
    func setNewPassword(password: String){
        if(dbManager.setNewPassword(email: self.profesor.correo, password: password)){
            print("Change Succesfully")
        }else{
            print("Error: Change Unsuccesfully")
        }
    }
    
    func setNumberGroup(number: Int){
        self.grupo = Grupo(curso: self.curso, num: number, estudiante: self.estudiante)
    }
    
    private func getDaysOfCourse()-> Array<String> {
        let dia1 = Expression<String>("Dia1")
        let dia2 = Expression<String>("Dia2")
        
        var diaCurso:Array<String> = Array<String>()
        let query = self.dbManager.getDaysOfCourse(idCourse: self.curso.codigo, idUser: self.estudiante.id, numberGroup: self.grupo.getNumber())
        for item in query{
            diaCurso.append(String(item[dia1].split(separator: "-")[0]))
            if !item[dia2].isEmpty{
                diaCurso.append(String(item[dia2].split(separator: "-")[0]))
            }else{
                diaCurso.append("")
            }
        }
        
        return diaCurso
    }
    
    func getAttendanceList() -> (Int, Array<String>, Array<String>) {
        let fecha = Expression<String>("Horario")
        let estado = Expression<String>("Estado")
        
        let lad = self.dbManager.getAttendanceList(idCourse: self.curso.codigo, idUser: self.estudiante.id, numberGroup: self.grupo.getNumber())
        
        var dia:String
        var dia1List:Array<String> = Array<String>()
        var dia2List:Array<String> = Array<String>()
        
        //Dias que dan clases de un grupo en un curso especifico(Curso y Grupo seleccionado por el usuario)
        var dias = getDaysOfCourse()
        for item in lad{
            dia = (item[fecha]) //Ej:   D-H1-H2 -> L-9:30-11:30
            dia = String(dia.split(separator: "-")[0])  // [L, 9:30, 11:30]
            switch dia{
            case dias[0]:
                dia1List.append(item[estado])
                break
            case dias[1]:
                dia2List.append(item[estado])
                break
            default:
                dia1List.append(item[estado])
            }
        }
        
        if dia1List.isEmpty || dia1List.isEmpty{
            return (0, dia1List, dia2List)
        }
        
        return (max(dia1List.count, dia2List.count), dia1List, dia2List)
    }
    
    func belongsToCourse(courseName: String)-> Bool{
        var listCourses:Array<(Curso, Int, String)> = Array<(Curso, Int, String)>()
        (_, listCourses) = numberOfCourse()
        
        for course in listCourses{
            if course.0.nombre.elementsEqual(courseName){
               return true
            }
        }
        return false
    }
    
    func confirmPresence(data:[String.SubSequence])-> Bool{
        //15:39,15:54,Carlos,Benavides,Redes,1,K,J
        let nombreCurso = String(data[4])
        
        let curso = Curso(codigo: "", nombre: nombreCurso)
        let profesor = Profesor(tipo: .Profesor, nombre: String(data[2]), apellidos: String(data[3]), correo: "", tiempoTardiaCodigo: 0, tiempoVigenciaCodigo: 0)
        
        //Apple use GMT so it is GMT+6 in CR
        var day2: String
        if data.count > 7 {
            day2 = String("\(String(data[7]))-\(String(data[0]))-\(String(data[1]))")
        }else{
            day2 = ""
        }
        let grupo = Grupo(
            curso: curso,
            num: Int(String(data[5]))!,
            profesor: profesor,
            horario1: String("\(String(data[6]))-\(String(data[0]))-\(String(data[1]))"),
            horario2: day2
        )
        if grupo.validateSchedule(){
            let estado:String = grupo.getAssistanceState(lateTime: timeToBePresent(profesorName: profesor.nombre, profesorLastName: profesor.apellidos))
            let numberLAD = dbManager.getNumberOfLA(nameCurse: curso.nombre, idGroup: grupo.getNumber())
            if self.dbManager.confirmPresence(numberList: numberLAD, userID: self.estudiante.id, state: estado){
                return true
            }
            return false
        }
        return false
    }
    
    func getStudentsFrom(date: String)-> (Int, Array<(String, String)>){
        let nombre = Expression<String>("Nombre")
        let apellidos = Expression<String>("Apellidos")
        let estado = Expression<String>("Estado")
        
        var listaEstudiantes:Array<(String, String)> = Array<(String, String)>()
        let estudiantes:Array<Row>
        
        if date.count > 0 {
            estudiantes = self.dbManager.getStudentsFromAttendanceList(idAttendanceList: dbManager.getNumberOfLA(idCurse: getGrupo().getCurse().codigo, idGroup: getGrupo().getNumber(), date: date))
        }else{
            estudiantes = self.dbManager.getStudentsFromAttendanceList(idAttendanceList: self.grupo.getNumberAL())
        }
        
        for estudiante in estudiantes{
            listaEstudiantes.append((String("\(estudiante[nombre]) \(estudiante[apellidos])"), estudiante[estado]))
        }
        
        return (listaEstudiantes.count, listaEstudiantes)
    }
    
    func getStudentsFrom()-> Dictionary<String, [Int]>{
        var resultDict: [String: [Int]] = [:]
        let estudiantes:Array<Row>
        
        let nombre = Expression<String>("Nombre")
        let apellidos = Expression<String>("Apellidos")
        let estado = Expression<String>("Estado")
        
        estudiantes = self.dbManager.getStudentsFromAttendanceList(idCurse: grupo.getCurse().codigo, idGroup: grupo.getNumber())
        
        var keys = [String](resultDict.keys)
        for row in estudiantes{
            let key = row[nombre]+" "+row[apellidos]
            if keys.contains(key){
                var oldValue = resultDict[row[nombre]+" "+row[apellidos]]
                switch row[estado]{
                case "P":
                    oldValue![0] += 1
                    break
                case "A":
                    oldValue![1] += 1
                    break
                case "T":
                    oldValue![2] += 1
                    break
                default:
                    break
                }
                
                resultDict.updateValue(oldValue!, forKey: key)
            }else{
                var newValue:[Int] = [0,0,0]
                switch row[estado]{
                case "P":
                    newValue[0] += 1
                    break
                case "A":
                    newValue[1] += 1
                    break
                case "T":
                    newValue[2] += 1
                    break
                default:
                    break
                }
                
                resultDict[key] = newValue
                keys.append(key)
            }
        }
        
        return resultDict
    }
    
    func getAllCourses()-> Array<String>{
        var listCourses: Array<String> = Array<String>()
        
        let nombre = Expression<String>("Nombre")
        
        let queryResult = dbManager.getAllCourses(idUser: usuario.correo)
        
        for curso in queryResult{
            listCourses.append(curso[nombre])
        }
        
        return listCourses
    }
    
    func getAllNameCourses()-> Array<(String, String)>{
        var listCourses: Array<(String, String)> = Array<(String, String)>()
        
        let nombre = Expression<String>("Nombre")
        let codigo = Expression<String>("Codigo")
        
        let queryResult = dbManager.getAllCourses()
        
        for curso in queryResult{
            listCourses.append((curso[nombre], curso[codigo]))
        }
        
        return listCourses
    }
    
    func numberOfGroups(nameCurse: String) -> Int {
        return dbManager.getNumberGroups(nombreCurso: nameCurse)
    }
    
    func addNewCourse(nameCurse: String, idCurse: String, number: Int, firstDay: String, secondDay: String, startTime: String, endTime: String)-> Bool {
        
        let day1 = String(format:"%@-%@-%@", firstDay, startTime, endTime)
        let day2 = secondDay.isEmpty ? "" : String(format:"%@-%@-%@", secondDay, startTime, endTime)
        
        //var time = endTime.split(separator: ":")
        
        //let hour = Int(String(time[0]))!
        //let minute = Int(String(time[1]))!
        
        let info = String(format: "%@,%@,%@,%@,%@,%d,%@,%@", startTime, endTime, getProfesor().nombre, getProfesor().apellidos, idCurse, number, firstDay, secondDay)
        
        let code = Codigo()
        code.setData(data: info)
        
        let newGroup = Grupo(curso: Curso(codigo: nameCurse, nombre: idCurse), num: number, profesor: profesor, horario1: day1, horario2: day2, code: code.getQRCode())
        
        listGroup.append(newGroup)
        
        return dbManager.addNewCourse(idCurse: idCurse, number: number, idProfessor: profesor!.correo, firstDay: day1, secondDay: day2, code: code.getQRCode())
    }
    
    func getAvailableLA()-> Array<String>{
        var listDates: Array<String> = Array<String>()
        
        let fecha = Expression<String>("Fecha")
        
        let queryResult = dbManager.getDateOfAvailableLA(idCurse: getGrupo().getCurse().codigo, idGroup: getGrupo().getNumber())
        
        for dates in queryResult{
            listDates.append(dates[fecha])
        }
        return listDates
    }
    
    func getStadistics(type: String, state: String, student: String = "")-> Double{
        let rawStadistic: Array<Array> = dbManager.getStadistics(idCurse: grupo.getCurse().codigo, idGroup: grupo.getNumber(), nameStudent: student)
        
        var typeAssistant: [String : Int] = [
            "P": 0,
            "A": 0,
            "T": 0
        ]
        
        switch type {
        case "Total":
            for row in rawStadistic{
                let t = row[0] as! String
                let n = Int(row[1] as! Int64)
                
                typeAssistant.updateValue(typeAssistant[t]! + n, forKey: t)
            }
            return Double(typeAssistant[state]!)
        case "Promedio":
            for row in rawStadistic{
                let t = row[0] as! String
                let n = Int(row[1] as! Int64)
                
                typeAssistant.updateValue(typeAssistant[t]! + n, forKey: t)
            }
            let total = typeAssistant.reduce(0) { (result, tupleOKeyAndValue) in
                return result + tupleOKeyAndValue.value
            }
            
            return Double(typeAssistant[state]! / total)
        /*case "Promedio Por Mes":
            for row in rawStadistic{
                let t = row[0] as! String
                let n = row[1] as! Int
                
                typeAssistant.updateValue(typeAssistant[t]! + n, forKey: t)
            }
        */
        default:
            return -1.0
        }
    }
}
