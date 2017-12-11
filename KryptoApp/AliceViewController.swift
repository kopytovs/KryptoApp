//
//  AliceViewController.swift
//  KryptoApp
//
//  Created by Sergey Kopytov on 11.12.2017.
//  Copyright © 2017 Sergey Kopytov. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftyRSA

class AliceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var generationButton: UIButton!
    @IBOutlet weak var closeKey: JVFloatLabeledTextField!
    @IBOutlet weak var openKey: JVFloatLabeledTextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageField: JVFloatLabeledTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kryptoButton: UIButton!
    @IBOutlet weak var encryptMsg: JVFloatLabeledTextField!
    
    var pubKey:PublicKey?
    var priKey:PrivateKey?
    var abra:EncryptedMessage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (!abrakadabra.isEmpty){
            decode()
        }
        self.kryptoButton.isEnabled = (BobPublicKey != nil) ? true : false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func decode(){
        let encrypted = try! EncryptedMessage(base64Encoded: (abrakadabra.last?.base64String)!)
        let clear = try! encrypted.decrypted(with: AlicePrivateKey!, padding: .PKCS1)
        let msg = try! clear.string(encoding: String.Encoding.utf8)
        if (messages.isEmpty == true){
            messages.append("\(msg)")
        } else{
            if messages.last! != msg{
                messages.append("\(msg)")
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        self.sendMessageButton.isEnabled = false
        persons.append("Алиса:")
        abrakadabra.append(abra!)
    }
    
    @IBAction func generateKeys(_ sender: Any) {
        pubKey = try! PublicKey(pemEncoded: pemPub)
        priKey = try! PrivateKey(pemEncoded: pemPri)
        AlicePublicKey = pubKey
        AlicePrivateKey = priKey
        let pub = try! pubKey?.pemString()
        let pri = try! priKey?.pemString()
        self.openKey.text = "\(pub!)"
        self.closeKey.text = "\(pri!)"
    }
    @IBAction func kryptoMsg(_ sender: Any) {
        let clear = try! ClearMessage(string: self.messageField.text!, using: .utf8)
        let encrypted = try! clear.encrypted(with: BobPublicKey!, padding: .PKCS1)
        self.encryptMsg.text = encrypted.base64String
        self.abra = encrypted
        self.sendMessageButton.isEnabled = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = persons[indexPath.row]
        cell.detailTextLabel?.text = messages[indexPath.row]
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
