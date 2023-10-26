> You really haven't to do much at all. And your users won't lose any data. I love getting your feedback so tap the thumbs up button if you enjoyed this video and leave a comment below. Make sure you subscribe to the video and ring that bell to get notifications of new videos. And if you want to support my work you can buy me a coffee. You may recall in the second video when we changed our rating property from being a status enum to the status's raw value which is an int, our app crashed. This is because our data model made a significant change and our backend model container did not know how to deal with it. At the time I mentioned that we'd need to perform a migration if we wanted to keep our existing data on our phone. Well before I get into relationships which will require changing our model structure I want to introduce you to Swift data migrations. If you're following along with me you can continue on with your project from video 3. If not please download the completed project from the current branch for this project's repository and that's the third video underscore dynamic query and sort branch. I'll leave a link in the description. For this video I've started a new branch for lightweight migrations. Also I want to make sure that you have at least three book entries in the app when you run it on the simulator. 

Nie musisz zbyt wiele robić. I twoi użytkownicy nie stracą żadnych danych. Uwielbiam otrzymywać wasze opinie, więc naciśnij przycisk kciuka w górę, jeśli podobał ci się ten film, i zostaw komentarz poniżej. Upewnij się, że jesteś subskrybentem kanału i włącz powiadomienia, aby otrzymywać informacje o nowych filmach. A jeśli chcesz wesprzeć moją pracę, możesz mi kupić kawę.

Pamiętasz może w drugim filmie, kiedy zmieniliśmy naszą właściwość `rating` z typu enum `status` na wartość surową `status` (raw value), która jest liczbą całkowitą (`int`), nasza aplikacja uległa awarii. Działo się tak, ponieważ nasz model danych uległ znacznej zmianie, a nasz kontener modelu backendowego nie wiedział, jak sobie z tym poradzić. Wtedy wspomniałem, że będziemy musieli przeprowadzić migrację, jeśli chcemy zachować nasze istniejące dane na telefonie. Zanim przejdę do omawiania relacji, co będzie wymagało zmiany struktury naszego modelu, chcę przedstawić ci, jak działa migracja danych w Swift Data.

Jeśli podążasz za mną, możesz kontynuować pracę nad swoim projektem z filmu trzeciego. Jeśli nie, pobierz ukończony projekt z obecnej gałęzi w repozytorium tego projektu, a jest to gałąź trzeciego filmu, która obsługuje dynamiczne zapytania i sortowanie. Zamieszczę link w opisie.

W tym filmie rozpocznę nową gałąź dotyczącą "migracji lekkich" (lightweight migrations). Upewnij się również, że masz co najmniej trzy wpisy książek w aplikacji, gdy uruchamiasz ją na symulatorze.



> Now I'm going to be adding a new property to my book model so that I can track who might have recommended that book to me. Well I can do this in two ways. I can create a property as an optional string or I can create it as a string and give it a default value like an empty string when I create a new book as we did with summary. I'd like to show you how making the choice has an impact on your development so we're going to do both. But in order to check the differences though I want to be able to revert my data store back to its original state at the beginning of this video after I show the first of these implementations. So make sure you run your project and locate the location of the three my book files that are stored in the application support directory. Stop the application then and copy those three files into a separate location on your computer so we can revert back to them. So let's open the book model file and add a new property to our book model and I'm going to make it an optional string. I'm going to add a new optional string parameter to the initializer with the same name and set it to nil so that we don't need to provide a value for it when we create our previews. And then we'll set it self.recommendedby to this property. Let me run the application. Fantastic! No crash. It runs just fine. So let's take a look at the database now in our SQLite browser app. When I go to browse data and check out our book table I see that the new recommended by field has been added and all of our records have been assigned a null value. That's great. I didn't have to do anything. 

Teraz zamierzam dodać nową właściwość do mojego modelu książki, aby móc śledzić, kto mógłby mi polecić daną książkę. Mogę to zrobić na dwa sposoby. Mogę utworzyć właściwość jako opcjonalny ciąg znaków (optional string) lub mogę utworzyć ją jako ciąg znaków i przypisać jej wartość domyślną, na przykład pusty ciąg znaków, gdy tworzę nową książkę, tak jak zrobiliśmy to ze właściwością `summary`. Chciałbym pokazać ci, jakie znaczenie ma wybór podczas rozwoju, dlatego też zrobimy obie opcje. Jednakże, aby sprawdzić różnice, chcę być w stanie przywrócić mój magazyn danych do jego pierwotnego stanu na początku tego filmu, po pokazaniu pierwszej z tych implementacji. Upewnij się, że uruchamiasz swój projekt i zlokalizujesz lokalizację trzech plików mojej książki, przechowywanych w katalogu wsparcia aplikacji. Następnie zatrzymaj aplikację i skopiuj te trzy pliki do oddzielnego miejsca na swoim komputerze, abyśmy mogli do nich wrócić.

Teraz otwórz plik modelu książki i dodaj nową właściwość do modelu. Zamierzam ustawić ją jako opcjonalny ciąg znaków. Dodam nowy opcjonalny parametr typu String do inicjalizatora o tej samej nazwie i ustaw go na nil, abyśmy nie musieli podawać wartości podczas tworzenia podglądów. Następnie przypiszemy tę właściwość jako `self.recommendedBy`. Uruchommy aplikację. Fantastycznie! Brak awarii. Działa świetnie. Teraz spójrzmy na bazę danych w naszej aplikacji przeglądającej SQLite. Gdy przechodzę do przeglądania danych i sprawdzam naszą tabelę książek, widzę, że zostałe nowe pole "recommended by" i wszystkim naszym rekordom przypisano wartość null. Świetnie. Nic nie musiałem robić.

> This is known as a lightweight migration and Swift can add new properties if the property is optional and we have a default value of nil so all of our current records were assigned a value of nil to that property. Well what if however we didn't want to use nil for this object when we create our new books and we want to assign an empty string as we did for summary. Now our database has already been updated with our last run with that optional value so we'll need to revert back to the original data store. So delete that modified set of files in the application support directory and restore them back to those ones that we just copied just previously. So let me return to book model and I'm going to change recommended by to a string not an optional string. Then in the initializer I'll set recommended by to be that non-optional string and assign it a default value of an empty string in that initializer and that's different from nil. Let me run once more. This time the application crashes and if I open that database and navigate to our table we'll see that the property wasn't added at all. So no modifications have been made to the database it just crashed. Well remember what I said in the last case when recommended by was nil it had a default value of nil. So how can we use that knowledge in this model? Well all is not lost. The issue is how we have set up our model and our initializer. This initializer is used when we create a book in our application or in our previews but not when the app launches and it finds that there's a new property. It doesn't check out that specific initializer it crashes right away. 

To jest znane jako lekka migracja, a Swift może dodawać nowe właściwości, jeśli właściwość jest opcjonalna i ma wartość domyślną nil, więc wszystkie nasze obecne rekordy zostały przypisane wartości nil dla tej właściwości. Ale co w przypadku, gdy nie chcemy używać nil dla tego obiektu, gdy tworzymy nowe książki i chcemy przypisać mu pusty ciąg znaków, tak jak zrobiliśmy to dla summary. Teraz nasza baza danych została już zaktualizowana podczas ostatniego uruchomienia z tą opcjonalną wartością, więc będziemy musieli przywrócić pierwotną wersję naszego składu danych. Usuń zmodyfikowane pliki w katalogu application support i przywróć je do tych, które właśnie wcześniej skopiowaliśmy. Wróćmy teraz do modelu książki, zmienię pole "recommendedBy" na string, nie będący opcjonalnym. Następnie w initializerze ustawmy "recommendedBy" jako ten nieopcjonalny string i przypiszmy mu wartość domyślną, która będzie pustym ciągiem znaków. To jest coś innego niż nil. Uruchommy naszą aplikację ponownie. Tym razem aplikacja się zawiesi, a jeśli otworzymy bazę danych i przejdziemy do naszej tabeli, zobaczymy, że właściwość ta nie została dodana w ogóle. Nie dokonano żadnych zmian w bazie danych, aplikacja po prostu się zawiesiła. Pamiętajmy o tym, co powiedziałem wcześniej: gdy "recommendedBy" było nil, miało ono wartość domyślną nil. Jak możemy wykorzystać tą wiedzę w naszym modelu? Wszystko nie jest jeszcze stracone. Problem polega na tym, jak zbudowaliśmy nasz model i nasz initializer. Ten initializer jest używany, gdy tworzymy książkę w naszej aplikacji lub w naszych podglądach, ale nie podczas uruchamiania aplikacji, kiedy znajduje nową właściwość. Aplikacja od razu się zawiesza, nie sprawdzając tego konkretengo initializera.

> Well the solution is to set the default value at the source where we declare the property and not just in the initializer and this is going to be really super important when we start looking at CloudKit and this is very significant but more on that in a later video. We can leave our initializer as is because that will give us an option of specifying a different value recommended by when we create our new preview data. So if I run the application now it doesn't crash. Everything's great and if I open up this in our db browser to take a look at the SQL database in the back end and navigate to our books we can see that new property has been added here but this time instead of it being null all of the entries are empty strings. Okay moving on now what if we wanted to rename a property? For example summary may not be a great name for this property. What if we wanted to call it synopsis instead? So in this model let me refactor and rename that property to synopsis. Then let me fix the initializers parameter to be synopsis too. Then I'm going to go to edit book view where this is used and I'll refactor the summary property here to be synopsis too. Now our preview data for our sample books will no longer work though so I'll need to make sure I change every instance of summary used here to synopsis. Well it compiles just fine but when I run the app it crashes. So let's return to our book model and fortunately SwiftData provides us with an attribute macro that allows us to change the name of a property as a lightweight migration. 

Rozwiązaniem jest ustawienie wartości domyślnej w miejscu, gdzie deklarujemy właściwość, a nie tylko w initializerze, co będzie naprawdę ważne, gdy zaczniemy pracować z CloudKit, co jest bardzo istotne, ale więcej na ten temat w późniejszym filmie. Możemy pozostawić nasz initializer tak, jak jest, ponieważ pozwala nam to ustawić inną wartość dla `recommendedBy` podczas tworzenia danych podglądowych. Teraz, jeśli uruchomimy aplikację, nie będzie ona się zawieszać. Wszystko działa świetnie, i jeśli otworzymy naszą bazę danych SQLite za pomocą przeglądarki db, możemy zobaczyć, że nowa właściwość została dodana, ale tym razem zamiast wartości null, wszystkie wpisy są pustymi ciągami znaków. 

Przechodząc dalej, co jeśli chcielibyśmy zmienić nazwę właściwości? Na przykład może `summary` nie jest najlepszą nazwą dla tej właściwości. Co by było, gdybyśmy chcieli nazwać ją `synopsis`? W tym modelu zmieńmy nazwę tej właściwości na `synopsis`. Następnie poprawmy parametr initializera, aby również nazywał się `synopsis`. Następnie przejdźmy do widoku `EditBookView`, gdzie jest używana ta właściwość, i zmieńmy właściwość `summary` na `synopsis`. Nasze dane podglądowe dla przykładowych książek już nie będą działać, więc musimy upewnić się, że zmienimy każde wystąpienie `summary` na `synopsis`. Kod kompiluje się poprawnie, ale gdy uruchomimy aplikację, ona się zawiesi. 

Powróćmy teraz do naszego modelu książki. Na szczęście SwiftData dostarcza nam makro atrybutu, które pozwala zmienić nazwę właściwości jako lekką migrację.

> All we have to do is within the attribute provide the original name which was summary. If I run the app once more our app no longer crashes and our data is intact. So let me stop the app and open up our data store in our db browser. Again I'll navigate to the book table to see our data and I'll see that the summary field has now been changed to synopsis. Perfect. This lightweight migration that SwiftData handles is fantastic. It will handle most of the cases during development as well as production. A complex migration will allow us to make significant changes to our data types or attributes and in my experience this is pretty rare but we saw that case within our enum. But rather than going through a complex migration right now I'm going to leave that for a later video. In the meantime these are the kinds of things that a lightweight migration will handle with very little effort on your part. We can add one or more new models which we'll be doing in the next video. We can add one or more new properties so long as we provide a default value or it's optional as we just saw. We can rename one of our properties and although we didn't show it we could have deleted one from our model. Now there are some other things the lightweight migration will do as well. If you're storing data in a SwiftData model in one of your properties you can assign an external storage attribute and you can add or remove this and a lightweight migration will handle this. As being encrypted you can assign that as an attribute as well. Adding or removing this attribute is handled by a lightweight migration. And then there's another attribute that will guarantee that each property is unique so you can add that attribute but only if the existing values are already unique. This will enforce all new properties to be unique. But when we get into relationships next there is a delete rule that we can provide as well and this can be adjusted by a lightweight migration. These changes are all safe and automatic with SwiftData and that's fantastic as we grow our app. To finish off this video then since we added a new isRecommended property to our model we might as well use it. So let's return to the edit book view and add a new state property for it and initialize it as an empty string. Let me add a labeled content view for this with a text field. But before I do that let me just change this string here to synopsis. Remember we changed it to a text field. And remember we changed summary to synopsis. So I'm going to duplicate the author's labeled content view and update the binding to recommended by and change the text view accordingly as well. 

Wszystko, co musimy zrobić, to wewnątrz atrybutu podać oryginalną nazwę, która była `summary`. Jeśli uruchomimy aplikację ponownie, nasza aplikacja już nie będzie się zawieszać, a nasze dane będą nietknięte. Dlatego zatrzymajmy aplikację i otwórzmy nasze źródło danych w przeglądarce bazy danych. Ponownie przejdźmy do tabeli książek, aby zobaczyć nasze dane i zobaczymy, że pole `summary` zostało teraz zmienione na `synopsis`. Doskonałe. Ta lekka migracja, którą obsługuje SwiftData, jest fantastyczna. Poradzi sobie z większością przypadków podczas rozwoju oraz w produkcji. Złożona migracja pozwoli nam wprowadzić znaczące zmiany w naszych typach danych lub atrybutach, ale z mojego doświadczenia jest to dość rzadkie, ale widzieliśmy taki przypadek w naszym enumie. Ale zamiast przeprowadzać teraz skomplikowaną migrację, zostawię to na późniejsze wideo. W międzyczasie to są rodzaje zmian, którymi lekka migracja zajmie się z niewielkim wysiłkiem z twojej strony. Możemy dodać jeden lub więcej nowych modeli, co zrobimy w następnym filmie. Możemy dodać jedną lub więcej nowych właściwości, o ile podamy wartość domyślną lub jest ona opcjonalna, jak właśnie widzieliśmy. Możemy zmienić nazwę jednej z naszych właściwości, a chociaż tego nie pokazaliśmy, moglibyśmy ją również usunąć z naszego modelu. Istnieją również inne rzeczy, które lekka migracja obsługuje. Jeśli przechowujesz dane w modelu SwiftData w jednej z twoich właściwości, możesz przypisać atrybut zewnętrznego składowania i dodawanie lub usuwanie tego atrybutu zostanie obsłużone przez lekką migrację. Jeśli dane są zaszyfrowane, również możesz przypisać to jako atrybut. Dodanie lub usunięcie tego atrybutu jest obsługiwane przez lekką migrację. Jest jeszcze jeden atrybut, który zagwarantuje, że każda właściwość jest unikalna, więc możesz dodać ten atrybut, ale tylko jeśli istniejące wartości już są unikalne. To sprawi, że wszystkie nowe właściwości będą musiały być unikalne. Ale kiedy przejdziemy do relacji, jest również reguła usuwania, którą możemy dostarczyć, i to można dostosować za pomocą lekkiej migracji. Te zmiany są wszystkie bezpieczne i automatyczne dzięki SwiftData, co jest fantastyczną opcją w miarę rozwoju naszej aplikacji. Aby zakończyć ten film, skoro dodaliśmy nową właściwość `isRecommended` do naszego modelu, możemy równie dobrze jej użyć. Wróćmy więc do widoku `EditBookView` i dodajmy nową właściwość stanu dla niej i zainicjalizujmy ją jako pusty ciąg znaków. Dodajmy `labeled content view` dla tej właściwości z polem tekstowym. Ale zanim to zrobimy, zmieńmy ten ciąg znaków tutaj na `synopsis`. Pamiętajmy, że zmieniliśmy to na pole tekstowe. I pamiętajmy, że zmieniliśmy `summary` na `synopsis`. Zduplikujmy `labeled content view` dla autorów i zaktualizujmy wiązanie do `recommendedBy`, a także zmieńmy odpowiednio `text view`.

> And then for our action in the update button we can apply this property to the book recommended by. In the onAppear we can set the value of recommended by to the corresponding property of the passed in book. And then for our changed computed boolean property we'll add another or statement to check to see if the recommended by property is not equal to the one that was passed in by the book. Now our preview still works because our books sample books array at index four has a default empty string for the recommended by. If you want you can go back to the book samples file and add a new property for this example. Now remember when we added that property in our initializer we added it as the last property so we'll need to add it in that order in our samples after the status property. So we'll say it's recommended by Stuart Lynch. When I return to our edit book view I see it's there. Let me test this in the simulator by adding a recommended by to one of our books and verify that in fact it gets persisted to the database. Now it's really unbelievable how easy it is to add and remove new properties in our models the Swift data. We just have to make sure that we add a new property that we have given it a default value or made it optional. And if we're renaming a property we can always use the attribute macro. We can get into a more complicated migration later on in this series but I really believe that for the most part lightweight migrations will meet your needs and your users will not lose any data. Thanks for watching!

A następnie dla akcji w przycisku aktualizacji możemy przypisać tę właściwość do pola `recommendedBy` książki. W bloku `onAppear` możemy ustawić wartość `recommendedBy` na odpowiednią właściwość przekazanej książki. A dla naszej obliczonej właściwości logicznej `changed` dodamy kolejne wyrażenie logiczne OR, aby sprawdzić, czy właściwość `recommendedBy` nie jest równa tej, która została przekazana w obiekcie książki. Teraz nasz podgląd wciąż działa, ponieważ nasz tablica próbek książek w indeksie czwartym ma domyślny pusty ciąg znaków dla `recommendedBy`. Jeśli chcesz, możesz wrócić do pliku `BookSamples` i dodać nową właściwość dla tego przykładu. Pamiętaj, że gdy dodaliśmy tę właściwość w naszym inicjalizatorze, dodaliśmy ją jako ostatnią, więc będziemy musieli dodać ją w tej samej kolejności w naszych próbkach, po właściwości `status`.  Kiedy wrócę do widoku `EditBookView`, widzę, że tam jest. Przetestujmy to w symulatorze, dodając rekomenację do jednej z naszych książek i sprawdzając, czy faktycznie jest ona zapisywana w bazie danych. To naprawdę niewiarygodne, jak łatwo jest dodawać i usuwać nowe właściwości w naszych modelach w SwiftData. Musimy tylko upewnić się, że jeśli dodajemy nową właściwość, nadaliśmy jej domyślną wartość lub uczyniliśmy ją opcjonalną. A jeśli zmieniamy nazwę właściwości, zawsze możemy użyć atrybutu macro. W późniejszych odcinkach tej serii możemy przejść do bardziej skomplikowanej migracji, ale naprawdę wierzę, że w większości przypadków lekkie migracje będą spełniać Twoje wymagania, a Twoi użytkownicy nie utracą żadnych danych. Dziękuję za obejrzenie!