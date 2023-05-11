
import UIKit
import FirebaseFirestore

var isAdded : Bool = false

class HomeController : UIViewController{
    
    var isLoadingNotes: Bool = false
    
    var collectionView : UICollectionView!
    
    let db = Firestore.firestore()
    var notesArray = [Note]()
    var filterData = [Note]()
    var searching = false
    var gridview = true
    var delegate : HomeControllerDelegate?
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = UIColor.colorFromHex("#8F3B76")
        let image = UIImage(systemName: "plus" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerBar()
        configureCollectionView()
        fetchNotes()
        actionFloatingButton()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 100, y: view.frame.size.height - 100, width: 60, height: 60)
    }
    
    func actionFloatingButton(){
        floatingButton.addTarget(self, action: #selector(goToAddNoteController), for: .touchUpInside)
    }
    

    func configureCollectionView(){
        if let collectionView = collectionView {
            collectionView.removeFromSuperview()
        }
        let layout = UICollectionViewFlowLayout()
       
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else{
            return
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.colorFromHex("#C7417B")
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
        view.addSubview(collectionView)
        print("subView count ",view.subviews.count)
        collectionView.frame = view.bounds
        view.addSubview(floatingButton)
   }
    
    func configureListView(){
        if let collectionView = collectionView{
            collectionView.removeFromSuperview()
        }
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: configuration)
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    guard let collectionView = collectionView else{
        return
    }
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.colorFromHex("#8F3B76")
    collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
    view.addSubview(collectionView)
        collectionView.frame = view.bounds
        view.addSubview(floatingButton)
        
    }
  
    @objc func goToAddNoteController(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let addNoteVC = storyboard.instantiateViewController(identifier: "AddNoteViewController") as! AddNoteViewController
        navigationController?.pushViewController(addNoteVC, animated: true)
        
    }
    
    @objc func gridView(){
        gridview.toggle()
        collectionView.reloadData()
    }
    
    @objc func handleMenuToggle(){
            delegate?.handleMenuToggle(forMenuOption: nil)
    
        }
  
    func navigationControllerBar(){
        navigationController?.navigationBar.barTintColor = UIColor.colorFromHex("#C7417B")
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image : UIImage.init(systemName: "line.horizontal.3") , style: .plain, target: self, action: #selector(handleMenuToggle))
                navigationItem.leftBarButtonItem?.tintColor = .black
        
        //search bar
        
        let searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "circle.grid.2x2"), style: .plain, target: self, action: #selector(gridView) )
        navigationItem.rightBarButtonItem?.tintColor = .black
        
   }
    var lastDocument: QueryDocumentSnapshot?
    
    func fetchExtraNotes(){
        print ("fetch extra notes")
        guard !isLoadingNotes else {
            print("executing fetchmoreNotes")
            return
        }
        guard let lastDocument = lastDocument else {
            print("executing lastDocument")
            return
        }
        
        self.isLoadingNotes = true
            self.db.collection("notes").order(by: "id", descending: true).limit(to: 10).start(afterDocument: lastDocument).getDocuments { snapShot, error in
                
                if error != nil{
                    print("error occured")
                    return
                }
                
                guard let snapShot = snapShot else {return}
                
                print("snapshot doc ", snapShot.documents)
                
                snapShot.documents.forEach { document in
                    let dataDictionary = document.data()
                    let title = dataDictionary["title"] as? String ?? ""
                    let description = dataDictionary["description"] as? String ?? ""
                    let id = document.documentID
                    let note = Note(title: title, description: description, id: id)
                    let isDeleted = dataDictionary["isDeleted"] as? Bool ?? false
                    guard !isDeleted else {
                        return
                    }
                    self.notesArray.append(note)
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.collectionView.reloadData()
                    
                }
                self.lastDocument = snapShot.documents.last
                
                self.isLoadingNotes = false
                
            }
    }

    func fetchNotes(){
        
        db.collection("notes").order(by: "id", descending: true).limit(to: 20).addSnapshotListener { [weak self] querySnapshot, error in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            guard let self = self else {
                print("self is nil")
                return }
            guard let snapShot = querySnapshot else {
                print("querySnapshot")
                return
            }
            
            self.lastDocument = snapShot.documents.last
            snapShot.documentChanges.forEach { change in
                
                let type = change.type
                let document = change.document
                let dataDictionary = document.data()
                let title = dataDictionary["title"] as? String ?? ""
                let description = dataDictionary["description"] as? String ?? ""
                let id = document.documentID
                let note = Note(title: title, description: description, id: id)
                let isDeleted = dataDictionary["isDeleted"] as? Bool ?? false
                
                switch type{
                    
                case .added:
                    
                    guard !isDeleted else {
                        return
                    }
                    if isAdded {
                        self.notesArray.insert(note, at: 0)
                        
                    }
                    else{
                        
                        self.notesArray.append(note)
                        
                    }
                    
                    
                case .modified:
                    
                    guard let foundNoteIndex = self.notesArray.firstIndex(where: { note in
                        note.id == id
                    }) else{return}
                    
                    self.notesArray.remove(at: foundNoteIndex)
                    
                    if !isDeleted {
                        self.notesArray.insert(note, at: foundNoteIndex)
                        
                    }
                case .removed:

                    print("removed")
                    let id = document.documentID

                    guard let foundNoteIndex = self.notesArray.firstIndex(where: { note in
                        note.id == id
                    }) else{return}

                    self.notesArray.remove(at: foundNoteIndex)
                    
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

