import '../../domain/entities/scenario.dart';
import '../../domain/entities/scenario_option.dart';

class ScenarioSeedData {
  ScenarioSeedData._();

  static List<Scenario> get allScenarios => [
        // 1. Noise at 2 AM
        const Scenario(
          id: 'sc_noise_2am',
          order: 1,
          category: 'noise',
          weightHints: {'noise_tolerance': 0.9, 'conflict_style': 0.7},
          title: {
            'tr': 'Gece 02:00 ve Salon Kalabalığı',
            'en': '2 AM and a Crowded Living Room',
          },
          situation: {
            'tr': 'Yarın sabah erken saatte önemli bir sınavın veya iş görüşmen var. Saat gece 02:00 ve ev arkadaşın salonda arkadaşlarıyla yüksek sesle gülüp müzik dinliyor.',
            'en': 'You have an important early morning exam or interview tomorrow. It is 2 AM and your roommate is in the living room with friends laughing loudly and playing music.',
          },
          options: [
            ScenarioOption(
              id: 'sc_noise_2am_a',
              text: {
                'tr': 'Odamdan çıkıp doğrudan "Yarın erken kalkmam gerek, sesi kısabilir misiniz?" derim.',
                'en': 'I step out of my room and say directly: "I have to wake up early tomorrow, can you turn it down?"',
              },
              effects: {'noise_tolerance': -1.5, 'conflict_style': 1.8},
            ),
            ScenarioOption(
              id: 'sc_noise_2am_b',
              text: {
                'tr': 'Kulak tıkacımı takar veya beyaz gürültü açıp uyumaya çalışırım; sabah sakince konuşurum.',
                'en': 'I put on earplugs or white noise and try to sleep; I talk calmly in the morning.',
              },
              effects: {'noise_tolerance': 0.5, 'conflict_style': -1.2},
            ),
            ScenarioOption(
              id: 'sc_noise_2am_c',
              text: {
                'tr': 'WhatsApp grubundan nazik bir mesaj atıp sessizlik rica ederim.',
                'en': 'I send a polite text message in our group chat asking for quiet.',
              },
              effects: {'noise_tolerance': -0.8, 'conflict_style': -0.3},
            ),
            ScenarioOption(
              id: 'sc_noise_2am_d',
              text: {
                'tr': 'Kısa süreliğine aralarına katılıp bir şeyler içer, ortamın havasını yumuşatıp sonra uyurum.',
                'en': 'I join them briefly, have a drink to lighten the mood, then head to bed.',
              },
              effects: {'noise_tolerance': 1.8, 'social_energy': 1.5, 'conflict_style': -0.5},
            ),
          ],
        ),

        // 2. Dishes left in sink
        const Scenario(
          id: 'sc_dishes_3days',
          order: 2,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.95, 'chore_fairness': 0.8},
          title: {
            'tr': 'Lavaboda Bekleyen Bulaşıklar',
            'en': 'Dishes Piled in the Sink',
          },
          situation: {
            'tr': 'Ev arkadaşının kullandığı tencere ve tabaklar 3 gündür lavaboda ıslak ve dağınık şekilde bekliyor. Kendi yemeğini yapacak alanın kalmadı.',
            'en': 'Your roommate left greasy pans and dishes in the sink for 3 days. You have no clean counter space to cook your own meal.',
          },
          options: [
            ScenarioOption(
              id: 'sc_dishes_a',
              text: {
                'tr': 'Fotoğrafını çekip gruba atar ve "Bunu lütfen artık yıkayalım" derim.',
                'en': 'I take a photo, post it in the group chat and say: "Please wash this already."',
              },
              effects: {'cleanliness': 1.5, 'conflict_style': 0.8},
            ),
            ScenarioOption(
              id: 'sc_dishes_b',
              text: {
                'tr': 'Kendi işim görülsün diye söylenmeden yıkarım ama içten içe rahatsız olurum.',
                'en': 'I wash them myself so I can cook, but feel internally resentful.',
              },
              effects: {'cleanliness': 1.0, 'conflict_style': -1.8, 'chore_fairness': -0.5},
            ),
            ScenarioOption(
              id: 'sc_dishes_c',
              text: {
                'tr': 'Bulaşıkları bir leğene veya kenara toplar, tezgahı açıp kendi yemeğimi yaparım.',
                'en': 'I stack their dishes neatly into a tub to clear the sink and make my meal.',
              },
              effects: {'cleanliness': 0.0, 'conflict_style': 0.2, 'privacy_need': 0.5},
            ),
            ScenarioOption(
              id: 'sc_dishes_d',
              text: {
                'tr': 'Yüz yüze gelince gülümseyerek "Yoğun bir günün ardından lavabo seni bekliyor :)" diye takılırım.',
                'en': 'When I see them, I smile and tease: "The sink is eagerly waiting for you :)"',
              },
              effects: {'cleanliness': 0.8, 'conflict_style': 0.6, 'social_energy': 0.7},
            ),
          ],
        ),

        // 3. Partner staying over
        const Scenario(
          id: 'sc_partner_stay',
          order: 3,
          category: 'guest_policy',
          weightHints: {'guest_policy': 0.9, 'privacy_need': 0.8},
          title: {
            'tr': 'Haftada 5 Gün Kalan Sevgili',
            'en': 'Partner Sleeping Over 5 Nights a Week',
          },
          situation: {
            'tr': 'Ev arkadaşının sevgilisi son birkaç haftadır neredeyse haftanın 5 günü sizde kalıyor, duş alıyor ve evde yarı-ev arkadaşı gibi takılıyor.',
            'en': 'Your roommate’s partner has been staying over 5 nights a week for the past month, using utilities and acting like an unofficial third roommate.',
          },
          options: [
            ScenarioOption(
              id: 'sc_partner_a',
              text: {
                'tr': 'Aramızda anlaştığımız misafir sınırını hatırlatır, fatura ve ortak alan paylaşımı hakkında net konuşurum.',
                'en': 'I remind them of our agreed guest boundary and initiate a clear talk about utility bills and shared space.',
              },
              effects: {'guest_policy': -1.8, 'privacy_need': 1.8, 'conflict_style': 1.5, 'money_style': 1.2},
            ),
            ScenarioOption(
              id: 'sc_partner_b',
              text: {
                'tr': 'Ortamı kalabalıklaştırmadığı ve bana saygılı davrandığı sürece hiç sorun etmem.',
                'en': 'As long as they are respectful and don’t crowd my space, I don’t mind at all.',
              },
              effects: {'guest_policy': 1.8, 'privacy_need': -1.5, 'social_energy': 1.2},
            ),
            ScenarioOption(
              id: 'sc_partner_c',
              text: {
                'tr': 'Haftada en fazla 2 gece kalması kuralını baştan koyup sözleşmeye bağlamak isterim.',
                'en': 'I want a strict house rule agreed upfront: maximum 2 nights per week for overnight guests.',
              },
              effects: {'guest_policy': -1.5, 'privacy_need': 1.6, 'responsibility': 1.2},
            ),
            ScenarioOption(
              id: 'sc_partner_d',
              text: {
                'tr': 'Ben de arkadaşlarımı rahatça getirebiliyorsam karşılıklı özgürlük olarak görürüm.',
                'en': 'As long as I have the same freedom to host my own guests, I see it as mutual freedom.',
              },
              effects: {'guest_policy': 1.4, 'chore_fairness': 0.5},
            ),
          ],
        ),

        // 4. Grocery splitting
        const Scenario(
          id: 'sc_grocery_split',
          order: 4,
          category: 'money_style',
          weightHints: {'money_style': 0.9, 'chore_fairness': 0.7},
          title: {
            'tr': 'Ortak Mutfak Alışverişi',
            'en': 'Shared Grocery Expenses',
          },
          situation: {
            'tr': 'Mutfakta deterjan, yağ, baharat gibi temel ihtiyaçlar bitti. Market alışverişinin nasıl yapılmasını ve ödenmesini tercih edersin?',
            'en': 'Kitchen staples like detergent, cooking oil, and spices are empty. How do you prefer to manage grocery shopping and payments?',
          },
          options: [
            ScenarioOption(
              id: 'sc_grocery_a',
              text: {
                'tr': 'Her harcamayı Splitwise/uygulamaya kuruşu kuruşuna girip fişleri kaydetmek isterim.',
                'en': 'I want every shared penny logged in Splitwise or an app with receipts attached.',
              },
              effects: {'money_style': 1.9, 'responsibility': 1.2},
            ),
            ScenarioOption(
              id: 'sc_grocery_b',
              text: {
                'tr': 'Bu ay ben alırım, bir dahakine o alır; küçük hesaplara takılmamak samimiyet göstergesidir.',
                'en': 'I buy this round, they buy the next; not nickel-and-diming builds trust.',
              },
              effects: {'money_style': -1.8, 'social_energy': 0.8},
            ),
            ScenarioOption(
              id: 'sc_grocery_c',
              text: {
                'tr': 'Aylık sabit ortak bir mutfak kumbarası kuralım, oradan harcayalım.',
                'en': 'Let’s maintain a fixed monthly cash pool / debit card for household items.',
              },
              effects: {'money_style': 0.8, 'responsibility': 1.4, 'chore_fairness': 1.2},
            ),
            ScenarioOption(
              id: 'sc_grocery_d',
              text: {
                'tr': 'Herkes kendi deterjanını ve yağını alsın, mutfakta hiçbir şeyi ortak kullanmayalım.',
                'en': 'Everyone should buy their own detergent and oil; no shared consumables.',
              },
              effects: {'money_style': 1.5, 'privacy_need': 1.9, 'social_energy': -1.2},
            ),
          ],
        ),

        // 5. Late rent payment
        const Scenario(
          id: 'sc_rent_late',
          order: 5,
          category: 'responsibility',
          weightHints: {'responsibility': 0.95, 'money_style': 0.8},
          title: {
            'tr': 'Geciken Kira ve Faturalar',
            'en': 'Delayed Rent and Utility Bills',
          },
          situation: {
            'tr': 'Kira günü geldi. Ev arkadaşın "Serbest çalışıyorum, ödemem 5 gün gecikecek" dedi ve ev sahibine toplu ödemeyi sen yapıyorsun.',
            'en': 'Rent is due today. Your roommate says: "I freelance, my client payment is 5 days late." You are the one who transfers the full sum to the landlord.',
          },
          options: [
            ScenarioOption(
              id: 'sc_rent_a',
              text: {
                'tr': 'İnsanlık hali, önceden haber verdiği sürece birkaç gün idare edebilirim.',
                'en': 'Life happens; as long as they notify me in advance, I can cover for a few days.',
              },
              effects: {'responsibility': -0.4, 'money_style': -1.0, 'social_energy': 0.5},
            ),
            ScenarioOption(
              id: 'sc_rent_b',
              text: {
                'tr': 'Büyük stres yaşarım; kiranın kesinlikle gününde hazır olması gerektiğini net şekilde belirtirim.',
                'en': 'I feel high stress; I clearly state that rent must always be ready on time without fail.',
              },
              effects: {'responsibility': 1.8, 'money_style': 1.6, 'conflict_style': 1.3},
            ),
            ScenarioOption(
              id: 'sc_rent_c',
              text: {
                'tr': 'Bu seferlik kapatırım ama bir sonraki ay için 1 aylık güvence fonu oluşturmayı teklif ederim.',
                'en': 'I cover this once, but propose building a 1-month emergency buffer fund for future rent.',
              },
              effects: {'responsibility': 1.7, 'chore_fairness': 1.0, 'conflict_style': 0.6},
            ),
            ScenarioOption(
              id: 'sc_rent_d',
              text: {
                'tr': 'Kendi payımı öderim, ev sahibine durumu anlatıp onunla kendisinin muhatap olmasını söylerim.',
                'en': 'I pay only my share and tell them to explain their delay directly to the landlord.',
              },
              effects: {'responsibility': 1.2, 'privacy_need': 1.4, 'conflict_style': 1.0},
            ),
          ],
        ),

        // 6. Borrowing belongings
        const Scenario(
          id: 'sc_borrow_clothing',
          order: 6,
          category: 'privacy',
          weightHints: {'privacy_need': 0.9, 'conflict_style': 0.7},
          title: {
            'tr': 'İzinsiz Eşya Kullanımı',
            'en': 'Borrowing Items Without Asking',
          },
          situation: {
            'tr': 'Eve geldin ve ev arkadaşının senin pahalı kulaklığını veya en sevdiğin montunu sana sormadan alıp dışarı çıktığını fark ettin.',
            'en': 'You arrive home and discover your roommate borrowed your expensive headphones or jacket without asking.',
          },
          options: [
            ScenarioOption(
              id: 'sc_borrow_a',
              text: {
                'tr': 'Hemen mesaj atarım: "Eşyalarımı izinsiz alma lütfen, bu benim kırmızı çizgim."',
                'en': 'I text right away: "Please do not borrow my stuff without asking, this is a strict boundary for me."',
              },
              effects: {'privacy_need': 1.9, 'conflict_style': 1.7},
            ),
            ScenarioOption(
              id: 'sc_borrow_b',
              text: {
                'tr': 'Temiz ve sağlam getirdiği sürece önemsemem, ben de onunkileri rahatça alabilirim.',
                'en': 'As long as it returns clean and intact, I don’t mind; I expect mutual sharing.',
              },
              effects: {'privacy_need': -1.9, 'social_energy': 1.2},
            ),
            ScenarioOption(
              id: 'sc_borrow_c',
              text: {
                'tr': 'Dönünce sakince "Sorsaydın verirdim ama önceden sormanı rica ediyorum" derim.',
                'en': 'When they return, I calmly say: "I’d lend it if you asked, please ask beforehand next time."',
              },
              effects: {'privacy_need': 1.2, 'conflict_style': 0.5},
            ),
            ScenarioOption(
              id: 'sc_borrow_d',
              text: {
                'tr': 'Odamın kapısını kilitlemeye başlar, bir şey söylemekten çekinirim.',
                'en': 'I start locking my room door and avoid saying anything directly.',
              },
              effects: {'privacy_need': 1.8, 'conflict_style': -1.9},
            ),
          ],
        ),

        // 7. Thermostat wars
        const Scenario(
          id: 'sc_thermostat_wars',
          order: 7,
          category: 'noise',
          weightHints: {'responsibility': 0.7, 'conflict_style': 0.6},
          title: {
            'tr': 'Klima & Kombi Sıcaklık Savaşı',
            'en': 'Thermostat & AC Temperature Wars',
          },
          situation: {
            'tr': 'Yazın sen klima 24°C olsun istersin, o 18°C yapıp dondurur. Kışın sen kombiyi kısmak istersin, o sonuna kadar açar.',
            'en': 'In summer you want AC at 24°C, they drop it to 18°C. In winter you want reasonable heating, they blast radiators on maximum.',
          },
          options: [
            ScenarioOption(
              id: 'sc_thermostat_a',
              text: {
                'tr': 'Sabit bir sıcaklık derecesi belirleyip ikimiz de buna uyacağımıza söz verelim.',
                'en': 'Let us agree on an exact compromise temperature and stick to it.',
              },
              effects: {'chore_fairness': 1.4, 'conflict_style': 0.8},
            ),
            ScenarioOption(
              id: 'sc_thermostat_b',
              text: {
                'tr': 'Fazla yakan veya klimayı açan taraf faturanın ek farkını ödesin.',
                'en': 'Whoever blasts heating or AC should pay the extra margin on utility bills.',
              },
              effects: {'money_style': 1.7, 'responsibility': 1.2},
            ),
            ScenarioOption(
              id: 'sc_thermostat_c',
              text: {
                'tr': 'Gider gizlice dereceyi değiştiririm, fark edene kadar sessizce mücadele ederim.',
                'en': 'I covertly reset the thermostat and engage in silent adjustment battles.',
              },
              effects: {'conflict_style': -1.6, 'noise_tolerance': -0.4},
            ),
            ScenarioOption(
              id: 'sc_thermostat_d',
              text: {
                'tr': 'Üşürsem hırka giyerim, sıcaklarsa vantilatör açarım; ev içinde esneklik esastır.',
                'en': 'I wear a hoodie if cold, use a personal fan if hot; flexibility is key.',
              },
              effects: {'noise_tolerance': 1.0, 'conflict_style': -0.5, 'social_energy': 0.6},
            ),
          ],
        ),

        // 8. Smoking on balcony
        const Scenario(
          id: 'sc_balcony_smoking',
          order: 8,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.85, 'privacy_need': 0.7},
          title: {
            'tr': 'Balkonda Sigara ve İçeri Sızan Duman',
            'en': 'Balcony Smoking and Drifting Smoke',
          },
          situation: {
            'tr': 'Ev arkadaşın balkonda sigara/elektronik sigara içiyor ama balkon kapısı açık kaldığı için duman ve koku doğrudan salona ve senin odana doluyor.',
            'en': 'Your roommate smokes/vapes on the balcony, but leaves the door ajar so smoke and odor drift into your room.',
          },
          options: [
            ScenarioOption(
              id: 'sc_smoking_a',
              text: {
                'tr': 'Sigara dumanına asla tahammül edemem; balkon kapısının kesinlikle kapalı kalmasını şart koşarım.',
                'en': 'I have zero tolerance for smoke; keeping the balcony door sealed is a non-negotiable rule.',
              },
              effects: {'cleanliness': 1.8, 'privacy_need': 1.4, 'conflict_style': 1.3},
            ),
            ScenarioOption(
              id: 'sc_smoking_b',
              text: {
                'tr': 'Hafif koku beni rahatsız etmez, havalandırıp geçerim.',
                'en': 'Faint odors don’t bother me, I just open a window and move on.',
              },
              effects: {'cleanliness': -1.2, 'noise_tolerance': 0.8},
            ),
            ScenarioOption(
              id: 'sc_smoking_c',
              text: {
                'tr': 'Kapıya otomatik kapanan sineklik veya koku giderici almayı öneririm.',
                'en': 'I suggest installing a screen door damper or air purifier.',
              },
              effects: {'cleanliness': 1.0, 'chore_fairness': 1.1, 'money_style': 0.5},
            ),
            ScenarioOption(
              id: 'sc_smoking_d',
              text: {
                'tr': 'İçeride tütsü veya oda spreyi sıkarak kokuyu bastırmaya çalışırım.',
                'en': 'I light incense or spray air freshener to cover the smell without confrontation.',
              },
              effects: {'cleanliness': 0.0, 'conflict_style': -1.2},
            ),
          ],
        ),

        // 9. Late cooking smells
        const Scenario(
          id: 'sc_cooking_smells',
          order: 9,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.75, 'sleep_schedule': 0.6},
          title: {
            'tr': 'Gece 01:00 Ağır Yemek Kokusu',
            'en': 'Late-Night Heavy Cooking Smells',
          },
          situation: {
            'tr': 'Gece 01:30’da ev arkadaşın mutfakta yoğun baharatlı veya balık/kızartma tarzı yemek pişiriyor. Aspiratörü açmamış ve koku tüm eve yayılmış.',
            'en': 'At 1:30 AM your roommate starts cooking strong spiced or fried food without turning on the vent, filling the apartment with fumes.',
          },
          options: [
            ScenarioOption(
              id: 'sc_cooking_a',
              text: {
                'tr': 'Mutfağa gidip aspiratörü açar, "Gece bu saatte kokulu yemek yapmasak harika olur" derim.',
                'en': 'I go to the kitchen, switch on the hood, and say: "Could we avoid aromatic frying at this hour?"',
              },
              effects: {'cleanliness': 1.4, 'sleep_schedule': -1.3, 'conflict_style': 1.5},
            ),
            ScenarioOption(
              id: 'sc_cooking_b',
              text: {
                'tr': 'Kokuyu alınca acıkırım, gider bana da bir tabak ayırmasını rica ederim!',
                'en': 'Smelling it makes me hungry; I walk in and ask if there’s an extra plate for me!',
              },
              effects: {'cleanliness': -1.0, 'social_energy': 1.8, 'sleep_schedule': 1.6},
            ),
            ScenarioOption(
              id: 'sc_cooking_c',
              text: {
                'tr': 'Odamın kapı altına havlu koyup pencereyi açarım, uykuya dalarım.',
                'en': 'I wedge a towel under my bedroom door, open my window, and sleep.',
              },
              effects: {'privacy_need': 1.2, 'conflict_style': -1.4},
            ),
            ScenarioOption(
              id: 'sc_cooking_d',
              text: {
                'tr': 'Ertesi gün aspiratör ve mutfak penceresi kuralını konuşurum.',
                'en': 'The next day, I initiate a discussion about kitchen ventilation etiquette.',
              },
              effects: {'cleanliness': 1.0, 'conflict_style': 0.6, 'responsibility': 0.8},
            ),
          ],
        ),

        // 10. Early alarm snoozing
        const Scenario(
          id: 'sc_early_alarm',
          order: 10,
          category: 'sleep',
          weightHints: {'sleep_schedule': 0.9, 'noise_tolerance': 0.8},
          title: {
            'tr': 'Sabah 06:30’da 5 Kez Ertelenen Alarm',
            'en': 'Snoozed 6:30 AM Alarms',
          },
          situation: {
            'tr': 'Ev arkadaşının alarmı sabah 06:30’dan 07:30’a kadar her 10 dakikada bir yüksek sesle çalıyor. O uyanmıyor ama sen uykundan uyanıyorsun.',
            'en': 'Your roommate’s phone alarm rings every 10 minutes from 6:30 to 7:30 AM at full volume. They sleep through it while you are repeatedly jolted awake.',
          },
          options: [
            ScenarioOption(
              id: 'sc_alarm_a',
              text: {
                'tr': 'Kapısına vurup "Lütfen şu alarmı kapat ya da uyan artık!" derim.',
                'en': 'I knock firmly on their door and say: "Please turn off that alarm or get up!"',
              },
              effects: {'noise_tolerance': -1.8, 'conflict_style': 1.6, 'sleep_schedule': -0.8},
            ),
            ScenarioOption(
              id: 'sc_alarm_b',
              text: {
                'tr': 'Ben zaten erken kalkan biriyim, beni rahatsız etmez güne başlarım.',
                'en': 'I am an early bird anyway, so it doesn’t bother me and I start my day.',
              },
              effects: {'sleep_schedule': -1.9, 'noise_tolerance': 1.2},
            ),
            ScenarioOption(
              id: 'sc_alarm_c',
              text: {
                'tr': 'Titreşimli akıllı bileklik veya akıllı ışıklı alarm kullanmasını öneririm.',
                'en': 'I gently suggest they switch to a vibrating smartwatch or light-based alarm.',
              },
              effects: {'noise_tolerance': -1.0, 'conflict_style': 0.7, 'chore_fairness': 0.8},
            ),
            ScenarioOption(
              id: 'sc_alarm_d',
              text: {
                'tr': 'Yastığı başıma bastırıp içimden öfkelenirim ama bir şey demem.',
                'en': 'I press a pillow over my ears and fume silently without confronting.',
              },
              effects: {'noise_tolerance': -1.2, 'conflict_style': -1.8},
            ),
          ],
        ),

        // 11. Friday party vs exam
        const Scenario(
          id: 'sc_friday_party',
          order: 11,
          category: 'social',
          weightHints: {'social_energy': 0.9, 'guest_policy': 0.85},
          title: {
            'tr': 'Cuma Akşamı Ev Partisi',
            'en': 'Friday Night House Party',
          },
          situation: {
            'tr': 'Haftanın yorgunluğu üzerindeyken cuma akşamı eve geldiğinde salonda 10 kişilik bir arkadaş grubunun toplandığını görüyorsun.',
            'en': 'After an exhausting week, you get home on Friday evening to find 10 people gathered in the living room for drinks.',
          },
          options: [
            ScenarioOption(
              id: 'sc_party_a',
              text: {
                'tr': 'Harika! Hemen üzerimi değiştirip partiye dahil olur, eğlencenin tadını çıkarırım.',
                'en': 'Awesome! I quickly change and join the party to unwind and socialize.',
              },
              effects: {'social_energy': 1.9, 'guest_policy': 1.8, 'noise_tolerance': 1.5},
            ),
            ScenarioOption(
              id: 'sc_party_b',
              text: {
                'tr': 'Önceden haber verilmediği için sinirlenir, doğrudan odama çekilip kapımı kapatırım.',
                'en': 'I get upset that I was not given a heads-up, head straight to my bedroom and shut the door.',
              },
              effects: {'social_energy': -1.8, 'guest_policy': -1.7, 'privacy_need': 1.8},
            ),
            ScenarioOption(
              id: 'sc_party_c',
              text: {
                'tr': 'Kısa bir selam verir, 15 dakika sohbet edip sonra kendi dinlenme alanıma geçerim.',
                'en': 'I say a friendly hello, chat for 15 minutes, then politely retreat to rest.',
              },
              effects: {'social_energy': 0.5, 'guest_policy': 0.3, 'privacy_need': 0.8},
            ),
            ScenarioOption(
              id: 'sc_party_d',
              text: {
                'tr': 'Toplu etkinlikler için 24 saat önceden onaylaşma kuralı getirilmesini isterim.',
                'en': 'I want a strict rule requiring 24-hour advance notice for any group gathering.',
              },
              effects: {'guest_policy': -1.4, 'responsibility': 1.5, 'conflict_style': 0.8},
            ),
          ],
        ),

        // 12. Bathroom schedule rush
        const Scenario(
          id: 'sc_bathroom_rush',
          order: 12,
          category: 'chore',
          weightHints: {'chore_fairness': 0.85, 'privacy_need': 0.75},
          title: {
            'tr': 'Sabah 08:30 Banyo Trafiği',
            'en': 'Morning 8:30 AM Bathroom Rush',
          },
          situation: {
            'tr': 'İkinizin de evden 09:00’da çıkması gerekiyor. Ev arkadaşın banyoya girip 40 dakika boyunca saç-makyaj-duş keyfi yapıyor.',
            'en': 'Both of you need to leave the apartment at 9:00 AM. Your roommate occupies the single bathroom for 40 minutes doing hair, shower, and makeup.',
          },
          options: [
            ScenarioOption(
              id: 'sc_bath_a',
              text: {
                'tr': 'Sabah saatleri için kesin bir banyo zaman çizelgesi (örn: 20’şer dakika) yapmalıyız.',
                'en': 'We need a strict morning schedule slot (e.g. 20 minutes each max).',
              },
              effects: {'chore_fairness': 1.8, 'responsibility': 1.4, 'conflict_style': 1.0},
            ),
            ScenarioOption(
              id: 'sc_bath_b',
              text: {
                'tr': 'Ben alarmımı 30 dakika daha erkene kurar, o uyanmadan işimi hallederim.',
                'en': 'I set my alarm 30 minutes earlier so I finish before they even wake up.',
              },
              effects: {'chore_fairness': -1.0, 'sleep_schedule': -1.5, 'conflict_style': -1.2},
            ),
            ScenarioOption(
              id: 'sc_bath_c',
              text: {
                'tr': 'Kapıyı tıklar "Geç kalıyorum, dişimi fırçalayıp çıkabilir miyim?" diye araya girerim.',
                'en': 'I knock and ask: "I am running late, mind if I brush my teeth quickly?"',
              },
              effects: {'privacy_need': -1.0, 'conflict_style': 1.2, 'social_energy': 0.5},
            ),
            ScenarioOption(
              id: 'sc_bath_d',
              text: {
                'tr': 'Akşamdan duş alırım, sabah banyo ihtiyacımı minimumda tutarım.',
                'en': 'I shower at night and keep morning bathroom routines under 5 minutes.',
              },
              effects: {'privacy_need': 0.6, 'noise_tolerance': 0.5},
            ),
          ],
        ),

        // 13. Pet accident
        const Scenario(
          id: 'sc_pet_accident',
          order: 13,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.8, 'responsibility': 0.8},
          title: {
            'tr': 'Evcil Hayvanın Salona Zararı',
            'en': 'Pet Accident on the Living Room Rug',
          },
          situation: {
            'tr': 'Ev arkadaşının kedisi veya köpeği salondaki halıya pisledi veya tırmaladı. Ev arkadaşın okulda/işte ve akşama kadar gelmeyecek.',
            'en': 'Your roommate’s pet vomited or scratched the living room rug. The roommate is away until tonight.',
          },
          options: [
            ScenarioOption(
              id: 'sc_pet_a',
              text: {
                'tr': 'Hayvanı severim; temizliğini hemen yapar, gelince haber verir masrafı varsa paylaşırım.',
                'en': 'I love pets; I clean it up immediately and let them know gently when they arrive.',
              },
              effects: {'cleanliness': 1.0, 'responsibility': 1.4, 'social_energy': 0.8},
            ),
            ScenarioOption(
              id: 'sc_pet_b',
              text: {
                'tr': 'Fotoğrafını çekip "Hemen gelip temizlemen gerekiyor" derim, asla dokunmam.',
                'en': 'I message them: "You need to come home and clean this right away", I won’t touch it.',
              },
              effects: {'cleanliness': 1.6, 'responsibility': -0.4, 'conflict_style': 1.6, 'privacy_need': 1.5},
            ),
            ScenarioOption(
              id: 'sc_pet_c',
              text: {
                'tr': 'Üzerini gazete veya bezle örter, gelince temizlemesini beklerim.',
                'en': 'I cover it with paper towels and wait for them to clean it when they return.',
              },
              effects: {'cleanliness': 0.2, 'conflict_style': -0.5},
            ),
            ScenarioOption(
              id: 'sc_pet_d',
              text: {
                'tr': 'Evcil hayvanlı evde böyle şeyler doğaldır, dert etmem.',
                'en': 'These things are natural in pet homes; I brush it off with zero stress.',
              },
              effects: {'cleanliness': -1.2, 'noise_tolerance': 1.2},
            ),
          ],
        ),

        // 14. Couch surfer friend
        const Scenario(
          id: 'sc_couch_surfer',
          order: 14,
          category: 'guest_policy',
          weightHints: {'guest_policy': 0.9, 'privacy_need': 0.85},
          title: {
            'tr': 'Salonda 10 Gün Yatan Arkadaş',
            'en': 'A Friend Crashing on the Couch for 10 Days',
          },
          situation: {
            'tr': 'Ev arkadaşının memleketten gelen bir arkadaşı "birkaç gün kalacağım" diyerek salondaki koltuğa yerleşti ve 10 gündür gitmiyor.',
            'en': 'Your roommate’s hometown friend came for "a couple of days", camped out on the sofa, and is still there on day 10.',
          },
          options: [
            ScenarioOption(
              id: 'sc_couch_a',
              text: {
                'tr': 'Ev arkadaşımı kenara çeker ve "Bu misafirlik süresi aşıldı, bir tarih belirleyin" derim.',
                'en': 'I pull my roommate aside and say: "This has exceeded a normal stay, you need an exit date."',
              },
              effects: {'guest_policy': -1.8, 'privacy_need': 1.8, 'conflict_style': 1.5},
            ),
            ScenarioOption(
              id: 'sc_couch_b',
              text: {
                'tr': 'Kira ve faturalara üçüncü bir kişi gibi katkı sağladığı sürece kalabilir.',
                'en': 'They can stay as long as they contribute a fair third toward rent and bills.',
              },
              effects: {'money_style': 1.8, 'guest_policy': 0.5, 'responsibility': 1.2},
            ),
            ScenarioOption(
              id: 'sc_couch_c',
              text: {
                'tr': 'Salonu kullanamadığım için odamdan çıkmamaya başlarım.',
                'en': 'I isolate in my bedroom because the living room no longer feels accessible.',
              },
              effects: {'guest_policy': -1.0, 'privacy_need': 1.6, 'conflict_style': -1.8},
            ),
            ScenarioOption(
              id: 'sc_couch_d',
              text: {
                'tr': 'Yeni insan tanımak keyifli, arkadaşla kaynaşıp gezer tozarız.',
                'en': 'I enjoy meeting new people; I hang out with the friend and make the best of it.',
              },
              effects: {'social_energy': 1.9, 'guest_policy': 1.7, 'noise_tolerance': 1.2},
            ),
          ],
        ),

        // 15. Wi-Fi Bandwidth hog
        const Scenario(
          id: 'sc_wifi_bandwidth',
          order: 15,
          category: 'responsibility',
          weightHints: {'responsibility': 0.75, 'conflict_style': 0.6},
          title: {
            'tr': 'İnternet Kotası ve Yüksek Ping',
            'en': 'Wi-Fi Bandwidth & Torrent Lag',
          },
          situation: {
            'tr': 'Sen online mülakattayken veya dersteyken ev arkadaşın dev oyun indirmesi veya canlı yayın başlatıyor ve internetin tamamen donuyor.',
            'en': 'While you are on an important Zoom call or exam, your roommate starts massive game downloads, causing your video to freeze.',
          },
          options: [
            ScenarioOption(
              id: 'sc_wifi_a',
              text: {
                'tr': 'Modeme girip hız sınırlaması (QoS) tanımlarım veya internet paketini yükseltmeyi teklif ederim.',
                'en': 'I configure router QoS bandwidth limits or propose upgrading to a gigabit fiber plan.',
              },
              effects: {'responsibility': 1.6, 'money_style': 0.8, 'chore_fairness': 1.2},
            ),
            ScenarioOption(
              id: 'sc_wifi_b',
              text: {
                'tr': 'O an odasına gidip acil bir görüşmede olduğumu, indirmeyi durdurmasını söylerim.',
                'en': 'I step into their room right away and ask them to pause their downloads during my meeting.',
              },
              effects: {'conflict_style': 1.5, 'noise_tolerance': -0.8},
            ),
            ScenarioOption(
              id: 'sc_wifi_c',
              text: {
                'tr': 'Kendi telefonumun hücresel internetine geçer, uzatmam.',
                'en': 'I switch to mobile hotspot data and avoid arguing.',
              },
              effects: {'conflict_style': -1.4, 'privacy_need': 0.8},
            ),
            ScenarioOption(
              id: 'sc_wifi_d',
              text: {
                'tr': 'İndirmeleri gece 02:00’den sonraya planlamak için ortak kural koyalım.',
                'en': 'Let’s establish an agreement to schedule heavy downloads after 2 AM.',
              },
              effects: {'chore_fairness': 1.5, 'responsibility': 1.3},
            ),
          ],
        ),

        // 16. Sunday deep cleaning vs casual
        const Scenario(
          id: 'sc_cleaning_day',
          order: 16,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.9, 'chore_fairness': 0.85},
          title: {
            'tr': 'Pazar Temizliği Tartışması',
            'en': 'Sunday Cleaning Routine',
          },
          situation: {
            'tr': 'Sen her pazar sabahı yerlerin silindiği, banyonun ovulduğu detaylı temizlik istiyorsun; ev arkadaşın ise "kirlenince bakarız" kafasında.',
            'en': 'You prefer a thorough weekly Sunday deep clean; your roommate prefers an ad-hoc "clean whenever it looks dirty" approach.',
          },
          options: [
            ScenarioOption(
              id: 'sc_clean_a',
              text: {
                'tr': 'Haftalık görev çizelgesi asarız, herkes sırası gelince sorumlu olduğu bölgeyi temizler.',
                'en': 'We hang a chore chart; everyone cleans their designated zone on their week.',
              },
              effects: {'cleanliness': 1.6, 'chore_fairness': 1.8, 'responsibility': 1.4},
            ),
            ScenarioOption(
              id: 'sc_clean_b',
              text: {
                'tr': 'Ayda 2 kez profesyonel temizlikçi çağıralım, masrafı yarı yarıya bölüşelim.',
                'en': 'Let’s hire a professional cleaner twice a month and split the cost 50/50.',
              },
              effects: {'cleanliness': 1.5, 'money_style': 1.2, 'chore_fairness': 0.6},
            ),
            ScenarioOption(
              id: 'sc_clean_c',
              text: {
                'tr': 'Herkes sadece kendi odasını temizlesin, ortak alanları ben içim elverdiğince yaparım.',
                'en': 'Everyone does their own room; I clean the common areas when my patience runs out.',
              },
              effects: {'cleanliness': 0.8, 'chore_fairness': -1.2, 'conflict_style': -1.0},
            ),
            ScenarioOption(
              id: 'sc_clean_d',
              text: {
                'tr': 'Aşırı kuralcılık evi kışlaya çevirir, rahat olmak temizlikten daha önemlidir.',
                'en': 'Too many rigid rules ruin the vibe; being relaxed matters more than spotless floors.',
              },
              effects: {'cleanliness': -1.8, 'chore_fairness': -1.5, 'social_energy': 0.8},
            ),
          ],
        ),

        // 17. Fridge shelf labeling
        const Scenario(
          id: 'sc_fridge_labeling',
          order: 17,
          category: 'privacy',
          weightHints: {'privacy_need': 0.8, 'money_style': 0.7},
          title: {
            'tr': 'Buzdolabı Rafları ve Etiketleme',
            'en': 'Fridge Shelf Separation vs Sharing',
          },
          situation: {
            'tr': 'Buzdolabında aldığın özel peynir veya sütün birkaç kez ev arkadaşın tarafından "nasılsa evde var" denerek tüketildiğini gördün.',
            'en': 'You find that your specialty cheese or milk in the fridge was consumed because "it was just sitting there."',
          },
          options: [
            ScenarioOption(
              id: 'sc_fridge_a',
              text: {
                'tr': 'Rafları net ayırırız, herkes kendi rafına etiket yapıştırır; izinsiz almak yasaktır.',
                'en': 'We designate separate shelves and label items; taking without permission is prohibited.',
              },
              effects: {'privacy_need': 1.8, 'money_style': 1.5, 'responsibility': 1.2},
            ),
            ScenarioOption(
              id: 'sc_fridge_b',
              text: {
                'tr': 'Bitebilir sorun değil, tüketen kişi yenisini marketten alır gelir.',
                'en': 'No big deal; whoever finishes it simply buys a replacement.',
              },
              effects: {'privacy_need': -1.5, 'money_style': -1.2, 'social_energy': 0.8},
            ),
            ScenarioOption(
              id: 'sc_fridge_c',
              text: {
                'tr': 'Ortak ürünler için ayrı bir sepet yaparız, kişisel olanlara dokunulmaz.',
                'en': 'We create a communal basket for staples, while personal treats are left untouched.',
              },
              effects: {'privacy_need': 0.9, 'chore_fairness': 1.2, 'responsibility': 0.8},
            ),
            ScenarioOption(
              id: 'sc_fridge_d',
              text: {
                'tr': 'Özel yiyeceklerimi odamdaki mini buzdolabında saklamayı tercih ederim.',
                'en': 'I’d rather keep a mini fridge in my bedroom for my private food items.',
              },
              effects: {'privacy_need': 2.0, 'social_energy': -1.4},
            ),
          ],
        ),

        // 18. WFH Speakerphone calls
        const Scenario(
          id: 'sc_wfh_calls',
          order: 18,
          category: 'noise',
          weightHints: {'noise_tolerance': 0.85, 'privacy_need': 0.8},
          title: {
            'tr': 'Salonda Hoparlörle Yapılan Toplantılar',
            'en': 'Speakerphone Zoom Calls in Living Room',
          },
          situation: {
            'tr': 'Ev arkadaşın evden çalışıyor ve tüm gün salondaki masada hoparlör açık şekilde yüksek sesle müşteri toplantıları yapıyor.',
            'en': 'Your roommate works from home and conducts speakerphone client calls at the dining table all day.',
          },
          options: [
            ScenarioOption(
              id: 'sc_wfh_a',
              text: {
                'tr': '"Toplantılar için kulaklık kullanabilir misin veya odana geçebilir misin?" derim.',
                'en': 'I request: "Could you please use headphones or take calls in your bedroom?"',
              },
              effects: {'noise_tolerance': -1.7, 'privacy_need': 1.6, 'conflict_style': 1.4},
            ),
            ScenarioOption(
              id: 'sc_wfh_b',
              text: {
                'tr': 'Kendi kulaklığımı takar müzik dinlerim, çalışmasını kısıtlamak istemem.',
                'en': 'I put on my noise-cancelling headphones; I don’t want to restrict their work.',
              },
              effects: {'noise_tolerance': 0.8, 'conflict_style': -1.0},
            ),
            ScenarioOption(
              id: 'sc_wfh_c',
              text: {
                'tr': 'Salonun ortak çalışma ve sessizlik saatlerini belirleyelim.',
                'en': 'Let’s establish designated quiet working hours for the living room.',
              },
              effects: {'chore_fairness': 1.5, 'responsibility': 1.3},
            ),
            ScenarioOption(
              id: 'sc_wfh_d',
              text: {
                'tr': 'Ben de salonda takılır, konuşmalarına kulak misafiri olur ortamı paylaşırım.',
                'en': 'I lounge in the room too and don’t mind ambient professional chatter.',
              },
              effects: {'noise_tolerance': 1.8, 'social_energy': 1.2},
            ),
          ],
        ),

        // 19. Personal belongings in lounge
        const Scenario(
          id: 'sc_personal_belongings',
          order: 19,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.85, 'privacy_need': 0.7},
          title: {
            'tr': 'Ortak Alana Dağıtılan Özel Eşyalar',
            'en': 'Personal Belongings Cluttering Common Space',
          },
          situation: {
            'tr': 'Salondaki sehpa ve kanepeler ev arkadaşının montları, çantaları, spor eşyaları ve kablolarıyla sürekli dolu.',
            'en': 'The living room sofa and coffee table are permanently occupied by your roommate’s gym bags, jackets, and wires.',
          },
          options: [
            ScenarioOption(
              id: 'sc_clutter_a',
              text: {
                'tr': 'Ortak alanda gün sonunda hiçbir kişisel eşya bırakılmaması kuralı koyarım.',
                'en': 'I enforce a rule: no personal items left in common rooms overnight.',
              },
              effects: {'cleanliness': 1.8, 'privacy_need': 1.5, 'chore_fairness': 1.2},
            ),
            ScenarioOption(
              id: 'sc_clutter_b',
              text: {
                'tr': 'Gözüme battıkça eşyalarını toplayıp kapısının önüne bırakırım.',
                'en': 'Whenever it annoys me, I dump their belongings outside their bedroom door.',
              },
              effects: {'cleanliness': 1.2, 'conflict_style': -0.8},
            ),
            ScenarioOption(
              id: 'sc_clutter_c',
              text: {
                'tr': 'Ev dediğin yaşanmışlık kokar; aşırı düzen takıntım yoktur, beni germez.',
                'en': 'A home should feel lived-in; tidy obsession stresses me out, so it’s fine.',
              },
              effects: {'cleanliness': -1.9, 'noise_tolerance': 0.8},
            ),
            ScenarioOption(
              id: 'sc_clutter_d',
              text: {
                'tr': 'Salona kapaklı bir dolap veya sepet alıp pratik çözüm üretmeyi öneririm.',
                'en': 'I suggest placing a storage basket in the living room for quick decluttering.',
              },
              effects: {'chore_fairness': 1.2, 'cleanliness': 0.8, 'conflict_style': 0.5},
            ),
          ],
        ),

        // 20. Lost keys late night
        const Scenario(
          id: 'sc_keys_lost',
          order: 20,
          category: 'responsibility',
          weightHints: {'responsibility': 0.85, 'sleep_schedule': 0.7},
          title: {
            'tr': 'Gece 03:00’te Unutulan Anahtarlar',
            'en': 'Forgotten Keys Buzzing at 3 AM',
          },
          situation: {
            'tr': 'Ev arkadaşın bu ay üçüncü kez anahtarını unuttu ve gece yarısı zili çalıp seni uykundan kaldırarak kapıyı açtırdı.',
            'en': 'For the third time this month, your roommate forgot their keys and buzzes your doorbell at 3 AM to be let in.',
          },
          options: [
            ScenarioOption(
              id: 'sc_keys_a',
              text: {
                'tr': 'Açarım ama ertesi sabah yedek anahtar yaptırıp paspas altına veya güvenilir bir yere koymasını isterim.',
                'en': 'I let them in, but require making a spare key copy stored with building security or keybox.',
              },
              effects: {'responsibility': 1.7, 'conflict_style': 0.8},
            ),
            ScenarioOption(
              id: 'sc_keys_b',
              text: {
                'tr': 'Kapıyı açar açmaz sert bir dille uyarır ve tekrarlanmamasını isterim.',
                'en': 'I reprimand them on the spot and insist it never happens again.',
              },
              effects: {'responsibility': 1.5, 'conflict_style': 1.8, 'noise_tolerance': -1.2},
            ),
            ScenarioOption(
              id: 'sc_keys_c',
              text: {
                'tr': 'Gülüp geçerim, herkes unutabilir; ev arkadaşı olmak böyle şeyleri hoş görmektir.',
                'en': 'I laugh it off; anyone can forget, being roommates means giving grace.',
              },
              effects: {'responsibility': -1.0, 'social_energy': 1.2, 'conflict_style': -0.8},
            ),
            ScenarioOption(
              id: 'sc_keys_d',
              text: {
                'tr': 'Telefonumu sessize alır, zili duymazdan gelmeyi düşünürüm.',
                'en': 'I consider putting my phone on silent and ignoring the doorbell.',
              },
              effects: {'conflict_style': -1.9, 'responsibility': -0.5},
            ),
          ],
        ),

        // 21. Sticky notes vs direct talk
        const Scenario(
          id: 'sc_passive_sticky_note',
          order: 21,
          category: 'conflict',
          weightHints: {'conflict_style': 0.95},
          title: {
            'tr': 'Buzdolabındaki Yapışkan Notlar',
            'en': 'Sticky Notes on the Fridge',
          },
          situation: {
            'tr': 'Bir konuda rahatsızlık yaşandığında (çöpün atılmaması, ışıkların açık unutulması gibi) hangi iletişim tarzını tercih edersin?',
            'en': 'When an issue arises (trash not taken out, lights left on), how do you prefer communication to happen?',
          },
          options: [
            ScenarioOption(
              id: 'sc_comm_a',
              text: {
                'tr': 'Göz göze, yüz yüze konuşmak; imalı notlar veya mesajlar ortamı gerer.',
                'en': 'Face-to-face, eye-to-eye; sticky notes or passive texts create unnecessary tension.',
              },
              effects: {'conflict_style': 1.9, 'social_energy': 0.8},
            ),
            ScenarioOption(
              id: 'sc_comm_b',
              text: {
                'tr': 'Ev WhatsApp grubundan tatlı ve emojili bir hatırlatma mesajı atmak en kolayı.',
                'en': 'A friendly emoji reminder in our roommate group chat is the easiest and least awkward.',
              },
              effects: {'conflict_style': 0.0, 'social_energy': 0.2},
            ),
            ScenarioOption(
              id: 'sc_comm_c',
              text: {
                'tr': 'Buzdolabına nazik bir not bırakmak doğrudan yüzleşmekten daha az kırıcıdır.',
                'en': 'Leaving a polite note on the board is less confrontational than direct argument.',
              },
              effects: {'conflict_style': -1.5, 'privacy_need': 0.8},
            ),
            ScenarioOption(
              id: 'sc_comm_d',
              text: {
                'tr': 'Küçük şeyleri büyütmeyip kendim halletmeyi, hiç konu açmamayı seçerim.',
                'en': 'I just handle it myself without making a fuss or bringing it up.',
              },
              effects: {'conflict_style': -1.9, 'chore_fairness': -1.0},
            ),
          ],
        ),

        // 22. Mental health low period
        const Scenario(
          id: 'sc_mental_health_slump',
          order: 22,
          category: 'social',
          weightHints: {'social_energy': 0.8, 'privacy_need': 0.8},
          title: {
            'tr': 'Düşük Mod ve İnziva Dönemleri',
            'en': 'Low Mood & Solitude Periods',
          },
          situation: {
            'tr': 'Zor bir dönemden geçerken evde nasıl bir tutum sergilersin ve ev arkadaşından ne beklersin?',
            'en': 'When you are going through a tough psychological period, what is your domestic dynamic preference?',
          },
          options: [
            ScenarioOption(
              id: 'sc_mood_a',
              text: {
                'tr': 'Odamda yalnız kalmak ve sıfır soru sorulması; alanıma saygı duyulması en büyük beklentimdir.',
                'en': 'Total solitude in my room with zero questions asked; space is my healing mechanism.',
              },
              effects: {'privacy_need': 2.0, 'social_energy': -1.8},
            ),
            ScenarioOption(
              id: 'sc_mood_b',
              text: {
                'tr': 'Ev arkadaşımın bir kahve yapıp dinlemesi, dertleşmek ve paylaşmak bana iyi gelir.',
                'en': 'A roommate brewing tea, offering a listening ear, and talking things through.',
              },
              effects: {'social_energy': 1.8, 'privacy_need': -1.5},
            ),
            ScenarioOption(
              id: 'sc_mood_c',
              text: {
                'tr': 'Ev işlerini aksatmamak şartıyla herkes kendi havasında takılmalıdır.',
                'en': 'As long as house responsibilities aren’t dropped, everyone manages their own emotions.',
              },
              effects: {'responsibility': 1.5, 'chore_fairness': 1.3},
            ),
            ScenarioOption(
              id: 'sc_mood_d',
              text: {
                'tr': 'Birlikte film izlemek veya dışarı çıkmak gibi dikkati dağıtıcı aktivitelere açığımdır.',
                'en': 'I welcome casual distractions like ordering takeout or watching a movie together.',
              },
              effects: {'social_energy': 1.2, 'noise_tolerance': 0.6},
            ),
          ],
        ),

        // 23. Early lease break
        const Scenario(
          id: 'sc_early_lease_break',
          order: 23,
          category: 'responsibility',
          weightHints: {'responsibility': 0.9, 'money_style': 0.85},
          title: {
            'tr': 'Sözleşme Bitmeden Evden Ayrılmak',
            'en': 'Breaking the Lease Early',
          },
          situation: {
            'tr': 'Kira kontratının bitmesine 4 ay kala ev arkadaşın aniden "Taşınmam gerekiyor" dedi.',
            'en': 'With 4 months remaining on the lease, your roommate abruptly announces they are moving out.',
          },
          options: [
            ScenarioOption(
              id: 'sc_lease_a',
              text: {
                'tr': 'Yerine onayladığım yeni bir ev arkadaşı bulana kadar kendi payını ödemeye devam etmelidir.',
                'en': 'They must continue paying their share until finding a qualified replacement roommate approved by me.',
              },
              effects: {'responsibility': 1.9, 'money_style': 1.7, 'conflict_style': 1.2},
            ),
            ScenarioOption(
              id: 'sc_lease_b',
              text: {
                'tr': 'Depozitosunu bırakıp gidebilir, yeni birini bulma yükünü ben üstlenirim.',
                'en': 'They forfeit their deposit and leave; I will manage finding a new roommate.',
              },
              effects: {'money_style': 0.5, 'responsibility': 0.2},
            ),
            ScenarioOption(
              id: 'sc_lease_c',
              text: {
                'tr': 'Hayat beklenmedik sürprizlerle dolu, zorluk çıkarmadan vedalaşırım.',
                'en': 'Life is unpredictable; I let them go amicably without adding stress.',
              },
              effects: {'responsibility': -1.2, 'social_energy': 0.6},
            ),
            ScenarioOption(
              id: 'sc_lease_d',
              text: {
                'tr': 'Ev sahibine danışıp evi birlikte kapatmayı veya devretmeyi teklif ederim.',
                'en': 'I consult the landlord and suggest terminating or transferring the entire lease.',
              },
              effects: {'responsibility': 1.2, 'chore_fairness': 1.0},
            ),
          ],
        ),

        // 24. Decorating common walls
        const Scenario(
          id: 'sc_decorating_style',
          order: 24,
          category: 'privacy',
          weightHints: {'privacy_need': 0.7, 'social_energy': 0.6},
          title: {
            'tr': 'Salona Tablo & Dekorasyon Asmak',
            'en': 'Decorating Shared Living Room Walls',
          },
          situation: {
            'tr': 'Ev arkadaşın salona kendi zevkine göre büyük bir poster veya dini/politik simge içeren bir tablo asmak istiyor.',
            'en': 'Your roommate wants to hang a large art print or ideological poster in the shared living room.',
          },
          options: [
            ScenarioOption(
              id: 'sc_decor_a',
              text: {
                'tr': 'Ortak alanlar nötr olmalıdır; kişisel zevkler ve posterler sadece yatak odalarında kalmalı.',
                'en': 'Common rooms must stay neutral; subjective posters belong exclusively in bedrooms.',
              },
              effects: {'privacy_need': 1.6, 'chore_fairness': 1.2},
            ),
            ScenarioOption(
              id: 'sc_decor_b',
              text: {
                'tr': 'İkimizin de sevdiği ortak bir parça seçebiliriz; birlikte karar almak keyiflidir.',
                'en': 'We can curate wall decor together; joint aesthetic choices make a home warm.',
              },
              effects: {'social_energy': 1.5, 'chore_fairness': 1.1},
            ),
            ScenarioOption(
              id: 'sc_decor_c',
              text: {
                'tr': 'Duvara ne astığı beni hiç ilgilendirmez, estetik tartışmalara girmem.',
                'en': 'I couldn’t care less what is hung on the wall; aesthetics aren’t worth debating.',
              },
              effects: {'noise_tolerance': 1.2, 'privacy_need': -1.0},
            ),
            ScenarioOption(
              id: 'sc_decor_d',
              text: {
                'tr': 'Duvarları yarı yarıya bölüşelim, o bir tarafı assın ben diğer tarafı.',
                'en': 'Divide the wall 50/50: they decorate one side, I decorate the other.',
              },
              effects: {'chore_fairness': 1.5, 'conflict_style': 0.8},
            ),
          ],
        ),

        // 25. Recycling habits
        const Scenario(
          id: 'sc_recycling_habits',
          order: 25,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.7, 'responsibility': 0.7},
          title: {
            'tr': 'Geri Dönüşüm ve Çöp Ayrıştırma',
            'en': 'Waste Sorting and Recycling',
          },
          situation: {
            'tr': 'Evde plastik, cam ve organik atıkların ayrı poşetlere konmasını istiyorsun, ev arkadaşın ise her şeyi tek çöp kovasına atıyor.',
            'en': 'You separate plastics, paper, and food scraps; your roommate tosses everything into a single trash bag.',
          },
          options: [
            ScenarioOption(
              id: 'sc_recy_a',
              text: {
                'tr': 'Çevre bilinci benim için esastır; renkli kutular alıp ayrıştırmayı kural haline getiririm.',
                'en': 'Environmental responsibility is essential to me; I set up labeled sorting bins as a house rule.',
              },
              effects: {'responsibility': 1.7, 'cleanliness': 1.3, 'conflict_style': 1.0},
            ),
            ScenarioOption(
              id: 'sc_recy_b',
              text: {
                'tr': 'Kendi atıklarımı ayırırım ama ona karışmam, herkesin kendi vicdanıdır.',
                'en': 'I sort my own recyclables and let them do whatever they want.',
              },
              effects: {'privacy_need': 1.2, 'conflict_style': -0.8},
            ),
            ScenarioOption(
              id: 'sc_recy_c',
              text: {
                'tr': 'Ayrıştırma ile uğraşamam, tek çöp kutusu pratik ve yeterlidir.',
                'en': 'I cannot bother sorting trash; a single bag is practical and fast.',
              },
              effects: {'cleanliness': -1.0, 'responsibility': -1.2},
            ),
            ScenarioOption(
              id: 'sc_recy_d',
              text: {
                'tr': 'Çöpü atan kişi kutuyu da dışarı çıkarsın yeter, detaylara takılmam.',
                'en': 'As long as full bags are taken out before smelling, I don’t mind how it’s packed.',
              },
              effects: {'cleanliness': 0.5, 'chore_fairness': 0.8},
            ),
          ],
        ),

        // 26. Moldy food in fridge
        const Scenario(
          id: 'sc_food_expiration',
          order: 26,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.9},
          title: {
            'tr': 'Dolapta Küflenen Yemek Kabı',
            'en': 'Moldy Leftovers in Tupperware',
          },
          situation: {
            'tr': 'Ev arkadaşının 3 hafta önce koyduğu saklama kabındaki yemek yeşermiş ve küflenmiş şekilde buzdolabının arkasında duruyor.',
            'en': 'Your roommate’s leftover pasta in a container has turned green and moldy in the back of the fridge for 3 weeks.',
          },
          options: [
            ScenarioOption(
              id: 'sc_mold_a',
              text: {
                'tr': 'Kokusuna katlanamam, kabıyla birlikte çöpe atarım ve sonra "Atmak zorunda kaldım" derim.',
                'en': 'I throw the entire moldy container into the trash and inform them afterwards.',
              },
              effects: {'cleanliness': 1.7, 'conflict_style': 1.2, 'privacy_need': -0.5},
            ),
            ScenarioOption(
              id: 'sc_mold_b',
              text: {
                'tr': 'Kabı çıkarıp tezgahın ortasına koyarım, kendisi görüp temizlesin.',
                'en': 'I take the container out and place it on the counter for them to notice and wash.',
              },
              effects: {'cleanliness': 1.2, 'conflict_style': -1.0},
            ),
            ScenarioOption(
              id: 'sc_mold_c',
              text: {
                'tr': 'Haftada bir gün buzdolabı temizleme seansı yapar, birlikte eskiyen her şeyi dökeriz.',
                'en': 'We institute a weekly fridge purge ritual together every trash collection evening.',
              },
              effects: {'cleanliness': 1.6, 'chore_fairness': 1.6, 'responsibility': 1.2},
            ),
            ScenarioOption(
              id: 'sc_mold_d',
              text: {
                'tr': 'Kendi yiyeceklerimi ön tarafa çekerim, arka tarafa bakmam bile.',
                'en': 'I keep my food in front and simply ignore whatever lurks in the back.',
              },
              effects: {'cleanliness': -1.4, 'conflict_style': -1.6},
            ),
          ],
        ),

        // 27. Door locking security
        const Scenario(
          id: 'sc_door_locking',
          order: 27,
          category: 'responsibility',
          weightHints: {'responsibility': 0.95, 'privacy_need': 0.7},
          title: {
            'tr': 'Dış Kapıyı Kilitleme Hassasiyeti',
            'en': 'Front Door Locking & Security',
          },
          situation: {
            'tr': 'Ev arkadaşın bakkala veya spor salonuna giderken kapıyı sadece çekip gidiyor, kilitlemiyor. Sen ise kapının iki tur kilitlenmesini istiyorsun.',
            'en': 'Your roommate merely latches the door without locking the deadbolt when running errands, while you insist on double locking.',
          },
          options: [
            ScenarioOption(
              id: 'sc_lock_a',
              text: {
                'tr': 'Güvenlik şakaya gelmez; kapıyı her çıkışta kilitlemek tartışmasız bir zorunluluktur.',
                'en': 'Security is non-negotiable; double-locking every single time is mandatory.',
              },
              effects: {'responsibility': 1.9, 'privacy_need': 1.5, 'conflict_style': 1.3},
            ),
            ScenarioOption(
              id: 'sc_lock_b',
              text: {
                'tr': 'Güvenli bir mahalledeysek veya apartman kapısı kilitliyse aşırı kasmaya gerek yok.',
                'en': 'In a secure apartment building, latching is sufficient for quick errands.',
              },
              effects: {'responsibility': -1.2, 'noise_tolerance': 0.8},
            ),
            ScenarioOption(
              id: 'sc_lock_c',
              text: {
                'tr': 'Akıllı kilit veya şifreli kapı aparatı almayı teklif ederim.',
                'en': 'I suggest investing in a smart auto-locking deadbolt to end the dispute.',
              },
              effects: {'responsibility': 1.4, 'money_style': 0.6, 'chore_fairness': 1.0},
            ),
            ScenarioOption(
              id: 'sc_lock_d',
              text: {
                'tr': 'Her arkasından gidip sessizce kilitlerim.',
                'en': 'I just walk up and lock it behind them without commenting.',
              },
              effects: {'responsibility': 0.8, 'conflict_style': -1.5},
            ),
          ],
        ),

        // 28. Shared subscriptions & consumables fee
        const Scenario(
          id: 'sc_shared_amenities_fee',
          order: 28,
          category: 'money_style',
          weightHints: {'money_style': 0.85},
          title: {
            'tr': 'Netflix, Spotify & Mutfak Sarf Malzemeleri',
            'en': 'Streaming & Household Consumables Split',
          },
          situation: {
            'tr': 'Evde kullanılan ortak Netflix/YouTube Premium abonelikleri ve tuvalet kağıdı gibi ortak giderleri nasıl bölüşelim?',
            'en': 'How should shared Netflix accounts, olive oil, and toilet paper subscriptions be split?',
          },
          options: [
            ScenarioOption(
              id: 'sc_amenities_a',
              text: {
                'tr': 'Kullanım oranına bakılmaksızın tüm dijital ve fiziksel ortak giderler eşit 50-50 bölünür.',
                'en': 'Strict 50/50 split across all household subscriptions and paper goods regardless of usage.',
              },
              effects: {'money_style': 1.5, 'chore_fairness': 1.4},
            ),
            ScenarioOption(
              id: 'sc_amenities_b',
              text: {
                'tr': 'Kim daha çok kullanıyorsa o ödesin; ben izlemiyorsam Netflix’e ortak olmam.',
                'en': 'Pay per use; if I don’t watch Netflix, I will not subsidize it.',
              },
              effects: {'money_style': 1.8, 'privacy_need': 1.2},
            ),
            ScenarioOption(
              id: 'sc_amenities_c',
              text: {
                'tr': 'Biri abonelikleri ödesin, diğeri temizlik malzemelerini; denge kendiliğinden kurulur.',
                'en': 'One pays subscriptions, the other buys groceries; approximate balance works fine.',
              },
              effects: {'money_style': -1.5, 'social_energy': 0.9},
            ),
            ScenarioOption(
              id: 'sc_amenities_d',
              text: {
                'tr': 'Hiçbir dijital hesabı ortak açmam, kendi kişisel hesaplarımı kullanırım.',
                'en': 'I do not share any digital accounts; everyone uses their own private credentials.',
              },
              effects: {'privacy_need': 1.8, 'money_style': 1.2},
            ),
          ],
        ),

        // 29. Sick roommate care
        const Scenario(
          id: 'sc_sick_roommate',
          order: 29,
          category: 'social',
          weightHints: {'social_energy': 0.8, 'privacy_need': 0.75},
          title: {
            'tr': 'Ev Arkadaşın Ağır Grip Olduğunda',
            'en': 'When Your Roommate Falls Sick',
          },
          situation: {
            'tr': 'Ev arkadaşın yüksek ateş ve grip ile yatağa düştü. Birbirinizden beklentiniz nedir?',
            'en': 'Your roommate is bedridden with flu and fever. What is the ideal dynamic?',
          },
          options: [
            ScenarioOption(
              id: 'sc_sick_a',
              text: {
                'tr': 'Çorba kaynatır, eczaneden ilacını alır ve düzenli aralıklarla yoklarım.',
                'en': 'I cook warm soup, pick up medication, and check in on them regularly.',
              },
              effects: {'social_energy': 1.8, 'responsibility': 1.4, 'privacy_need': -1.0},
            ),
            ScenarioOption(
              id: 'sc_sick_b',
              text: {
                'tr': '"Bir şeye ihtiyacın olursa seslen" derim ama bulaşmaması için mesafemi korurum.',
                'en': 'I say "Let me know if you need anything" but keep my distance to avoid catching it.',
              },
              effects: {'privacy_need': 1.4, 'social_energy': -0.5},
            ),
            ScenarioOption(
              id: 'sc_sick_c',
              text: {
                'tr': 'Hemen maske takar, ortak temas noktalarını dezenfekte eder, kendi odamda izole olurum.',
                'en': 'I mask up, sanitize doorknobs, and quarantine inside my room.',
              },
              effects: {'cleanliness': 1.8, 'privacy_need': 1.9, 'social_energy': -1.5},
            ),
            ScenarioOption(
              id: 'sc_sick_d',
              text: {
                'tr': 'Ailesini veya yakın arkadaşlarını arayıp ilgilenmelerini rica ederim.',
                'en': 'I contact their close friends or family to step in.',
              },
              effects: {'responsibility': 0.5, 'privacy_need': 0.8},
            ),
          ],
        ),

        // 30. Moving day help
        const Scenario(
          id: 'sc_moving_day_help',
          order: 30,
          category: 'responsibility',
          weightHints: {'responsibility': 0.8, 'chore_fairness': 0.75},
          title: {
            'tr': 'Ağır Eşya ve Mobilya Taşıma',
            'en': 'Moving Day & Heavy Furniture',
          },
          situation: {
            'tr': 'Eve yeni bir koltuk veya dolap sipariş edildi ve bina girişine bırakıldı. 3. kata çıkarılması gerekiyor.',
            'en': 'A heavy couch or wardrobe was delivered curbside and needs to be hauled up 3 flights of stairs.',
          },
          options: [
            ScenarioOption(
              id: 'sc_moving_a',
              text: {
                'tr': 'Hemen kolları sıvar, iki ucundan tutup birlikte yukarı taşırız.',
                'en': 'I immediately roll up my sleeves and help carry it upstairs together.',
              },
              effects: {'responsibility': 1.7, 'social_energy': 1.2, 'chore_fairness': 1.3},
            ),
            ScenarioOption(
              id: 'sc_moving_b',
              text: {
                'tr': 'Eşya kime aitse nakliye ve taşımayı profesyonel hamala ödeyerek halletmelidir.',
                'en': 'Whoever ordered the item should hire professional movers to carry it.',
              },
              effects: {'privacy_need': 1.5, 'money_style': 1.4, 'responsibility': -0.3},
            ),
            ScenarioOption(
              id: 'sc_moving_c',
              text: {
                'tr': 'Taşımaya yardım ederim ama karşılığında bana bir akşam yemeği ısmarlamasını beklerim.',
                'en': 'I help carry it, but expect them to treat me to dinner as a thank you.',
              },
              effects: {'money_style': 0.8, 'chore_fairness': 1.5, 'social_energy': 0.7},
            ),
            ScenarioOption(
              id: 'sc_moving_d',
              text: {
                'tr': 'Belim ağrıyor veya işim var diyerek nazikçe kenara çekilirim.',
                'en': 'I excuse myself citing a bad back or busy schedule.',
              },
              effects: {'responsibility': -1.6, 'conflict_style': -1.2},
            ),
          ],
        ),

        // 31. Shoes indoors
        const Scenario(
          id: 'sc_shoes_indoors',
          order: 31,
          category: 'cleanliness',
          weightHints: {'cleanliness': 0.95},
          title: {
            'tr': 'Evde Dış Ayakkabı ile Dolaşmak',
            'en': 'Outdoor Shoes Past the Doorway',
          },
          situation: {
            'tr': 'Ev arkadaşın veya misafiri unuttuğu bir şeyi almak için dış ayakkabısıyla koridordan salona kadar yürüdü.',
            'en': 'Your roommate or guest rushes into the living room wearing muddy outdoor sneakers to grab a forgotten bag.',
          },
          options: [
            ScenarioOption(
              id: 'sc_shoes_a',
              text: {
                'tr': 'Evde asla dış ayakkabıya izin verilemez! Hemen arkasından yerlerin silinmesini isterim.',
                'en': 'Outdoor shoes inside are completely forbidden! I demand the floor be mopped immediately.',
              },
              effects: {'cleanliness': 2.0, 'conflict_style': 1.6},
            ),
            ScenarioOption(
              id: 'sc_shoes_b',
              text: {
                'tr': 'Acil durumlar için bir seferlik görmezden gelirim ama alışkanlık olmasın.',
                'en': 'I overlook it for urgent moments, provided it does not become a habit.',
              },
              effects: {'cleanliness': 0.4, 'noise_tolerance': 0.6},
            ),
            ScenarioOption(
              id: 'sc_shoes_c',
              text: {
                'tr': 'Ben de bazen ayakkabıyla içeri girerim, evde ayakkabısızlık kuralım yoktur.',
                'en': 'I sometimes wear sneakers inside too; I have no issue with shoes indoors.',
              },
              effects: {'cleanliness': -1.8, 'noise_tolerance': 1.0},
            ),
            ScenarioOption(
              id: 'sc_shoes_d',
              text: {
                'tr': 'Girişe galoş ve terlik sepeti koyarak sorunu baştan çözerim.',
                'en': 'I place a basket with shoe covers and slippers at the foyer entrance.',
              },
              effects: {'cleanliness': 1.4, 'responsibility': 1.3},
            ),
          ],
        ),

        // 32. Household quiet hours
        const Scenario(
          id: 'sc_quiet_hours',
          order: 32,
          category: 'sleep',
          weightHints: {'sleep_schedule': 0.9, 'noise_tolerance': 0.85},
          title: {
            'tr': 'Evde Sessizlik Saatleri',
            'en': 'Household Quiet Hours Agreement',
          },
          situation: {
            'tr': 'Evde haftaiçi ve haftasonu sessizlik saatlerinin başlangıcı için senin ideal saatin nedir?',
            'en': 'What is your ideal baseline policy for weekday household quiet hours?',
          },
          options: [
            ScenarioOption(
              id: 'sc_quiet_a',
              text: {
                'tr': 'Haftaiçi 23:00’ten sonra evde mutlak sessizlik olmalı; erken uyur erken kalkarım.',
                'en': 'Strict quiet after 11 PM on weekdays; I sleep early and wake early.',
              },
              effects: {'sleep_schedule': -1.9, 'noise_tolerance': -1.8, 'responsibility': 1.2},
            ),
            ScenarioOption(
              id: 'sc_quiet_b',
              text: {
                'tr': 'Gece 01:00’e kadar normal sohbet ve müzik olabilir; gece yaşamayı severim.',
                'en': 'Normal chatter and music until 1 AM is fine; I am a night owl.',
              },
              effects: {'sleep_schedule': 1.8, 'noise_tolerance': 1.3, 'social_energy': 1.2},
            ),
            ScenarioOption(
              id: 'sc_quiet_c',
              text: {
                'tr': 'Herkes kendi odasında kulaklık taktığı sürece saat kuralına gerek yoktur.',
                'en': 'No rigid clock rules needed as long as everyone uses headphones in their bedrooms.',
              },
              effects: {'privacy_need': 1.5, 'noise_tolerance': 0.4},
            ),
            ScenarioOption(
              id: 'sc_quiet_d',
              text: {
                'tr': 'Ertesi gün sınav veya mesai varsa esnetilir, karşılıklı konuşarak ayarlanır.',
                'en': 'Dynamic quiet hours negotiated daily based on upcoming exams or work schedules.',
              },
              effects: {'chore_fairness': 1.4, 'conflict_style': 0.8},
            ),
          ],
        ),
      ];
}
