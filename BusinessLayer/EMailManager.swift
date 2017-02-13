//
//  EMailManager.swift
//  ErrorHandling
//
//  Created by Abhishek Shukla on 17/10/16.
//  Copyright © 2016 InnovationM. All rights reserved.
//

import Foundation
import MessageUI

class EMailManager: NSObject, MFMailComposeViewControllerDelegate{
    
    private let emailButtonTitle = "Send Report"
    private let emailButtonCancel = "Cancel"
    private let mailErrorTitle = "Could Not Send Email"
    private let mailErrorMessage = "Your device could not send e-mail.  Please check e-mail configuration and try again."
    private let methodName = "EmailManager.mailComposeController()"
    private let errorMessageTitle = "Error Occured"
    private let errorMessageBody = "Some thing went wrong ErrorCode"
    private let errorFileSubject = "Error Reporting"
    private let errorFileName = "Error"
    private let errorFile = "Error.txt"
    private let errorFileType = "txt"
    private let errorFileMimeType = "text/plain"
    
    private let errorManager = ErrorManager.sharedInstance
    
    static let sharedInstance = EMailManager()
    private override init() {}
    
    private var _emailMessage: String?
    private var _emailSubject: String?
    private var _emailrecipientsList:[String]?
    private var _viewController: UIViewController?
    
    private var _onSuccess: ((errorModel: ErrorModel) -> Void)?
    private var _onFailure: ((errorModel: ErrorModel) -> Void)?
    
    func reportError(vc:UIViewController, errorModel: ErrorModel, onSuccess: (errroModel: ErrorModel) -> Void, onFailure: (errorModel: ErrorModel) -> Void) {
        
        _onSuccess = onSuccess
        _onFailure = onFailure
        _viewController = vc
        _emailMessage = errorModel.errorMessage
        _emailSubject = self.errorFileSubject
        _emailrecipientsList = Constants.ERROR_REPORT_RECIPIENTS
        
        self.showErrorAlert(self.errorMessageTitle, message: self.errorMessageBody + "(\(errorModel.errorCode))", cancelButtonTitle: self.emailButtonCancel, sendButtonTitle: self.emailButtonTitle, cancelBlock: {(action) in
            self.cancel()
            }
            , okBlock: { (action) in
                self.sendMail()
        })
    }
    
    private func sendMail() {
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            
            let filePath = self.getFilePath() + self.errorFile
            
            if let fileData = NSData(contentsOfFile: filePath) {
                mailComposeViewController.addAttachmentData(fileData, mimeType: self.errorFileMimeType, fileName: self.errorFileName)
            }
            
            _viewController?.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert({ (action) in
                self.cancel()
            })
        }
    }
    
    private func getFilePath() -> String {
        
        let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return filePath + "/"
    }
    
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(_emailrecipientsList)
        mailComposerVC.setSubject(_emailSubject!)
        mailComposerVC.setMessageBody(_emailMessage!, isHTML: false)
        
        return mailComposerVC
    }
    
    private func showSendMailErrorAlert(okBlock: ((UIAlertAction) -> Void)?) {
        let sendMailErrorAlert = UIAlertController(title: mailErrorTitle, message: mailErrorMessage, preferredStyle: .Alert)
        let actionOK = UIAlertAction(title: "OK", style: .Default, handler: okBlock)
        sendMailErrorAlert.addAction(actionOK)
        _viewController?.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        _viewController?.dismissViewControllerAnimated(true, completion: nil)
        if error != nil {
            let errorModel = ErrorModel.error(ErrorModel.Domain, code: ErrorModel.ErrorCode_Mail.mailFailed.rawValue, failureReason: error.debugDescription, methodName: self.methodName, nsError: error!)
            self.errorManagerHandler(errorModel)
            self._onFailure!(errorModel: errorModel)
        }
        else {
            switch result.rawValue {
            case 0:
                let errorModel = ErrorModel.error(ErrorModel.Domain, code: ErrorModel.ErrorCode_Mail.mailFailed.rawValue, failureReason: error.debugDescription, methodName: self.methodName, nsError: error!)
                self.errorManagerHandler(errorModel)
                self._onFailure!(errorModel: errorModel)
                
                break
            case 1:
                let errorModel = ErrorModel.error(ErrorModel.Domain, code: ErrorModel.ErrorCode_Mail.mailSaved.rawValue, failureReason: error.debugDescription, methodName: self.methodName, nsError: error!)
                self.errorManagerHandler(errorModel)
                self._onFailure!(errorModel: errorModel)
                break
            case 2:
                let errorModel = ErrorModel.error(ErrorModel.Domain, code: ErrorModel.ErrorCode_Mail.mailSent.rawValue, failureReason: error.debugDescription, methodName: self.methodName, nsError: error!)
                self.errorManagerHandler(errorModel)
                self._onSuccess!(errorModel: errorModel)
                break
            case 3:
                let errorModel = ErrorModel.error(ErrorModel.Domain, code: ErrorModel.ErrorCode_Mail.mailFailed.rawValue, failureReason: error.debugDescription, methodName: self.methodName, nsError: error!)
                self.errorManagerHandler(errorModel)
                self._onFailure!(errorModel: errorModel)
                break
                
            default:
                break
            }
        }
    }
    
    private func errorManagerHandler(errorModel: ErrorModel) {
        self.errorManager.reportErrorToCrashlitics(errorModel)
        self.errorManager.reportErrorToLogFile(errorModel)
    }
    
    private func showErrorAlert(title: String, message: String, cancelButtonTitle: String, sendButtonTitle: String, cancelBlock: ((UIAlertAction) -> Void)?, okBlock: ((UIAlertAction) -> Void)?) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action1 = UIAlertAction(title: cancelButtonTitle, style: .Default, handler: cancelBlock)
        let action2 = UIAlertAction(title: sendButtonTitle, style: .Default, handler: okBlock)
        controller.addAction(action1)
        controller.addAction(action2)
        _viewController!.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    private func cancel() {
        let errorModel = ErrorModel.error(ErrorModel.Domain, code: ErrorModel.ErrorCode_Mail.mailCancelled.rawValue, failureReason: "", methodName: self.methodName, nsError: NSError(domain: "", code: 0, userInfo: nil))
        self._onFailure!(errorModel: errorModel)
    }
}
