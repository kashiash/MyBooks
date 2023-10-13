# My Books

oryginalne video :

https://www.youtube.com/watch?v=CAr_1kcf2_c&t=4s



Aplikacja korzystająca z Swift Data. W pierwszym zestawie trzech filmów będziemy tworzyć aplikację do śledzenia książek, które albo umieściliśmy na półce, albo aktualnie czytamy, albo już przeczytaliśmy. Ten film będzie najdłuższy w tej serii, wprowadzę was do operacji CRUD, czyli tworzenia, odczytu, aktualizacji i usuwania rekordów, oraz jak je trwale przechowywać w bazie danych SQLite na urządzeniu. W kolejnych sekcjach po tym filmie rozwiniemy tę aplikację i przedstawię wam relacje, takie jak relacje jeden-do-wielu oraz wiele-do-wielu. Będziemy nawet zagłębiać się w lokalizację i CloudKit.  Chcemy stworzyć aplikację na iPhone'a, która pozwoli nam dodawać i śledzić książki, które zdobyliśmy i które czekają na przeczytanie, są w trakcie czytania lub zostały już przeczytane. Możemy także chcieć dodać podsumowanie książki lub nawet ocenę. Zaczynajmy więc od utworzenia nowej aplikacji teraz w Xcode i nazwiemy ją "Moje Książki". Moglibyśmy wybrać SwiftData jako opcję przechowywania danych, ale to spowodowałoby konieczność zmiany wielu podstawowych fragmentów kodu, a poza tym z SwiftData bardzo łatwo ręcznie tworzyć nasze modele danych i przechowywać je. 

## Books model

Zaczniemy od utworzenia modelu dla naszej książki. Kiedy tworzę nowy wpis, chcę po prostu dodać tytuł i autora, dlatego ustalimy domyślne wartości dla pozostałych właściwości, ale o tym jeszcze porozmawiam. Zacznijmy więc od utworzenia pliku Swift o nazwie "Book". Wewnątrz utworzymy klasę o nazwie "Book" i dodamy kilka właściwości. Będziemy potrzebowali tytułu i autora, oba będą typu String. Chcę śledzić datę dodania książki, datę rozpoczęcia jej czytania i datę jej zakończenia.

Wszystkie te właściwości będą typu daty, i możesz pomyśleć, że właściwości `started` i `completed` powinny być opcjonalne. Ale uważam, że ponieważ zamierzam użyć pickera, łatwiej jest ustawić wartość domyślną, o czym niedługo zobaczysz. Dla podsumowania stworzę właściwość typu String, a dla oceny utworzę opcjonalną wartość całkowitą (`Int`). 

```swift
class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var summary: String
    var rating: Int?
}
```



Aby śledzić status naszej książki, stworzę enuma dla tej właściwości i nazwę go `status`. Utworzę go tutaj, w tym samym pliku. Zdefiniuję go jako Int, ale dla Swift Data musimy upewnić się, że jest Codable. Chcę również używać go w pickerze, więc musi być identyfikowalny (`Identifiable`). Jeśli użyję case iterable, będę mógł iterować przez wszystkie różne przypadki. Trzy przypadki, które chcę obejmować, to `onShelf`, `inProgress` i `completed`.

```swift
enum Status: Int, Codable, Identifiable, CaseIterable {
  case onShelf,inProgress, completed
}
```

 Aby spełnić protokół `Identifiable`, mogę utworzyć obliczoną właściwość `id` typu `Self`, która po prostu zwróci `self`. 

```swift
    var id: Self {
        self
    }
```

Teraz picker będzie potrzebować pewnego tekstu do wyświetlenia dla każdego przypadku. Utworzę więc kolejną obliczoną właściwość, którą nazwę `description` , która będzie typu String. Użyję instrukcji switch na `self` i dla każdego przypadku zwrócę tekstową reprezentację tego przypadku. Tak więc OnShelf, InProgress lub Completed. Teraz mogę dodać właściwość `status` do naszej klasy, która będzie miała ten typ `status`. 

```swift
    var description: String {
        switch self {

        case .onShelf:
            "On Shelf"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }
```

Następnie, ponieważ używam klasy, będę potrzebować inicjalizatora. Pozwól, że zaznaczę parametry 

```swift
    init(
        title: String,
        author: String,
        dateAdded: Date,
        dateStarted: Date,
        dateCompleted: Date,
        summary: String,
        rating: Int? = nil,
        status: Status
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.summary = summary
        self.rating = rating
        self.status = status
    }
```

naszego inicjalizatora i użyję skrótu Ctrl+M wprowadzonego w Xcode 15, aby rozdzielić je na wiele linii. 





Jak wspomniałem, jedynym, co będę wymagać, to podanie tytułu książki i autora. Oznacza to, że będę musiał dostarczyć domyślne wartości dla każdej innej właściwości.

Data dodania zostanie przypisana jako aktualna data (`Date()` lub `Date.now`). Ponownie, zamiast sprawiać, że `dateStarted` i `dateCompleted` będą opcjonalne i trzeba będzie sprawdzać to ręcznie, użyję statycznego `date.distantPastDate`, ponieważ książka jeszcze nie została zaczęta lub zakończona. Dla podsumowania użyję pustego ciągu znaków (`""`), a ocena domyślnie będzie `nil`. Status książki zostanie ustawiony na "onShelf" (na półce), gdy książka zostanie dodana.

```swift
    init(
        title: String,
        author: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantPast,
        summary: String = "",
        rating: Int? = nil,
        status: Status = .onShelf
    ) {
        ...
    }
```

Teraz, aby nasz model stał się obiektem Swift Data, musimy zaimportować Swift Data i oznaczyć naszą klasę makrem `@Model`. 

```swift
import Foundation
import SwiftData

@Model
class Book { 
  ...
}
```

W ten sposób, podczas tworzenia nowej książki, będziemy musieli podać tylko nazwę i autora, a domyślne wartości zostaną ustawione dla pozostałych właściwości. 

Całość:

```swift
import Foundation
import SwiftData
import SwiftUI

@Model
class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var summary: String
    var rating: Int?
    var status: Status

    init(
        title: String,
        author: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantPast,
        summary: String = "",
        rating: Int? = nil,
        status: Status = .onShelf
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.summary = summary
        self.rating = rating
        self.status = status
    }
    
}
enum Status: Int, Codable, Identifiable, CaseIterable {
  case onShelf,inProgress, completed
    var id: Self {
        self
    }
    var description: String {
        switch self {

        case .onShelf:
            "On Shelf"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }
}
```



Teraz, gdy mamy nasz model, musimy, gdy aplikacja zostanie uruchomiona, utworzyć dla niego kontener, aby można było zachować dane. Z pomocą Swift Data jest to niezwykle łatwe. Podczas uruchamiania naszej aplikacji, możemy zastosować metodę Swift Data do naszej grupy okien. Importuję Swift Data i teraz mamy dostęp do metody `modelContainer`. Jedynym wymogiem jest podanie typu modelu, który chcemy przechowywać jako trwały. Dla naszego przypadku, naszym modelem jest nasza książka, więc używamy `.self`. 

```swift
import SwiftUI
import SwiftData

@main
struct MyBooksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }

}
```

Zawsze lubię sprawdzić, gdzie są przechowywane dane backendowe. Odkryłem, że podobnie jak Core Data, Swift Data domyślnie przechowuje dane w katalogu application support dla naszej aplikacji w symulatorze. Chcę więc utworzyć inicjalizator dla naszej aplikacji, który zostanie wywołany podczas jej uruchamiania, a następnie wydrukować ścieżkę do tego miejsca. Ponieważ katalog application support w Finderze zawiera więcej niż jedno słowo, chcę usunąć znaki procentowe (`%20s`), które będą generowane dla każdej spacji, ustawiając `percentEncoded` na `false`.

```swift
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
```



Pozwólcie, że teraz uruchomię tę aplikację i wyświetlę konsolę po uruchomieniu. Widzę, że ścieżka jest wydrukowana w konsoli. 

```swift
/Users/uta/Library/Developer/CoreSimulator/Devices/65D28238-47E9-40BE-8185-EB5A26699637/data/Containers/Data/Application/442223B0-C445-493F-BC5A-AEE8A2BC8B81/Library/Application Support/
```

Wybiorę teraz tę ścieżkę, kliknę prawym przyciskiem myszy i z menu Usługi wybiorę opcję "Otwórz lokalizację", aby wyświetlić trzy pliki, tak jak w przypadku Core Data. Pierwszy plik to default.store, to plik SQLite, który chcę przejrzeć za pomocą edytora SQLite. Możecie użyć dowolnego edytora, który wam odpowiada, ale znalazłem ten darmowy, który może być dobrym wyborem na początek.

https://sqlitebrowser.org/dl/

można go zainstalować  za pomocą brew: 

```swift
brew install --cask db-browser-for-sqlite
```

Teraz, jeśli kliknę prawym przyciskiem myszy na ten plik i otworzę go w aplikacji, zauważycie, że podobnie jak w Core Data w tej bazie danych jest wiele tabel wsparcia. Ale jest jedna dla naszego modelu książki. Nie martwcie się o literę Z na początku - to jest coś związane z Core Data i Swift Data. Teraz, jeśli wybierzecie Przeglądaj dane i wybierzecie tabelę, którą chcemy zobaczyć, czyli naszą tabelę książek, zobaczycie, że są tam kolumny dla wszystkich naszych właściwości. 

![image-20231011145312090](image-20231011145312090.png)

## Operacje CRUD

## NewBookView czyli Create  

Na razie nie utworzyliśmy jeszcze żadnych książek, ale wrócimy do tego, gdy to zrobimy. Pierwsza litera w skrócie CRUD oznacza C, co oznacza Create (Utwórz). Zobaczmy więc, jak możemy tworzyć nowe książki i przechowywać je w naszej bazie danych. Teraz zmienię nazwę widoku  `ContentView` na `BookListView`. Umieszczę obecnie ten widok w nawigacyjnym stosie i dodam tytuł nawigacji "Moje Książki". Następnie utworzę pasek narzędzi i będę miał na nim tylko jeden przycisk.

W ramach tego paska narzędziowego mogę utworzyć przycisk, na razie pomijając akcję. Ale jako etykietę chcę utworzyć obrazek, używając systemowego symbolu `plus.circle.fill`. Następnie ustawiam skalę obrazka na dużą (`large`). 

```swift
struct BookListView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ...
            }
            .padding()
            .navigationTitle("Moje książki")
            .toolbar{
                Button {

                } label : {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}
```



Chcę móc wyświetlić arkusz na dole, który zapyta o nazwę i autora książki. Dlatego utworzę nowy plik, który nazwę `NewBookView`. Będzie to widok SwiftUI. Dodam dwie właściwości stanu, jedną dla tytułu i drugą dla autora, obie domyślnie ustawione na puste ciągi znaków. Ponieważ będę go prezentować jako modalny arkusz, aby go zamknąć, dodam zmienną środowiskową dla wartości klucza `dismiss` i utworzę ją jako `dismiss`. 

```swift
struct NewBookView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
    var body: some View {
        ...
    }
}
```

Zbudujmy teraz ten widok, zastępując zawartość `body` nawigacyjnym stosem, a wewnątrz tego stosu utworzymy formularz. Wewnątrz formularza utworzę dwa pola tekstowe. Pierwsze będzie polem tekstowym z napisem "Tytuł książki", związane z naszą właściwością stanu `title`. Zrobię to samo dla drugiego, które będzie naszym polem na autora, związanym z właściwością stanu `author`. Poniżej dodam kolejny przycisk z etykietą "Zapisz", a jako akcję na razie będę wywoływać "Dismiss". Ustawiam ramkę tak, aby współgrała z brzegiem od strony prawej, mogę to zrobić, określając maksymalną szerokość na nieskończoność z wyjustowaniem do prawego brzegu. Aby się wyróżniał, nadam przyciskowi styl graniczy wyraźnie (`borderedProminent`). Dodam też nieco wypełnienia pionowego. Nie chcę również, aby użytkownik mógł nacisnąć przycisk, dopóki nie wpisze zarówno tytułu, jak i autora. Mogę więc go wyłączyć, jeśli albo tytuł, albo autor jest pusty. Następnie dodam nawigacyjny tytuł z napisem "Nowa Książka" i ustawiam tryb wyświetlania tytułu na "Inline". 

```swift
        NavigationStack{
            Form{
                TextField("Tytuł ksiązki",text: $title)
                TextField("Autor",text: $author)
                Button("Zapisz") {
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty || author.isEmpty)
                .navigationTitle("Nowa książka")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
```



Swift Data przechowuje wszystkie dane w pamięci, a informacje nie są przechowywane w bazie danych, chyba że jest to konieczne - na przykład podczas tworzenia, aktualizacji lub usuwania rekordów. Te operacje są zarządzane przez główny kontekst kontenera.

Gdy utworzyliśmy nasz kontener, został utworzony kontekst i umieszczony w środowisku, gdzie mogę uzyskać do niego dostęp za pomocą ścieżki klucza modelu (`modelContextKeyPath`). Pozwólcie mi teraz utworzyć zmienną o nazwie `context` z tego klucza środowiskowego. 

```swift
struct NewBookView: View {
    @Environment(\.modelContext) private var context
  ...
}
```

Aby utworzyć nową książkę w akcji "Utwórz", możemy utworzyć tę książkę, przekazując tytuł i autora z naszych pól tekstowych w stanie. Następnie mogę po prostu wywołać metodę `context.insert`, przekazując do niej tę książkę, a potem oczywiście zamkniemy arkusz. 

```swift
                Button("Zapisz") {
                    let newBook = Book(title: title, author: author)
                    context.insert(newBook)
                    dismiss()
                }
```

Wróćmy teraz do widoku listy książek `BookListView`. Tutaj będziemy musieli wyświetlić arkusz po naciśnięciu przycisku paska narzędziowego. Stworzymy zatem stanową właściwość typu boolowskiego, którą nazwę `createNewBook` i zainicjalizuję jako `false`. Po pasku narzędziowym utworzę arkusz, który będzie związany z właściwością stanu `isPresented` (czyli `createNewBook`). Użyję tutaj domknięcia związującego. Posprzątam to trochę. Następnie jako zawartość wyświetlę widok `NewBookView`. Nie chcę, żeby był pełnoekranowy, więc ustawiam sposób wyświetlania na `medium` w tablicy detent. Aby wyświetlić widok, będziemy musieli ustawić wartość `createNewBook` na `true` w akcji przycisku paska narzędziowego. 

```swift
struct BookListView: View {
    @State  private var createNewBook = false
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .navigationTitle("Moje książki")
            .toolbar{
                Button {
                    createNewBook = true
                } label : {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
            .sheet(isPresented: $createNewBook) {
                NewBookView()
                    .presentationDetents([.medium])
            }
        }
    }
}
```

Teraz uruchommy aplikację w symulatorze i stwórzmy nową książkę. Musisz podać tytuł i autora. Możesz utworzyć wpis dla prawdziwej książki lub wymyślić jakąś, jak ja robię teraz. Zatrzymajmy teraz aplikację i otwórzmy ponownie nasz edytor SQL, aby zobaczyć, co mamy. Tym razem uzyje lubiane przeze mnie DataGrip:

![image-20231011184751985](image-20231011184751985.png)

nastepnie przechodzimy do nowo dodanej gaqlezi w database explorer, wybieramy ZBOOK, następnie tabelę książek:

![image-20231011185449831](image-20231011185449831.png)

 Zauważ, że wartości zostały wprowadzone dla wszystkich pól oprócz oceny, która jest ustawiona na `null`, ponieważ była opcjonalna. Wydaje się, że pole podsumowania jest puste, ale jest to pusty ciąg znaków. Teraz, aby mieć coś do pracy w naszym następnym etapie, stwórzmy kilka kolejnych wpisów w aplikacji. 



Jeszcze jedno, co chcę zrobić, to w moim widoku `NewBookView` dodać przycisk "Anuluj", aby zamknąć widok, jeśli nie chcemy tworzyć nowej książki, gdy wyświetlimy ten arkusz. Potrzebuję paska narzędziowego, a ten przycisk chcę umieścić z przodu, więc będę musiał utworzyć element paska narzędziowego i ustawić jego umiejscowienie na `topBarLeading`. Wewnątrz niego po prostu utworzę przycisk z etykietą "Anuluj", a jako akcję po prostu wywołam funkcję `dismiss`. 

```swift
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Anuluj") {
                            dismiss()
                        }
                    }
                }
```



Całość kodu `NewBokView` :

```swift
struct NewBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
    var body: some View {
        NavigationStack{
            Form{
                TextField("Tytuł ksiązki",text: $title)
                TextField("Autor",text: $author)
                Button("Zapisz") {
                    let newBook = Book(title: title, author: author)
                    context.insert(newBook)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty || author.isEmpty)
                .navigationTitle("Nowa książka")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Anuluj") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
```

wariant alternatywny przycisk anuluj mozna dac obok przycisku zapisz osadzajac oba w HStack i przenoszac modyfikatory przycisku zapisz bezposrednio do niego:

```swift
HStack{
  Button("Anuluj") {

    dismiss()
  }
  .frame(maxWidth: .infinity, alignment: .leading)
  .buttonStyle(.bordered)

  Button("Zapisz") {
    let newBook = Book(title: title, author: author)
    context.insert(newBook)
    dismiss()
  }
  .frame(maxWidth: .infinity, alignment: .trailing)
  .buttonStyle(.borderedProminent)
  .padding(.vertical)
  .disabled(title.isEmpty || author.isEmpty)
}
```



## BookListView czyli Read  

Teraz, gdy mamy już jakieś wpisy, będziemy musieli je wyświetlić, co odpowiada literze R w akronimie CRUD. Będziemy prezentować te elementy w liście. Domyślnie tablice obiektów modelu trwałego spełniają protokół `Identifiable`. Każdy rekord w tabeli książek ma unikalne ID obiektu, o którym dowiemy się trochę później. Najpierw będziemy musieli uzyskać dostęp do wszystkich rekordów. Można to zrobić za pomocą nowego makra `query`, które jest częścią Swift Data. Obserwuje ono zmiany i odświeża widok za każdym razem, gdy wystąpią nowe zmiany. Najpierw będziemy musieli zaimportować SwiftData.

Następnie możemy użyć makra, które może przyjąć porządek sortowania i opcję filtrowania. Na razie pomińmy filtr i pobierzmy wszystkie nasze obiekty, ale ustawmy domyślny porządek sortowania jako rosnący i określmy właściwość, według której chcemy sortować, używając ścieżki klucza. Później będziemy patrzeć na sortowanie według wielu właściwości, używając tablicy deskryptorów sortowania, ale na razie użyjemy tylko ścieżki klucza i przypiszemy to do prywatnej zmiennej o nazwie `books`. `books` będzie tablicą obiektów typu `Book`.

```swift
@Query(sort: \Book.title) private var books: [Book]
```

Teraz możemy zastąpić naszego `VStack` listą, ale chcemy móc używać funkcji `onDelete` na elementach naszej listy. Musimy więc użyć pętli `forEach` wewnątrz listy. W tej liście chcę stworzyć link nawigacyjny, który zabierze mnie w końcu do ekranu szczegółowego, gdzie będę mógł przeglądać i / lub edytować pozostałe właściwości. Ale na razie utwórzmy link nawigacyjny, który zabierze mnie do widoku tekstu, który wyświetli tytuł książki. Dla etykiety będę chciał wyświetlić tytuł i autora, a także ikonę reprezentującą status książki. Jeśli jest ocena, chcę również wyświetlić odpowiednią liczbę gwiazdek reprezentujących tę ocenę. Ustawmy także styl listy na zwykłą listę (`plain list`).

```swift
List {
  ForEach(books) { book in
                  NavigationLink{

                  } label: {

                  }
                 }

}
.listStyle(.plain )
```

Teraz, jeśli chcemy móc używać podglądu, będziemy musieli dodać kontener modelu do naszego widoku listy książek również w podglądzie. Ale nie chcemy przechowywać danych w naszym podglądzie, chcemy je trzymać tylko w pamięci i nie zapisywać ich trwale. Oczywiście moglibyśmy to zrobić, ale później może to stworzyć pewne problemy. W teście zaczynamy tak samo jak w sekcji `@Main`, ale tym razem dodamy dodatkowy argument `inMemory` i ustawimy go na `true`. 

```swift
#Preview {
    BookListView()
        .modelContainer(for: Book.self, inMemory: true)
}
```

Teraz wróćmy do naszego modelu książki i stworzymy właściwość obliczeniową, która będzie reprezentować inną ikonę dla statusu naszej książki. Właściwości obliczeniowe nie są przechowywane w bazie danych SQLite, więc nasza struktura nie będzie się zmieniać. Możemy utworzyć tę zmienną i nazwę ją "icon", a będzie to obrazek. Teraz `Image` jest dostępne tylko w SwiftUI, więc będziemy musieli zaimportować SwiftUI zamiast Foundation. Teraz możemy przełączyć się na ten status i utworzyć odpowiednie obrazy. Oto te, które zamierzam użyć: dla `onShelf` będzie to obrazek używający systemowego symbolu "checkmark.diamond.fill", dla `inProgress` użyję "book.fill", a dla `completed` użyję "books.vertical.fill". 

```swift
var icon: Image {
  switch status {

    case .onShelf:
    Image(systemName: "checkmark.diamond.fill")
    case .inProgress:
    Image(systemName: "book.fill")
    case .completed:
    Image(systemName: "books.vertical.fill")
  }
}
```



Wróćmy teraz do naszego widoku listy książek i utwórzmy etykietę dla naszego linku nawigacyjnego. Zacznę od `HStack` z odstępem 10. A pierwszym elementem w tym `HStack` będzie obrazek ikony książki. Po prawej stronie tego umieszczę pionowy stos (`VStack`) z wyrównaniem do lewej. Pierwszy wiersz będzie zawierał pole tekstowe wyświetlające tytuł. Następnie ustawię czcionkę na tytułową o rozmiarze 2. Poniżej tego kolejny wiersz będzie kolejnym polem tekstowym, ale tym razem wyświetlającym autora książki. Zmienię również styl koloru tekstu na drugoplanowy (`secondary`). 

```swift
HStack(spacing: 10) {
  book.icon
  VStack(alignment: .leading) {
    Text(book.title)
    .font(.title2)
    Text(book.author)
    .foregroundStyle(.secondary)
  }
}
```

Ponieważ nie wszystkie książki mają ocenę, użyję instrukcji `if let` do obsłużenia  oceny książki. A jeśli istnieje, mogę utworzyć kolejny stos horyzontalny (`HStack`), który przeiteruje od 0 do samej oceny i ustawienie ID jako `self`. Wewnątrz tej pętli mogę utworzyć obrazek za pomocą systemowego obrazka gwiazdki wypełnionej (`star.fill`). Ustawię skalę obrazka na małą (`small`) i zmienię styl koloru tekstu na żółty.

```swift
if let rating = book.rating {
  HStack {
    ForEach(0..<rating, id:\.self) { _ in
                                    Image(systemName: "star.fill")
                                    .imageScale(.small)
                                    .foregroundStyle(.yellow)
                                   }
  }
}
```

Teraz uruchommy to na naszym symulatorze i zobaczmy, co się stanie. Zobaczymy wszystkie trzy książki, które utworzyliśmy. Żadna z nich nie ma oceny, a wszystkie ikony są dla statusu "on shelf", ponieważ taki był domyślny podczas ich tworzenia. Zatrzymajmy teraz aplikację. Otworzę bazę danych w moim edytorze SQL i chcę edytować niektóre właściwości. Przejdźmy do przeglądania danych naszej tabeli książek. Mogę na przykład zaktualizować dwa z naszych statusów. Dla statusu 2, który oznacza "completed", nadam ocenę 4. Zamknijmy bazę danych i uruchommy ponownie. Widzimy, że nasze aktualizacje zostały zastosowane. Mamy różne ikony dla różnych statusów, i widzimy ocenę.

<img src="image-20231011212137465.png" alt="image-20231011212137465" style="zoom:50%;" />

Możemy także przetestować to w podglądzie. W podglądzie mogę utworzyć nowy element. Jednak jeśli zaktualizuję kod lub przejdę do widoku wybierania w podglądzie, a potem z powrotem, ten element zniknie, ponieważ nie zapisujemy danych trwale. Teraz, gdy nie ma książek na liście, powinniśmy poinformować naszych użytkowników, żeby stworzyli swoją pierwszą książkę.  Sprawdźmy, czy tablica `Books` jest pusta. Jeśli tak, wyświetlmy widok `ContentUnavailable` z tekstem "Wprowadź swoją pierwszą książkę". Użyję także systemowego obrazka książki (`book.fill`).

```swift
if books.isEmpty {
    ContentUnavailableView("Wprowadź pierwszą książkę", systemImage: "book.fill")
}
```

 Jeśli nie jest pusta, utworzymy klauzulę `else` i wyświetlimy istniejącą  listę książek. 

```swift
if books.isEmpty {
  ContentUnavailableView("Wprowadź pierwszą książkę", systemImage: "book.fill")
} else {
  List {...}
  .navigationTitle("Moje książki")
  .toolbar{...}
  .listStyle(.plain )
  .sheet(isPresented: $createNewBook) {...}
}
```

Problem polega na tym, że mamy tytuł i pasek narzędziowy, które chcę, aby zawsze się pojawiały, ale nie możemy ich przypisać do instrukcji warunkowej `if-else`. Więc będę musiał zamknąć całą tę instrukcję warunkową `if-else` w grupie (`Group`),przeniesiemy odpowiednie modyfikatory z List pod Group  dzięki czemu nasz pasek narzędziowy i tytuł zostaną wyświetlone .

```swift
        NavigationStack {
            Group {
                if books.isEmpty {
                    ...
                } else {
                    List {...}
                    .listStyle(.plain )
                }
            }
            .navigationTitle("Moje książki")
            .toolbar{...}
            .sheet(isPresented: $createNewBook) {...}
        }
```

 

W naszej podglądzie widzimy widok "Zawartość niedostępna", ale gdy tworzymy naszą pierwszą książkę, widok ten znika i zostaje zastąpiony listą. Wykonaliśmy już operacje tworzenia (Create) i odczytu (Read) z naszego akronimu CRUD. 

### Usuwanie danych - Delete z CRUD

Mamy jeszcze dwie pozostałe do zrobienia: Aktualizację (Update) i Usunięcie (Delete). Usunięcie jest najłatwiejsze, więc zróbmy to teraz. Ponieważ użyliśmy pętli forEach, możemy teraz skorzystać z funkcji onDelete, która pozwoli nam uzyskać dostęp do zestawu indeksów, na których przesunęliśmy palcem. Następnie możemy przejść przez każdy z naszych indeksów, używając kolejnej pętli forEach, aby uzyskać indeks naszej tablicy książek, którą chcemy usunąć. Potem pozwólmy, aby zmienna "book" równała się książce o indeksie. Podobnie jak przy dodawaniu książki, potrzebowaliśmy dostępu do kontekstu, aby ją dodać. Podobnie, będziemy musieli mieć dostęp do tego kontekstu, aby ją usunąć. Zatem ponownie będziemy musieli dodać właściwość środowiskową o ścieżce klucza "model.context". Przypiszę ją do zmiennej o nazwie "context". Teraz możemy użyć tego kontekstu, aby usunąć naszą książkę. 

```swift
                    List {
                        ForEach(books) {...}
                        .onDelete { indexSet in
                            indexSet.forEach{ index in
                                let book = books[index]
                                context.delete(book)
                            }
                        }
```

Możemy przetestować to na oknie podglądu, dodając najpierw nową książkę. I znowu, gdy to zrobiliśmy, widok "Zawartość niedostępna" zniknął, a książka pojawiła się na liście. Ale teraz mamy akcję przesunięcia palcem z prawej strony, która pozwala nam usunąć. A kiedy to zniknie, widok "Zawartość niedostępna" pojawia się ponownie. Przetestujmy to teraz na symulatorze i spójrzmy na nasze przechowywane dane. Usuńmy tę fikcyjną książkę tutaj. 

![2023-10-12_15-26-37 (1)](2023-10-12_15-26-37%20(1).gif)

Sprawdźmy jeszcze raz, wracając do naszej bazy danych SQL w edytorze SQL. Jeśli przejdę do karty "Przeglądaj dane" dla naszej tabeli "book", widzę teraz tylko dwie pozycje, podczas gdy wcześniej miałem trzy. Wszystko wygląda dobrze do tej pory. 

###  Aktualizacja danych czyi Update z CRUD

Mamy teraz ostatnią część naszego akronimu CRUD, czyli Aktualizację (Update). Będziemy mogli zaktualizować wszystkie pola w naszym modelu książki. W związku z tym będę musiał stworzyć nowy widok. Stwórzmy więc widok SwiftUI, który nazwiemy "EditBookView". Ten widok będzie wyświetlany, gdy klikniemy na nasz wiersz, który jest naszym odnośnikiem nawigacyjnym z widoku listy. Będziemy więc musieli otrzymać książkę, na którą kliknięto. Stworzę stałą dla tego obiektu, o nazwie "book", która będzie typu "book". Kiedy to zrobimy, podgląd będzie wymagać wstrzyknięcia książki do środowiska, ale nie będzie wiedział, gdzie znaleźć ten obiekt i jak go uzyskać, więc podgląd nie załaduje się. Na razie zamknę to wywołanie i zbuduję moje UI, a potem przetestuję je na urządzeniu, aby pokazać, że działa. W następnym filmie z tej serii pokażę ci, jak można rozwiązać ten problem, tworząc kontener w pamięci z przykładowymi danymi. Teraz ten widok będzie aktualizować każdą właściwość. Zamiast wiązać te właściwości bezpośrednio z każdą właściwością w książce do pól tekstowych, pickerów i edytorów tekstu, wolałbym utworzyć odpowiadającą właściwość stanu dla każdej z tych właściwości. Powodem tego jest, że jeśli użyję książki jako obiektu wiążącego zamiast stałej, będę mógł bezpośrednio wiązać każdą z właściwości z samą książką. Jednakże problem polega na tym, że po dokonaniu zmian, Core Data automatycznie aktualizuje i zapisuje te zmiany, co może być niepożądane. Chcę dać użytkownikowi szansę na dokonanie aktualizacji tylko wtedy, gdy nastąpiły zmiany. Zamiast korzystać z formularza, zamierzam użyć wielu widoków z etykietami, ponieważ pozwoli mi to na większą kontrolę nad układem. Na początek stworzymy właściwość stanu dla każdej z ośmiu różnych właściwości książki, które chcemy zaktualizować, i przypiszemy wartości domyślne dla wszystkich wartości, które nie są opcjonalne.

```swift
struct EditBookView: View {
   // var book: Book
    @State private var status = Status.onShelf
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
}
```

 Kiedy załadujemy ten widok, przypiszemy wartości przekazywanej książki w metodzie onAppear, aby zastąpić je obecnymi wartościami. Daty nie są opcjonalne, ale ponieważ zostaną zastąpione przez wersje książki, możemy po prostu użyć date.distantPast we wszystkich przypadkach. Stworzyłem prywatną właściwość stanu dla każdej z naszych różnych właściwości w naszym modelu. Dla wszystkich oprócz oceny (rating) stworzyłem wartość domyślną. 

​	Zamieńmy teraz zawartość widoku na HStack. Jako pierwszy widok, stworzę pole tekstowe (textView) z służacy za etykietę z tekstem "Status". Następnie utworzymy picker z etykietą "status", gdzie wybór będzie powiązany ze zmienną stanu statusu. Teraz, ponieważ case'y w enumie status są iterable, możemy użyć pętli forEach, aby przejść przez wszystkie przypadki statusu i uzyskać iterator statusu, który możemy wykorzystać do utworzenia pola tekstowego (textView) wyświetlającego właściwość statusDescript. Następnie będziemy musieli ustawić tag na sam status, aby zaktualizować tę zmienną stanu statusu po wybraniu odpowiedniego statusu. Dodatkowo ustawiam styl przycisku na bordered, co sprawia, że jest bardziej widoczny. 

```swift
        HStack{
            Text("Status")
            Picker("Status",selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.description).tag(status)

                }
            }
            .buttonStyle(.bordered)
        }
```

Poniżej HStacka wyświetlę pozostałe siedem właściwości. Utworzymy więc VStack z ustawionym wyrównaniem na leading. Na początek wyświetlę wszystkie daty, ale tylko te istotne. Więc jeśli status jest "na półce", będę wyświetlać tylko datę dodania. Jeśli jest "w trakcie", pokażę datę dodania i datę rozpoczęcia. Jeśli jest "zakończone", pokażę wszystkie trzy. Chcę, aby były one zawarte w grupie (GroupBox), aby się wyróżniały. Tutaj możemy użyć oznaczonych zawartości (labeled content) z konstruktorem content i label. Dla pierwszej daty, content będzie stanowić date picker, gdzie klucz tytułu będzie pustym ciągiem, a selection będzie powiązane z właściwością daty dodania. Ustawię komponenty wyświetlania tylko na datę. Nie interesuje mnie godzina. Następnie dla etykiety użyję pola tekstowego (textView) z etykietą "data dodania". Zawsze będziemy wyświetlać datę dodania, ponieważ domyślnie tworzymy bieżącą datę, gdy dodajemy nową książkę. Datę rozpoczęcia jednak będziemy musieli sprawdzić, czy status jest "w trakcie" lub "zakończone". Jeśli tak, możemy użyć kolejnej oznaczonej zawartości (labeled content), gdzie content będzie kolejnym date pickerem z pustym kluczem tytułu, tym razem powiązanym z datą rozpoczęcia. Znowu użyjemy komponentów wyświetlania daty. Dla daty zakończenia, najpierw sprawdzimy, czy status jest "zakończone". Jeśli tak, utworzymy kolejną oznaczoną zawartość, wyświetlającą datę zakończenia. Dodajmy także styl przedniego planu (foreground) na całą grupę, ustawiając go na sekundarny. 

```swift
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("",selection: $dateAdded, displayedComponents: .date)
                } label: {
                    Text("Data dodania")
                }

                if status == .inProgress || status == .completed {
                    DatePicker("Data rozpoczęcia",selection: $dateStarted, displayedComponents: .date)
                }
                if status == .completed {
                    DatePicker("Data przeczytania",selection: $dateCompleted, displayedComponents: .date)
                }
            }
            .foregroundStyle(.secondary)
        }
```

Gdy zmienimy status, będziemy chcieli ewentualnie zresetować daty, ponieważ jeśli przejdziemy z "w trakcie" z powrotem na "na półce", będziemy musieli zresetować datę rozpoczęcia. Sprawdźmy wszystkie przypadki w modyfikatorze onChange. Korzystając z onChange dla statusu, uzyskujemy dostęp zarówno do starej, jak i nowej wartości. 

Jeśli nowa wartość równa jest "na półce", ustawimy datę rozpoczęcia na date.distantPast i datę zakończenia na date.distantPast. 

Jeśli nowa wartość to "w trakcie", a stara wartość to "zakończone", oznacza to, że przeszliśmy z "zakończonego" na "w trakcie", wtedy ustawimy dateCompleted na date.distantPast. 

Kolejny przypadek, to jeśli nowa wartość jest równa "w trakcie", a stara wartość to "na półce", oznacza to, że zaczęliśmy czytać książkę. Możemy więc ustawić datę rozpoczęcia na date.now. 

Kolejny przypadek to, gdy nowa wartość jest równa "zakończone", ale stara wartość to "na półce", co oznacza, że zapomnieliśmy ustawić początek książki i przeskoczyliśmy od "na półce" do "zakończone". Wtedy możemy ustawić datę zakończenia na date.now, ale datę rozpoczęcia ustawimy na tę samą datę, którą dodaliśmy książkę. 

W przeciwnym razie, gdy jest to "zakończone", ustalimy datę zakończenia na date.now. 

```swift
            .onChange(of: status) { oldValue, newValue in
                if newValue == .onShelf {
                    dateStarted = Date.distantPast
                    dateCompleted = Date.distantPast
                } else if newValue == .inProgress && oldValue == .completed {
                    dateCompleted = Date.distantPast
                } else if newValue == .inProgress && oldValue == .onShelf {
                    dateStarted = Date.now
                } else if newValue == .completed && oldValue == .onShelf {
                    dateCompleted = Date.now
                    dateStarted = dateAdded
                } else  {
                    dateCompleted = Date.now
                }
            }
```

Poniżej tego utworzę separator. Jeśli chodzi o ocenę, chcę użyć niestandardowego widoku oceny, który stworzyłem. To jest modyfikacja widoku oceny, który pokazuję w tutorialu o korzystaniu z pakietów Swift. Zostawię link w opisie, jeśli chcesz to sprawdzić. Trochę go zmieniłem, więc nie mogę użyć tego pakietu, ale możesz uzyskać dostęp do kodu z tego gist. Link znajduje się w opisie. Możesz albo utworzyć nowy plik o nazwie "ratingsview" w swoim projekcie i skopiować ten kod, albo po prostu pobrać plik stąd, rozpakować i przeciągnąć go do swojego projektu. 

```swift
// https://gist.github.com/StewartLynch/03372c873fef568e0a613a968adbae69

import SwiftUI

/// A view of inline images that represents a rating.
/// Tapping on an image will change it from an unfilled to a filled version of the image.
///
/// The following example shows a Ratings view with a maximum rating of 10 red flags, each with a width of 20:
///
///     RatingsView(maxRating: 10,
///              currentRating: $currentRating,
///              width: 20,
///              color: .red,
///              ratingImage: .flag)
///
///
public struct RatingsView: View {
    var maxRating: Int
    @Binding var currentRating: Int?
    var width:Int
    var color: UIColor
    var sfSymbol: String
    
    /// Only two required parameters are maxRating and the binding to currentRating.  All other parameters have default values
    /// - Parameters:
    ///   - maxRating: The maximum rating on the scale
    ///   - currentRating: A binding to the current rating variable
    ///   - width: The width of the image used for the rating  (Default - 20)
    ///   - color: The color of the image ( (Default - systemYellow)
    ///   - sfSymbol: A String representing an SFImage that has a fill variabnt (Default -  "star")
    ///
    public init(maxRating: Int, currentRating: Binding<Int?>, width: Int = 20, color: UIColor = .systemYellow, sfSymbol: String = "star") {
        self.maxRating = maxRating
        self._currentRating = currentRating
        self.width = width
        self.color = color
        self.sfSymbol = sfSymbol
    }

    public var body: some View {
        HStack {
                Image(systemName: sfSymbol)
                    .resizable()
                    .scaledToFit()
                    .symbolVariant(.slash)
                    .foregroundStyle(Color(color))
                    .onTapGesture {
                        withAnimation{
                            currentRating = nil
                        }
                    }
                    .opacity(currentRating == 0 ? 0 : 1)
            ForEach(1...maxRating, id: \.self) { rating in
               Image(systemName: sfSymbol)
                    .resizable()
                    .scaledToFit()
                    .fillImage(correctImage(for: rating))
                    .foregroundStyle(Color(color))
                    .onTapGesture {
                        withAnimation{
                            currentRating = rating + 1
                        }
                    }
            }
        }.frame(width: CGFloat(maxRating * width))
    }
    
    func correctImage(for rating: Int) -> Bool {
        if let currentRating, rating < currentRating {
            return true
        } else {
            return false
        }
    }
}

struct FillImage: ViewModifier {
    let fill: Bool
    func body(content: Content) -> some View {
        if fill {
            content
                .symbolVariant(.fill)
        } else {
            content
        }
    }
}

extension View {
    func fillImage(_ fill: Bool) -> some View {
        modifier(FillImage(fill: fill))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var currentRating: Int? = 3
        
        var body: some View {
            RatingsView(
                maxRating: 5,
                currentRating: $currentRating,
                width: 30,
                color: .red,
                sfSymbol: "heart"
            )
        }
    }
    return PreviewWrapper()
}
```

Teraz jest dość prosty, jak widać na podglądzie, przekazujesz maksymalną ocenę wraz z obecną oceną, która będzie powiązana z jakąś wartością, którą w naszym przypadku jest to właściwość stanu oceny, właściwość szerokości (width), kolor i symbol SF, który ma trzy różne warianty symboli: normalny, wypełniony i ukośnik. Podgląd wykorzystuje czerwony symbol serca z maksymalną oceną 5 i szerokością 30. Jednak z konstruktora domyślnego wynika, że szerokość wynosi 20, kolor to systemowy żółty, a ja używam symbolu gwiazdy SF. Więc to prawie pasuje do tego, co chcę. Jedyną rzeczą, którą chcę zmienić z domyślnych ustawień, to szerokość. W naszym widoku edycji książki, poniżej separatora, stworzymy kolejny oznaczony widok zawartości. Dla content, stworzymy nowy widok oceny. Określimy maksymalną ocenę na 5. Powiążemy obecną ocenę z naszą właściwością oceny, ale szerokość ustawię na 30. A dla etykiety, po prostu użyję pola tekstowego (textView) z napisem "ocena".

```swift
            LabeledContent{
                RatingsView(maxRating: 5, currentRating: $rating, width: 30)
            }label: {
                Text("Ocena")
            }
```

Przechodząc dalej, dla tytułu naszej książki ponownie użyję oznaczonej zawartości (labeled content), gdzie zawartość to pole tekstowe (text field) z pustym ciągiem jako kluczem tytułu, które jest powiązane z odpowiadającą właściwością stanu. Etykieta będzie po prostu polem tekstowym (text view) pokazującym "tytuł", a ustawie styl przedniego planu na sekundarny. 

```swift
            LabeledContent {
                TextField("", text:$title)
            } label: {
                Text("Tytuł")
            }
```

Skopiuję to dla autora, ponieważ będzie bardzo podobne, ale pole tekstowe będzie powiązane z właściwością stanu autora, a pole tekstowe wskaże "autor" zamiast "tytuł". 

```swift
            LabeledContent {
                TextField("", text: $author)
            } label: {
                Text("Autor")
            }
```

Następnie dodam kolejny separator, a pod nim pole tekstowe (text view), które wyświetli napis "podsumowanie" ze stylem przedniego planu ustawionym na sekundarny. I ostatecznie poniżej edytora tekstu, gdzie tekst jest powiązany z naszą zmienną podsumowania (summary), dodam trochę odstępu o wartości 5. 

```swift
            Divider()
            Text("Opis").foregroundStyle(.secondary)
            TextEditor(text: $summary)
                .padding(5)
```

Następnie dodam nakładkę w postaci zaokrąglonego prostokąta (rounded rectangle) z promieniem naroża wynoszącym 20. Ustawię obrys na kolor korzystający z koloru UI wypełnienia systemowego trzeciego stopnia (tertiary system fill) i grubość linii na 2. 

```swift
.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
```

Pozwól, że trochę to uporządkuję. Dodam odstęp i ustawie styl pola tekstowego na zaokrągloną ramkę (rounded border). Ponieważ będzie to przeniesione na stos nawigacyjny (navigation stack), możemy określić tytuł nawigacji, który będzie wyświetlał tytuł książki. Następnie ustawię tryb wyświetlania tytułu paska nawigacji na inline (inline). Teraz stworzę pasek narzędzi (toolbar), który będzie zawierał przycisk z napisem "Aktualizuj" i na razie pozostawmy akcję, ale ustawmy styl przycisku na wyeksponowany z ramką (Bordered Prominent). 

```swift
  VStack {...}
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Zapisz") {

            }
            .buttonStyle(.borderedProminent)
        }
```

Nie zobaczysz tego w widoku, ponieważ nasz podgląd nie wie, że znajduje się na stosie nawigacyjnym. Aby to zobaczyć, umieśćmy podgląd w stosie nawigacyjnym. 



```swift
#Preview {
    NavigationStack {
        EditBookView()
    }
}
```

Ale gdy już zakończymy aktualizację, będziemy chcieli zamknąć widok. Będziemy więc potrzebować zmiennej środowiskowej (environment variable) dla tego, używając klucza dismiss (zwolnij). 

```swift
struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    var book: Book 
  ...
}
```

Następnie, gdy zaktualizujemy, możemy zamknąć widok. 

```swift
        .toolbar {
            Button("Zapisz") {
                //kod do zapisu
                    dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
```

No cóż, to mniej więcej nasz projekt teraz. Chcemy jednak wyświetlić przycisk aktualizacji tylko wtedy, gdy będą jakieś zmiany w przekazanej książce. Zatem odkomentujmy książkę i zakomentujmy nasz podgląd, który nie będzie działał do następnego lekcji, i zobaczmy, co musimy zrobić, aby zaktualizować książkę. Gdy książka się pojawi, chcemy ustawić właściwości stanu na te, które otrzymujemy od przekazanej książki, jak już wspomniałem. Zróbmy to dla każdej ze zmiennych stanu, dopasowując właściwości modelu z odpowiadającymi właściwościami książki. Status na book status, rating na book rating itd. 

```swift
        .onAppear {
            status = book.status
            rating = book.rating
            title = book.title
            author = book.author
            summary = book.summary
            dateAdded = book.dateAdded
            dateCompleted = book.dateCompleted
            dateStarted = book.dateStarted
        }
```

Jednak chcę wyświetlić ten przycisk aktualizacji tylko wtedy, gdy któraś z tych właściwości zostanie zmieniona. Chcę więc utworzyć obliczeniową właściwość boolowską, którą nazwę "zmienione". Będzie ona sprawdzać, czy któreś z tych właściwości uległy zmianie. Pozwól mi po prostu skopiować to, co było w bloku onAppear i wkleić to tutaj, korzystając z technik edycji. Chcę sprawdzić, czy status nie jest równy statusowi książki, lub to samo będzie dotyczyć każdej z pozostałych właściwości. Więc użyję edycji wielokursorowej, naciskając Control-Shift-klik i przeciągając w dół, abym mógł po prostu dodać "or" i spacje przed każdą z naszych innych linii. Następnie mogę użyć Control-klik i po prostu zmienić równo na różne od. 

```swift
    var changed: Bool {
       status != book.status
      || rating != book.rating
      || title != book.title
      || author != book.author
      || summary != book.summary
      || dateAdded != book.dateAdded
      || dateCompleted != book.dateCompleted
      || dateStarted != book.dateStarted
    }
```

A potem mogę wrócić i wyświetlić ten przycisk paska narzędzi tylko wtedy, gdy dane byly zmienione.



Teraz jest jeden problem z naszymi datami. Ustawianie ich w bloku onAppear wprowadza zamieszanie w naszą właściwość obliczeniową changed ze względu na naszą metodę onChange. Aby to naprawić, zamierzam wprowadzić właściwość logiczną o nazwie firstView i ustawić ją na true, ponieważ chcę, aby właściwości te były ustawiane w bloku onAppear tylko podczas pierwszego pojawienia się widoku, a nie po każdym odświeżeniu. 

```swift
    @State private var firstView = true;
```

Więc teraz wszystko, co muszę zrobić, to zmienić wszystkie nasze przypisania lub zmiany w bloku onChange, korzystając z klauzuli if not firstView. A po ustanowieniu dat, ustawiamy ją na false. 

```swift
            .onChange(of: status) { oldValue, newValue in
                if firstView {

                 if newValue == .onShelf {
                    dateStarted = Date.distantPast
                    dateCompleted = Date.distantPast
                } else if newValue == .inProgress && oldValue == .completed {
                    dateCompleted = Date.distantPast
                } else if newValue == .inProgress && oldValue == .onShelf {
                    dateStarted = Date.now
                } else if newValue == .completed && oldValue == .onShelf {
                    dateCompleted = Date.now
                    dateStarted = dateAdded
                } else  {
                    dateCompleted = Date.now
                }
                    firstView = false
            }
```

Następnie możemy wrócić do naszego paska narzędzi (toolbar) dla akcji. 

Jeślizarejestrowano zmianę, zanim zamkniemy widok, możemy przepisać wszystkie właściwości stanu do obiektu książki, a Swift zajmie się zmianą i zachowaniem tych wartości. Wreszcie wracając do widoku listy książek, gdzie otrzymujemy ten nawigacyjny link do tytułu książki, możemy go zmienić na wyświetlenie widoku edycji książki, przekazując książkę. 

```swift
                    List {
                        ForEach(books) { book in
                            NavigationLink{
                                EditBookView(book:book)
                            } label: { ...}
                    ...                    
```

Chcę się upewnić, że daty dodania, rozpoczęcia i zakończenia są sekwencyjne, i że nie mogę ustawić daty poza sekwencją. Na przykład nie mogę ustawić daty wcześniej niż datę rozpoczęcia. Wróćmy więc do grupy (GroupBox) tutaj i tam, gdzie ustawiamy datę rozpoczęcia, zaznaczę, że nie możemy ustawić daty przed datą dodania. Robimy to, określając zakres za pomocą operatora in, a potem widzimy dateAdded..., trzy kropki. Podobnie dla daty zakończenia będziemy musieli ustawić zakres zaczynający się od dateStarted. 

```swift
if status == .inProgress || status == .completed {
  DatePicker("Data rozpoczęcia",selection: $dateStarted,in: dateAdded..., displayedComponents: .date)
}

if status == .completed {
  DatePicker("Data przeczytania",selection: $dateCompleted,in: dateStarted..., displayedComponents: .date)
}
```

Sprawdźmy to teraz, uruchamiając symulator i zobaczmy, czy nasze dane są zachowane. Utwórzmy wpis do książki, aby się upewnić, że wszystko działa. Pamiętajmy, że potrzebujemy tylko tytułu i autora.



Świetnie, działa. Zatem, edytujmy tę książkę. Powiedzmy, że zapomniałem dodać tej książki, gdy ją dostałem, więc zmienię datę na "ostatni miesiąc". Zacząłem czytać książkę, więc zmienię status. Zauważ, że kiedy to robię, data zostaje ustawiona na "dzisiejszą datę". Oceńmy książkę na razie. A co powiesz na wstępne myśli na temat podsumowania? Można je edytować w dowolnym momencie. Jeśli wrócę do widoku listy, zobaczę, że ikona się zmieniła, a moje oceny gwiazd się zmieniły, ale myślę, że dałem jej tylko trzy gwiazdki, więc muszę gdzieś popełnić błąd. Zatrzymajmy symulator i sprawdźmy, gdzie jest mój błąd. Ta ocena powinna być od 1, nie od 0. 

```swift
if let rating = book.rating {
  HStack {
    ForEach(1..<rating, id:\.self) { _ in
                                    Image(systemName: "star.fill")
                                    .imageScale(.small)
                                    .foregroundStyle(.yellow)
                                   }
  }
}
```

Uruchommy ponownie, zobaczysz, że dane są zachowane, a czytanie jest poprawne. 

![2023-10-13_10-46-28 (1)](2023-10-13_10-46-28%20(1).gif)

 Cóż, to kończy podstawowe operacje CRUD, a kolejne filmy w tej serii nie będą tak długie i będą skupiać się na pojedynczych tematach. W następnym filmie bliżej przyjrzymy się, jak jest konstruowany nasz modelowy kontener i jak możemy nad nim trochę kontrolować. Rozwiążemy także problem w widoku edycji, gdzie nie możemy podglądać książki w naszym podglądzie. Pokażę ci również, jak możesz tworzyć i używać przykładowych danych (mock data), abyś nie musiał zawsze pracować w symulatorze. 



## MockData - dane przykładowe do podglądu



> We took a look at the basic CRUD functions of SwiftData and how the data is stored in a model container in your device. In this video, we're going to take a closer look at that model container and how we can configure it to meet our own needs. In addition, I'm also going to show you how you can create mock data and have it stored in memory so that you can use it in your previews. I love getting your feedback, so tap the thumbs up button if you enjoyed this video and leave a comment below. Make sure you subscribe to the video and ring that bell to get notifications of new videos. And if you want to support my work, you can buy me a coffee. In that last video we were able to persist our data to the application support directory, and when we ran our app, we printed out the path to that URL in our console. If you completed the project from that first video, you can continue along with me. If not, you can download the completed project from the link in the description, and it's a GitHub repository listed in that description. By the time you watch this video, there may be more branches, but you want to make sure that you start with the one that ends in the first video_crud. When you're at this page, you should see the completed branch from the video has been selected. can download it as a zip or choose to do as I do and use the GitHub CLI. 

Przypatrzeliśmy się podstawowym funkcjom CRUD w SwiftData oraz temu, jak dane są przechowywane w kontenerze modelu na Twoim urządzeniu. W tym filmie przyjrzymy się bliżej temu kontenerowi modelu i jak możemy go skonfigurować, aby spełniał nasze własne potrzeby. Ponadto pokażę Ci, jak możesz tworzyć przykładowe dane (mock data) i przechowywać je w pamięci, dzięki czemu będziesz mógł ich używać w podglądach. Uwielbiam otrzymywać od Was opinie, więc naciśnij przycisk kciuka w górę, jeśli podobał Ci się ten film i zostaw komentarz poniżej. Upewnij się, że jesteś subskrybentem kanału i włącz powiadomienia, aby otrzymywać informacje o nowych filmach. Jeśli chcesz wesprzeć moją pracę, możesz mi kupić kawę.

W poprzednim filmie udało nam się zachować nasze dane w katalogu wsparcia aplikacji, a gdy uruchomiliśmy naszą aplikację, wypisaliśmy ścieżkę do tego URL-a w konsoli. Jeśli ukończyłeś projekt z tego pierwszego filmu, możesz kontynuować razem ze mną. Jeśli nie, możesz pobrać gotowy projekt z linku w opisie, który znajdziesz w repozytorium na GitHubie podanym w opisie tego filmu. W chwili, gdy oglądasz ten film, może być więcej gałęzi, ale upewnij się, że zaczynasz od tej, która kończy się na "first video_crud". Gdy znajdziesz się na tej stronie, powinieneś zobaczyć wybraną gałąź "completed" z tego filmu. Możesz pobrać ją jako plik ZIP lub wybrać opcję, którą ja używam, czyli GitHub CLI.

I recommend that you do some investigation on this command-line interface, but that's for another day. So where we left off we found out that when we ran our app in the simulator and had it print out the location for the persistent SQL database, the default location is the Applications Library Application Support Directory for the selected simulator and the database is named named default.store. And this will be the case for every Swift data project that you create. Often, you may store data like images in the Documents directory for your apps. Well, you can have your SQLite database stored there as well and use a different name. This is your choice. The default is used because we use the modelContainerFor and specified our model method. By option clicking on the method, we can get more information. There's an In Memory option that we used in our preview so that the data is kept in memory only. But of course, we don't want that for the default in our application. Auto saving is enabled by default, so that's why we never had to specify a call to a save method when we created, updated, or deleted our books. I'm not going to get into this isUndoEnabled or the onSetup callback in this series, but I encourage you to dig down and look to the documentation on your own. Further down, we're told that the environment model context property will be assigned a new context associated with the container. Remember, we used that when we had to update and delete our. Remember, we used that when we created with an insert or deleted one of our objects. All implicit model context operations in the scene, such as the query properties, use this environment's context. It's the context that has our insert and delete methods and handles the autosave. By default, the container stores its model data persistently on disk, just as we learned. The container will only be created once, however. So each time we launch our app, we're not going to create a new container. New values that are passed to the model type and in-memory parameters after the view is first created will be ignored. If you want more control, we'll need to use a different overload for creating the container. If you drill down into the documentation, we'll see that there's actually other choices. Specifically, one where we can pass in a model context, and another where we can pass in a model container, instead of a persistent model, or an array of persistent models. It's this option that I want to explore a bit more. So let me drill down on model container and see that it refers to such things as model configuration, schemas, and schema migration plan. And we'll get to that later on in the series. But there are three things that you need to be aware of. The model container is responsible for creating and managing the actual database file used in all Swift data stores needs. And as mentioned above, this gets created once. The model context has the job of tracking all objects that have been created, modified, and deleted in memory so that they can all be saved to the model container at some later point. So when we create our model container, the context is available from the environment. The model configuration determines how and where the data is stored, including which Cloud Kit container to use, if any, and whether saving should be enabled or not. This configuration is provided to your model container to determine how it behaves. So we need to explore this configuration option a bit more. In the location where our app launches, where the app main decoration is, let's create a new container property that's going to allow us to configure the name and where we want to store our database. First, we'll create a container property that is a model container. And in our initializer, where I currently print out the directory to the existing data store, I can configure that container. Well, we can create a configuration, which is a model configuration. It has a number of different overloads with properties, many of which are optional, or have default values. One just has a URL property that will allow us to determine where we want to store the container and its name. It allows us to specify a different directory, and when we append a path, that will allow us to name our datastore to be whatever we want. So let's set the location to the "Documents" directory, and we can give it a name other than default.store by appending a path and specifying our own name, like mybooks.store. Next, I can now create a new container and assign it to my container property. The overload I want to use is where we pass in our persistent model types as a variadic parameter along with any configurations I might have. And in our case we have one of each so we can just pass in book.self and config. When I create my model container using the model container with configurations, it can throw. So we have to use a try, and we have to enclose this in a do catch block. In the case that it would fail, your app is not going to run anyway, so I'm just going to use a fatal error, and display a string could not configure the container. Now, instead of using the modelContainer for our persistent model mentioned here, I'll use the modelContainer method that just asks for the container, which we now have. And instead of printing out our path to the application support directory, let me print out the path to the documents directory. And I don't need %encoding here because it's not necessary. There are no spaces in that path. If we run this now, our app launches, but we see that whatever data we had before has been lost because we're no longer using that other container. So let's open up the path, and here we see it with our new name. It's being stored in the documents directory. That old container in the library's application support directory is still there though. I personally don't like to move things into the documents directory. So I'm going to go back to the application support directory and use a different overload to do this and change the name. So I'm going to comment out the body of that new initializer now, and I'm going to create a different container. We'll get into migrations later on and you'll learn about schemas. But a schema is an object that maps model classes to data in the model store. And that helps with migration of the data between releases. But for us, all we need to do is specify an array of the models that we have, and we have only one. So we can say let schema equals schema, and the array contains the book.self. Well now I can create a configuration that uses the schema, and I can provide a name as the first argument for our data store, followed by the schema, which is what we've just defined. Now there are plenty of different options here, but all I need is the one to specify the name and schema, which we can do. Then as before, we create our container in a do catch block by trying to use the model containers overload for the schema, this time with the configuration, the single config. And again, we'll catch the error. Let's comment out that Documents directory path now and uncomment the print for the Application Support directory path, and run once more. When I return to the Application Support directory, I see that we now have added that new named container and we still have that old one, the default one. I encourage you to read through the documentation so that you can create your own containers as you wish. I'm going to leave it with this last option now, but I'm going to go and delete the container from the documents directory because we're no longer accessing it. Remember, by creating a new container with a different name in the application support directory, we lost all the data from our last lesson. It's still in that default location. Well, if we delete the My Books, but rename default as My Books, We should then be able to recover all of our data. So let's do that and let's run our app. Great, our data is back. So rather than running in the simulator, I'd like to be able to use mock data that I can have just for my previews. This will only be used for our previews, so in Xcode with the preview content folder, I'm going to create a new Swiss file, and I'm going to call it book samples. Inside there, I'm going to create an extension to our book model where I can create a static property representing an array of books. So I'm going to create that static property, and I'm going to call it Sample Books, which as I said is an array of book. So we'll start with an empty array. Now within here, that's where I want to create a variety of different book samples. Now because there are so many different default values and optionals, there are many, many different constructors for creating a sample book. The simplest is just to provide the title and author like we do in our app. This will default to a start day of today, the status of onShelf, but the other dates will be those Date.DistantPast, the rating will be an optional nil, and the summary will simply be an empty string. But in order to verify our UI, we need lots of other information when we view the Edit screen. So if I want to test this out, I want to have some variety in our list. Now the trickiest is providing dates. So what I'd like to do is to create a two more static properties, one for last week and one for last month. So I can use the calendar.current.date method, which allows me to add using by adding to a specific date component like day a value of minus seven to the current date, which is date.now, that will give me last week. So similarly, I can create a static property for last month, by changing that date component to month and the value to minus one. So you can create a lot of dates relative to the current date that you can use in your sample data. So with these static properties, I could create a variety of different books. So for example, I could have had a book that was added last month, started last week, and completed today. Now, if you don't want to create your own data, You can use the data that I provided in this gist. You can simply get to the raw value if you like, and copy all this content and paste it into the array of your sample books. Now that we have some sample data, let's see how we can use it. Now that we have some preview data, we can set up a memory container that we can populate with this data and use in our previews. So in the preview content folder, I'm going to create a new file and call it preview container. First let me import Swift data. And then I'm going to create a new struct called preview. and I'm going to create a single property that will be a container. And we're going to create it just as we created our persistent container. So I'll need an initializer. So we'll create a model configuration called config and specify that this is isStoredInMemoryOnly as true. There's no need to specify a URL as we did for our persistent store because it's going to be in memory. With the initializer, we can create that container within a do-catch block, remember it throws, by trying to create the model container for book.self with that particular config, just as we did before. But now, let's create a function that will allow us to add examples from an array of these type. While I do have this type, I do have that array of sample books. So within that function, we can loop through this array of examples for each loop, and then use the container's main context to insert that example iteration. Remember, we found that the container has a context, and this is its main context, and you can see here that the main context is giving us a warning that the main context is used in a context that doesn't support concurrency. Then the next warning is telling us that this must be executed on the main thread. So we create a task unit of work for the asynchronous task, and then we use a @MainActor in to have it performed on the main thread. So how can we use this? Well, let's return to our book list view then, where we use the model container for book.self in memory set to true. But we're going to replace this with our new container and examples. So first, we'll create a new instance of our preview struct, we'll just call it preview. Then we'll call the add examples function to pass in the book sample books array as that array. So now our preview container is going to have all of those examples. But then we'll need to change the model context from using for to simply use the preview.container property, as we did for our persisted container. Now, because we no longer have a single line being returned here, we'll need to specify a return on the book list view. There you have it. Our sample books are in memory and being displayed in our preview. Now, remember in edit book view, we commented out the preview in edit book view. So now we'll uncomment it, and I'm going to create our own preview container, and add in our books just as we did before, but we don't need to add in an array. What we can do is simply create a new preview object that has this container, and then as before, apply the model container for that preview container. Well, now we'll need to add a return for the entire navigation stack. But the edit book view requires a book, so we can pass in any one of our books from the sample books array. So for example, item 3, and we see that that is now displayed in our preview. Having an array of sample books, I can change that index to display a different book. Well, this is displaying our book okay, but we wouldn't be able to make any modifications in the preview here, unless we specify that modelContainer method, passing in our previews container. Well, this is pretty good, but we can do one better than this because eventually we might be adding in more models, and I don't want to have to create a different preview container type struck just to display those different objects. I might even want to reuse this preview container for different projects. Right now, all we're reviewing is this book model. If we return to the preview struct, everywhere I see book, I want to replace this with something that I inject when I initialize this preview. So this is going to have to happen in the initializer. So rather than injecting just a book, I'm going to inject models, and it's going to be a variadic array of persistent model.type. So I can pass in more than just book, I can simply pass in every single model that I want. Well, now the problem is that my constructor for the model container can't pass in a type, any persistent model.type as variadic arguments. Fortunately though, our container has another constructor as we've learned, and that's the one that allows us to add a schema. A schema can take a variadic set of models. So I can let schema equal schema models. Well, then we can change our model container to use the schema instead. Then finally, where we have that function to add our examples, well, this doesn't have to be an array of books. It can be an array of any persistent model. I can call this function for any model that I pass in and their sample array. Everywhere we went and constructed our preview with our in-memory preview then, we're going to have to pass in some variadic set of models. But we only have one, so we'll let the preview be the preview of book.self, and we'll do that in both of our views. First in the book list view, we'll pass in our model, which is the book.self, and similarly in the edit book view. We make sure that we apply the model container function for that preview container. Now, our previews are loaded in memory and I can perform all the same actions that I do when I run on the simulator. Now, if you're interested in learning more about these previews, I suggest you watch a video created by TunesDev on working with previews in Swift Data. It is a very nice solution for streamlining the previews even more, but I'm going to leave it like this as I think it might help you understand containers, contexts, and configurations and schemas a little bit better as you're learning, but definitely worth a watch. In the next video in this series, we're going to start to take a look at how we can filter and sort our list of books. And this is going to have to be a dynamic sort, allowing us to make those changes on on the fly and have the view refreshed. Hi, my name's Stuart Lynch. [BLANK_AUDIO]