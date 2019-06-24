import UIKit
import UserNotifications

class ViewController: UIViewController, UITextViewDelegate {
    
    //変数の宣言
    //今日の日付を代入
    var nowDate = Date()
    let DateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    //メモ欄の配置
    @IBOutlet weak var workPlaces: UITextView!
    //日付選択欄の配置D
    @IBOutlet weak var dateSelecter: UITextView!
    //メモ欄に初めに書いてある文字列
    var testText:String = "入力してね"
    
    let userDefaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    var textString = "あ"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DateFormat.dateFormat = "yyyy年MM月dd日"
        dateSelecter.text = DateFormat.string(for: nowDate)
        self.dateSelecter.delegate = self
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "jp_JP")
        
        //メモ欄の枠線の色を決める
        workPlaces.layer.borderColor = UIColor.black.cgColor
        //メモ欄の枠線の太さ
        workPlaces.layer.borderWidth = 2.0
        //日付選択欄の枠線の色を決める
        dateSelecter.layer.borderColor = UIColor.black.cgColor
        //日付選択欄の枠線の太さを決める
        dateSelecter.layer.borderWidth = 1.0
        
        workPlaces.delegate = self
        userDefaults.register(defaults: ["DataStore":"default"])
        workPlaces.text = readData()
    //-----デートピッカーの設定---------------
        inputDatePicker.datePickerMode = UIDatePicker.Mode.date
        dateSelecter.inputView = inputDatePicker
        //Todayより前の日にちを通知設定できないようにするため
        inputDatePicker.minimumDate = nowDate as Date
        //キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect(x:0, y:40, width:self.view.frame.size.width/1, height:self.view.frame.size.height/6))
        pickerToolBar.layer.position = CGPoint(x:self.view.frame.size.width/2, y:self.view.frame.size.height-20)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.black
       //-----------------------------------
    }

    //確定ボタンが押された時
    @IBAction func kakuteiData(_ sender: Any) {
        dateSelecter.endEditing(true)
        let pickerDate = inputDatePicker.date
        dateSelecter.text = DateFormat.string(from: pickerDate)
        textString = DateFormat.string(from: pickerDate)
        print(textString)
        nowDate = inputDatePicker.date
        print(nowDate)
       
    }
    func readData() -> String{
        let str:String = userDefaults.object(forKey: "DataStore") as! String
        return str
    }
    @IBAction func saveButton(_ sender: Any) {
    }
    //保存ボタンを押したとき
    @IBAction func saveData(_ sender: Any) {
        workPlaces.endEditing(true)
        testText = workPlaces.text!
        workPlaces.text = testText
        workPlaces.resignFirstResponder()
        saveData(str: testText)
    }
    func saveData(str:String){
        userDefaults.set(str, forKey: "DataStore")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //通知ボタンが押された時
    @IBAction func tutiButton(_ sender: UIButton) {
        print("通知ボタンが押されました。")
        //ローカル通知の内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "通知テスト！！！"
        //メモを通知内容にする
        content.body = workPlaces.text
        //送信する時刻について
        var notification = DateComponents()
        //通知する年
        notification.year = Int(textString.prefix(4))
        //通知する月
        notification.month = Int(textString[textString.index(textString.startIndex, offsetBy: 6) ..< textString.index(textString.startIndex, offsetBy: 7)])
        //通知する日にち
        notification.day = Int(textString[textString.index(textString.startIndex, offsetBy: 8) ..< textString.index(textString.startIndex, offsetBy: 10)])
        notification.hour = 15
        notification.minute = 45
        
        print(notification.year)
        print(notification.month)
        print(notification.day)
        print(notification.hour)
        print(notification.minute)

        // ローカル通知リクエストを作成
        let trigger = UNCalendarNotificationTrigger(dateMatching: notification, repeats: false)
        //ユニークなIDを作る
        let identifier = NSUUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //ローカル通知リクエストを登録
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
          if let error = error {
            print(error.localizedDescription)
        }
        }
    }
}
