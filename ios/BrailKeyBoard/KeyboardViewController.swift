
import UIKit
import AVFoundation
import AudioToolbox

//complate
class KeyboardViewController: UIInputViewController {
    
    var player:AVAudioPlayer?
    var cases: Cases = Cases.Latter

    @IBOutlet var nextKeyboardButton: UIButton!
    
    
   
     
    var index:[Int] = [0,0,0,0,0,0]
    
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
        
        var label = key.titleLabel?.text as! String
        
      
        
        
        switch label {
        case "‹":
            setSound(url:  Bundle.main.url(forResource: "delete", withExtension: "mp3")!)
            (textDocumentProxy as UIKeyInput).deleteBackward()
            makeZero()
        case "1":
            setSound(url:  Bundle.main.url(forResource: "one", withExtension: "mp3")!)
            index[0] = 1;
        case "2":
            setSound(url:  Bundle.main.url(forResource: "2", withExtension: "mp3")!)
            index[1] = 2
        case "3":
            setSound(url:  Bundle.main.url(forResource: "tree", withExtension: "mp3")!)
            index[2] = 3
        case "4":
            setSound(url:  Bundle.main.url(forResource: "fo", withExtension: "mp3")!)
            index[3] = 4
        case "5":
            setSound(url:  Bundle.main.url(forResource: "five", withExtension: "mp3")!)
            index[4] = 5
        case "6":
            setSound(url:  Bundle.main.url(forResource: "six", withExtension: "mp3")!)
            index[5] = 6
        case "UZB":
            cases = Cases.Number
            setSound(url:  Bundle.main.url(forResource: "number", withExtension: "mp3")!)
        case "a-z":
            
            switch cases{
            case Cases.Latter:
                cases = Cases.Upper
                setSound(url:  Bundle.main.url(forResource: "upper", withExtension: "mp3")!)
            case Cases.Upper:
                cases = Cases.Latter
                setSound(url:  Bundle.main.url(forResource: "latter", withExtension: "mp3")!)
            default :
                cases = Cases.Latter
                setSound(url:  Bundle.main.url(forResource: "latter", withExtension: "mp3")!)
                
            }
           
        case "›":
            switch index {
            case [1,0,0,0,0,0]:
                if cases == Cases.Latter{
                    setSound(url:  Bundle.main.url(forResource: "a", withExtension: "mp3")!)
                    (textDocumentProxy as UIKeyInput).insertText("a")
                }else if cases == Cases.Number{
                    setSound(url:  Bundle.main.url(forResource: "one", withExtension: "mp3")!)
                    (textDocumentProxy as UIKeyInput).insertText("1")
                                    }else{

                  
                    setSound(url:  Bundle.main.url(forResource: "a", withExtension: "mp3")!)
                                        (textDocumentProxy as UIKeyInput).insertText("A")
                                    }
                                    
                                    
                                case [0,0,0,0,0,0]:
                                    setSound(url:  Bundle.main.url(forResource: "space", withExtension: "mp3")!)
                                    (textDocumentProxy as UIKeyInput).insertText(" ")
                                case [1,2,0,0,0,0]:
                                    if cases == Cases.Latter{
                                        setSound(url:  Bundle.main.url(forResource: "a", withExtension: "mp3")!)
                                        (textDocumentProxy as UIKeyInput).insertText("a")
                                    }else if cases == Cases.Number{
                                        setSound(url:  Bundle.main.url(forResource: "2", withExtension: "mp3")!)
                                        (textDocumentProxy as UIKeyInput).insertText("2")
                                    }else{
                                        setSound(url:  Bundle.main.url(forResource: "a", withExtension: "mp3")!)
                                        (textDocumentProxy as UIKeyInput).insertText("B")
                                    }
                                    
                                   
                                default:
                                    (textDocumentProxy as UIKeyInput).insertText("\(index)")
                                }
                                
                                
                                makeZero();
                                
                                
                                
                                
                                
                                
                            default:
                                (textDocumentProxy as UIKeyInput).insertText(label)
                            }
                            
                            
                             
                            
                             
                        }
                        
                        
                        func makeZero(){
                            index = [0,0,0,0,0,0];
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
