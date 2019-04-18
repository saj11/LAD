//
//  Grupo.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 3/24/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

enum DiaSemana:String {
    case D = "D"
    case L = "L"
    case K = "K"
    case M = "M"
    case J = "J"
    case V = "V"
    case S = "S"
    case None = ""
}

struct Dia {
    var diaSemana: DiaSemana = DiaSemana.None
    var horaInicio: Date = Date()
    var horaFinal: Date = Date()
}

struct Horario {
    var dia1: Dia
    var dia2: Dia
}

class Grupo{
    private var dayArray: [String]
    private let curso: Curso
    private let numero: Int
    private let profesor: Profesor?
    private let estudiante: Estudiante?
    private var horario: Horario!
    private var codigo: Codigo?
    private var listaDias: [DiaSemana]
    
    init(curso: Curso, num: Int, profesor: Profesor, horario1: String, horario2: String) {
        self.dayArray = ["D","L","K","M","J","V","S"]
        self.curso = curso
        self.numero = num
        self.profesor = profesor
        self.estudiante = nil
        self.codigo = Codigo()
        
        self.listaDias = Array<DiaSemana>()
        self.listaDias.append(DiaSemana.L)
        self.listaDias.append(DiaSemana.K)
        self.listaDias.append(DiaSemana.M)
        self.listaDias.append(DiaSemana.J)
        self.listaDias.append(DiaSemana.V)
        self.listaDias.append(DiaSemana.S)
        self.listaDias.append(DiaSemana.D)
        
        self.horario = Horario(dia1: self.decomposeSchedule(schedule: horario1), dia2: decomposeSchedule(schedule: horario2))
    }
    
    init(curso: Curso, num: Int, profesor: Profesor, horario1: String, horario2: String, code:String) {
        self.dayArray = ["D","L","K","M","J","V","S"]
        self.curso = curso
        self.numero = num
        self.profesor = profesor
        self.estudiante = nil
        self.codigo = Codigo(code: code)
        
        self.listaDias = Array<DiaSemana>()
        self.listaDias.append(DiaSemana.L)
        self.listaDias.append(DiaSemana.K)
        self.listaDias.append(DiaSemana.M)
        self.listaDias.append(DiaSemana.J)
        self.listaDias.append(DiaSemana.V)
        self.listaDias.append(DiaSemana.S)
        self.listaDias.append(DiaSemana.D)
        
        self.horario = Horario(dia1: self.decomposeSchedule(schedule: horario1), dia2: decomposeSchedule(schedule: horario2))
    }
    
    init(curso: Curso, num: Int, estudiante: Estudiante) {
        self.dayArray = ["D","L","K","M","J","V","S"]
        self.curso = curso
        self.numero = num
        self.profesor = nil
        self.estudiante = estudiante
        self.listaDias = Array<DiaSemana>()
    }
    
    func decomposeSchedule(schedule: String)-> Dia{
        //Apple use GMT so it is GMT+6 in CR
        if(!schedule.isEmpty){
            let calendar = Calendar.current
            
            var hor:Array<String.SubSequence> = schedule.split(separator: "-")
            
            var hour = hor[1].split(separator: ":")
            let hour1 = calendar.date(bySettingHour: Int(String(hour[0]))!, minute: Int(String(hour[1]))!, second: 0, of: Date())
            
            
            hour = hor[2].split(separator: ":")
            let hour2 = calendar.date(bySettingHour: Int(String(hour[0]))!, minute: Int(String(hour[1]))!, second: 0, of: Date())
            
            let dia: Dia = Dia(diaSemana: DiaSemana(rawValue:String(hor[0]))!, horaInicio: hour1!, horaFinal: hour2!)
            
            return dia
        }else{
            return Dia()
        }
    }
    
    func setCode(code:String){ self.codigo = Codigo(code: code) }
    
    func getCode()-> Codigo?{ return self.codigo }
    
    func getNumber()-> Int{ return self.numero }
    
    func getSchedule()-> Horario { return self.horario }
    
    func getSchedule(numberDay:Int) -> Dia {
        return self.horario.dia1.diaSemana.rawValue == self.listaDias[numberDay-1].rawValue ? self.horario.dia1 : self.horario.dia2
    }
    
    func validateSchedule()-> Bool{
        //Apple use GMT so it is GMT+6 in CR
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday, .hour, .minute], from: Date())
        
        let scheduleMirror = Mirror(reflecting: self.horario!)
        for dayInSchedule in scheduleMirror.children {
            let day = dayInSchedule.value as! Dia
            if(!day.diaSemana.rawValue.elementsEqual(self.dayArray[components.weekday!])){
                return false
            }else{
                //-3600seg*6hrs = para obtener en segundos las 6hrs que esta la hora
                let now = Date().addingTimeInterval(-3600*6)
                if(now >= day.horaInicio.addingTimeInterval(-3600*6) && now <= day.horaFinal.addingTimeInterval(-3600*6)){
                    return true
                }
                return false
            }
        }
        return false
    }
    
    func beutyPrint(){
        Swift.print(String(format: """
                                    Curso
                                        Codigo: %@
                                        Nombre: %@
                                    Numero: %d
                                    Profesor
                                        Nombre: %@
                                        Correo: %@
                                    Horario
                                        Dia1
                                            Dia: %@
                                            Hora Inicio: %@
                                            Hora Final: %@
                                        Dia2:
                                            Dia: %@
                                            Hora Inicio: %@
                                            Hora Final: %@
                                    """, self.curso.codigo, self.curso.nombre, self.numero, self.profesor!.nombre, self.profesor!.correo, self.horario.dia1.diaSemana.rawValue, self.horario.dia1.horaInicio.description, self.horario.dia1.horaFinal.description,self.horario.dia2.diaSemana.rawValue, self.horario.dia2.horaInicio.description, self.horario.dia2.horaFinal.description))
    }
}
