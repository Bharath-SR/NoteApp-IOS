import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ContainerController : UIViewController{

    //MARK: - Properties

    var menuController: MenuController!
    var centerController : UIViewController!
    var isExpanded = false
    let db = Firestore.firestore()
    var notesArray = [Note]()
    var isDeleted : Bool = false
    var collectionView : UICollectionView!

    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureHomeController()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    //MARK: - Handlers
    
    func configureHomeController(){
        let homeController = HomeController()
       
        homeController.delegate = self
       
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController(){
        if menuController ==  nil {
            //add our menu controller here
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func animatePanel(shouldExpand : Bool,menuOption:MenuOption?){
        if shouldExpand{
            //show menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut , animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80

            }, completion: nil)

            
        }else{
            //hide menu
        
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else {return}
                self.didSelectMenuOption(menuOption:menuOption)
            }
        }
        
        animatedStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption){
        switch menuOption {
        
        case .Inbox:
            print("Show Inbox")
            
        case .Notification:
            print("Show Notification")

        case .Trash:
            print("Show Trash")
//            let deletedVC = DeletedNotes()
//            self.view.window?.rootViewController = deletedVC
//            self.view.window?.makeKeyAndVisible()
            let deletedVC = DeletedNotes()
            present(UINavigationController(rootViewController: deletedVC), animated: true, completion: nil)
            
        case .Logout:
            
            try! Auth.auth().signOut()
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let Mainvc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                               
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                fatalError("could not get scene delegate ")
            }
            sceneDelegate.window?.rootViewController = Mainvc
            
        }
    }

    
    func animatedStatusBar(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut , animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)

    }
}

extension ContainerController : HomeControllerDelegate{
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded{
            configureMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }  
}
