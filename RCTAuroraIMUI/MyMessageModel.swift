//
//  MyMessageModel.swift
//  IMUIChat
//
//  Created by oshumini on 2017/3/5.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit



open class RCTMessageModel: IMUIMessageModel {
  //消息接受发送的状态
  static let kMsgKeyStatus = "status"
  static let kMsgStatusSuccess = "send_succeed"
  static let kMsgStatusSending = "send_going"
  static let kMsgStatusFail = "send_failed"
  static let kMsgStatusDownloadFail = "download_failed"
  static let kMsgStatusDownloading = "downloading"
  //日期
  static let kInDate = "inDate"
  //接受发送的消息类型
  static let kMsgKeyMsgType = "msgType"
  static let kMsgTypeText = "text"  //文本类型
  static let kMsgTypeVoice = "voice" //语音
  static let kMsgTypeImage = "image"//图片
  static let kMsgTypeVideo = "video"//视频
  static let kMsgTypeCustom = "custom" //自定义
  static let kMsgTypeShare = "share" //资讯分享

  static let kMsgKeyMsgId = "msgId"   //该条信息的id
  static let kMsgKeyFromUser = "fromUser"   //用户信息
  static let kMsgKeyText = "text"    //文本信息
  static let kMsgKeyisOutgoing = "isOutgoing"   //是左边的还是右边的
  static let kMsgKeyMediaFilePath = "mediaPath"  //媒体路径
  static let kMsgKeyDuration = "duration"   //时间间隔
  static let kMsgKeyContentSize = "contentSize"  //内容大小
  static let kMsgKeyContent = "content" //内容
  static let kMsgKeyExtras = "extras"  //额外信息
  //资讯分享的标题
  static let kMsgKeyTitle = "title"
  //资讯分享的副标题
  static let kMsgKeySubTitle = "subtitle"
  //资讯分享的缩略图
  static let kMsgKeyShareImageUrl = "shareImageUrl"
    
  static let kUserKeyUerId = "userId"   //用户id
  static let kUserKeyDisplayName = "diaplayName" //用户名
  static let kUserAvatarPath = "avatarPath"  //头像路径
  
  static let ktimeString = "timeString"  //服务器收到的日期字符串

  open var myTextMessage: String = ""
  
  var mediaPath: String = ""
  var extras: NSDictionary?
    
   var aTitle: String = ""
   var aSubTitle: String = ""
   var aShareImageUrl: String = ""
    
  override open func mediaFilePath() -> String {
    return mediaPath
  }
    //资讯分享正标题
    open override func title() -> String {
        return aTitle;
    }
    //资讯分享副标题
    open override func subTitle() -> String {
        return aSubTitle;
    }
    
    //资讯分享图片链接
    open override func shareImageUrl() -> String {
        return aShareImageUrl;
    }
    
    open override func messageType() -> String {
        return type
    }
    
  @objc static open var outgoingBubbleImage: UIImage = {
    var bubbleImg = UIImage.imuiImage(with: "outGoing_bubble")
    bubbleImg = bubbleImg?.resizableImage(withCapInsets: UIEdgeInsetsMake(24, 10, 9, 15), resizingMode: .tile)
    return bubbleImg!
  }()
  
  @objc static open var incommingBubbleImage: UIImage = {
    var bubbleImg = UIImage.imuiImage(with: "inComing_bubble")
    bubbleImg = bubbleImg?.resizableImage(withCapInsets: UIEdgeInsetsMake(24, 15, 9, 10), resizingMode: .tile)
    return bubbleImg!
  }()
  
  @objc override open var resizableBubbleImage: UIImage {
    if isOutGoing {
      return RCTMessageModel.outgoingBubbleImage
    } else {
      return RCTMessageModel.incommingBubbleImage
    }
  }
  
    @objc public init(msgId: String, messageStatus: IMUIMessageStatus, fromUser: RCTUser, isOutGoing: Bool, time: String, type: String, text: String, mediaPath: String, layout: IMUIMessageCellLayoutProtocol, duration: CGFloat, extras: NSDictionary?, inDate: Int64, title: String, subTitle: String, shareImageUrl: String) {
    
    self.myTextMessage = text
    self.mediaPath = mediaPath
    self.extras = extras
    
    self.aTitle = title //标题
    self.aSubTitle = subTitle  //副标题
    self.aShareImageUrl = shareImageUrl //图片链接
   
    super.init(msgId: msgId, messageStatus: messageStatus, fromUser: fromUser, isOutGoing: isOutGoing, time: time, type: type, cellLayout: layout, duration: duration, inDate: inDate)
    
        
  }
  //便利初始化方法
  @objc public convenience init(messageDic: NSDictionary) {
    
    let msgId = messageDic.object(forKey: RCTMessageModel.kMsgKeyMsgId) as! String //消息id
    let msgTypeString = messageDic.object(forKey: RCTMessageModel.kMsgKeyMsgType) as? String //消息类型
    let statusString = messageDic.object(forKey: RCTMessageModel.kMsgKeyStatus) as? String //消息状态
    let isOutgoing = messageDic.object(forKey: RCTMessageModel.kMsgKeyisOutgoing) as? Bool //自己的消息还是对方的消息
    

    let duration = messageDic.object(forKey: RCTMessageModel.kMsgKeyDuration) as? NSNumber //
    let durationTime = CGFloat(duration?.floatValue ?? 0.0)
    
    let inDateNum = messageDic.object(forKey: RCTMessageModel.kInDate) as? NSNumber //时间戳字符串
    let inDate = Int64(inDateNum?.int64Value ?? 0)

//    var aTimeString = messageDic.object(forKey: RCTMessageModel.ktimeString) as? String
    //时间相关的
    var aTimeString = ""
     var timeContentSize: CGSize = CGSize.zero
     let needShowTime = true //PS: 这里显示顶部的时间并不能决定是否真的显示
    
    let messageDate: Date = Date(timeIntervalSince1970: Double(inDate/1000))
    
    let inDateString =  DateFormatterManager.stringDate(date: messageDate, dateFormat: "yyyy-MM-dd")

    let todayString = DateFormatterManager.stringDate(date: Date(), dateFormat: "yyyy-MM-dd")
    //显示的是今天
    if inDateString.contains(todayString) {
        if DateFormatterManager.isAMPM() {

            let newDateString: String = DateFormatterManager.stringDate(date: messageDate, dateFormat: "aaa hh:mm")
            aTimeString = newDateString

        } else {
            // yyyy-MM-dd HH:ss
            let newDateString: String = DateFormatterManager.stringDate(date: messageDate, dateFormat: "HH:mm")
            aTimeString = newDateString

        }
    } else {
        
        if DateFormatterManager.isAMPM() {
            
            let newDateString: String = DateFormatterManager.stringDate(date: messageDate, dateFormat: "yyyy-MM-dd aaa hh:mm")
            aTimeString = newDateString
            
        } else {
            // yyyy-MM-dd HH:ss
            let newDateString: String = DateFormatterManager.stringDate(date: messageDate, dateFormat: "yyy-MM-dd HH:mm")
            aTimeString = newDateString
        }
        
    }
    if !aTimeString.isEmpty {
      timeContentSize = RCTMessageModel.calculateTimeContentSize(text: aTimeString)
    }

    //额外信息
    let extras = messageDic.object(forKey: RCTMessageModel.kMsgKeyExtras) as? NSDictionary
    if let _ = extras {
      
    }
    //音频路径
    var mediaPath = messageDic.object(forKey: RCTMessageModel.kMsgKeyMediaFilePath) as? String
    if let _ = mediaPath {
      
    } else {
      mediaPath = ""
    }
    //消息文本
    var text = messageDic.object(forKey: RCTMessageModel.kMsgKeyText) as? String
    if let _ = text {
      
    } else {
      text = ""
    }
    //消息类型
    var msgType: String?
    // TODO: duration
    let userDic = messageDic.object(forKey: RCTMessageModel.kMsgKeyFromUser) as? NSDictionary
    let user = RCTUser(userDic: userDic!)
    
    //资讯分享信息的主标题
    var titleString = messageDic.object(forKey: RCTMessageModel.kMsgKeyTitle) as? String
    if let _ = titleString {
        
    } else {
       titleString = ""
    }
    //资讯分享信息副标题
    var subtitleString = messageDic.object(forKey: RCTMessageModel.kMsgKeySubTitle) as? String
    if let _ = subtitleString {
        
    } else {
        subtitleString = ""
    }
    //资讯分享信息缩略图
    var shareImageUrlString = messageDic.object(forKey: RCTMessageModel.kMsgKeyShareImageUrl) as? String
    if let _ = shareImageUrlString {
        
    } else {
        shareImageUrlString = ""
    }
    
    
    
    //该条信息对应的布局
    var messageLayout: MyMessageCellLayout?
    if let typeString = msgTypeString {
        
      msgType = typeString
      //纯文本
      if typeString == RCTMessageModel.kMsgTypeText {
    
        
        messageLayout = MyMessageCellLayout(isOutGoingMessage: isOutgoing ?? true,
                                               isNeedShowTime: needShowTime,
                                            bubbleContentSize: RCTMessageModel.calculateTextContentSize(text: text!,
                                                                                                  isOutGoing: isOutgoing!),
                                          bubbleContentInsets: UIEdgeInsets.zero,
                                         timeLabelContentSize: timeContentSize,
                                                         type: RCTMessageModel.kMsgTypeText)
      }
      //图片
      if typeString == RCTMessageModel.kMsgTypeImage {
        
        var imgSize = CGSize(width: 120, height: 160)
        if let img = UIImage(contentsOfFile: mediaPath!) {
          imgSize = RCTMessageModel.converImageSize(with: CGSize(width: img.size.width, height: img.size.height))
        }
        
        messageLayout = MyMessageCellLayout(isOutGoingMessage: isOutgoing ?? true,
                                               isNeedShowTime: needShowTime,
                                            bubbleContentSize: imgSize,
                                          bubbleContentInsets: UIEdgeInsets.zero,
                                         timeLabelContentSize: timeContentSize,
                                                         type: RCTMessageModel.kMsgTypeImage)
      }
      //语音
      if typeString == RCTMessageModel.kMsgTypeVoice {
        messageLayout = MyMessageCellLayout(isOutGoingMessage: isOutgoing ?? true,
                                               isNeedShowTime: needShowTime,
                                            bubbleContentSize: CGSize(width: 80, height: 37),
                                          bubbleContentInsets: UIEdgeInsets.zero,
                                         timeLabelContentSize: timeContentSize,
                                                         type: RCTMessageModel.kMsgTypeVoice)
      }
      //视频
      if typeString == RCTMessageModel.kMsgTypeVideo {

        messageLayout = MyMessageCellLayout(isOutGoingMessage: isOutgoing ?? true,
                                               isNeedShowTime: needShowTime,
                                            bubbleContentSize: CGSize(width: 120, height: 160),
                                          bubbleContentInsets: UIEdgeInsets.zero,
                                         timeLabelContentSize: timeContentSize,
                                                         type: RCTMessageModel.kMsgTypeVideo)
      }
    
          //自定义
          if typeString == RCTMessageModel.kMsgTypeCustom {
            // TODO custom
            text = messageDic.object(forKey: RCTMessageModel.kMsgKeyContent) as? String
            var bubbleContentSize = CGSize.zero
            var contentSize = messageDic.object(forKey: RCTMessageModel.kMsgKeyContentSize) as? NSDictionary
            if let _ = contentSize {
              let contentWidth = contentSize!["width"] as! NSNumber
              let contentHeight = contentSize!["height"] as! NSNumber
              bubbleContentSize = CGSize(width: contentWidth.doubleValue, height: contentHeight.doubleValue)
            } else {
              bubbleContentSize = CGSize.zero
            }
            messageLayout = MyMessageCellLayout(isOutGoingMessage: isOutgoing ?? true,
                                                   isNeedShowTime: needShowTime,
                                                bubbleContentSize: bubbleContentSize,
                                              bubbleContentInsets: UIEdgeInsets.zero,
                                             timeLabelContentSize: timeContentSize,
                                                             type: RCTMessageModel.kMsgTypeCustom)
          }
        
        
        //资讯分享类型的布局
        if typeString == RCTMessageModel.kMsgTypeShare {
            
            //计算资讯分享的高度
            
            let width = (isOutgoing == true ?   IMUINewsMessageContentView.outgoingPadding.left + IMUINewsMessageContentView.outgoingPadding.right : IMUINewsMessageContentView.incommingPadding.left + IMUINewsMessageContentView.incommingPadding.right) + MyMessageCellLayout.bubbleMaxWidth
         

           let titleSize =  RCTMessageModel.calculateTextContentSize(text: titleString!, isOutGoing: isOutgoing ?? true, width: width, font: IMUINewsMessageContentView.titleFont, lineHeight: IMUINewsMessageContentView.titleLineHeight)
        
            var titleHeight = IMUINewsMessageContentView.titleFont.lineHeight;
            //说明有2行否则一行
            if titleSize.height - titleHeight > IMUINewsMessageContentView.titleLineHeight {
                titleHeight = 2 * IMUINewsMessageContentView.titleFont.lineHeight + IMUINewsMessageContentView.titleLineHeight
            }

            let height = (isOutgoing == true ?   IMUINewsMessageContentView.outgoingPadding.top : IMUINewsMessageContentView.incommingPadding.top) + (isOutgoing == true ?   IMUINewsMessageContentView.outgoingPadding.bottom : IMUINewsMessageContentView.incommingPadding.bottom) + titleHeight +  IMUINewsMessageContentView.shareImageSize.height + IMUINewsMessageContentView.titleAndSubTitleSpace
            
            //最终的高度和高度
            
            let size = CGSize(width: width, height: height )
            
            messageLayout = MyMessageCellLayout(isOutGoingMessage: isOutgoing ?? true,
                                                isNeedShowTime: needShowTime,
                                                bubbleContentSize: size,
                                                bubbleContentInsets: UIEdgeInsets.zero,
                                                timeLabelContentSize: timeContentSize,
                                                type: RCTMessageModel.kMsgTypeShare)
        }
    }
    
    var msgStatus = IMUIMessageStatus.success
    if let statusString = statusString {
      
      if statusString == RCTMessageModel.kMsgStatusSuccess {
        msgStatus = .success
      }
      
      if statusString == RCTMessageModel.kMsgStatusFail {
        msgStatus = .failed
      }
      
      if statusString == RCTMessageModel.kMsgStatusSending {
        msgStatus = .sending
      }
      
      if statusString == RCTMessageModel.kMsgStatusDownloadFail {
        msgStatus = .mediaDownloadFail
      }
      
      if statusString == RCTMessageModel.kMsgStatusDownloading {
        msgStatus = .mediaDownloading
      }
      
    }
    
    self.init(msgId: msgId, messageStatus: msgStatus, fromUser: user, isOutGoing: isOutgoing ?? true, time: aTimeString
        , type: msgType!, text: text!, mediaPath: mediaPath!, layout:  messageLayout!,duration: durationTime, extras: extras,inDate: inDate,title: titleString!,subTitle:subtitleString!,shareImageUrl:shareImageUrlString!)
  }
  
  override open func text() -> String {
    return self.myTextMessage
  }
  //计算文本高度
  @objc static func calculateTextContentSize(text: String, isOutGoing: Bool) -> CGSize {
    
    if isOutGoing {
        
      var textSize = text.sizeWithConstrainedWidth(with: IMUIMessageCellLayout.bubbleMaxWidth, font: IMUITextMessageContentView.outGoingTextFont, lineSpacing: IMUITextMessageContentView.outGoingTextLineHeight)
      
        //因为一行文字的时候也有行间距
        if textSize.height - IMUITextMessageContentView.outGoingTextFont.lineHeight <= IMUITextMessageContentView.outGoingTextLineHeight {
            
            textSize.height = IMUITextMessageContentView.outGoingTextFont.lineHeight
        }
        
      return textSize
        
    } else {
        
        var textSize = text.sizeWithConstrainedWidth(with: IMUIMessageCellLayout.bubbleMaxWidth,
                                                     font: IMUITextMessageContentView.inComingTextFont,
                                                     lineSpacing: IMUITextMessageContentView.inComingTextLineHeight)
        
        //因为一行文字的时候富文本也有行间距
        if textSize.height - IMUITextMessageContentView.inComingTextFont.lineHeight <= IMUITextMessageContentView.inComingTextLineHeight {
            
            textSize.height = IMUITextMessageContentView.inComingTextFont.lineHeight
        }
        
      return textSize
    }
    
  }
    
    //资讯分享调用了这里
    @objc static func calculateTextContentSize(text: String, isOutGoing: Bool , width: CGFloat ,  font: UIFont, lineHeight: CGFloat) -> CGSize {
        if isOutGoing {
            return text.sizeWithConstrainedWidth(with: width, font: font, lineSpacing: lineHeight)
        } else {
            return text.sizeWithConstrainedWidth(with: width,
                                                 font: font,
                                                 lineSpacing: lineHeight)
        }
    }
  //计算时间
  static func calculateTimeContentSize(text: String) -> CGSize {
      return text.sizeWithConstrainedWidth(with: IMUIMessageCellLayout.bubbleMaxWidth,
                                           font: IMUIMessageCellLayout.timeStringFont)
  }
  
  static func converImageSize(with size: CGSize) -> CGSize {
    
    let maxSide = 160.0
    
    var scale = size.width / size.height
    
    if size.width > size.height {
      scale = scale > 2 ? 2 : scale
      return CGSize(width: CGFloat(maxSide), height: CGFloat(maxSide) / CGFloat(scale))
    } else {
      scale = scale < 0.5 ? 0.5 : scale
      return CGSize(width: CGFloat(maxSide) * CGFloat(scale), height: CGFloat(maxSide))
    }
  }
  //回调给RN的信息
  @objc public var messageDictionary: NSDictionary {
    get {
      
      let messageDic = NSMutableDictionary()
      //消息id
      messageDic.setValue(self.msgId, forKey: RCTMessageModel.kMsgKeyMsgId)
      //是否发出去的还是接受的
      messageDic.setValue(self.isOutGoing, forKey: RCTMessageModel.kMsgKeyisOutgoing)
        
      //各个类型特有的字段
      switch self.type {
        
          case "text":
            messageDic.setValue(RCTMessageModel.kMsgTypeText, forKey: RCTMessageModel.kMsgKeyMsgType)
            messageDic.setValue(self.text(), forKey: RCTMessageModel.kMsgKeyText)
            break
        
          case "image":
            messageDic.setValue(RCTMessageModel.kMsgTypeImage, forKey: RCTMessageModel.kMsgKeyMsgType)
            messageDic.setValue(self.mediaPath, forKey: RCTMessageModel.kMsgKeyMediaFilePath)
            break
        
          case "voice":
            messageDic.setValue(RCTMessageModel.kMsgTypeVoice, forKey: RCTMessageModel.kMsgKeyMsgType)
            messageDic.setValue(self.mediaPath, forKey: RCTMessageModel.kMsgKeyMediaFilePath)
            messageDic.setValue(self.duration, forKey: RCTMessageModel.kMsgKeyDuration)
            break
        
          case "video":
            messageDic.setValue(RCTMessageModel.kMsgTypeVideo, forKey: RCTMessageModel.kMsgKeyMsgType)
            messageDic.setValue(self.mediaPath, forKey: RCTMessageModel.kMsgKeyMediaFilePath)
            messageDic.setValue(self.duration, forKey: RCTMessageModel.kMsgKeyDuration)
            break
        
          case "custom":
            messageDic.setValue(RCTMessageModel.kMsgTypeCustom, forKey: RCTMessageModel.kMsgKeyMsgType)
            messageDic.setValue(self.text(), forKey: RCTMessageModel.kMsgKeyContent)
            let contentSize = ["height": self.layout.bubbleContentSize.height,
                               "width": self.layout.bubbleContentSize.width]
            messageDic.setValue(contentSize, forKey: RCTMessageModel.kMsgKeyContentSize)
            break
        
          case "share":
            messageDic.setValue(RCTMessageModel.kMsgTypeShare, forKey: RCTMessageModel.kMsgKeyMsgType)
            messageDic.setValue(self.title(), forKey: RCTMessageModel.kMsgKeyTitle)
            messageDic.setValue(self.subTitle(), forKey: RCTMessageModel.kMsgKeySubTitle)
            messageDic.setValue(self.shareImageUrl(), forKey: RCTMessageModel.kMsgKeyShareImageUrl)
                break;
        
          default:
            break
      }
      
     //接受的状态
      var msgStatus = ""
      switch self.messageStatus {
      case .success:
        msgStatus = RCTMessageModel.kMsgStatusSuccess
        break
      case .sending:
        msgStatus = RCTMessageModel.kMsgStatusSending
        break
      case .failed:
        msgStatus = RCTMessageModel.kMsgStatusFail
        break
      case .mediaDownloading:
        msgStatus = RCTMessageModel.kMsgStatusDownloading
        break
      case .mediaDownloadFail:
        msgStatus = RCTMessageModel.kMsgStatusDownloadFail
        break
      }
      //额外信息
      if let _ = self.extras {
        messageDic.setValue(self.extras, forKey: RCTMessageModel.kMsgKeyExtras)
      }
        
      //时间戳
      messageDic.setValue(self.inDate, forKey: RCTMessageModel.kInDate)
        
      
      messageDic.setValue(msgStatus, forKey: "status")
    
      let userDic = NSMutableDictionary()
      userDic.setValue(self.fromUser.userId(), forKey: "userId")
      userDic.setValue(self.fromUser.displayName(), forKey: "diaplayName")
        
      let user = self.fromUser as! RCTUser
      userDic.setValue(user.rAvatarFilePath, forKey: "avatarPath")
      
      messageDic.setValue(userDic, forKey: "fromUser")
      messageDic.setValue(self.msgId, forKey: "msgId")
      messageDic.setValue(self.timeString, forKey: "timeString")
      
      return messageDic
    }
  }
}


//MARK - IMUIMessageCellLayoutProtocal
public class MyMessageCellLayout: IMUIMessageCellLayout {

  @objc open static var outgoingPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 15)
  @objc open static var incommingPadding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
    
  @objc open static var newsPadding = UIEdgeInsets.zero
  
  var type: String
  
  init(isOutGoingMessage: Bool,
          isNeedShowTime: Bool,
       bubbleContentSize: CGSize,
     bubbleContentInsets: UIEdgeInsets,
    timeLabelContentSize: CGSize,
                    type: String) {
    self.type = type
    super.init(isOutGoingMessage: isOutGoingMessage,
                  isNeedShowTime: isNeedShowTime,
               bubbleContentSize: bubbleContentSize,
             bubbleContentInsets: UIEdgeInsets.zero,
            timeLabelContentSize: timeLabelContentSize)
  }
  
  open override var bubbleContentInset: UIEdgeInsets {
    
        if type == RCTMessageModel.kMsgTypeText{
            
            if isOutGoingMessage {
                return MyMessageCellLayout.outgoingPadding
            } else {
                return MyMessageCellLayout.incommingPadding
            }
            
        }
    
        return UIEdgeInsets.zero
  }
  //消息内容对应的视图
  open override var bubbleContentView: IMUIMessageContentViewProtocol {
    
    if type == "text" {
      return IMUITextMessageContentView()
    }
    
    if type == "image" {
      return IMUIImageMessageContentView()
    }
    
    if type == "voice" {
      return IMUIVoiceMessageContentView()
    }
    
    if type == "video" {
      return IMUIVideoMessageContentView()
    }
    
    if type == "custom" {
      return IMUICustomMessageContentView()
    }
    
    if type == "share" {
        return IMUINewsMessageContentView()
    }
    
    return IMUIDefaultContentView()
  }
  
  open override var bubbleContentType: String {
    return type
  }
  
}

