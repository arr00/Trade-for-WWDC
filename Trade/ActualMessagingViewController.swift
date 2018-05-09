//
//  ActualMessagingViewController.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/8/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import MessageKit
import SendBirdSDK
import Parse

class ActualMessagingViewController: MessagesViewController {
    var messages:[MessageType]!
    var channel:SBDGroupChannel?
    var trade:Trade!
    var otherUser:PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.trade.match.objectId! == PFUser.current()!.objectId! {
            otherUser = self.trade.requester
        }
        else {
            otherUser = self.trade.match
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Trade details", style: .plain, target: self, action: #selector(ActualMessagingViewController.showTradeDetails))
        
        
        // Do any additional setup after loading the view.
        messages = [MessageType]()
        
        if SBDMain.getConnectState() == SBDWebSocketConnectionState.open {
            SBDGroupChannel.createChannel(withUserIds: [otherUser.objectId!], isDistinct: true) { (channel, error) in
                print("done")
                self.channel = channel
                print("Creating channel with userid \(self.otherUser.objectId!)")
                print("Current user object id is \(PFUser.current()?.objectId)")
                print("error is \(error?.localizedDescription)")
                SBDMain.add(self, identifier: self.description)
                self.getMessages()
            }
        }
        else {
        SBDMain.connect(withUserId: PFUser.current()!.objectId!, completionHandler: { (user, error) in
            SBDGroupChannel.createChannel(withUserIds: [self.otherUser.objectId!], isDistinct: true) { (channel, error) in
                print("done")
                self.channel = channel
                print("Creating channel with userid \(self.otherUser.objectId!)")
                print("Current user object id is \(PFUser.current()?.objectId)")
                print("error is \(error?.localizedDescription)")
                SBDMain.add(self, identifier: self.description)
                self.getMessages()
            }
            
        })
        }
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    
    @objc func showTradeDetails() {
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TradeDetailsViewController {
            dest.trade = trade
            dest.vcType = Type.ExistingTrade
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getMessages() {
        let previousMessageQuery = self.channel!.createPreviousMessageListQuery()
        previousMessageQuery?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (messages, error) in
            if error != nil {
                NSLog("Error: %@", error!)
                return
            }
            for message in messages! {
                
                if let myMessage = message as? SBDUserMessage {
                    let mmessage = TextMessage(sender: Sender(id: (myMessage.sender?.userId)!, displayName: myMessage.sender?.nickname ?? "filler"), messageId: String(myMessage.messageId), sentDate: Date(timeIntervalSince1970: TimeInterval(myMessage.createdAt)/1000.0), text: myMessage.message!)
                    self.messages.append(mmessage)
                    
                }
                
                
            }
            /*self.messages.sort(by: { (m1, m2) -> Bool in
                return m1.sentDate < m2.sentDate
            })*/
            self.messagesCollectionView.reloadData()
            
            
        })
    }
    
    

}
public class TextMessage:MessageType {
    
    public var kind: MessageKind
    
    public var sender: Sender
    
    public var messageId: String
    
    public var sentDate: Date
    
    public var text:String
    
    
    public init(sender:Sender, messageId:String, sentDate:Date, text:String) {
        self.text = text
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = MessageKind.text(text)
    }
    
    
}
extension ActualMessagingViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
        
    }
    override func viewWillLayoutSubviews() {
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
    }
}
extension ActualMessagingViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
        
        for component in inputBar.inputTextView.components {
            
            if let text = component as? String {
                
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                
                let message = TextMessage(sender: Sender(id: PFUser.current()!.objectId!, displayName: "Steven"), messageId: UUID().uuidString, sentDate: Date(), text: text)
                messages.append(message)
                messagesCollectionView.insertSections([messages.count - 1])
                channel?.sendUserMessage(text, completionHandler: { (message, error) in
                    print("sent message")
                    print("error is \(error != nil)")
                })
            }
            
        }
        
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
    
}

extension ActualMessagingViewController:SBDChannelDelegate {
    //recieve messages
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        print("cool")
        let myMessage = message as! SBDUserMessage
        let mmessage = TextMessage(sender: Sender(id: (myMessage.sender?.userId)!, displayName: myMessage.sender?.nickname ?? "filler"), messageId: String(myMessage.messageId), sentDate: Date(timeIntervalSince1970: TimeInterval(myMessage.createdAt)), text: myMessage.message!)
        self.messages.append(mmessage)
        self.messagesCollectionView.reloadDataAndKeepOffset()
    }
}
extension ActualMessagingViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: PFUser.current()!.objectId!, displayName: "")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}
