import UIKit
import AVFoundation
import AudioToolbox

//complate
class KeyboardViewController: UIInputViewController {

    var player:AVAudioPlayer?
    var cases: Cases = Cases.Latter

    @IBOutlet var nextKeyboardButton: UIButton!




    var index:[Int] = [0,0,0,0,0,0]
    var lanType: Lan = Lan.Uz
    let multilingualMap: [String: [Lan: String]] = [
        "000000" : [ Lan.En : " ", Lan.Uz : " ", Lan.Ru : " "],
        "000001" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "000010" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "000011" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "000100" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "000101" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "000110" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "000111" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "001000" : [ Lan.En : "'", Lan.Uz : "'", Lan.Ru : ""],
        "001001" : [ Lan.En : "-", Lan.Uz : "-", Lan.Ru : "-"],
        "001010" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "001011" : [ Lan.En : "”", Lan.Uz : "”", Lan.Ru : "”"],
        "001100" : [ Lan.En : "/", Lan.Uz : "", Lan.Ru : ""],
        "001101" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "001110" : [ Lan.En : ")", Lan.Uz : ")", Lan.Ru : ""],
        "001111" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "010000" : [ Lan.En : ",", Lan.Uz : ",", Lan.Ru : ","],
        "010001" : [ Lan.En : "?", Lan.Uz : "?", Lan.Ru : "?"],
        "010010" : [ Lan.En : ":", Lan.Uz : ":", Lan.Ru : ":"],
        "010011" : [ Lan.En : ".", Lan.Uz : ".", Lan.Ru : "."],
        "010100" : [ Lan.En : "i", Lan.Uz : "i", Lan.Ru : "и"],
        "010101" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : "э"],
        "010110" : [ Lan.En : "j", Lan.Uz : "j", Lan.Ru : "ж"],
        "010111" : [ Lan.En : "w", Lan.Uz : "v", Lan.Ru : "в"],
        "011000" : [ Lan.En : ";", Lan.Uz : ";", Lan.Ru : ";"],
        "011001" : [ Lan.En : "“", Lan.Uz : "“", Lan.Ru : "“"],
        "011010" : [ Lan.En : "!", Lan.Uz : "!", Lan.Ru : "!"],
        "011011" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : "("],
        "011100" : [ Lan.En : "s", Lan.Uz : "s", Lan.Ru : "с"],
        "011101" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : "ы"],
        "011110" : [ Lan.En : "t", Lan.Uz : "t", Lan.Ru : "т"],
        "011111" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : "ь"],
        "100000" : [ Lan.En : "a", Lan.Uz : "a", Lan.Ru : "а"],
        "100001" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : "ё"],
        "100010" : [ Lan.En : "e", Lan.Uz : "e", Lan.Ru : "е"],
        "100011" : [ Lan.En : "", Lan.Uz : "sh", Lan.Ru : "ш"],
        "100100" : [ Lan.En : "c", Lan.Uz : "", Lan.Ru : "ц"],
        "100101" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
        "100110" : [ Lan.En : "d", Lan.Uz : "d", Lan.Ru : "д"],
        "100111" : [ Lan.En : "", Lan.Uz : "x", Lan.Ru : ""],
        "101000" : [ Lan.En : "k", Lan.Uz : "k", Lan.Ru : "к"],
        "101001" : [ Lan.En : "u", Lan.Uz : "u", Lan.Ru : "у"],
        "101010" : [ Lan.En : "o", Lan.Uz : "o", Lan.Ru : "о"],
        "101011" : [ Lan.En : "z", Lan.Uz : "z", Lan.Ru : "з"],
        "101100" : [ Lan.En : "m", Lan.Uz : "m", Lan.Ru : "м"],
        "101101" : [ Lan.En : "x", Lan.Uz : "", Lan.Ru : "щ"],
        "101110" : [ Lan.En : "n", Lan.Uz : "n", Lan.Ru : "н"],
        "101111" : [ Lan.En : "y", Lan.Uz : "q", Lan.Ru : ""],
        "110000" : [ Lan.En : "b", Lan.Uz : "b", Lan.Ru : "б"],
        "110001" : [ Lan.En : "(", Lan.Uz : "(", Lan.Ru : ""],
        "110010" : [ Lan.En : "h", Lan.Uz : "h", Lan.Ru : "х"],
        "110011" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : "ю"],
        "110100" : [ Lan.En : "f", Lan.Uz : "f", Lan.Ru : "ф"],
        "110101" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : "я"],
        "110110" : [ Lan.En : "g", Lan.Uz : "g", Lan.Ru : "г"],
        "110111" : [ Lan.En : "", Lan.Uz : "g'", Lan.Ru : ""],
        "111000" : [ Lan.En : "l", Lan.Uz : "l", Lan.Ru : "л"],
        "111001" : [ Lan.En : "v", Lan.Uz : "o'", Lan.Ru : ""],
        "111010" : [ Lan.En : "r", Lan.Uz : "r", Lan.Ru : "р"],
        "111011" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : "ъ"],
        "111100" : [ Lan.En : "p", Lan.Uz : "p", Lan.Ru : "п"],
        "111101" : [ Lan.En : "", Lan.Uz : "y", Lan.Ru : "й"],
        "111110" : [ Lan.En : "q", Lan.Uz : "ch", Lan.Ru : "ч"],
        "111111" : [ Lan.En : "", Lan.Uz : "", Lan.Ru : ""],
    ];

        let numberToNumber: [String : String] = [
            "000000": " ",
            "000001": "", /// command to Upper Letters
            "000010": "",
            "000011": "", /// command to Lower Letters
            "000100": "", /// qandaydr belgi qoyb urg'u berish uchun
            "000101": "",
            "000110": "",
            "000111": "",
            "001000": "",
            "001001": "",
            "001010": "",
            "001011": "",
            "001100": "",
            "001101": "",
            "001110": "",
            "001111": "", /// write by numbers
            "010000": "",
            "010001": "",
            "010010": "",
            "010011": ".",
            "010100": "9",
            "010101": "",
            "010110": "0",
            "010111": "",
            "011000": "",
            "011001": "",
            "011010": "",
            "011011": "",
            "011100": "",
            "011101": "",
            "011110": "",
            "011111": "",
            "100000": "1",
            "100001": "",
            "100010": "5",
            "100011": "",
            "100100": "3",
            "100101": "",
            "100110": "4",
            "100111": "",
            "101000": "",
            "101001": "",
            "101010": "",
            "101011": "",
            "101100": "",
            "101101": "",
            "101110": "",
            "101111": "",
            "110000": "2",
            "110001": "",
            "110010": "8",
            "110011": "",
            "110100": "6",
            "110101": "",
            "110110": "7",
            "110111": "",
            "111000": "",
            "111001": "",
            "111010": "",
            "111011": "",
            "111100": "",
            "111101": "",
            "111110": "",
            "111111": "",
        ];
        
        let wordSound: [Lan : [String: String]] = [
            Lan.En : [
                "a" : "en_a",
                "b" : "en_b",
                "c" : "en_c",
                "d" : "en_d",
                "e" : "en_e",
                "f" : "en_f",
                "g" : "en_g",
                "h" : "en_h",
                "i" : "en_i",
                "j" : "en_j",
                "k" : "en_k",
                "l" : "en_l",
                "m" : "en_m",
                "n" : "en_n",
                "o" : "en_o",
                "p" : "en_p",
                "q" : "en_q",
                "r" : "en_r",
                "s" : "en_s",
                "t" : "en_t",
                "u" : "en_u",
                "v" : "en_v",
                "w" : "en_w",
                "x" : "en_x",
                "y" : "en_y",
                "z" : "en_z",
                "1" : "en_n1",
                "2" : "en_n2",
                "3" : "en_n3",
                "4" : "en_n4",
                "5" : "en_n5",
                "6" : "en_n6",
                "7" : "en_n7",
                "8" : "en_n8",
                "9" : "en_n9",
                "0" : "en_n0",
                " " : "en_space",
                "." : "en_dot",
                "," : "en_comma",
                "(" : "en_bracket_opened",
                ")" : "en_bracket_closed",
                "'" : "en_apostrophe",
                "-" : "en_minus",
                "”" : "en_quote_closed",
                "“" : "en_quote_opened",
                "!" : "en_exclamation_mark",
                "?" : "en_question_mark",
                ":" : "en_colon",
                ";" : "en_semicolon",
                "*" : "en_asterisk",
              ],
              Lan.Uz : [
                "a" : "uz_a",
                "b" : "uz_b",
                "d" : "uz_d",
                "e" : "uz_e",
                "f" : "uz_f",
                "g" : "uz_g",
                "h" : "uz_h",
                "i" : "uz_i",
                "j" : "uz_j",
                "k" : "uz_k",
                "l" : "uz_l",
                "m" : "uz_m",
                "n" : "uz_n",
                "o" : "uz_o",
                "p" : "uz_p",
                "q" : "uz_q",
                "r" : "uz_r",
                "s" : "uz_s",
                "t" : "uz_t",
                "u" : "uz_u",
                "v" : "uz_v",
                "x" : "uz_x",
                "y" : "uz_y",
                "z" : "uz_z",
                "ch" : "uz_ch",
                "1" : "uz_n1",
                "2" : "uz_n2",
                "3" : "uz_n3",
                "4" : "uz_n4",
                "5" : "uz_n5",
                "6" : "uz_n6",
                "7" : "uz_n7",
                "8" : "uz_n8",
                "9" : "uz_n9",
                "0" : "uz_n0",
                " " : "uz_space",
                "." : "uz_dot",
                "," : "uz_comma",
                "(" : "uz_bracket_opened",
                ")" : "uz_bracket_closed",
                "'" : "uz_apostrophe",
                "-" : "uz_minus",
                "”" : "uz_quote_closed",
                "“" : "uz_quote_opened",
                "!" : "uz_exclamation_mark",
                "?" : "uz_question_mark",
                ":" : "uz_colon",
                ";" : "uz_semicolon",
                "*" : "uz_asterisk",
              ],
              Lan.Ru : [
                "а" : "ru_a",
                "б" : "ru_b",
                "в" : "ru_v",
                "г" : "ru_g",
                "д" : "ru_d",
                "е" : "ru_ye",
                "ё" : "ru_yo",
                "ж" : "ru_j",
                "з" : "ru_z",
                "и" : "ru_i",
                "й" : "ru_y",
                "к" : "ru_k",
                "л" : "ru_l",
                "м" : "ru_m",
                "н" : "ru_n",
                "о" : "ru_o",
                "п" : "ru_p",
                "р" : "ru_r",
                "с" : "ru_s",
                "т" : "ru_t",
                "у" : "ru_u",
                "ф" : "ru_f",
                "х" : "ru_x",
                "ц" : "ru_ts",
                "ч" : "ru_ch",
                "ш" : "ru_sh",
                "щ" : "ru_shsh",
                "ъ" : "ru_ib",
                "ы" : "ru_bi",
                "ь" : "ru_bb",
                "э" : "ru_e",
                "ю" : "ru_yu",
                "я" : "ru_ya",
                "1" : "ru_n1",
                "2" : "ru_n2",
                "3" : "ru_n3",
                "4" : "ru_n4",
                "5" : "ru_n5",
                "6" : "ru_n6",
                "7" : "ru_n7",
                "8" : "ru_n8",
                "9" : "ru_n9",
                "0" : "ru_n0",
                " " : "ru_space",
                "." : "ru_dot",
                "," : "ru_comma",
                "(" : "ru_bracket_opened",
                ")" : "ru_bracket_closed",
                "'" : "ru_apostrophe",
                "-" : "ru_minus",
                "”" : "ru_quote_closed",
                "“" : "ru_quote_opened",
                "!" : "ru_exclamation_mark",
                "?" : "ru_question_mark",
                ":" : "ru_colon",
                ";" : "ru_semicolon",
                "*" : "ru_asterisk",
              ]
        ]
            
        let settings: [Set: [Lan: String]] = [
          Set.Letter : [ Lan.En : "en_letter", Lan.Uz : "uz_letter", Lan.Ru : "ru_letter"],
          Set.Letter_no_sign : [Lan.En : "en_letter_no_sign", Lan.Uz : "uz_letter_no_sign", Lan.Ru : "ru_letter_no_sign" ],
          Set.Cannot_use_letter : [Lan.En : "en_cannot_use_letters", Lan.Uz : "uz_cannot_use_letters", Lan.Ru : "ru_cannot_use_letters" ],
          Set.Upper : [Lan.En : "en_upper", Lan.Uz : "uz_upper", Lan.Ru : "ru_upper" ],
          Set.Number : [Lan.En : "en_number", Lan.Uz : "uz_number", Lan.Ru : "ru_number" ],
          Set.Number_no_Sign : [Lan.En : "en_number_no_sign", Lan.Uz : "uz_number_no_sign", Lan.Ru : "ru_number_no_sign" ],
          Set.Delete : [Lan.En : "en_delete", Lan.Uz : "uz_delete", Lan.Ru : "ru_delete" ],
          Set.Language : [Lan.En : "en_lang", Lan.Uz : "uz_lang", Lan.Ru : "ru_lang" ],
        ]

    private weak var _heightConstraint: NSLayoutConstraint?

       override func viewWillAppear(_ animated: Bool)
       {
           super.viewWillAppear(animated)

           guard nil == _heightConstraint else { return }

           // We must add a subview with an `instrinsicContentSize` that uses autolayout to force the height constraint to be recognized.
           //
           let emptyView = UILabel(frame: .zero)
           emptyView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(emptyView);

           let heightConstraint = NSLayoutConstraint(item: view,
                                                     attribute: .height,
                                                      relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 0.0,
                                                     constant: 320)
           heightConstraint.priority = .required - 1
           view.addConstraint(heightConstraint)
           _heightConstraint = heightConstraint
       }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Add custom view sizing constraints here
    }


    @IBAction func onKey(key:UIButton ){

      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        var label = key.titleLabel?.text as! String;




        switch label {
        case "‹":
            setSound(url:  Bundle.main.url(forResource: "delete", withExtension: "mp3")!)
            (textDocumentProxy as UIKeyInput).deleteBackward()
            makeZero()
        case "1":
            setSound(url:  Bundle.main.url(forResource: wordSound[lanType]!["1"], withExtension: "mp3")!)
            index[0] = 1;
        case "2":
            setSound(url:  Bundle.main.url(forResource: wordSound[lanType]!["2"], withExtension: "mp3")!)
            index[1] = 2
        case "3":
            setSound(url:  Bundle.main.url(forResource: wordSound[lanType]!["3"], withExtension: "mp3")!)
            index[2] = 3
        case "4":
            setSound(url:  Bundle.main.url(forResource: wordSound[lanType]!["4"], withExtension: "mp3")!)
            index[3] = 4
        case "5":
            setSound(url:  Bundle.main.url(forResource: wordSound[lanType]!["5"], withExtension: "mp3")!)
            index[4] = 5
        case "6":
            setSound(url:  Bundle.main.url(forResource: wordSound[lanType]!["6"], withExtension: "mp3")!)
            index[5] = 6
        case "UZB","RUS","ENG":
            switch lanType {
            case .En:
                lanType = Lan.Uz
                key.setTitle("UZB", for: .normal);
               
                setSound(url:  Bundle.main.url(forResource: "uz_lang", withExtension: "mp3")!)
            case .Uz:
                lanType = Lan.Ru
                key.setTitle("RUS", for: .normal);
                setSound(url:  Bundle.main.url(forResource: "ru_lang", withExtension: "mp3")!)
            case .Ru:
                lanType = Lan.En
                key.setTitle("ENG", for: .normal);
                setSound(url:  Bundle.main.url(forResource: "en_lang", withExtension: "mp3")!)
            }
        case "a-z","A-Z","0-9":

            switch cases{
            case Cases.Latter:
                cases = Cases.Upper
                key.setTitle("A-Z", for: .normal);
                
                setSound(url:  Bundle.main.url(forResource: settings[Set.Upper]![lanType], withExtension: "mp3")!)
            case Cases.Upper:
                cases = Cases.Number
                key.setTitle("0-9", for: .normal);
        
                setSound(url:  Bundle.main.url(forResource: settings[Set.Number]![lanType], withExtension: "mp3")!)
            case Cases.Number :
                cases = Cases.Latter
                key.setTitle("a-z", for: .normal);
                setSound(url:  Bundle.main.url(forResource: settings[Set.Letter]![lanType], withExtension: "mp3")!)
            }
        case "›":
            var numbers: String = ""
            for num in 0...5  {
                if(index[num] == num+1) {
                    numbers += "1";
                } else {
                    numbers += "0";
                }
            }
            if(cases == Cases.Latter || cases == Cases.Upper) {
                // for fount signs add word + listen sound
                if(multilingualMap[numbers]![lanType] != "") {
                    var word = multilingualMap[numbers]![lanType]!
                    print(word)
                    // add upper case(A)
                    if(cases == Cases.Upper) {
                        (textDocumentProxy as UIKeyInput).insertText(word.uppercased())
                        // add lower case(a)
                    } else {
                        (textDocumentProxy as UIKeyInput).insertText(word)
                    }
                        // listen sign sound
                    if(wordSound[lanType]![word] != nil){
                        setSound(url:  Bundle.main.url(forResource: wordSound[lanType]![word], withExtension: "mp3")!)
                    }
                    // listen error(not found sign) sound
                } else {
                    setSound(url:  Bundle.main.url(forResource: settings[Set.Letter_no_sign]![lanType], withExtension: "mp3")!)
                }
            } else if(cases == Cases.Number) {
                var num = numberToNumber[numbers]!
                print(num)
                setSound(url:  Bundle.main.url(forResource: wordSound[lanType]![num], withExtension: "mp3")!)
                // add number
                if(num != "") {
                    (textDocumentProxy as UIKeyInput).insertText(num)
                    // listen error(can't use words) sound
                } else if(multilingualMap[numbers]![lanType] != "") {
                    setSound(url:  Bundle.main.url(forResource: settings[Set.Cannot_use_letter]![lanType], withExtension: "mp3")!)
                    // listen error(not found sign) sound
                } else {
                    setSound(url:  Bundle.main.url(forResource: settings[Set.Number_no_Sign]![lanType], withExtension: "mp3")!)
                }
            }
            makeZero();
        default:
            (textDocumentProxy as UIKeyInput).insertText(label)
        }
    }
    
    func makeZero(){
        index = [0,0,0,0,0,0]
    }





                        override func viewDidLoad() {
                            super.viewDidLoad()





                            let nib = UINib(nibName: "KeyBoardView", bundle: nil);

                            let views = nib.instantiate(withOwner: self, options: nil)



                            view = views[0] as! UIView

                            // Perform custom UI setup here
                            self.nextKeyboardButton = UIButton(type: .system)

                            self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
                            self.nextKeyboardButton.sizeToFit()


                            self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false

                            self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

                    //        self.view.addSubview(self.nextKeyboardButton)

                            self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = false
                            self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = false
                        }

                        override func viewWillLayoutSubviews() {
                    //        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
                            super.viewWillLayoutSubviews()
                        }

                        override func textWillChange(_ textInput: UITextInput?) {
                            // The app is about to change the document's contents. Perform any preparation here.
                        }

                        override func textDidChange(_ textInput: UITextInput?) {
                            // The app has just changed the document's contents, the document context has been updated.

                            var textColor: UIColor
                            let proxy = self.textDocumentProxy
                            if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
                                textColor = UIColor.white
                            } else {
                                textColor = UIColor.black
                            }
                            self.nextKeyboardButton.setTitleColor(textColor, for: [])
                        }



                        func setSound(url: URL){




                               do {
                                   try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                                   try AVAudioSession.sharedInstance().setActive(true)

                                   /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                                   player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                                   /* iOS 10 and earlier require the following line:
                                                  player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AV
                                   Jamshid ####, [19.05.2022 15:27]
                                   FileTypeMPEGLayer3) */

                                                  guard let player = player else { return }

                                                  player.play()

                                              } catch let error {
                                                  print(error.localizedDescription)
                                              }

                                       }


                                   }

enum Cases {
case Number, Latter, Upper
}

enum Lan {
case En, Uz, Ru
}

enum Set {
case Number, Letter, Upper, Delete, Number_no_Sign, Cannot_use_letter, Letter_no_sign, Language
}
