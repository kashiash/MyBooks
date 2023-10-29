# Relacja wiele do wielu - gatunek literatury



W przeciwieństwie do cytatów, gdzie istnieje relacja jeden-do-wielu między książką a tablicą cytatów, gdzie każda książka może mieć wiele cytatów, każdy cytat jest powiązany tylko z jedną książką. W tym przypadku książka może mieć wiele gatunków, ale każdy gatunek może być powiązany z wieloma różnymi książkami. Gatunek może być czymś takim jak literatura piękna, literatura faktu, romans, tajemnica, itp. Chcemy, aby każdy z gatunków był powiązany z określonym kolorem, aby użytkownik mógł go również wybrać. Będziemy więc potrzebować modelu dla tego nowego obiektu i będziemy musieli zdefiniować jego właściwości. Stwórz nowy plik o nazwie Gatunek i zaimportuj SwiftData. Utwórz nową klasę o nazwie Gatunek i stwórz dwie właściwości, obie typu String - jedną dla nazwy i jedną dla koloru. 

```swift
import SwiftUI
import SwiftData

@Model
class Genre {
    var name: String
    var color: String

    init(name: String, color: String) {
        self.name = name
        self.color = color
    }

}
```

Będziemy przechowywać wartość szesnastkową dla koloru jako ciąg znaków. Upewnij się, że zastosujesz makro model do tej klasy i utwórz inicjalizator. W najprostszej postaci, kolor w formacie szesnastkowym składa się z sześciu cyfr szesnastkowych, które określają jego mieszankę czerwieni, zieleni i niebieskiego, czyli RGB. Innymi słowy, kod koloru szesnastkowego jest skrótem jego wartości RGB, z niewielką konwersją pomiędzy nimi.



Reprezentacje kolorów w formacie szesnastkowym używają 16 bitów do przedstawienia wartości czerwieni, zieleni i niebieskiego koloru. Obecnie nie ma domyślnego sposobu na dostarczenie dla nas ciągu znaków dla tej wartości szesnastkowej, a ja chcę generować widok koloru w SwiftUI. Dzięki inteligentnym ludziom dostępne są pewne rozszerzenia, których możemy użyć. Jednym z nich jest rozszerzenie stworzone przez Maxa Alexandra, dostępne pod tym linkiem 

https://www.linkedin.com/pulse/color-hex-strings-swiftui-uicolor-max-alexander/

. Skopiujmy kod z tego pierwszego okna kodu. Następnie wróć do projektu SwiftUI i utwórz nowy plik nazwij go `uicolor+extension.swift`. Zmień import na `uikit` i wklej tam ten kod. 

```swift
import UIKit

extension UIColor {
    // Initializes a new UIColor instance from a hex string
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        let scanner = Scanner(string: hexString)

        var rgbValue: UInt64 = 0
        guard scanner.scanHexInt64(&rgbValue) else {
            return nil
        }

        var red, green, blue, alpha: UInt64
        switch hexString.count {
        case 6:
            red = (rgbValue >> 16)
            green = (rgbValue >> 8 & 0xFF)
            blue = (rgbValue & 0xFF)
            alpha = 255
        case 8:
            red = (rgbValue >> 16)
            green = (rgbValue >> 8 & 0xFF)
            blue = (rgbValue & 0xFF)
            alpha = rgbValue >> 24
        default:
            return nil
        }

        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }

    // Returns a hex string representation of the UIColor instance
    func toHexString(includeAlpha: Bool = false) -> String? {
        // Get the red, green, and blue components of the UIColor as floats between 0 and 1
        guard let components = self.cgColor.components else {
            // If the UIColor's color space doesn't support RGB components, return nil
            return nil
        }

        // Convert the red, green, and blue components to integers between 0 and 255
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)

        // Create a hex string with the RGB values and, optionally, the alpha value
        let hexString: String
        if includeAlpha, let alpha = components.last {
            let alphaValue = Int(alpha * 255.0)
            hexString = String(format: "#%02X%02X%02X%02X", red, green, blue, alphaValue)
        } else {
            hexString = String(format: "#%02X%02X%02X", red, green, blue)
        }

        // Return the hex string
        return hexString
    }
}
```

To pozwoli nam przechodzić między kolorami `UIColor` a ciągami znaków w formacie szesnastkowym, ale chcemy stworzyć widok koloru w Swift, więc będziemy potrzebować drugiego rozszerzenia. Wróćmy więc na bloga Maxa i skopiuj zawartość drugiego okna kodu. Z powrotem w Xcode, utwórz kolejny plik i nazwij go `color+extension`. Następnie wklej skopiowany kod, zmieniając import na `SwiftUI`. 

```swift
import SwiftUI

extension Color {
    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self.init(uiColor: uiColor)
    }

    func toHexString(includeAlpha: Bool = false) -> String? {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }
}
```

Teraz możemy wrócić do naszego modelu gatunku i zmienić import na `SwiftUI`. Możemy utworzyć obliczeniową właściwość dla koloru szesnastkowego, która jest typu `Color`. Użyj nowego inicjalizatora `Color` do przekazania wartości szesnastkowej `self.color`, a jeśli z jakiegoś powodu nie uda się go zainicjalizować, dostarczymy kolor czerwony.

```swift
import SwiftUI
import SwiftData

@Model
class Genre {
    ...

    var hexColor: Color {
        Color(hex: self.color) ?? .red
    }
}
```



Teraz, gdy mamy nasz model, możemy ustalić relację między naszym modelem książki a gatunkiem. Jak wspomniałem, każda książka może mieć dowolną liczbę gatunków lub w ogóle żadnego, co będzie miało miejsce, gdy tworzymy naszą książkę. Ponieważ patrzę w przyszłość, gdzie będziemy chcieli korzystać z CloudKit, ma to sens, aby tutaj właściwości były opcjonalne. W naszej klasie książki utworzę nową właściwość, nazwę ją "genres", i będzie to opcjonalna tablica obiektów typu gatunek. 

```swift
    var genres: [Genre]?
```

Jeśli przełączę się do klasy gatunku, zrobię odwrotnie, i utworzę zmienną dla książek, która będzie opcjonalną tablicą książek. 

```swift
 var books: [Book]?
```

Nie chcę usuwać wszystkich gatunków z tablicy gatunków książki, jak to robiliśmy z komentarzami, gdy usuwamy jedną z naszych książek. Chcemy po prostu używać domyślnej wartości nullify, ale chcę być tutaj bardziej wyraźny i określić, żeby były to gatunki i określić odwrotność relacji, gdzie nasz gatunek to gatunek.książki. 

```swift
    @Relationship(inverse: \Genre.books)
    var genres: [Genre]?
```

Nie muszę robić nic więcej po drugiej stronie tej relacji. Teraz, gdy aplikacja się uruchamia, znowu nie muszę niczego specjalnego robić tutaj, aby nasz punkt wejścia wiedział, że mamy kolejny schemat, ponieważ książka zawiera właściwość dla tego nowego gatunku, więc jak w przypadku cytatów, SwiftData poradzi sobie z tym dla nas. Podczas procesu projektowania i testowania chciałbym mieć jakieś przykłady do pracy. Więc w naszym folderze z podglądem zawartości, utworzę kolejny nowy plik, nazwę go "genre samples". Tutaj utworzę rozszerzenie dla klasy gatunek i utworzę statyczną właściwość o nazwie "sampleGenres", która będzie tablicą obiektów typu gatunek, i możemy zacząć od pustej tablicy. Dopiszmy ze cztery gatunki.

```swift
import Foundation

extension Genre {
    static var sampleGenres: [Genre] {
        [
            Genre(name: "Fiction", color: "00FF00"),
            Genre(name: "Non Fiction", color: "0000FF"),
            Genre(name: "Romance", color: "FF0000"),
            Genre(name: "Thriller", color: "000000"),
        ]
    }
}
```

Pierwszy gatunek nazwę "Literatura piękna" i ustawię kolor na zielony, czyli szesnastkowo 00FF00. Skopiuję to jeszcze trzy razy i zmienię, aby ustawić kolory na: niebieski (0000FF) dla drugiego, czerwony (FF0000) dla romansu i czarny (000000) dla thrillery. Następnie, jeśli chcemy użyć ich w naszym podglądzie, chcę dodać je do naszego kontenera podglądu. Przejdę więc do widoku listy książek `BookListView`, gdzie stworzę właściwość dla przykładowych książek oraz dla przykładowych gatunków, używając statycznych właściwości z rozszerzenia. Następnie zmienię tę pierwszą funkcję, aby wywoływała `previewAddExampleBooks`, a dla drugiej dodam przykłady naszych gatunków.

```swift
#Preview {
    let preview = Preview(Book.self)

    let books = Book.sampleBooks
    let genres = Genre.sampleGenres

    preview.addExamples(books)
    preview.addExamples(genres)
  
    return BookListView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "GB"))
}
```



 Mamy teraz wiele plików w naszym nawigatorze, więc chciałbym je zorganizować, zanim pójdę dalej. Zatem pierwszą rzeczą, jaką zrobię, to wybiorę widok listy książek, listę książek, widok nowej książki i widok edycji książki, zaznaczę je wszystkie i utworzę nową grupę z tego zaznaczenia, nazwiję ją po prostu "Books". Możesz organizować pliki według własnego uznania, to tylko sposób, w jaki ja to robię. Następnie wybiorę moje trzy modele, książkę, cytat i gatunek, i utworzę z nich nową grupę, nazywając ją "Models". Mam dwie rozszerzenia, więc je zaznaczę i utworzę grupę nazwaną "Extensions". Mam tylko jeden widok cytatu, ale może lepiej będzie zaznaczyć go i utworzyć osobną grupę, którą nazwę "Quotes". Przenieśmy go powyżej "Books".Następnie wybiorę widok ocen i utworzę z niego nową grupę, którą nazwę "Accessory View". Teraz w nawigatorze możesz wybrać dowolny folder lub przejść na najwyższy poziom w dowolnym momencie i użyć klawisza opcji oraz strzałek w lewo lub w prawo, aby zwijać lub rozwijać wszystkie grupy folderów. 

## GenresView

Stwórzmy teraz widok, który pozwoli nam zobaczyć wszystkie dostępne gatunki w liście, jednocześnie umożliwiając wybór tych, które mogą być związane z wybraną książką. Zacznijmy od utworzenia grupy, którą nazwę "Gatunek", która będzie zawierała wszystkie pliki związane z tym zagadnieniem. Wewnątrz niej utworzymy nowy plik SwiftUI, który nazwę "GenresView", i zaimportujemy SwiftData. Ten widok będzie prezentowany jako modalny arkusz, więc będziemy musieli uzyskać dostęp do kluczowego środowiska "dismiss" i utworzyć zmienną dla tego celu. Będę również potrzebował dostępu do kontekstu, ponieważ będę prezentować listę z przesunięciem palca. Zdefiniujmy więc kolejną zmienną środowiskową dla klucza "modelContext", którą przypiszę do zmiennej o nazwie "context". Zapytanie będzie otrzymywane z obiektu książki z widoku edycji książki, gdzie będę miał przycisk do wyświetlenia arkusza. Tym razem jednak chcę otrzymać książkę jako obiekt typu "BindableObject". Oznacza to, że będziemy mogli dokonywać zmian bezpośrednio w dowolnej właściwości książki, a zostaną one zaktualizowane i zapisane przez SwiftData. Aby wyświetlić listę wszystkich gatunków przechowywanych w naszej tabeli gatunków, mogę użyć makra "query" i podać kolejność sortowania według ścieżki klucza "name". To da nam tablicę gatunków.

```swift
struct GenresView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var book: Book
    @Query(sort:\Genre.name) var genres: [Genre]
    
    var body: some View {
        Text("Hello, World!")
    }
}
```

 Teraz poprawmy ten podgląd, abyśmy mogli z nim pracować. Możemy zrobić to samo, co w przypadku widoku listy książek. Mogę utworzyć instancję struktury podglądu, przekazując `book.self`, dzięki czemu otrzymamy wszystkie nasze modele.Pamiętaj, że książka ma również relacje z gatunkiem. Stworzę właściwości dla przykładowych książek i gatunków. Następnie dodam te przykłady do naszego dostawcy podglądu. Następnie mogę wybrać jedną z tych książek, na przykład tę o indeksie 1, i jeden z gatunków, na przykład ten o indeksie 0, i dodać go. Następnie mogę zwrócić ten widok gatunków, przekazując tę samą książkę. Użyję kontenera podglądu dla naszego kontenera modelu. 



```swift
#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    let genres = Genre.sampleGenres

    preview.addExamples(genres)
    preview.addExamples(books)
    books[1].genres?.append(genres[0])
    return GenresView(book: books[1])
        .modelContainer(preview.container)
}
```

Aby zaprojektować ten widok, na początku zakomentuj trzy linie w podglądzie, które odnoszą się do gatunku. Oznacza to, że nasz widok nie ma jeszcze żadnych gatunków. Chcę to zrobić, ponieważ chcę zastąpić treść widoku widokiem. Jeśli gatunek nie istnieje, chcę wyświetlić widok z informacją o niedostępnej zawartości.

```swift
            if genres.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "bookmark.fill")
                        .font(.largeTitle)
                } description: {
                    Text("You need to create some genres first.")
                } actions: {
                    Button("Create Genre") {

                    }
                    .buttonStyle(.borderedProminent)
                }
            }
```

 Najpierw sprawdzimy, czy gatunki są puste. Następnie utworzę widok z informacją o niedostępnej zawartości, który pozwoli nam podać jakąś treść, opis i akcję przycisku. Dla treści utworzymy obraz, używając systemowego obrazka "bookmark.fill". Ustawmy czcionkę na dużą tytułową. Dla opisu utworzę nowy widok tekstowy i użyję napisu "Musisz najpierw stworzyć jakieś gatunki". A dla akcji utworzę przycisk z etykietą "Utwórz gatunek", ale na razie zostawię akcję dla tego przycisku pustą. Ustawię jednak styl przycisku na wyraźny wypukły. To dotyczy sytuacji, gdy nie ma jeszcze żadnych gatunków. W przeciwnym razie, zakładając, że teraz mamy gatunki, które nie są puste, możemy wyświetlić listę, używając pętli "for each" do iteracji przez każdy gatunek. Będzie to dostarczać nam gatunek, którego możemy użyć do wyświetlenia nazwy gatunku. Obejmijmy całe to wyrażenie if-else w grupie. Następnie umieśćmy tę grupę w nawigacyjnym stosie. Dzięki temu będę mógł zastosować tytuł nawigacyjny "Tytuł książki" do grupy. Teraz widzimy widok z informacją o niedostępnej zawartości, zachęcający do utworzenia gatunku. Jednak jeśli odkomentujemy nasze linie dla gatunku, lista pojawi się. Teraz możemy dostosować nasz widok wewnątrz listy.

```swift
    var body: some View {
        NavigationStack {
            if genres.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "bookmark.fill")
                        .font(.largeTitle)
                } description: {
                    Text("You need to create some genres first.")
                } actions: {
                    Button("Create Genre") {

                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                List {
                    ForEach(genres) { genre in
                        HStack {
                            if let bookGenres = book.genres {
                                if bookGenres.isEmpty {
                                    Button {

                                    } label: {
                                        Image(systemName: "circle")
                                    }
                                    .foregroundColor(genre.hexColor)
                                } else {
                                    Button {

                                    } label: {
                                        Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
                                    }
                                }
                            }
                            Text(genre.name)
                        }
                    }
                }
            }
        }
        .navigationTitle(book.title)
    }
```

Zagnieżdżymy nasz widok tekstowy w hstack. Dla pierwszego elementu w hstack stworzymy przycisk, który będziemy mogli przełączać, aby dodać lub usunąć ten gatunek dla tej książki. Najpierw sprawdzimy, czy bookGenres nie jest puste. Jeśli jest puste, możemy utworzyć przycisk i na razie zostawić pustą akcję. Obraz będzie pochodził z systemowego zestawu, a mianowicie "circle". Nie wiem, dlaczego mój podgląd ciągle mi się zawiesza, ale kiedy edytuję kod, wraca do normy. Dodajmy jeszcze styl wypełnienia (foreground) koloru gatunku. W przeciwnym razie, w klauzuli else, utworzymy przycisk z tą samą pustą akcją, ale etykieta będzie warunkowa, w zależności od tego, czy bookGenre zawiera gatunek czy nie. Jeśli tak, użyjemy "circle.fill", w przeciwnym razie użyjemy po prostu "circle". Ponownie zastosujmy styl wypełnienia koloru hex gatunku. Widzimy, że nasz pierwszy gatunek, "Literatura piękna", musi być tablicą, ponieważ dodaliśmy go w naszym podglądzie. Więc poza naszą strukturą zdefiniujmy funkcję do dodawania lub usuwania gatunków, które zostały przekazane. Nazwijmy ją "addRemoveGenres" z tym jednym parametrem. 

```swift
    func addRemove(_ genre: Genre) {
        if let bookGenres = book.genres {
            if bookGenres.isEmpty {
                book.genres?.append(genre)
            } else {
                if bookGenres.contains(genre),
                   let index = bookGenres.firstIndex(where: {$0.id == genre.id}) {
                    book.genres?.remove(at: index)
                } else {
                    book.genres?.append(genre)
                }
            }
        }
    }
```

Odpakujmy naszą tablicę gatunków książki za pomocą "if let". Następnie, jeśli bookGenres jest puste, możemy dodać nasz gatunek do tablicy bookGenres. W przeciwnym razie, jeśli nie jest puste, musimy sprawdzić, czy istniejąca tablica bookGenres zawiera ten gatunek. Jednocześnie musimy znaleźć indeks, szukając pierwszego indeksu w tablicy bookGenres, gdzie jego id jest równe id gatunku. Jeśli go znajdziemy, możemy go usunąć z tego indeksu. Jeśli nie możemy go znaleźć, musimy go dodać do tablicy bookGenres. Teraz, gdy ta funkcja jest gotowa, możemy ją wywołać w naszych przyciskach akcji, przekazując ten gatunek. 

```swift
if let bookGenres = book.genres {
  if bookGenres.isEmpty {
    Button {
      addRemove(genre)
    } label: {
      Image(systemName: "circle")
    }
    .foregroundColor(genre.hexColor)
  } else {
    Button {
      addRemove(genre)
    } label: {
      Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
    }
    .foregroundStyle(genre.hexColor)
  }
}
```

Teraz możemy dotknąć gatunku, aby dodać go do listy lub usunąć z tablicy gatunków książki. Kontener podglądu aktualizuje naszą książkę w pamięci. 

![2023-10-29_11-07-10 (1)](2023-10-29_11-07-10%20(1).gif)

## NewGenreView

Teraz, gdy możemy prezentować gatunki, będziemy musieli mieć możliwość tworzenia nowych. Zacznijmy od utworzenia nowego widoku SwiftUI wewnątrz grupy "Gatunek" i nazwijmy go "NewGenreView". Zaimportujmy SwiftData. Będę potrzebować dwóch właściwości stanu, których możemy użyć do utworzenia naszego nowego gatunku. Jeden dla nazwy i jeden dla koloru. Nazwa będzie ciągiem znaków, który możemy zainicjalizować jako pusty ciąg. Ale kolor będzie widokiem koloru, który możemy użyć w selektorze kolorów do zmiany, więc ustaw domyślnie na czerwony. Będziemy tworzyć nowy obiekt gatunku, więc będziemy potrzebować dostępu do kontekstu z otoczenia. Dostaniemy się do tego kontekstu modelu i nazwiemy go "context". Widok ten będzie prezentowany jako modalny arkusz, więc znowu umożliwmy jego zamknięcie, korzystając z klucza środowiska "dismiss" w celu utworzenia właściwości "dismiss".

```swift
struct NewGenreView: View {
    @State private var name = ""
    @State private var color = Color.red
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {...}
}
```

 Zamienię ciało widoku na nawigacyjny stos zawierający formularz. Jako pierwszy element formularza utworzę widok tekstowy z kluczem tytułowym "name" i zbindowaną właściwością stanu "name". Następnie dodam do tego selektor kolorów, gdzie klucz tytułowy będzie ustawiony na "genreColor", a wybór będzie zbindowany z właściwością stanu "color". Ignoruję także opcję przezroczystości, więc argument "supportsOpacity" będzie ustawiony na "false". 

```swift
    var body: some View {
        NavigationStack {
            Form {
                TextField("name", text: $name)
                ColorPicker("Set the genre color", selection: $color, supportsOpacity: false)
            }
        }
    }
```

Następnie utworzę przycisk z etykietą "Utwórz". Dla akcji utworzymy nowy gatunek, gdzie nazwa będzie równa naszej nazwie. Dla koloru będziemy musieli przekształcić kolor na ciąg szesnastkowy za pomocą naszego rozszerzenia. Musi to być "force unwrap", ponieważ jest to opcjonalne, ale ponieważ będzie pochodzić bezpośrednio z selektora kolorów, jest bezpieczne do "force unwrap" w tym miejscu. Teraz, gdy obie wartości są ciągami, możemy użyć kontekstu do wstawienia modelu. Następnie zamkniemy ten widok. 

```swift
                Button("Create") {
                    let newGenre = Genre(name: name, color: color.toHexString()!)
                    context.insert(newGenre)
                    dismiss()
                }
```

Ustawmy też styl przycisku na "borderedProminent". Zastosujmy ramkę, ustawiając maksymalną szerokość na "infinity" z wyjustowaniem do prawej strony, co przesunie go na prawą stronę naszego formularza. Aby upewnić się, że nie uzyskamy pustych kolorów, zdezaktywujemy przycisk, jeśli nazwa jest pusta. Do formularza dodam też odrobinę marginesu. Utworzymy nawigacyjny tytuł, używając ciągu "New Genre", ale ustawmy tryb wyświetlania tytułu paska nawigacyjnego na "inline". 

```swift
import SwiftUI
import SwiftData

struct NewGenreView: View {
    @State private var name = ""
    @State private var color = Color.red
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("name", text: $name)
                ColorPicker("Set the genre color", selection: $color, supportsOpacity: false)
                Button("Create") {
                    let newGenre = Genre(name: name, color: color.toHexString()!)
                    context.insert(newGenre)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity,alignment: .trailing)
                .disabled(name.isEmpty)
            }
            .padding()
            .navigationTitle("New Genre")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
```

Teraz, jeśli spróbujesz utworzyć jakiś gatunek na podglądzie, aplikacja by się zawiesiła, ponieważ nie skonfigurowaliśmy jeszcze naszego kontenera podglądu. Niemniej jednak nie ma sensu tego robić tutaj. Wróćmy do naszego widoku gatunków i dodajmy przycisk, który ten widok będzie prezentować. Tak więc, jako ostatni wiersz w liście po pętli "for each", utwórzmy widok z etykietą, używając zawartości i etykiety. Dla zawartości utworzymy przycisk, ale na razie pozostawmy akcję pustą. Dla etykiety przycisku utworzymy obrazek, używając nazwy systemowej "plus.circle.fill". Ustawimy skalę obrazka na "large". Zastosujemy również styl przycisku na "borderedProminent".

```swift
var body: some View {
  NavigationStack {
    Group{
      if genres.isEmpty {...
                        } else {
        List {
          ForEach(genres) { ...
                          }
          LabeledContent {
            Button {

            } label: {
              Image(systemName: "plus.circle.fill")
              .imageScale(.large)
            }
            .buttonStyle(.borderedProminent)
          } label: {
            Text("Create new Genre")
            .font(.caption).foregroundStyle(.secondary)
          }
        }
      }
    }
  }
  .navigationTitle(book.title)
}
```

Dla etykiety samego widoku "labeled content" utworzę nowy widok tekstowy, używając napisu "Create New Genre". Zastosuję czcionkę podpisu (captioned font) i ustawię styl wypełnienia (foreground style) na "secondary". Ustawmy również styl listy na "plain". Przycisk, który utworzyliśmy, będzie używany do prezentowania arkusza modalnego, więc utworzę nową właściwość stanu o nazwie "newGenre" i zainicjalizuję ją jako "false". Następnie dla akcji tego przycisku po prostu przełączymy tę właściwość stanu. 

```swift
struct GenresView: View {
    ...
   @State private var newGenre = false
```

Czasami zauważam, że zakomentowanie i odkomentowanie linii kodu naprawia te fałszywe błędy podglądu. Teraz ważne jest, aby wrócić do widoku z informacją o niedostępnej zawartości, gdzie mieliśmy ten przycisk akcji. Możemy również użyć tego samego przełączania "newGenre". Po przełączeniu go będziemy musieli wyświetlić arkusz, więc utworzymy modyfikator "sheet", gdzie "isPresented" będzie zbindowane z tym przełącznikiem i użyjemy go do prezentowania widoku "NewGenreView". 

```swift
        .sheet(isPresented: $newGenre) {
            NewGenreView()
        }
```

Utworzę również pasek narzędzi, aby dostać przycisk, który pozwoli mi zamknąć ekran. Następnie wewnątrz tego paska narzędzi utworzę element paska narzędzi, gdzie położenie (placement) będzie ustawione na "top bar leading", aby umieścić go na krawędzi wiodącej, i utworzę przycisk, który nazwę "Back" i po prostu wywoła funkcję "dismiss".

```swift
struct GenresView: View {
  ...
  var body: some View {
        NavigationStack {...}
        .navigationTitle(book.title)
        .sheet(isPresented: $newGenre) {
            NewGenreView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
        }
```

 Teraz ten widok sam w sobie musi być prezentowany z widoku edycji książki, dokładnie tak samo, jak utworzyliśmy przycisk do prezentacji widoku "QuotesView". Więc wrócę do widoku edycji książki i utworzę właściwość stanu dla "showGenres" i ustawię ją na "false". 

```swift
struct EditBookView: View {
    ...
    @State private var showGenres = false;
```

Szukamy fragmentu gdzie mamy ten link nawigacyjny do prezentacji naszych cytatów, 



```swift
struct EditBookView: View {
  var body: some View {
    ...
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

zagnieżdżę go w HStack, aby pokazać oba te przyciski obok siebie, a jako pierwszy element w hstack utworzę przycisk, gdzie klucz tytułowy to "Genres", ale teraz w Xcode 15 możemy również dodać obraz systemowy do etykiety naszego przycisku. Więc podam "bookmark.fill". A dla akcji po prostu przełączę "showGenres".

```swift
var body: some View {
  ...
  HStack {
    Button("Genres",systemImage: "bookmark.fill") {
      showGenres.toggle()
    }
    .sheet(isPresented: $showGenres) {
      GenresView(book: book)
    }

    NavigationLink {
      QuotesListView( book: book)
    } label : {
      let count = book.quotes?.count ?? 0
      Label("\(count) Quotes",systemImage:"quote.opening")
    }
    .buttonStyle(.bordered)
    .frame(maxWidth: .infinity, alignment:.trailing)
    .padding(.horizontal)
  }
}
...
}
}
```

Teraz, gdy mamy przełącznik akcji "showGenres", mogę utworzyć arkusz, który będzie prezentować nasz widok gatunków. Ten arkusz będzie zbindowany z "isPresented" do właściwości "showGenres", a następnie mogę utworzyć widok "GenresView", przekazując do niego tę książkę. Teraz, jeśli wrócimy teraz do widoku listy książek, możemy to przetestować w podglądzie. Dotknij dowolnego wiersza, a dostaniesz widok szczegółowy. A stąd możemy nacisnąć przycisk gatunków. I mogę wybrać jeden lub dwa gatunki dla mojej książki. Jeśli naciśnę przycisk "Wstecz", nie zobaczę jeszcze dodanych gatunków, ponieważ jeszcze tego nie obsłużyliśmy. To jest następne. Ale jeśli wrócę do widoku gatunków, zobaczę, że musiały zostać one dodane, ponieważ są wciąż zaznaczone. Dodajmy teraz nowy gatunek. Nazwę go "akcja". I wybiorę kolor. I dodam go. I widzimy, że został on dodany alfabetycznie do listy. 

![2023-10-29_11-04-23 (1)](2023-10-29_11-04-23%20(1).gif)

Jeśli go wybiorę i wrócę, zostanie wstawiony. Jeśli wrócę, zobaczę, że nowy gatunek pozostał i został zaznaczony. 

## GenreStackView 

​	Mamy jeszcze dwie rzeczy do zrobienia. Chcę stworzyć ładny sposób na wyświetlanie wybranych gatunków na tym widoku szczegółów, jak również na widoku listy. I nadal będziemy musieli być w stanie usunąć gatunek, którego już nie chcemy, oraz upewnić się, że zostanie on również usunięty z każdej z książek. Ponieważ chcę, aby wygląd był taki sam zarówno na widoku listy, jak i na szczegółowym, stworzę widok SwiftUI do prezentacji naszego stosu gatunków. Więc utworzę nowy plik SwiftUI, który nazwę "GenreStackView". Teraz ten widok otrzyma tablicę gatunków podczas prezentacji. Nazwiemy ją "genres". Następnie zastąpię ciało widoku hstackiem. I użyjemy pętli forEach na naszej tablicy gatunków. To da nam gatunek. Posortuję również tablicę, używając porównywacza klucza ścieżki, którym będzie nazwa naszego gatunku. Wówczas po prostu utworzymy widok tekstowy, używając tej nazwy gatunku. Ustawię czcionkę na podpis (caption). Styl wypełnienia na biały. Dodam trochę marginesu 5. A następnie ustawiam tło na zaokrąglony prostokąt o promieniu rogu 5 i wypełnieniu, które używa koloru szesnastkowego tego gatunku. Teraz nie będę używać podglądu tutaj, ponieważ to dość prosty widok. Więc możemy dodać to do naszych dwóch widoków. Więc w widoku listy książek, gdzie wykonujemy nasze zapytanie w etykiecie nawigacyjnego linku oraz w vStack po polu "reading", użyję iflet, aby sprawdzić, czy mamy tablicę gatunków. I po prostu wyświetlę ten widok "GenreStackView", przekazując tę tablicę.



Więc mogę skopiować to i użyć tego samego kodu w naszym widoku `editBookView` po polu tekstowym dla streszczenia, ale przed dwoma przyciskami. Więc wróćmy do widoku `bookListView` i przetestujmy to. To jest prawie idealne, ale co jeśli mielibyśmy wiele gatunków? Możemy wyczerpać miejsce w tym poziomym stosie. Aby to udowodnić, pozwól mi uruchomić to w symulatorze. Zobaczysz, że dodałem dość dużo więcej gatunków dla tej grupy książek. A dla jednego z nich przypisałem wiele gatunków. Teraz wygląda to dobrze tutaj, ale pozwól mi dodać jeszcze jeden gatunek do tej książki. Teraz, w widoku `editView`, nie wygląda to tak dobrze, ponieważ próbuje wcisnąć wszystkie te gatunki w ten wiersz. A jeśli wrócę do widoku `listView`, jest jeszcze gorzej. Gdyby to było wewnątrz `scrollView`, nie byłoby problemu. Okazuje się, że jest to dość łatwe do naprawienia. Po prostu możemy użyć `viewThatFits`, aby widok używał `scrollView`, tylko jeśli to konieczne. Użyłem tego jako przykład w moim filmie o `viewThatFits`. Więc w pliku `books.lists` zamknę `genreStacksView` w `viewThatFits`. Następnie jako drugi widok dodam `scrollView`, który jest poziomy i ustawię `showsIndicators` na `false`, a następnie przekażę ten `genreStackView` przekazując gatunek. Użyję dokładnie tego samego kodu w widoku `editBookView`. Teraz uruchommy to w symulatorze. Widzę, że wygląda idealnie. Nie tylko na liście, ale także w widoku szczegółów. Przewija się tylko w razie potrzeby. Teraz ostatnią rzeczą, którą chcę omówić, jest usuwanie gatunku z tablicy gatunków. Usunięcie gatunku nie spowoduje żadnego usunięcia związanej z nim książki, ponieważ domyślnie zostanie tylko znullowana. Więc to będzie w porządku. Będziemy musieli to zrobić w symulatorze, więc jeśli podążasz za mną, upewnij się, że dodałeś wiele książek, wiele gatunków i masz gatunki powiązane z różnymi książkami. Najpierw chcę jednak otworzyć tę bazę danych SQL, aby zobaczyć, jak aktualnie wygląda struktura. Jeśli przeglądam dane tej książki, nie widzę żadnej reprezentacji tablicy gatunków. Ale zauważ, że ta pierwsza kolumna, oznaczona jako `z_pk`, oznacza klucz główny. Na przykład książka `qb7` ma klucz główny 1. Podobnie, przeglądając dane dla gatunku, nie ma tu wzmianki o książkach, ale jest inna kolumna klucza głównego.



Kiedy tworzymy relację wiele do wielu w SwiftData, za kulisami tworzona jest nowa tabela łącząca. W tym przypadku nosi ona nazwę `z_one_genres`. Jeśli ją otworzę, zobaczę, że ma dwie kolumny, jedną dla książek i jedną dla gatunków, a lista tu to klucze główne każdego rekordu. Można zobaczyć, że książka o kluczu głównym 1, czyli `rqb7`, ma gatunki 1 i 6. A jeśli przejdę do gatunków, zobaczę, że 1 to fikcja, a 6 to historia. Wróćmy do aplikacji raz jeszcze, aby sprawdzić, czy to się zgadza. Teraz chcę przetestować usunięcie całego gatunku, aby zobaczyć, co się stanie. Więc w widoku gatunków utworzyłem listę gatunków przy użyciu pętli `forEach`. Możemy więc tutaj użyć modyfikatora `onDelete` dla akcji przesunięcia w lewo. Powinienem być w stanie przejść przez ten zestaw indeksów, utworzyć indeks, a następnie użyć metody `delete`, aby usunąć z tablicy gatunków pod tym indeksem. Uruchommy to teraz w naszym symulatorze. Widzę, że gatunek "Detektyw" jest powiązany z dwiema książkami. Pozwól mi go usunąć. Wybiorę jedną z książek z gatunkiem "Detektyw", a następnie pojawię się na ekranie z gatunkami, gdzie teraz mam przesunięcie akcji od prawej do lewej, aby go usunąć. Po powrocie do widoku szczegółów książki, nadal jest tam ten gatunek. To jest problem. Jednakże, po powrocie do widoku listy, tego gatunku już tam nie ma. Problem polega na tym, że kiedy prezentujemy widok gatunków i usuwamy gatunek, nie ma powiązania z tą konkretną tablicą dla naszej książki. Rozwiązanie jest jednak dość proste. Musimy po prostu najpierw usunąć książkę z tej tablicy, co zaktualizuje widok, który ją prezentuje, a następnie mogę usunąć gatunek, co automatycznie zaktualizuje widok listy. Więc tutaj możemy odczytać `book.genres`, używając `if let`, jednocześnie sprawdzając, czy `book.genres` zawiera gatunki pod indeksem gatunków. Jeśli tak jest, to możemy ustawić `bookGenresIndex` jako pierwszy indeks, gdzie ID gatunku dla gatunku tej książki jest równe indeksowi całej tablicy. Następnie możemy usunąć ten indeks z `bookGenresIndex`.



Pozwólmy sobie przetestować jeszcze raz. Widzę, że gatunek 'fiction' jest powiązany z wieloma książkami, więc pozwól mi wybrać dowolną książkę z tego gatunku. Widzę ją tutaj w widoku szczegółów, więc przejdźmy do ekranu gatunków i przesuńmy, aby usunąć ten gatunek 'fiction'. Po powrocie do ekranu szczegółów widzę, że już go tu nie ma. A wracając do widoku listy, widzę, że zniknął z każdej książki. Cóż, to praktycznie kompletna podstawa tej aplikacji opartej na SwiftData, ale nadal mam kilka rzeczy, które chciałbym zrobić z tą aplikacją. Cdn 