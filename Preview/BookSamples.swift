//
//  BookSamples.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 13/10/2023.
//

import Foundation
extension Book {
    static let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!
    static let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!

    static var sampleBooks: [Book] {
        [
            Book(title: "QBVII",
                 author: "Leon Uris"),

            Book(title: "Macbeth",
                 author: "William Shakespeare",
                 dateAdded: lastWeek,
                 dateStarted: Date.now,
                 status: Status.inProgress),

            Book(title: "Silence of the Grave",
                 author: "Arnuldur Indrason, Bernard Scudder",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 dateCompleted: Date.now,
                 synopsis: "Inheriting Ian Fleming's long-lost account of his spy activities during World War II, young American academic Amy Greenberg finds herself targeted by unknown assailants and must race to finish the manuscript in order to save her life and reveal the actions of a traitor.",
                 rating: 4,
                 status: Status.completed),

            Book(title: "Cardinal",
                 author: "Giles Blunt"),

            Book(title: "Jackdaws",
                 author: "Ken Follett",
                 dateAdded: lastWeek,
                 dateStarted: Date.now,
                 synopsis: "In his own bestselling tradition of Eye of the Needle and The Key to Rebecca, Ken Follett delivers a breathtaking novel of suspense set in the most dangerous days of World War II. D-Day is approaching. They don’t know where or when, but the Germans know it’ll be soon, and for Felicity “Flick” Clariet, the stakes have never been higher. A senior agent in the ranks of the Special Operations Executive (SOE) responsible for sabotage, Flick has survived to become one of Britain’s most effective operatives in Northern France. She knows that the Germans’ ability to thwart the Allied attack depends upon their lines of communications, and in the days before the invasion no target is of greater strategic importance than the largest telephone exchange in Europe. But when Flick and her Resistance-leader husband try a direct, head-on assault that goes horribly wrong, her world turns upside down. Her group destroyed, her husband missing, her superiors unsure of her, her own confidence badly shaken, she has one last chance at the target, but the challenge, once daunting, is now near impossible. The new plan requires an all-woman team, none of them professionals, to be assembled and trained within days. Code-named the Jackdaws, they will attempt to infiltrate the exchange under the noses of the Germans—but the Germans are waiting for them now and have plans of their own. There are secrets Flick does not know—secrets within the German ranks, secrets among her hastily recruited team, secrets among those she trusts the most. And as the hours tick down to the point of no return, most daunting of all, there are secrets within herself.",
                 status: Status.inProgress),

            Book(title: "Blackout",
                 author: "John Lawton",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 dateCompleted: Date.now,
                 synopsis: "In London, during World War II, a dog uncovers a severed arm, which turns out to be that of a rocket scientist--and it was not a bomb that killed him. Sgt. Frederick Troy of Scotland Yard is assigned to the case, which pits him against the U.S. Office of Strategic Services, the wartime spy agency.",
                 rating: 3,
                 status: Status.completed),

            Book(title: "The Sandman",
                 author: "Lars Kepler"),

            Book(title: "The Redbreast",
                 author: "Jo Nesbo",
                 dateAdded: lastWeek,
                 dateStarted: Date.now,
                 status: Status.inProgress),

            Book(title: "Fatherland",
                 author: "Robert Harris",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "Twenty years after Germany's victory in World War II, while the entire country prepares for the U.S. president's visit, Berlin Detective Xavier March attempts to solve the murder of a high-ranking Nazi commander. Reprint.",
                 rating: 5,
                 status: Status.completed),


            Book(title: "Solaris",
                 author: "Stanisław Lem",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W powieści „Solaris” naukowcy badają tajemniczą planetę Solaris, która pokryta jest ogromnym oceanem o niezwykłych właściwościach. Ocean ten potrafi ożywiać wspomnienia i myśli ludzkie, tworząc istoty, które są manifestacją ich najgłębszych lęków i pragnień. Bohaterowie eksplorujący tę zagadkową planetę zaczynają doświadczać własnych wewnętrznych demonów, co prowadzi do filozoficznych rozważań na temat natury ludzkiej świadomości i relacji między ludźmi.",
                 rating: 5,
                 status: Status.inProgress),

            Book(title: "Cyberiada",
                 author: "Stanisław Lem",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "„Cyberiada” to zbiór opowiadań osadzonych w futurystycznym świecie, gdzie roboty i istoty z innych planet współistnieją z ludźmi. Historie te eksplorują ludzkie relacje z technologią i sztuczną inteligencją, ukazując humorystyczne i filozoficzne aspekty interakcji między różnymi formami życia. Lem w tym dziele przemyca głębokie refleksje na temat istoty człowieczeństwa oraz nasze miejsce w kosmosie.",
                 rating: 5,
                 status: Status.inProgress),

            Book(title: "Kongres futurologiczny",
                 author: "Stanisław Lem",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "„Kongres futurologiczny” to satyryczna powieść, która przenosi czytelnika do futurystycznego świata, gdzie naukowcy i futurologowie z różnych epok próbują przewidzieć przyszłość ludzkości. Lem bawi się tutaj konwencjami science fiction, jednocześnie krytykując ludzką pychę i niezdolność do przewidywania skutków swoich działań.",
                 rating: 4,
                 status: Status.inProgress),

            Book(title: "Eden",
                 author: "Stanisław Lem",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W powieści „Eden” grupa naukowców wyrusza na obcą planetę Eden, aby zbadać jej egzotyczną florę i faunę. Podczas misji badawczej odkrywają tajemnicze zjawiska i starożytne artefakty, które zmuszają ich do przewartościowania swoich przekonań na temat natury życia i świata. Lem eksploruje w tej książce różnice między ludzkim a obcym sposobem myślenia oraz nasze miejsce w kosmicznym ekosystemie.",
                 rating: 4,
                 status: Status.inProgress),

            Book(title: "Dzienniki gwiazdowe",
                 author: "Stanisław Lem",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "„Dzienniki gwiazdowe” to zbiór esejów, w których Lem reflektuje nad przyszłością technologii, eksploracją kosmosu i ewolucją ludzkości. Autor prowadzi czytelnika przez filozoficzne rozważania na temat istoty życia, inteligencji i cywilizacji. Lem stawia pytania o naszą rolę jako gatunku w kosmosie oraz naszą zdolność do zrozumienia wszechświata.",
                 rating: 5,
                 status: Status.inProgress),

            Book(title: "Głos Pana",
                 author: "Stanisław Lem",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W powieści „Głos Pana” naukowcy odkrywają sygnały komunikacyjne od obcej cywilizacji. Próby zrozumienia tych sygnałów prowadzą do głębokich refleksji na temat istoty komunikacji między różnymi formami życia. Książka Lem przemyca ważne pytania o nasze miejsce w kosmosie oraz o nasze zdolności komunikacyjne i empatię.",
                 rating: 4,
                 status: Status.inProgress),

            Book(title: "Fiasco",
                 author: "Stanisław Lem",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W powieści „Fiasco” grupa naukowców przeprowadza misję badawczą na obcej planecie, która z pozoru wydaje się idealnym miejscem do życia. Jednakże, podczas eksploracji, naukowcy napotykają na niezrozumiałe zjawiska, które zagrażają ich misji i bezpieczeństwu. Lem w tej książce eksploruje ludzką chęć eksploracji kosmosu, pomieszaną z lękiem przed nieznanym.",
                 rating: 4,
                 status: Status.inProgress),

            Book(title: "Cesarz",
                 author: "Ryszard Kapuściński",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W książce „Cesarz” Kapuściński opisuje swoje doświadczenia z pracy jako korespondent zagraniczny w Etiopii podczas panowania cesarza Haile Selassie. Książka rzuca światło na życie w państwie, które przechodziło przez dramatyczne zmiany polityczne i społeczne, ukazując jednocześnie postać despotycznego władcy.",
                 rating: 5,
                 status: Status.inProgress),

            Book(title: "Heban",
                 author: "Ryszard Kapuściński",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W „Hebanie” Kapuściński relacjonuje swoje podróże do Afryki, przedstawiając barwne opowieści o różnych kulturach i miejscach, które odwiedził. Książka stanowi mieszankę reportażu, podręcznika geografii i eseju, ukazując niezwykłą różnorodność kontynentu afrykańskiego.",
                 rating: 5,
                 status: Status.inProgress),

            Book(title: "Szachinszach",
                 author: "Ryszard Kapuściński",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W „Szachinszachu” Kapuściński opisuje wybuch rewolucji islamskiej w Iranie w 1979 roku, która obaliła monarchię Pahlawich. Książka prezentuje portret szacha Mohammad Rezy Pahlawiego oraz analizuje przyczyny i skutki rewolucji, ukazując zarówno losy przywódcy, jak i zwykłych mieszkańców kraju.",
                 rating: 4,
                 status: Status.inProgress),

            Book(title: "Imperium",
                 author: "Ryszard Kapuściński",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "„Imperium” to podróżnicze eseje Kapuścińskiego, które opisują życie w krajach byłego Związku Radzieckiego po jego rozpadzie. Autor ukazuje skomplikowane procesy polityczne i społeczne, które miały miejsce po upadku imperium sowieckiego, ukazując jednocześnie ludzkie tragedie i nadzieje.",
                 rating: 4,
                 status: Status.inProgress),

            Book(title: "Afryka",
                 author: "Ryszard Kapuściński",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W „Afryce” Kapuściński przedstawia różne oblicza kontynentu afrykańskiego, zwracając uwagę na jego bogactwo kulturowe i historyczne. Książka skupia się na codziennym życiu mieszkańców Afryki, ukazując ich wyjątkowe zwyczaje, wierzenia i dążenia do lepszej przyszłości.",
                 rating: 5,
                 status: Status.inProgress),

            Book(title: "Lapidarium",
                 author: "Ryszard Kapuściński",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "„Lapidarium” to zbiór esejów Kapuścińskiego, które ukazują różne aspekty polityki, historii i kultury. Autor analizuje wydarzenia i postacie z różnych części świata, rzucając światło na ich znaczenie i wpływ na ludzkie losy.",
                 rating: 4,
                 status: Status.inProgress),

            Book(title: "Podróże z Herodotem",
                 author: "Ryszard Kapuściński",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "W „Podróżach z Herodotem” Kapuściński dzieli się swoimi refleksjami na temat podróży, historii i spotkań z różnymi kulturami. Autor odnosi się do dzieła Herodota, starożytnego historyka, porównując jego własne doświadczenia z podróżami Herodota, ukazując zarówno różnice, jak i wspólne cechy podróży i odkrywania świata.",
                 rating: 5,
                 status: Status.inProgress),

            Book(title: "Czarne oceany",
                 author: "Ryszard Kapuściński",
                 dateAdded: lastMonth,
                 dateStarted: lastWeek,
                 synopsis: "„Czarne oceany” to zbiór reportaży Kapuścińskiego, które opisują różne konflikty i wydarzenia polityczne na Bliskim Wschodzie, w Azji Środkowej i Afryce. Autor bierze czytelnika w podróż przez kraje dotknięte wojnami i niepokojami, ukazując zarówno ludzkie tragedie, jak i nadzieje na lepszą przyszłość.",
                 rating: 4,
                 status: Status.inProgress)

        ]
        
    }
}
