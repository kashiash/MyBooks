

# Sortowanie i Filtrowanie danych



Do tej pory  używaliśmy makra zapytania, aby pobrać wszystkie nasze książki, i jako klucz sortowania dla naszych książek użyliśmy ścieżki klucza tytułu książki. Widzisz to w podglądzie. Są one posortowane według tytułu. 

```swift
    @Query(sort: \Book.status) private var books: [Book]
```

Możemy zmienić tę ścieżkę klucza tutaj i posortować według autora, a sortowanie zmienia się automatycznie. To całkiem nieźle. Teraz mam jeszcze jedną właściwość, którą chciałbym posortować, a mianowicie status. Jednak gdy zmieniam ścieżkę klucza na status, otrzymuję ten błąd, że makro zapytania wymaga, aby status spełniał protokół Comparable. I czy chcę użyć wartości surowej? Nie, OK, więc zmieńmy to na wartość surową. Tym razem podgląd się zawiesza. I to jest problem, który pojawi się, jeśli używasz enum jako jednej z właściwości i chcesz go posortować lub odfiltrować. Swift Data przechowuje wartość surową enuma bez problemu, ale makro zapytania nie wie, jak ją posortować, a faktycznie zauważymy, że nie możemy jej także odfiltrować, więc będziemy musieli wrócić i przeprowadzić pewne prace nad refaktoryzacją. Więc na razie wróćmy do sortowania według autora lub tytułu i wróćmy do tego, gdy to naprawimy. Cóż, nasz enum ma wartość surową, która jest liczbą całkowitą, i to jest to, co jest przechowywane.



Więc wrócę do mojej definicji modelu, gdzie zdefiniowałem status, i zamiast tworzyć go jako typ status, zmienię to na status.rawValue. Mogłem równie dobrze użyć int, bo to jest rzeczywisty typ, ale podoba mi się to, ponieważ pokazuje mi, że status jest naprawdę powiązany z jakimś enumem. 

```swift
class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var summary: String
    var rating: Int?
    var status: Status.RawValue
...
}
```

Aby naprawić naszą inicjalizację, muszę zmienić miejsce, gdzie jest inicjowana nasza właściwość statusu. Nadal będę akceptować enum podczas tworzenia obiektu, ale gdy przypisuję go do naszej właściwości statusu, będę musiał użyć wartości surowej. 

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
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.summary = summary
        self.rating = rating
        self.status = status.rawValue
    }
```

Właściwość obliczeniowa ikony nie działa już, ponieważ status jest teraz liczbą całkowitą, ale możemy przełączyć na ten status enum, który pochodzi od wartości surowej. Oczywiście będziemy musieli użyć unwrappingu opcjonalnego, ale w tym przypadku to nie stanowi problemu. 

```swift
    var icon: Image {
        switch Status(rawValue: status)! {

        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "books.vertical.fill")
        }
    }
```

W EditBookView mamy trzy błędy z powodu tej zmiany. Nasz picker nadal używa enuma statusu, więc podczas aktualizacji elementu będziemy musieli użyć wartości surowej statusu zamiast tego. W funkcji onAppear będziemy musieli wyodrębnić enum z wartości całkowitej bookStatus. Znowu tutaj używanie unwrappingu opcjonalnego jest całkowicie w porządku. Podobnie, gdy będziemy musieli zaktualizować właściwość obliczeniową change, będziemy musieli zrobić to samo.

```swift
...   
.navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Zapisz") {
                    book.status     = status.rawValue
                  
                    book.rating     = rating
                    book.title      = title
                    book.author     = author
                    book.summary    = summary
                    book.dateAdded  = dateAdded
                    book.dateCompleted = dateCompleted
                    book.dateStarted = dateStarted

                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            status =   Status(rawValue: book.status)!
          
            rating  =   book.rating
            title   =   book.title
            author  =   book.author
            summary =   book.summary
            dateAdded       = book.dateAdded
            dateCompleted   = book.dateCompleted
            dateStarted     = book.dateStarted
        }
}
var changed: Bool {
    status != Status(rawValue: book.status)!
  
    || rating != book.rating
    || title != book.title
    || author != book.author
    || summary != book.summary
    || dateAdded != book.dateAdded
    || dateCompleted != book.dateCompleted
    || dateStarted != book.dateStarted
}
...
```



 

Nasza aplikacja powinna teraz kompilować się bez problemów, a podgląd działa również poprawnie. Mogę teraz zmienić nasze zapytanie, aby sortować według book.status, tego klucza, i rzeczywiście widzimy, że jest sortowane według tego statusu. To działa świetnie. Mogę teraz zmienić nasze zapytanie, aby sortować według book.status, i rzeczywiście widzimy, że jest sortowane według tego statusu. Jednakże, jeśli uruchomię aplikację, aplikacja się zawiesza. Dzieje się tak dlatego, że zmieniliśmy naszą właściwość statusu z enuma na liczbę całkowitą, a nasz kod bazowy Swift Data nie może sobie poradzić z tą zmianą. Podglądy działają dobrze, ponieważ za każdym razem, gdy inicjalizujemy podgląd, inicjalizujemy nowy kontener, który nie ma historii ani pamięci. Jeśli jednak usuniesz aplikację i uruchomisz ją ponownie, zauważysz, że nie dostajemy awarii. Jednakże, straciliśmy nasze stare dane. Dla nas to nie jest zbyt duży problem, ponieważ jeszcze nie wydaliśmy aplikacji i nadal jesteśmy w fazie rozwoju. Jednakże, gdybyśmy zaktualizowali tę aplikację w ten sposób, wszyscy, którzy mają zainstalowaną aplikację, ulegną awarii, a jeśli usuną aplikację, stracą wszystkie swoje dane. W takim przypadku będziemy musieli zająć się migracją danych.



Teraz jest jeszcze trochę za wcześnie w naszej podróży z SwiftData, aby to teraz omawiać, ale z pewnością wrócimy do tego później w serii. Pozwól mi teraz dodać nową książkę i sprawdzić, czy nic się nie zepsuło. Zmienię też status. OK, jesteśmy z powrotem na właściwej ścieżce. Testowanie i refaktoryzacja kodu to coś, co będziesz ciągle robić przez całą swoją karierę programisty. Ważne jest, aby utrzymywać swoje umiejętności na bieżąco i nigdy nie być zbyt zadowolonym z osiągnięć. Zawsze jest coś nowego do nauki. I nie ma lepszego sposobu na naukę niż dzięki Brilliant, sponsora tego wideo. Dzięki Brilliant możesz uczyć się umiejętności w sposób, który nie będzie kosztował cię tysięcy dolarów ani nie będzie wymagał lat szkolenia. Ważne jest, aby nie wkładać wszystkich jajek do jednego koszyka, można by rzec. Weź to odemnie, twoja kariera zaprowadzi cię na wiele ścieżek. Skorzystaj z tego, co Brilliant ma do zaoferowania w obszarach matematyki, nauk o danych i informatyki. Możesz uczyć się w sposób zabawny i interaktywny dzięki tysiącom lekcji, od podstawowych do zaawansowanych tematów.



Przejdźmy teraz do dynamicznego sortowania. Chciałbym teraz dać użytkownikowi możliwość wyboru kolejności sortowania. Aby to zrobić, utworzę picker. Najpierw wróćmy do widoku listy książek i utwórzmy tutaj enuma, który nazwę sortOrder. Będzie to typ String, Identifiable i CaseIterable, dzięki czemu będziemy mogli utworzyć z niego picker. Będzie miał trzy przypadki: status, tytuł i autor. Aby spełnić protokół Identifiable, będziemy mieli właściwość id jako właściwość obliczeniową self, która zwraca self.

```swift
enum SortOrder: String, Identifiable, CaseIterable {
    case status, title, author
    var id: Self {
        self
    }
}
```

 Teraz utwórzmy zmienną o nazwie sortOrder, która będzie jednym z tych rodzajów sortowania, i domyślnie ustawimy ją na status. 

```swift
 @State private var sortOrder = SortOrder.status
```

Ponieważ jest to pierwszy element na stosie nawigacji, możemy teraz utworzyć naszego pickera. Możemy pozostawić puste pole dla etykiety, ale będziemy wiązać wybór z sort order. Następnie wewnątrz tego pickera możemy utworzyć pętlę "for each" i użyć sortOrders.allCases, ponieważ uczyniliśmy go CaseIterable. To dostarczy nam sort order, który możemy użyć do utworzenia naszego widoku tekstowego dla naszego wyświetlacza. W tym przypadku użyjemy widoku tekstowego z wyrażeniem string (sortBy), a następnie użyjemy interpolacji ciągu znaków, aby wygenerować surową wartość sort order. Następnie ustawimy tag na sort order jako Int, a także nadamy styl przycisku jako bordered.

```swift
        NavigationStack {
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)")
                }
            }
            .buttonStyle(.bordered)
          ...
        }
```

Nasz picker teraz pozwala nam zmieniać strukturę. Jednakże, jeszcze nic nie zostało zrobione w tej sekcji. Teraz problem polega na tym, że nasza makro-kwerenda sortuje według stałej ścieżki klucza, a my chcemy, aby była dynamiczna na podstawie dokonanego wyboru. Aby to osiągnąć, musimy przenieść kwerendę i jej listę do oddzielnego widoku, dzięki czemu będziemy mogli ponownie zainicjować kwerendę za każdym razem, gdy dokonany zostanie wybór. Tworzymy więc nowy widok SwiftUI, który nazwiemy `BookListView`. Importuję SwiftData. Ten widok będzie zawierał cały kod naszego listowania, włącznie z usuwaniem elementów z listy oraz ustalaniem kolejności sortowania. Jeśli zamierzamy usuwać, będziemy potrzebowali dostępu do kontekstu modelu, co możemy uzyskać z otoczenia. Przeniesiemy naszą kwerendę do tego widoku. Na razie przeniesiemy właściwość kontekstu otoczenia i kwerendę do tego widoku. Wkrótce zmienię kwerendę.

```swift
struct BookList: View {
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]
```

Więc wycinam całą grupę, wracam do listy książek i zamieniam całe ciało widoku na tę grupę.  

```swift
    var body: some View {
        Group {
            if books.isEmpty {
                ContentUnavailableView("Wprowadź pierwszą książkę", systemImage: "book.fill")
            } else {
                List {
                    ForEach(books) { book in
                        NavigationLink{
                            EditBookView(book:book)
                        } label: {
                            HStack(spacing: 10) {
                                book.icon
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.title2)
                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                    if let rating = book.rating {
                                        HStack {
                                            ForEach(1..<rating, id:\.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.yellow)
                                            }
                                        }
                                    }
                                }

                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach{ index in
                            let book = books[index]
                            context.delete(book)
                        }
                    }

                }
                .listStyle(.plain )

            }
        }
    }
```



Teraz wracamy do widoku BooklistView, gdzie wycięliśmy tę grupę, i prezentujemy Booklist.

```swift
... 
				NavigationStack {
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)")
                }
            }
            .buttonStyle(.bordered)
            BookList(sortOrder: sortOrder)
            .navigationTitle("Moje książki")
            .toolbar{..}
          ...
        }
...
```

Cóż, podgląd w BooklistView działa świetnie. Ale sama lista książek nie wyświetla żadnych treści. To dlatego, że nie mamy kontenera podglądu. Możemy to naprawić w ten sam sposób, który nauczyliśmy się w ostatniej lekcji. Najpierw stworzymy obiekt podglądu, używając struktury podglądu i przekazując book.self jako nasz model. Następnie możemy wywołać funkcję add examples dla podglądu, aby przekazać tę statyczną tablicę przykładowych książek. Wreszcie możemy zwrócić listę książek i wywołać metodę modelu kontenera na tym widoku, dostarczając ten kontener podglądu. Teraz, jeśli umieścimy tę listę książek w stosie nawigacyjnym, w podglądzie i ją zwrócimy, otrzymamy teraz w pełni funkcjonalny widok.

```swift
#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    return BookListView()
        .modelContainer(preview.container)
}
```

 Teraz możemy zająć się przekazywaniem określonego porządku sortowania. W widoku listy książek możemy usunąć sortowanie z naszego zapytania, i w ten sposób pobierze ono całą listę książek w żadnej określonej kolejności.  Chcemy przekazać wybór sortowania, który jest typem enum. Więc stwórzmy dla tego widoku inicjalizator, który pozwoli nam przekazać ten enum i zaktualizować nasze zapytanie z makra odpowiednio. Będzie to inicjalizator, który otrzyma porządek sortowania typu sort order.

```swift
struct BookList: View {
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]

    init(sortOrder: SortOrder) {
        let sortDescriptors: [SortDescriptor<Book>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
        case .title:
            [SortDescriptor(\Book.title)]
        case .author:
            [SortDescriptor(\Book.author)]
        }
        _books = Query(sort: sortDescriptors)
    }
```

Następnie w tym inicjalizatorze możemy określić nasz porządek sortowania. Gdy przypadek to status, będziemy chcieli sortować zarówno według statusu, jak i tytułu. Dlatego nie możemy użyć tego samego jednoelementowego klucza, który mieliśmy do tej pory. Możemy zrobić tablicę tzw. sort descriptors, które przyjmują porównywalny klucz. Stwórzmy właściwość o nazwie sortDescriptors, która będzie tablicą tych sortDescriptorów, ale będziemy musieli określić, na jakim typie modelu chcemy to posortować, czyli będzie to typ book. Teraz możemy użyć nowego inline switch, który został wprowadzony w tym roku, aby uzyskać wszystkie trzy przypadki. Dla statusu nasza tablica będzie zawierać dwa sortDescriptors. Najpierw będziemy sortować według statusu książki, a następnie według tytułu. Dla tytułu będziemy sortować po samym tytule. Możemy użyć pojedynczego sort descriptor'a do sortowania według book.title. Podobnie dla autora, użyjemy sort descriptor'a, który sortuje według book.author. Możemy tego użyć do aktualizacji naszego zapytania makra dla książek. Robimy to, umieszczając podkreślnik przed books, a następnie możemy określić nasze zapytanie bez znaku @ i przekazać nasze sorty, czyli sort descriptors. Aby naprawić podgląd, będziemy musieli określić przykładowy porządek sortowania. Użyjmy na przykładu statusu. A potem w widoku Booklist, będziemy musieli zaktualizować wywołanie booklist, przekazując nasz porządek sortowania. Świetnie.

## Filtrowanie

Teraz możemy sortować według dowolnego wyboru, jaki chcemy. Teraz, gdy już mamy sortowanie, spójrzmy na filtrowanie. Mamy wiele książek, byłoby świetnie, gdybyśmy mieli sposób na wyszukiwanie pasującego ciągu znaków na podstawie autora lub tytułu. I to jest idealne do zrealizowania przy użyciu metody SwiftUI - searchable. Wróćmy więc do widoku BookListView i dodajmy właściwość stanu, którą będziemy mogli użyć dla pola tekstowego naszego wyszukiwania i zainicjujmy ją początkowo jako pusty ciąg znaków. Nazwiemy to `filter`. 

```swift
  @State private var filter = ""
```

Następnie do widoku BookListView dodamy modyfikator `searchable`, gdzie tekst będzie związany z tą właściwością `filter`. A dla podpowiedzi możemy użyć widoku tekstowego z ciągiem `"Filtruj według tytułu lub autora"`. 

```swift
            BookList(sortOrder: sortOrder)
                .searchable(text: $filter, prompt: "Filtruj po tytule lub autorze")
```

Teraz, filtrowanie będzie rzeczywiście wykonywane na książkach w naszej liście książek (`Booklist`), która jest tym drugim widokiem, który stworzyliśmy. Więc będziemy musieli przekazać ten ciąg do filtru w jego inicjalizatorze. Dlatego, dopóki jesteśmy tutaj, dodajmy kolejny argument do `booklist`, nazwijmy go `filterString` i przekażmy w nim ten `filter`. 

```swift
BookList(sortOrder: sortOrder, filterString: filter)
```

Oczywiście, `Booklist` nie ma jeszcze inicjalizatora dla tego filtru, więc w tym widoku `Booklist` dodajmy do inicjalizatora argument `filterString`, który jest typu `String`. Następnie możemy naprawić podgląd, podając pusty ciąg znaków jako `filterString`.

```swift

    return NavigationStack {
        BookList(sortOrder: .status, filterString: "")
            .modelContainer(preview.container)

```

 Swift Data używa nowego makra `predicate`, aby filtrować nasze dane ładowane w zapytaniu. Aby zdefiniować predykat, będziemy musieli określić typ, na którym wykonujemy filtrowanie. W naszym przypadku będzie to typ `book`. Więc utworzymy predykat, używając makra `predicate` dla `book`. I to da nam książkę jako iterator, który możemy użyć w naszym porównaniu filtru. Na przykład chcemy zwrócić lub filtrować książki, jeśli możemy utworzyć porównanie, które jest prawdziwe. Na przykład, jeśli tytuł książki zawiera nasz ciąg `filterString`, lub autor książki zawiera ten ciąg `filterString`. Problem tutaj polega jednak na tym, że funkcje takie jak `contains` i inne porównania ciągów znaków są wrażliwe na wielkość liter.

Więc `book` z wielkiej litery B nie jest tym samym co `book` z małej litery b. Gdybyśmy filtrowali tablicę za pomocą funkcji filtrującej, moglibyśmy użyć funkcji `lowercase` na tytule książki i autorze książki. Niestety jednak jesteśmy tu poinformowani, że funkcja `lowercase` nie jest obsługiwana w predykatach. Na szczęście jednak mamy alternatywę, która to umożliwia, a jest nią metoda `localizedStandardContains`. 

```swift
        let predicate = #Predicate<Book> { book in
            book.title.localizedStandardContains(filterString)
            || book.author.localizedStandardContains(filterString)
            || filterString.isEmpty
        }
     
```

Jest to szczególnie dobre, ponieważ porównania będą niewrażliwe na wielkość liter, a także będą obsługiwać różne typy znaków, takie jak akcenty w innych językach. Będzie to bardzo przydatne, gdy przystąpimy do lokalizacji naszej aplikacji. Ta metoda zajmie się filtrowaniem według tytułu, ale chcemy również zwrócić książkę, jeśli autor zawiera ciąg znaków z naszego filtra. Więc możemy dodać tutaj `or` i powtórzyć to dla `author` zawierającego ten ciąg znaków. Jednak jeśli zostawimy to w ten sposób, gdy mamy pusty ciąg znaków, nie zostanie nic zwrócone, dopóki nie wpiszemy czegoś w pole wyszukiwania. Muszę dodać jeszcze jedno `or`, aby zwracać każdą książkę, jeśli ciąg znaków filtra jest pusty. Teraz, mając to już gotowe, możemy po prostu dodać kolejny argument do naszego zapytania, które już mamy przygotowane dla tego sortowania, a mianowicie argument filtra, który jest pierwszym argumentem w tym inicjalizatorze, i potrzebuje predykatu, którego już mamy. 

```swift
   _books = Query(filter: predicate, sort: sortDescriptors)
```

Więc wracając do naszego widoku listy książek, widzimy, że pole filtra jest puste i widzimy wszystkie książki, ale gdy zaczynamy coś wpisywać w polu wyszukiwania, przeszukuje książki lub autorów, którzy zawierają ten ciąg znaków. Na przykład, jeśli wyszukamy ciąg "bl", zobaczymy zarówno autora Gilles Blunt, jak i tytuł książki "Blackout".

Ale zaraz po dodaniu litery "a" otrzymuję dopasowanie tylko do tytułu. Podobnie jeśli wyszukam "law", dostaję książkę napisaną przez autora Johna Lawtona. To kończy pierwszą część, trzy filmy w tej serii Swift Data. Jest dość podstawowy, ale omówiliśmy wszystkie operacje CRUD, kontenery i podglądy kontenerów oraz dynamiczne zapytania, gdzie możemy określić kolejność sortowania i filtr, aby zawęzić wyniki zapytania. Mamy jednak tylko podstawowy model książki. W następnej części tej serii filmów będziemy zajmować się relacjami, gdzie jedna książka może mieć wiele cytatów z tej książki, a my będziemy mieć numery stron dla tych cytatów. Będzie to relacja jeden do wielu. Ale będziemy także mogli dodać inny model o nazwie "genre" i określić, że książka może mieć wiele gatunków. Gatunek może być powiązany z wieloma książkami. To jest znane jako relacja wiele do wielu. Mam nadzieję, że pozostaniesz ze mną w tej podróży po Swift Data.