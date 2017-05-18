//
//  EmailSender.swift
//  RunningSchedule
//
//  Created by Luís Machado on 28/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class EmailSender: NSObject {
    
    var smtpSession = MCOSMTPSession()
    
    override init() {
        smtpSession.hostname = emailConfig.smtp
        smtpSession.username = emailConfig.email
        smtpSession.password = emailConfig.password
        smtpSession.port = UInt32(emailConfig.port)
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if let data = data {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
    }
    
    func sendEmail(name: String, date: Date?, location: String?, observations: String?, contactEmail: String, completion: @escaping (_ error: Error?) -> ()) {
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "RunningSchedule", mailbox: "lfmachado45@gmail.com")]
        builder.header.from = MCOAddress(displayName: "RunningSchedule", mailbox: contactEmail)
        builder.header.subject = "RunPortugal - iOS - Nova sugestão de corrida"
        
        let name = "Nome: \(name)"
        var dateString = "Data: ---"
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            dateString = "Data: \(dateFormatter.string(from: date))"
        }
        
        var locationString = "Localização: ---"
        if let location = location {
            locationString = "Localização: \(location)"
        }
        
        var observationsString = "Observações: ---"
        if let observations = observations {
            observationsString = "Observações: \(observations)"
        }
        
        let emailSender = "Email Contacto: \(contactEmail)"
        
        builder.textBody = name + "\n" + dateString + "\n" + locationString + "\n" + observationsString + "\n" + emailSender
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            completion(error)
        }
    }
}
