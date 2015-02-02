# coding: utf-8
require 'spec_helper'
require 'security_questions'

describe SecurityQuestions do
  describe 'find' do
    let(:ara_security_questions) do
      [{"id"=>1, "name"=>"في أي سنة ولدت؟"},
       {"id"=>2, "name"=>" آخر أربعة أحرف من رقم الضمان الاجتماعي؟"},
       {"id"=>3, "name"=>"ما هو الاسم الأوسط لوالدك؟"},
       {"id"=>4, "name"=>"ما هو اسم أول مدرسة ذهبت إليها؟"},
       {"id"=>5, "name"=>"من هو بطل طفولتك؟"},
       {"id"=>6, "name"=>"ما هو وقت التسلية المفضل لديك؟"},
       {"id"=>7, "name"=>"ما هو الفريق الرياضي المفضل لديك على الإطلاق؟"},
       {"id"=>8, "name"=>"ما هو اسم جالب الحظ الخاص بك في أيام مدرستك الثانوية؟"},
       {"id"=>9, "name"=>"ما هو طراز أول سيارة أو دراجة تملكتها؟"},
       {"id"=>10, "name"=>"ما هو اسم حيوانك الأليف؟"},
       {"id"=>11, "name"=>"ما هو الاسم الاوسط لوالدتك؟"}]
    end
    let(:cze_security_questions) do
      [{"id"=>1, "name"=>"V kterém roce jste se narodil(a)?"},
       {"id"=>2, "name"=>"Poslední čtyři číslice SSN?"},
       {"id"=>3, "name"=>"Jaké je prostřední jméno vašeho otce?"},
       {"id"=>4, "name"=>"Jak se jmenovala vaše první škola?"},
       {"id"=>5, "name"=>"Kdo byl hrdinou vašeho dětství?"},
       {"id"=>6, "name"=>"Co děláte rád(a) ve volném čase?"},
       {"id"=>7, "name"=>"Jaký je váš nejoblíbenější sportovní tým?"},
       {"id"=>8, "name"=>"Jaký byl maskot vaší střední školy?"},
       {"id"=>9, "name"=>"Jakou značku mělo vaše první auto nebo motorka?"},
       {"id"=>10, "name"=>"Jak se jmenuje vaše domácí zvíře?"},
       {"id"=>11, "name"=>"Jaké je prostřední jméno vaší matky?"}]
    end
    let(:dan_security_questions) do
      [{"id"=>1, "name"=>"Hvilket år er du født?"},
       {"id"=>2, "name"=>"Sidste fire cifre i SSN?"},
       {"id"=>3, "name"=>"Hvad er din fars mellemnavn?"},
       {"id"=>4, "name"=>"Hvad var navnet på din første skole?"},
       {"id"=>5, "name"=>"Hvem var din barndomshelt?"},
       {"id"=>6, "name"=>"Hvad er din yndlingshobby?"},
       {"id"=>7, "name"=>"Hvad er dit yndlings-sportsteam?"},
       {"id"=>8, "name"=>"Hvad var din gymnasiemaskot?"},
       {"id"=>9, "name"=>"Hvad var mærket på din første bil eller cykel?"},
       {"id"=>10, "name"=>"Hvad hedder dit kæledyr?"},
       {"id"=>11, "name"=>"Hvad er din mors mellemnavn?"}]
    end
    let(:deu_security_questions) do
      [{"id"=>1, "name"=>"In welchem Jahr wurden Sie geboren?"},
       {"id"=>2, "name"=>"Letzte vier Ziffern der Sozialversicherungsnummer?"},
       {"id"=>3, "name"=>"Wie lautet der Mittelname Ihres Vaters?"},
       {"id"=>4, "name"=>"Wie hieß Ihre erste Schule?"},
       {"id"=>5, "name"=>"Wer war der Held Ihrer Kindheit?"},
       {"id"=>6, "name"=>"Was ist Ihre liebste Freizeitbeschäftigung?"},
       {"id"=>7, "name"=>"Was ist Ihre Lieblingsmannschaft?"},
       {"id"=>8, "name"=>"Was war das Maskottchen Ihrer Schule?"},
       {"id"=>9, "name"=>"Welche Marke war Ihr erstes Auto oder Fahrrad?"},
       {"id"=>10, "name"=>"Wie heißt Ihr Haustier?"},
       {"id"=>11, "name"=>"Wie lautet der Mittelname Ihrer Mutter?"}]
    end
    let(:dut_security_questions) do
      [{"id"=>1, "name"=>"In welk jaar bent u geboren?"},
       {"id"=>2, "name"=>"Laatste vier cijfers van rijksregisternummer?"},
       {"id"=>3, "name"=>"Wat is de tweede naam van uw vader?"},
       {"id"=>4, "name"=>"Wat was de naam van uw eerste school?"},
       {"id"=>5, "name"=>"Wie was uw held toen u jong was?"},
       {"id"=>6, "name"=>"Wat is uw favoriete hobby?"},
       {"id"=>7, "name"=>"Wat is uw meest favoriete sportploeg ooit?"},
       {"id"=>8, "name"=>"Wat was de mascotte van uw middelbare school?"},
       {"id"=>9, "name"=>"Wat was het merk van uw eerste auto of fiets?"},
       {"id"=>10, "name"=>"Wat is de naam van uw huisdier?"},
       {"id"=>11, "name"=>"Wat is de tweede naam van uw moeder?"}]
    end
    let(:eng_security_questions) do
      [{"id"=>1, "name"=>"In what year were you born?"},
       {"id"=>2, "name"=>"Last four digits of SSN?"},
       {"id"=>3, "name"=>"What is your father's middle name?"},
       {"id"=>4, "name"=>"What was the name of your first school?"},
       {"id"=>5, "name"=>"Who was your childhood hero?"},
       {"id"=>6, "name"=>"What is your favorite pastime?"},
       {"id"=>7, "name"=>"What is your all-time favorite sports team?"},
       {"id"=>8, "name"=>"What was your high school mascot?"},
       {"id"=>9, "name"=>"What was the make of your first car or bike?"},
       {"id"=>10, "name"=>"What is your pet's name?"},
       {"id"=>11, "name"=>"What is your mother's middle name?"}]
    end
    let(:heb_security_questions) do
      [{"id"=>1, "name"=>"באיזו שנה נולדת?"},
       {"id"=>2, "name"=>"ארבע הספרות האחרונות של SSN?"},
       {"id"=>3, "name"=>"מה שמו האמצעי של אביך?"},
       {"id"=>4, "name"=>"מה שמו של בית הספר הראשון בו למדת?"},
       {"id"=>5, "name"=>"מי היה גיבור הילדות שלך?"},
       {"id"=>6, "name"=>"מה הבילוי המועדף עליך?"},
       {"id"=>7, "name"=>"מה שם קבוצת הספורט שאתה אוהד?"},
       {"id"=>8, "name"=>"איזה קמע היה לך בימי תיכון?"},
       {"id"=>9, "name"=>"מה היה דגם הרכב או האופניים הראשונים שלך?"},
       {"id"=>10, "name"=>"מה שם חיית המחמד שלך?"},
       {"id"=>11, "name"=>"מהו שם הנעורים של אמך?"}]
    end
    let(:hun_security_questions) do
      [{"id"=>1, "name"=>"Melyik évben született?"},
       {"id"=>2, "name"=>"A TAJ-szám utolsó négy számjegye?"},
       {"id"=>3, "name"=>"Mi az édesapja középső neve?"},
       {"id"=>4, "name"=>"Mi volt az első iskolája neve?"},
       {"id"=>5, "name"=>"Ki volt a gyermekkori példaképe?"},
       {"id"=>6, "name"=>"Mi a kedvenc hobbija?"},
       {"id"=>7, "name"=>"Mi a legkedvesebb sportcsapata neve?"},
       {"id"=>8, "name"=>"Mi volt az óvodai jele?"},
       {"id"=>9, "name"=>"Milyen márkájú volt az első autója vagy motorkerékpárja?"},
       {"id"=>10, "name"=>"Mi a háziállata neve?"},
       {"id"=>11, "name"=>"Mi az édesanyja középső neve?"}]
    end
    let(:ita_security_questions) do
      [{"id"=>1, "name"=>"In che anno sai nato?"},
       {"id"=>2, "name"=>"Ultimi quattro caratteri del Codice Fiscale?"},
       {"id"=>3, "name"=>"Qual è il secondo nome di tuo padre?"},
       {"id"=>4, "name"=>"Qual era il nome della tua prima scuola?"},
       {"id"=>5, "name"=>"Chi era il tuo eroe da bambino?"},
       {"id"=>6, "name"=>"Qual è il tuo passatempo preferito?"},
       {"id"=>7, "name"=>"Qual è la squadra sportiva che preferisci da sempre?"},
       {"id"=>8, "name"=>"Qual era la mascotte del tuo liceo?"},
       {"id"=>9, "name"=>"Qual è stata la marca della tua prima auto o moto?"},
       {"id"=>10, "name"=>"Qual è il nome del tuo animale domestico?"},
       {"id"=>11, "name"=>"Qual è il secondo nome di tua madre?"}]
    end
    let(:jpn_security_questions) do
      [{"id"=>1, "name"=>"生まれた年を入力してください。"},
       {"id"=>2, "name"=>"SSNの最後の4桁を入力してください。"},
       {"id"=>3, "name"=>"父親のミドルネームは何ですか？"},
       {"id"=>4, "name"=>"最初に通った学校の名前を入力してください。"},
       {"id"=>5, "name"=>"子供の頃のヒーローを入力してください。"},
       {"id"=>6, "name"=>"趣味を入力してください。"},
       {"id"=>7, "name"=>"お気に入りのスポーツチームを入力してください。"},
       {"id"=>8, "name"=>"高校時代のマスコットは何ですか?"},
       {"id"=>9, "name"=>"最初に購入した車/バイクのメーカーを入力してください。"},
       {"id"=>10, "name"=>"ペットの名前を入力してください。"},
       {"id"=>11, "name"=>"母親の旧姓は何ですか?"}]
    end
    let(:kor_security_questions) do
      [{"id"=>1, "name"=>"태어난 해가 언제입니까?"},
       {"id"=>2, "name"=>"사회보장번호의 마지막 4자리가 무엇입니까?"},
       {"id"=>3, "name"=>"아버지의 고향은 어디입니까?"},
       {"id"=>4, "name"=>"귀하가 입학한 초등학교의 이름은 무엇입니까?"},
       {"id"=>5, "name"=>"어린 시절의 영웅이 누구였습니까?"},
       {"id"=>6, "name"=>"가장 좋아하는 취미가 무엇입니까?"},
       {"id"=>7, "name"=>"가장 좋아하는 스포츠팀이 무엇입니까?"},
       {"id"=>8, "name"=>"고등학교 시절의 마스코트가 무엇입니까?"},
       {"id"=>9, "name"=>"소유했던 첫 자동차나 자전거가 무엇입니까?"},
       {"id"=>10, "name"=>"애완동물 이름이 무엇입니까?"},
       {"id"=>11, "name"=>"어머니의 고향은 어디입니까?"}]
    end
    let(:pol_security_questions) do
      [{"id"=>1, "name"=>"Podaj swój rok urodzenia"},
       {"id"=>2, "name"=>"Podaj ostatnie cztery cyfry numeru ubezpieczenia społecznego."},
       {"id"=>3, "name"=>"Jak brzmi drugie imię Twojego ojca?"},
       {"id"=>4, "name"=>"Jak nazywała się Twoja pierwsza szkoła?"},
       {"id"=>5, "name"=>"Kto był Twoim dziecięcym bohaterem?"},
       {"id"=>6, "name"=>"Jaka jest Twoja ulubiona rozrywka?"},
       {"id"=>7, "name"=>"Jaka jest Twoja ulubiona drużyna?"},
       {"id"=>8, "name"=>"Jaka była maskotka Twojego liceum?"},
       {"id"=>9, "name"=>"Jakiej marki był Twój pierwszy samochód lub rower?"},
       {"id"=>10, "name"=>"Jak ma na imię Twój zwierzak?"},
       {"id"=>11, "name"=>"Jak brzmi drugie imię Twojej matki?"}]
    end
    let(:rus_security_questions) do
      [{"id"=>1, "name"=>"В каком году вы родились?"},
       {"id"=>2, "name"=>"Укажите четыре последних цифры SSN."},
       {"id"=>3, "name"=>"Какое отчество у вашего отца?"},
       {"id"=>4, "name"=>"Как называлась ваша первая школа?"},
       {"id"=>5, "name"=>"Каким героем вы восхищались в детстве?"},
       {"id"=>6, "name"=>"Какое ваше любимое хобби?"},
       {"id"=>7, "name"=>"Какая ваша любимая спортивная команда?"},
       {"id"=>8, "name"=>"Какой символ вашей школы?"},
       {"id"=>9, "name"=>"Какая марка вашей первой машины или велосипеда?"},
       {"id"=>10, "name"=>"Как зовут ваше домашнее животное?"},
       {"id"=>11, "name"=>"Какое отчество у вашей матери?"}]
    end
    let(:zha_security_questions) do
      [{"id"=>1, "name"=>"您在哪一年出生？"},
       {"id"=>2, "name"=>"您的社会安全号码（SSN）的最后4位是什么？"},
       {"id"=>3, "name"=>"您父亲的中间名是什么？"},
       {"id"=>4, "name"=>"您的第一所学校的名称是什么？"},
       {"id"=>5, "name"=>"您在儿时崇拜的英雄是谁？"},
       {"id"=>6, "name"=>"您的业余爱好是什么？"},
       {"id"=>7, "name"=>"您一直最喜欢的运动队是哪一个？"},
       {"id"=>8, "name"=>"您上高中时学校的吉祥物是什么？"},
       {"id"=>9, "name"=>"您的第一辆汽车或自行车是什么牌子的？"},
       {"id"=>10, "name"=>"您的宠物名字是什么？"},
       {"id"=>11, "name"=>"您母亲的中间名是什么？"}]
    end
    let(:zho_security_questions) do
      [{"id"=>1, "name"=>"您哪一年出生？"},
       {"id"=>2, "name"=>"SSN 的後四位數字？"},
       {"id"=>3, "name"=>"您父親的中間名是什麽？"},
       {"id"=>4, "name"=>"您第一所學校的名字是什麽？"},
       {"id"=>5, "name"=>"您兒時的英雄是誰？"},
       {"id"=>6, "name"=>"您最愛的娛樂是什麽？"},
       {"id"=>7, "name"=>"歷來您最愛的運動小組是什麽？"},
       {"id"=>8, "name"=>"您所就讀的高中的吉祥物是什麽？"},
       {"id"=>9, "name"=>"您第一輛汽車或自行車的牌子是什麽？"},
       {"id"=>10, "name"=>"您寵物的名字是什麽？"},
       {"id"=>11, "name"=>"您母親的中間名是什麽？"}]
    end

    context 'when requesting security questions for existing locale' do
      it 'returns security questions' do
        expect(SecurityQuestions.find('ara')).to eq(ara_security_questions)
        expect(SecurityQuestions.find('cze')).to eq(cze_security_questions)
        expect(SecurityQuestions.find('dan')).to eq(dan_security_questions)
        expect(SecurityQuestions.find('deu')).to eq(deu_security_questions)
        expect(SecurityQuestions.find('dut')).to eq(dut_security_questions)
        expect(SecurityQuestions.find('eng')).to eq(eng_security_questions)
        expect(SecurityQuestions.find('heb')).to eq(heb_security_questions)
        expect(SecurityQuestions.find('hun')).to eq(hun_security_questions)
        expect(SecurityQuestions.find('ita')).to eq(ita_security_questions)
        expect(SecurityQuestions.find('jpn')).to eq(jpn_security_questions)
        expect(SecurityQuestions.find('kor')).to eq(kor_security_questions)
        expect(SecurityQuestions.find('pol')).to eq(pol_security_questions)
        expect(SecurityQuestions.find('rus')).to eq(rus_security_questions)
        expect(SecurityQuestions.find('zha')).to eq(zha_security_questions)
        expect(SecurityQuestions.find('zho')).to eq(zho_security_questions)

      end
    end

    context "when requesting security questions for locale that doesn't exist" do
      it 'throws exception' do
        expect{SecurityQuestions.find("xxx") }.to raise_error("Locale not found: xxx")
      end
    end

  end
end
