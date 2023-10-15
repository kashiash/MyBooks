# Relacja One : Many

https://youtu.be/dAMFgq4tDPM?si=SxXtlAK2Z3kV3MMg

> The fifth video in the Swift Data Series, and the second in this section. In this video I want to introduce you to a one-to-many relationship for our books that's going to allow us to add multiple pull quotes for each of our books. I love getting your feedback, so tap the thumbs-up button if you enjoyed this video and leave a comment below. Make sure you subscribe to the video and ring that bell to get notifications of new videos. And if you want to support my work, you can buy me a coffee. If you're following along with me, you can continue on with the project from video 4. If not, please download the completed project from the correct branch for this project's repository, and that's the fourth video, underscore, Lightweight Migration branch. I'll leave a link in the description. For this video I've started a new branch for one-to-many relationships. You should also make sure that you have at least three book entries in your app when you run it on the simulator. I also suggest that you run your application once and use the URL to open the location of that container's set of files and make a duplicate copy of those three files. I have already done that. Keep both of those windows available, as we'll be returning to them later. We are now at the point where I want to add more features to my app. Plus I also want to make sure that if I already have users, they don't lose any data that they've already entered. 

Piąty film w serii Swift Data, a drugi w tej sekcji. W tym filmie chcę przedstawić ci relację jeden do wielu dla naszych książek, co pozwoli nam dodać wiele cytatów do każdej z naszych książek. Uwielbiam otrzymywać twoją opinię, więc naciśnij przycisk kciuka w górę, jeśli podobał ci się ten film, i zostaw komentarz poniżej. Upewnij się, że subskrybujesz kanał i włączasz dzwonek, aby otrzymywać powiadomienia o nowych filmach. Jeśli chcesz wesprzeć moją pracę, możesz mi kupić kawę. Jeśli śledzisz mnie, możesz kontynuować pracę nad projektem z filmu numer 4. Jeśli nie, pobierz gotowy projekt z odpowiedniego brancha w repozytorium tego projektu, czyli z brancha "fourth video_lightweight_migration". Podam link w opisie. Dla tego filmu rozpocząłem nowy branch dla relacji jeden do wielu. Upewnij się również, że masz co najmniej trzy wpisy książek w swojej aplikacji, gdy uruchamiasz ją na symulatorze. Sugeruję także uruchomienie swojej aplikacji raz i używanie adresu URL, aby otworzyć lokalizację plików kontenera i utworzyć kopię tych trzech plików. Ja już to zrobiłem. Zachowaj obie te kopiuj okna, ponieważ będziemy do nich wracać później. Jesteśmy teraz w punkcie, w którym chcę dodać więcej funkcji do mojej aplikacji. Chcę także upewnić się, że jeśli już mam użytkowników, nie tracą żadnych danych, które już wprowadzili.

> Thankfully, if we are careful, we know that the SwiftData Lightweight Migrations can handle that for us. The first relationship I want to add is known as a one-to-many relationship. When I read a book, I like to pull quotes from that book and keep track of them. Each book can have many of these pull quotes, and that's why it's called a one-to-many relationship. So, for this quote, I'm going to need to create a new model that we can persist in our data store in our SQLite database. So I'm going to create a new file and I'm going to call it quote, and I'll import SwiftData. Next, I'll create a new class called quote, and I'm going to make sure that I apply the model macro. This quote is going to have three properties. The first one is going to be a date that it was created that we'll provide as the date.now. We're going to have one that's called text, which will be the text of the quote, and that's a string. And another one that will be a page number should I choose to add it. So I'm going to make it optional. We'll need an initializer. So when I create this initializer, I don't really need this one for the date because I'm defaulting it to date.now. So I'm going to remove it. Well, we'll need to somehow establish a relationship between our two models, book and quote. 

Na szczęście, jeśli będziemy ostrożni, wiemy, że lekkie migracje w SwiftData mogą zająć się tym za nas. Pierwszą relację, którą chcę dodać, nazywa się relacją jeden do wielu. Kiedy czytam książkę, lubię cytować z niej fragmenty i śledzić je. Każda książka może mieć wiele takich cytatów, stąd nazwa relacji jeden do wielu. Dlatego będziemy musieli utworzyć nowy model, który będziemy przechowywać w naszej bazie danych SQLite. Więc utworzę nowy plik i nazwę go "Quote", a następnie zaimportuję SwiftData. Następnie utworzę nową klasę o nazwie Quote i upewnę się, że stosuję makro modelu. Ten cytat będzie miał trzy właściwości. Pierwsza to data utworzenia, którą ustawimy jako date.now. Będziemy mieli również tekst cytatu, który będzie typu string, oraz opcjonalny numer strony, jeśli zdecyduję się go dodać. Musimy utworzyć inicjalizator. Kiedy tworzę ten inicjalizator, nie potrzebuję tego dla daty, ponieważ ustawiam ją jako date.now. Zatem go usunę. Będziemy musieli jakoś ustanowić relację między naszymi dwoma modelami, Book i Quote.

```swift
@Model
class Quote {
    var creationDate: Date = Date.now
    var text: String
    var page: String?

    init(text: String, page: String? = nil) {

        self.text = text
        self.page = page
    }
  
}
```

Cóż, SwiftData obsługuje zarówno implikitywne, jak i explicite tworzenie tych relacji. Zaczniemy od relacji implicit, zobaczymy, co SwiftData zrobi. W naszym modelu książki dodam nową właściwość o nazwie quotes, która będzie tablicą tych cytatów. To ustanowi relację od książki do cytatu. Musimy albo podać wartość domyślną, taką jak pusta tablica, albo uczynić to opcjonalnym. Wolałbym uczynić to pustą tablicą, ale wiem, że chcę w przyszłości eksplorować CloudKit, a tam znajdziemy wymaganie, że ta właściwość musi być opcjonalna. 

```swift
 var quotes: [Quote]?
```

Teraz nie ma potrzeby zmieniać naszego inicjalizatora, ponieważ gdy tworzymy nową książkę, nie będzie żadnych cytatów. Zatem domyślne ustawienie tej opcjonalnej właściwości jako nil jest w porządku. Następnie w pliku z cytatem możemy ustawić relację z powrotem do naszej książki. Robimy to, tworząc book typu book, a to musi być opcjonalne. Oznacza to, że każdy cytat może być powiązany z jedną książką, jeśli taka istnieje. Możesz się zastanawiać, jak to jest możliwe, że cytat nie może być powiązany z książką. Przejdziemy do tego niedługo. Chciałbym cię jednak ostrzec, że chociaż powyższe może działać, to z pewnymi ograniczeniami, będziemy mieć pewien problem, który rozwiążemy pod koniec tego filmu. Tak więc proszę, kontynuuj oglądanie. 

```swift
@Model
class Quote {
    var creationDate: Date = Date.now
    var text: String
    var page: String?

    init(text: String, page: String? = nil) {

        self.text = text
        self.page = page
    }
    var book: Book?
}
```

W naszym punkcie startowym aplikacji, gdzie tworzymy nasz kontener, stworzyliśmy schemat, który określał tylko model książki w tablicy. Być może myślisz, że teraz powinieneś dodać quote.self do tej tablicy tutaj. 

```swift
    init() {
        let schema = Schema([Book.self])
        let config = ModelConfiguration("MyBooks", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config )

        } catch {
            fatalError("Could not configure container")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
```

Jeśli używamy inicjalizatora modelu z tą zmienną liczba argumentów, być może powinniśmy dodać tutaj przecinek i quote.self. Odpowiedź brzmi nie. W przypadku SwiftData, ponieważ nasza książka ma relację z cytatem, SwiftData jest wystarczająco inteligentny, aby to wiedzieć i stworzy naszą tabelę w bazie danych za pierwszym razem, gdy ją znajdzie, a kontekst będzie o tym tabeli świadomy. Udowódmy to, uruchamiając teraz naszą aplikację. Mimo że dodaliśmy nowy model do naszej bazy danych i dodaliśmy nowe właściwości, SwiftData, której nauczyliśmy się w ostatnim filmie, poradził sobie z tym doskonale, i nasza aplikacja uruchomiła się. Teraz, jeśli zlokalizuję tę bazę danych SQLite z tego adresu URL w konsoli i otworzę ją za pomocą naszej aplikacji przeglądarki SQLite, zobaczysz, że została utworzona nowa tabela cytatu. I jeśli przejrzymy dane naszego cytatu, zobaczysz, że jest tu pole dodane dla książki, ale nie wprowadzono jeszcze żadnych rekordów. To ma sens. Kiedy jednak przeglądamy dane naszej książki, nie zobaczymy żadnej wzmianki o tablicy cytatu. Stwórzmy więc sposób na dodawanie książek i zobaczmy, jak to działa. Chcę stworzyć widok, który pozwoli nam nie tylko przeglądać wszystkie cytaty z książki, ale także pozwoli nam dodawać nowe, usuwać je lub nawet edytować istniejące. Widok ten jest całkiem podstawowy, ale zawiera kilka widoków warunkowych. Stwórzmy więc plik SwiftUI i nazwijmy go `QuotesListView`. Ponieważ będziemy aktualizować i dodawać dane, będę potrzebować dostępu do kontekstu z otoczenia, więc będę potrzebować właściwości otoczenia dla tego, którą nazywam ModelContext. Ponieważ chcemy przeglądać wszystkie cytaty dla konkretnej książki, gdy osiągniemy ten widok, kliknęliśmy przycisk w naszym widoku edycji, który jeszcze nie został utworzony, ale który przekroczy tę książkę do tego widoku. Stwórzmy więc stałą dla tej książki, która jest typu book.

```swift
    @Environment(\.modelContext) private var modelContext
    let book: Book
```

Nasza wersja podglądu teraz generuje błąd, ponieważ nie mamy książki. Jeśli chcemy przetestować ten widok w naszym podglądzie, będziemy musieli użyć naszego kontenera podglądu, aby dodać książki do podglądu w pamięci. Stwórzmy więc właściwość dla tego. Będziemy musieli przekazać book.self do naszej instancji podglądu. Musimy również uzyskać dostęp do jednej konkretnej książki podczas projektowania naszej aplikacji. Po pierwsze, utwórzmy tablicę książek jako books.samples. Teraz mogę użyć tej tablicy i funkcji Preview.AddExamples do dodania i wstawienia ich. Następnie możemy zwrócić nasz widok QuotesListView, dostarczając jedną z tych książek, więc użyję książki o indeksie 4. A następnie możemy zastosować funkcję ModelContainer, używając PreviewContainer. Będę przechodzić do tego widoku za pomocą stosu nawigacji, więc umieśćmy podgląd w nawigacji, abyśmy mogli zobaczyć jakiekolwiek tytuły, które może dodać. 

```swift
#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    preview.addExamples(books)
    return NavigationStack {
        QuotesListView(book: books[4])
            .modelContainer(preview.container)
    }
}
```

Cóż, data utworzenia cytatu zostanie utworzona automatycznie i nie może zostać zmieniona. Więc nie potrzebujemy dla niej żadnych właściwości. Ale podczas tworzenia lub edycji będą wymagane numer strony i tekst cytatu. Będziemy używać pól tekstowych do tego celu. Stworzę więc dwie właściwości stanu dla tych dwóch właściwości książki i zainicjuję je jako puste ciągi znaków. Ponieważ strony nie zawsze muszą być numerami. Mogą być na przykład 1a, 2a lub niektóre indeksy używają rzymskich cyfr. Jak wspomniano, będziemy używać tego widoku do wyświetlania listy istniejących cytatów.



Więc jeśli kliknę jeden z nich na liście, chcę być w stanie edytować i zaktualizować zawartość. Stworzę więc dwie kolejne właściwości. Pierwsza z nich będzie stanową właściwością dla wybranego cytatu. To jest ten, na który kliknąłem. Ale jeśli jeszcze na żaden nie kliknąłem, nie istnieje. Zatem jest to opcjonalny cytat. Następnie użyję prostej właściwości obliczeniowej o nazwie isEditing, która będzie właściwością typu Boolean i po prostu zwróci, czy wybrany cytat nie jest równy nil. Więc jeśli jestem w trybie edycji, nie jest nil.

```swift
    @State private var text = ""
    @State private var page = ""
    @State private var selectedQuote: Quote?
    var isEditing: Bool {
        selectedQuote != nil
    }
```

Teraz mam wszystko, co potrzebuję, aby stworzyć mój widok. Zastąpię tutaj ciało grupy box, gdzie stworzymy nasze dwa pola tekstowe zarówno do dodawania, jak i edycji. Wewnątrz grupy box stworzę HStack. A dla pierwszego elementu utworzę widok zawartości z etykietą, który pozwala mi utworzyć klucz tytułu i zawartość. Dla klucza tytułu użyję ciągu znaków "Strona". Dla zawartości stworzę pole tekstowe, gdzie kluczem tytułu będzie ciąg znaków "Numer strony". I będzie to powiązane z naszą właściwością stanu strony. Pozwolimy na wprowadzanie zarówno liczb, jak i tekstów, ponieważ niektóre strony, na przykład w indeksach, nie są numeryczne. Ale chcemy się upewnić, że nie dostajemy autokorekty. Zatem sprawdźmy, czy jest to wyłączone. I ustawmy styl pola tekstowego na zaokrąglony obramowanie. Ustawię szerokość na 150. Następnie dodaj Spacer(). 

```swift
        GroupBox {
            HStack {
                LabeledContent("Page") {
                    TextField("page #", text: $page)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    Spacer()
                }
            }
        }
```

Po odstępie chcę stworzyć dwa przyciski. Ale pierwszy z nich jest wyświetlany tylko wtedy, gdy jesteśmy w trybie edycji, i będzie to przycisk Anuluj, który po prostu wyczyści nasze pola. Dla akcji po prostu zresetujemy strony i tekst do pustych ciągów znaków. I ustawmy z powrotem wybrany cytat na nil. 

```swift
                if isEditing {
                    Button("Cancel") {
                        page = ""
                        text = ""
                        selectedQuote = nil
                    }
                    .buttonStyle(.bordered)
                }
```

Drugie oznaczenie przycisku będzie zależało od tego, czy jesteśmy w trybie edycji. Jeśli edytujemy, użyję ciągu znaków "Aktualizuj", w przeciwnym razie będzie to "Utwórz". A następnie dla akcji, jeśli edytujemy, chcemy po prostu zaktualizować właściwości wybranego cytatu. Nasz wybrany cytat zostanie ustawiony na tekst. Wybrany cytatu strony zależy od tego, czy strona jest pusta. Jeśli jest pusta, zrobimy ją nil, w przeciwnym razie przypiszemy zawartość tej zmiennej strony. Następnie zresetujemy zarówno stronę, jak i tekst do pustych ciągów znaków i ustawimy wybrany cytat na nil. Cóż, jeśli nie jesteśmy w trybie edycji, musimy być w trybie dodawania, więc możemy tutaj utworzyć instrukcję else. Musimy utworzyć nowy cytat, używając naszego inicjalizatora, ale pamiętaj, że nasza strona jest opcjonalna, więc naprawdę mamy dwie różne metody konstruowania nowego cytatu, jedną tylko z tekstem, a drugą z tekstem i numerem strony. Zatem mogę tutaj stworzyć operator ternarny, który będzie zależał od tego, czy strona jest pusta. Jeśli tak, po prostu stworzymy cytat, używając argumentu tekstowego. W przeciwnym razie dostarczę zarówno tekst, jak i stronę. Mamy naszą książkę, która jest przekazywana, i ma opcjonalną tablicę cytatów, więc mogę użyć funkcji append na tej opcjonalnej tablicy, aby dodać ten nowy cytat. A następnie mogę zresetować tekst i stronę na pusty ciąg znaków. Dla przycisku, ustawmy styl na zaokrąglone obramowanie. I również wyłączmy go, jeśli nasz tekst jest pusty. 

```swift
                Button(isEditing ? "Update" : "Create") {
                    if isEditing {
                        selectedQuote?.text = text
                        selectedQuote?.page = page
                        page = ""
                        text = ""
                        selectedQuote = nil
                    } else {
                        let quote = page.isEmpty ? Quote(text: text) : Quote(text:text,page: page)
                        book.quotes?.append(quote)
                        text = ""
                        page = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(text.isEmpty)
```

Ponieważ nadal potrzebujemy widoku tekstu, który pozwoli nam tworzyć lub edytować tekst, poniżej HStack, stworzę edytor tekstu powiązany z tą zmienną tekstową. Następnie ustawmy obramowanie na drugorzędny kolor i zastosujmy ramkę o wysokości 100. 

```swift
            TextEditor(text: $text)
                .border(Color.secondary)
                .frame(height: 100)
```

I wreszcie, dodajmy nieco poziomego wcięcia dla całej grupy.

```swift
    var body: some View {
        GroupBox {...}
        .padding(.horizontal)
    }
```

Teraz, gdy mamy już ustawione pole dodawania i edycji, stwórzmy widok listy, aby wyświetlić istniejące cytaty i umożliwić wybór jednego z nich do edycji lub usunięcia przesuwając w lewo. Zacznijmy od listy, ale wewnątrz niej użyjemy pętli `ForEach`, ponieważ chcę użyć funkcji usuwania. Cytaty, które chcę wyświetlić, są właściwościami przekazanej książki. Problem polega na tym, że nie znam kolejności sortowania. Dlatego stworzę obliczoną właściwość `sortedQuotes`, która będzie wynikiem sortowania opcjonalnej tablicy `book.quotes` za pomocą komparatora klucza `quote.creationDate`. Ponieważ `quotes` jest opcjonalne, `sortedQuotes` będzie również opcjonalne. Jeśli tak jest, przypiszę mu pustą tablicę, aby nie było już opcjonalne.



```swift
let sortedQuotes = book.quotes?.sorted(using: KeyPathComparator(\Quote.creationDate)) ?? []
```

 Teraz możemy użyć pętli `ForEach` do iteracji przez te posortowane cytaty. Ponieważ jest to model Swift Data, już jest identyfikowalny, więc nie muszę podawać ID, ale dostarczy mi obiekt `quote`, który mogę użyć do wyświetlenia informacji. Zacznijmy od `VStack`, gdzie `alignment` jest ustawione na `leading`. Wewnątrz `VStack` zaczniemy od `TextView` wyświetlającego `quote.creationDate`. Ponieważ jest to data, muszę określić format jako `.dateTime`. Mogę również określić trzy inne właściwości: miesiąc, dzień i rok. Ustawię czcionkę na rozmiar `caption` i kolor na `secondary`. Następnie dodam kolejny `TextView` wyświetlający tekst cytatu. Następnie chcę wyświetlić numer strony, ale tylko jeśli `quote.page` nie jest opcjonalne lub jeśli właściwość `page` nie jest pusta. 

```swift
            ForEach(sortedQuotes) { quote in
                VStack(alignment: .leading) {
                    Text(quote.creationDate,format:
                            .dateTime.month().day().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    Text(quote.text)
                }
            }
```

Najpierw stworzę `HStack`, a potem dodam `Spacer`, aby przesunąć go w prawo. Następnie użyję `if let page = quote.page`, aby je rozpakować, ale również sprawdzę, czy nie jest puste, aby ustalić, czy muszę dodać tę stronę. Jeśli te warunki są spełnione, mogę stworzyć `TextView` wyświetlający napis "Page:", a następnie numer strony za pomocą interpolacji ciągu znaków.

```swift
                    HStack{
                        Spacer()
                        if let page = quote.page, !page.isEmpty {
                            Text("Page: \(page)")
                        }
                    }
```

Teraz, jeśli chcę mieć możliwość edycji, będę musiał klikać na jednym z tych wybranych wierszy i ustawić wybrany cytat na odpowiadający mu cytat. Aby upewnić się, że cały wiersz może być docelowym punktem klikania, użyję `contentShape` i ustawię go na `rectangle`. 

```swift
                VStack(alignment: .leading) {...}
                .contentShape(Rectangle())
```

Teraz mogę utworzyć `onTapGesture`. W zamknięciu ustawię wybrany cytat na cytat, który został kliknięty, a następnie ustawię `text` jako właściwość stanu, która ma być przypisana do tekstu cytatu. Właściwość stanu `page` zostanie przypisana do strony cytatu, ale jest to opcjonalne, więc możemy użyć pustego ciągu znaków, jeśli jest. 

```swift
                .onTapGesture {
                    selectedQuote = quote
                    text = quote.text
                    page = quote.page ?? ""
                }
```

Ostatnim elementem tego układanki jest możliwość usunięcia cytatu przesuwając go palcem. Będziemy potrzebowali modyfikatora `onDelete` dla elementu `ForEach`, który dostarczy nam `index set`. Możemy wykonać nasze usuwanie w bloku animacji. Następnie możemy przejść przez każdy `index set` za pomocą `indexSet.forEach`. To dostarczy nam indeksu. A następnie możemy sprawdzić, czy cytatem jest ten w naszych `book.quotes` na tym indeksie. Jeśli tak, możemy użyć kontekstu, aby usunąć cytat. Pamiętaj, że utworzyliśmy zmienną środowiskową, którą nazwaliśmy `modelContext`. 

```swift
            ForEach(sortedQuotes) {...}
            .onDelete { indexSet in
                withAnimation {
                    indexSet.ForEach {index in
                        if let quote = book.quotes?[index] {
                            modelContext.delete(quote)
                        }
                    }
                }
            }
```

Ustawmy styl listy na plain i dodajmy tytuł nawigacyjny o napisie "Quotes". Teraz, gdy ten widok zostanie dodany do stosu nawigacji, pasek tytułowy będzie wyświetlany inline, a nie jako osobny pasek nawigacyjny. 

```swift
    var body: some View {
        GroupBox {...}
        .padding(.horizontal)
        List{...}
        .listStyle(.plain)
        .navigationTitle("Quotes")
    }
```

To jest teraz ustawienie domyślne. Ale jeśli chcemy zobaczyć, jak to naprawdę wygląda, możemy zastosować ten `navigationBarTitleDisplayMode` na `inline` do naszej podglądu. 

```swift
#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    preview.addExamples(books)
    return NavigationStack {
        QuotesListView(book: books[4])
            .navigationBarTitleDisplayMode(.automatic)
            .modelContainer(preview.container)
    }
}
```

 Z tym miejscem możemy przetestować ten widok i dodać oraz edytować kilka cytatów. Mogę dodać jeden z numerem strony, a zobaczymy, że data, cytat i numer strony pojawiają się w wierszu listy.

Kolejne są dodawane. Jeśli dodam jeden bez numeru strony, `pageTextView` się nie pojawi. Teraz będziemy musieli zapewnić sposób na uzyskanie tego podglądu z naszego widoku `editBookView`. Więc w widoku `editBookView` i poniżej `text editor`, chcę utworzyć `navigation link`. Docelowy widok to będzie `QuotesListView`, przekazując w nim `book`. Dla etykiety chcę wyświetlić bieżącą liczbę cytatów, więc utworzę stałą dla tego, która będzie to `book.quotes.count`, która jest opcjonalną wartością, więc jeśli jest opcjonalna, wyświetlimy ją jako zero. Następnie mogę utworzyć widok etykiety, używając kluczy tytułów ze string interpolation, aby wyświetlić liczbę, a następnie słowo "quotes", i użyć systemowego obrazka `quote.opening`. I ustawiam styl przycisku na `Bordered` oraz stosuję ramkę z `maxWidth` na `infinity` i wyrównanie do prawego krawędzi, aby przesunąć go do krawędzi prawej. I dodam trochę więcej poziomego odstępu. 

```swift
            NavigationLink {
                QuotesListView( book: book)
            } label : {
                let count = book.quotes?.count ?? 0
                Label("\(count) Quotes",systemImage:"quote.opening")
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment:.trailing)
            .padding(.horizontal)
```

Wracam do widoku listy książek i podglądu, aby to przetestować. Wybieram jedną z książek, które mam tutaj i widzę, że nie ma żadnych cytatów. Mogę kliknąć przycisk i dodać dwa cytaty, jeden z numerem strony, a drugi bez. Wygląda to dobrze, numer strony jest wyświetlany tylko wtedy, gdy mam numer strony. Jeśli wrócę do widoku edycji książki, widzę, że teraz mam dwa cytaty odnotowane na moim przycisku `navigation link`. Cóż, wróćmy do widoku cytatu i edytujmy jeden z tych cytatów i zaktualizujmy go. Świetnie. Pozwól mi usunąć jeden z cytatów, ale poprzez przeciąganie. Kiedy wrócę teraz do widoku edycji książki, widzę, że mam tylko jeden zauważony cytat, ale nienawidzę tego, że jest napisane "one quotes". Powinno być napisane "one quote" w liczbie pojedynczej. Cóż, jest na to szybkie rozwiązanie.

Tam, gdzie tworzyliśmy nasz klucz tytułowy etykiety, możemy zastosować to, co nauczyłem się od Paula Hudsona. Zacznij tekst od znaku strzałki, a następnie otocz klucz tytułowy ciągiem w nawiasach kwadratowych. Ten znak strzałki i nawiasy kwadratowe pozwolą nam zastosować atrybut reguły odmiany do tego ciągu, a mianowicie `inflect true`. W ten sposób nasze słowo będzie odpowiednio zapisane z wielką literą. 

```swift
  Label("^[\(count) Quotes](inflect: true)",systemImage:"quote.opening")
```

Teraz zauważ, jak cytaty są wyświetlane w liczbie mnogiej, np. "zero quotes" (zero cytaty)? Jeśli wrócę teraz do widoku listy książek i przetestuję to, "zero quotes" z "S" na końcu książki jest w porządku. Doskonale. Pozwól mi dodać jeden. Teraz widzę, że jest napisane "one quote" w liczbie pojedynczej. Dodajmy kolejny. I teraz widzimy znowu "two quotes" w liczbie mnogiej. Wszystko jest w porządku. Czy na pewno? Aby to sprawdzić, będziemy musieli stworzyć kilka cytatów w naszym symulatorze. Uruchom teraz tę aplikację. Po uruchomieniu dotknij jednej z książek i dodaj kilka cytatów. Wybierz inną i dodaj do niej przynajmniej jeden cytat. Zatrzymajmy aplikację i otwórz edytor SQL dla tej tabeli cytatu, a następnie przejdź do przeglądania danych i policz liczbę cytatu. W moim przypadku mam trzy. Pozwól mi teraz uruchomić aplikację i usunąć jedną z książek, która zawierała kilka cytatów. Usunę tę, która miała dwa cytaty. Po powrocie do mojego przeglądarki SQL i ponownym otworzeniu tej tabeli cytatu do przeglądania danych, zauważę, że rekordy dla książki, którą usunąłem, nie zostały usunięte. To teraz są osierocone cytaty bez przypisanej książki. Zauważ, że teraz związek z książką jest teraz równy null. Pamiętaj, że właściwość książki była opcjonalna? Otóż okazuje się, że domyślne zasady usuwania dla relacji jeden-do-wielu polegają na tym, żeby nie kaskadować usunięć i usuwać całą powiązaną zawartość, taką jak cytaty, ale raczej ustawiać powiązane łącze na null.

Okej, nie jest to to, co chcę. Ale jest szybkie rozwiązanie tego problemu. Najpierw pozwólcie mi ręcznie usunąć te dwa rekordy tutaj, te osierocone. Teraz wróćmy do naszego modelu książki i zastosujmy makro relacji do tego niejawnej właściwości `quotes`. To spowoduje, że stanie się ona jawna i będziemy mogli podać argument `deleteRule`, ustawiając regułę usuwania na `cascade`, zamiast domyślnej `nullify`. Pozwoli to na automatyczne usunięcie cytowań powiązanych z książką, gdy zostanie ona usunięta.

Oto, jak to zrobić:

1. Ręcznie usuń osierocone rekordy z bazy danych.
2. Zaktualizuj swój model `Book` i zastosuj makro relacji do właściwości `quotes`, sprawiając, że relacja staje się jawna, i ustaw `deleteRule` na `cascade`.

```swift
@Model
class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    @Attribute(originalName: "summary")
    var synopsis: String
    var rating: Int?
    var status: Status.RawValue
    var recomendedBy: String = ""
    @Relationship(deleteRule: .cascade)
    var quotes: [Quote]?
  	...
}
```

Po dokonaniu tych zmian reguła kasowania typu `cascade` zapewni, że gdy książka zostanie usunięta, jej powiązane cytaty zostaną automatycznie usunięte, unikając tym samym osieroconych rekordów w bazie danych.

W następnym filmie możesz przejść do wprowadzenia koncepcji pozwalania książce mieć gatunek, takie jak beletrystyka lub literatura faktu.