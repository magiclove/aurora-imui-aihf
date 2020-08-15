//
//  MessageEventModel.swift
//  sample
//
//  Created by oshumini on 2017/6/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import Foundation
/*
 好友入群时候的消息  即显示  "某某某加入了群"  这段文字
 */
@objc open class MessageEventModel: NSObject, IMUIMessageProtocol {
    
  public var inDate: Int64 = 0
  public var timeString: String = ""
  public var msgId: String = ""
  public var eventText: String = ""
  public var isNeedShowTimeString: Bool = false //不显示顶部的时间
  
  var eventSize: CGSize = CGSize.zero
  
    public init(msgId: String, eventText: String, inDate:Int64) {
    super.init()
    self.msgId = msgId
    self.eventText = eventText
    self.inDate = inDate
  }
  
  @objc public convenience init(messageDic: NSDictionary) {
    
    let msgId = messageDic["msgId"]
    let eventText = messageDic["text"]
    let inDateNum = messageDic.object(forKey: RCTMessageModel.kInDate) as? NSNumber
    
    let inDate = Int64(inDateNum?.int64Value ?? 0)
    
    
    
    self.init(msgId: msgId as! String, eventText: eventText as! String, inDate: inDate)
    
    self.eventSize = MessageEventModel.calculateTextContentSize(text: eventText as! String)
  }
  
  static func calculateTextContentSize(text: String) -> CGSize {
    
      var contentSize = text.sizeWithConstrainedWidth(with: MessageEventCollectionViewCell.maxWidth, font: MessageEventCollectionViewCell.eventFont)
    
      return CGSize(width: MessageEventCollectionViewCell.contentInset.left +
                           MessageEventCollectionViewCell.contentInset.right +
                           contentSize.width
                 , height: MessageEventCollectionViewCell.contentInset.top +
                           MessageEventCollectionViewCell.contentInset.bottom +
                           contentSize.height)
  }
  
  @objc public func cellHeight() -> CGFloat {
    return self.eventSize.height + MessageEventCollectionViewCell.paddingGap * 2.0;
  }
}
