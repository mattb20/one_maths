describe InputProcessorSupport do
  let!(:processor) { Class.new { include InputProcessorSupport }.new }

  describe '#standardise_answer' do
    context 'normal type' do
      let!(:answer_type) { 'normal' }

      it 'returns 100%' do
        sample_question_answer = '3, -2.22, -1/-2, 4/-3'
        sample_answer = '3, -2.22, 0.5, 4/-3'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 1
      end

      it 'returns 75%' do
        sample_question_answer = '3, -2.22, -1/-2, 4/-3'
        sample_answer = '3, -2.22, 0.5, 4/3'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0.75
      end

      it 'returns 50%' do
        sample_question_answer = '3, -2.22, -1/-2, 4/-3'
        sample_answer = '3, -2.22, 0, 4/3'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0.50
      end

      it 'returns 0%' do
        sample_question_answer = '3, -2.22, -1/-2, 4/-3'
        sample_answer = '2, -2, 0, 4/3'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0
      end
    end

    context 'inequality type' do
      let!(:answer_type) { 'inequality' }

      it 'returns 100%' do
        sample_question_answer = '4>x=>-12.5 , -2/3> = y or 100 = z or 20.5/-2 => x'
        sample_answer = '4>x=>-12.5 or -2/3>=y or 100=z,20.5/-2 => x'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 1
      end

      it 'returns 75%' do
        sample_question_answer = '5>x=>2.5 or -2/3> = y or 100 = z or 20.5/-2 => x'
        sample_answer = '2.5=<x<5,-2/3>=y or 100=z or 20.5/2 => x'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0.75
      end

      it 'returns 50%' do
        sample_question_answer = 'x=>2.5 or -2/3> = y > -3  or 100 = z , 20.5/-2 => x'
        sample_answer = 'x=>2.5 or -2/3>=y> -3,10=z or 20.5/2 => x'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0.50
      end

      it 'returns 0%' do
        sample_question_answer = 'x=>2.5 or -2/3> = y,100 = z or 20.5/-2 => x'
        sample_answer = 'x=>25,2/3>=y,10=z,20.5/2 => x'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0
      end
    end

    context 'coordinates type' do
      let!(:answer_type) { 'coordinates' }

      it 'returns 100%' do
        sample_question_answer = '(7.11, 16.72), (6.98, -25.66), (1/2, 0/-4), (200, -1/6)'
        sample_answer = '(7.11, 16.72), (6.98, -25.66), (1/2, 0/-4), (200, -1/6)'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 1
      end

      it 'returns 75%' do
        sample_question_answer = '(7.11, 16.72), (6.98, -25.66), (1/2, 0/-4), (200, -1/6)'
        sample_answer = '(7.11, 16.72), (6.98, -25.66), (1/2, 0/-4), (200, 1/6)'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0.75
      end

      it 'returns 50%' do
        sample_question_answer = '(7.11, 16.72), (6.98, -25.66), (1/2, 0/-4), (200, -1/6)'
        sample_answer = '(7.11, 16.72), (6.98, -25.66), (2/5, 0/-4), (200, 1/6)'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0.50
      end

      it 'returns 0%' do
        sample_question_answer = '(7.11, 16.72), (6.98, -25.66), (1/2, 0/-4), (200, -1/6)'
        sample_answer = '(7.11, 16), (6.98, 5.66), (2/5, 0/-4), (200, 1/6)'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0
      end
    end

    context 'words type' do
      let!(:answer_type) { 'words' }

      it 'returns 100%' do
        sample_question_answer = 'Maximum'
        sample_answer = 'maximum'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 1
      end

      it 'returns 0%' do
        sample_question_answer = 'Maximum'
        sample_answer = 'minimum'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0
      end

      it 'returns 0% for multiple words answer' do
        sample_question_answer = 'maximum'
        sample_answer = 'maximum point'
        expect(processor.standardise_answer(answer_type, sample_question_answer, sample_answer)).to eq 0
      end
    end

    context 'make it fail type mixture' do
      it "normal return 50%" do
        sample_question_answer = '3, -2.22, -1/-2, 4/-3'
        sample_answer = '%3,-2 . 22, , -1/-2, >4/-3}'
        expect(processor.standardise_answer('normal', sample_question_answer, sample_answer)).to eq 0.5
      end

      it "normal return 0" do
        sample_question_answer = '3, -2.22, -1/-2, 4/-3'
        sample_answer = '%3,- 2 . a2c2, , -$£1/*&-&%$2, >4</-{3}'
        expect(processor.standardise_answer('normal', sample_question_answer, sample_answer)).to eq 0
      end

      it "normal return 0" do
        sample_question_answer = '3, -2.22, -1/-2, 4/-3'
        sample_answer = '%3,- 2 . a2c2,-1/0, >4</-{3}'
        expect(processor.standardise_answer('normal', sample_question_answer, sample_answer)).to eq 0
      end

      it "normal return 0" do
        sample_question_answer = '3, -2.22, -1/-2, 4/-3'
        sample_answer = '%3,- 2 . a2c2, , -$£1/*&-&%$2, >4</-{3}'
        expect(processor.standardise_answer('normal', sample_question_answer, sample_answer)).to eq 0
      end

      it "normal return 0" do
        sample_question_answer = '3/5, -2.22, -1/-2, 4/-3'
        sample_answer ='3%/5,-2.a2c2, ,-$£1/*&-&%$2,>4</-{3}'
        expect(processor.standardise_answer('normal', sample_question_answer, sample_answer)).to eq 0
      end

      it "inequality return 100%" do
        sample_question_answer = 'x=>2.5 or -2/3> = y , 100 = z or 20.5/-2 => x'
        sample_answer = 'x=>2.5000 or -2/3> = y or 100.00 = z or 20.50/-2.00 => x'
        expect(processor.standardise_answer('inequality', sample_question_answer, sample_answer)).to eq 1
      end

      it "inequality return 75%" do
        sample_question_answer = 'x=>2.5 or -2/3> = y or 100 = z or 20.5/-2 => x'
        sample_answer = 'x=>2.5000 or -2//3> = y , 100%.00 = z or $20.50/-2.00 => x'
        expect(processor.standardise_answer('inequality', sample_question_answer, sample_answer)).to eq 0.75
      end

      it "inequality return 0" do
        sample_question_answer = 'x=>2.5 or -2/3> = y , 100 = z or 20.5/-2 => x'
        sample_answer = 'x=h>2.5000 or -2/3y>= or 100.00z = , 20.50@/-2.00 => x'
        expect(processor.standardise_answer('inequality', sample_question_answer, sample_answer)).to eq 0
      end

      it "inequality return 75%" do
        sample_question_answer = 'x=>2.5 or -2/3> = y,100 = z or 20.5/-2 => x'
        sample_answer = '2.5000=<x,>-2/3 = y or 100.00=z or 20.50/-2.00 => x'
        expect(processor.standardise_answer('inequality', sample_question_answer, sample_answer)).to eq 0.75
      end

      it "coordinates return 0" do
        sample_question_answer = '(7.11, 16.72), (6.98, -25.66), (1/2, 0/-4), (200, -1/6)'
        sample_answer = '(7.1#1, 16.7{2), (6.9^8, -25.6&6), (1/d2, 0/-4), (20d0, -1/6)'
        expect(processor.standardise_answer('coordinates', sample_question_answer, sample_answer)).to eq 0
      end

      it "coordinates return 100%" do
        sample_question_answer = '(7.11, 16.72), (6.98, -25.66), (1/2, 0/-4), (200, -1/6)'
        sample_answer = '(7.11, 16.72)kj, ()(6.98, -25.66), (  1/2,0/-4  ), (200, -1/6)'
        expect(processor.standardise_answer('coordinates', sample_question_answer, sample_answer)).to eq 1
      end

      it "words return 100%" do
        sample_question_answer = 'Maximum'
        sample_answer = 'mAxImUm'
        expect(processor.standardise_answer('words', sample_question_answer, sample_answer)).to eq 1
      end

      it "words return 100%" do
        sample_question_answer = 'Maximum, Inflection point'
        sample_answer = 'mAxImUm, , inflectionpoint'
        expect(processor.standardise_answer('words', sample_question_answer, sample_answer)).to eq 1
      end

      it "words return 0" do
        sample_question_answer = 'Maximum, Inflection point'
        sample_answer = 'mAxImU&m, , point inflection'
        expect(processor.standardise_answer('words', sample_question_answer, sample_answer)).to eq 0
      end
    end

    context 'error handling' do
      it 'when passed nil type it returns 0' do
        sample_question_answer = 'y=2x+10'
        sample_answer = 'y=2x+10'
        expect(processor.standardise_answer(nil, sample_question_answer, sample_answer)).to eq 0
      end

      it 'when passed unknown type it returns 0' do
        sample_question_answer = 'y=2x+10'
        sample_answer = 'y=2x+10'
        expect(processor.standardise_answer('equation', sample_question_answer, sample_answer)).to eq 0
      end
    end
  end

  describe '#single_answer_correctness' do
    it 'compare ["1","2"] with ["1","2"] return 1' do
      question_answer = %w(1 2)
      student_answer = %w(1 2)
      expect(processor.single_answer_correctness(question_answer, student_answer)).to eq 1
    end

    it 'compare ["1","2","3"] with ["3","2","4"] return 0.667' do
      question_answer = %w(1 2 3)
      student_answer = %w(3 2 4)
      expect(processor.single_answer_correctness(question_answer, student_answer)).to eq 0.66666667
    end

    it 'compare ["1","2","3"] with ["6","5","4"] return 0' do
      question_answer = %w(1 2 3)
      student_answer = %w(6 5 4)
      expect(processor.single_answer_correctness(question_answer, student_answer)).to eq 0
    end

    it 'compare ["1",["2"],"3"] with ["6",["2"],"4"] return 0.33333' do
      question_answer = ['1', ['2'], '3']
      student_answer = ['6', ['2'], '4']
      expect(processor.single_answer_correctness(question_answer, student_answer)).to eq 0.33333333
    end

    it 'compare ["1","2","3"] with ["2","3","4","5","6"] return 0.6667' do
      question_answer = %w(1 2 3)
      student_answer = %w(2 3 4 5 6)
      expect(processor.single_answer_correctness(question_answer, student_answer)).to eq 0.66666667
    end
  end

  describe '#sanitize_spaces' do
    it 'strips all spacing between characters' do
      test_strings = ['8 > x', '  x = 7', '( 12,3), ( -2 , 3 )']
      expected = %w(8>x x=7 (12,3),(-2,3))
      test_strings.each_with_index do |string, index|
        expect(processor.sanitize_spaces(string)).to eq expected[index]
      end
    end
  end

  describe '#inequality_reverser' do
    it "when passed '2=>g' return 'g=>2'" do
      sample_string = '2=>g'
      expected_string = 'g=>2'
      expect(processor.inequality_reverser(sample_string)).to eq expected_string
    end

    it "when passed '-1/2=<h' return 'h>=-1/2'" do
      sample_string = '-1/2=<h'
      expected_string = 'h=<-1/2'
      expect(processor.inequality_reverser(sample_string)).to eq expected_string
    end

    it "when passed '22.22>=z' return 'z>=22.22'" do
      sample_string = '22.22>=z'
      expected_string = 'z>=22.22'
      expect(processor.inequality_reverser(sample_string)).to eq expected_string
    end

    it "when passed '-22.22/9>=l' return 'l>=-22.22/9'" do
      sample_string = '-22.22/9>=l'
      expected_string = 'l>=-22.22/9'
      expect(processor.inequality_reverser(sample_string)).to eq expected_string
    end
  end

  describe '#inequality_formatter' do
    it "converts '8 <= x' to 'x >= 8'" do
      test_string = '8 <= x'
      expect(processor.inequality_formatter(test_string)).to eq 'x>=8'
    end

    it "converts '8 => x' to 'x <= 8'" do
      test_string = '8 => x'
      expect(processor.inequality_formatter(test_string)).to eq 'x<=8'
    end

    it "converts '8 =< x' to 'x >= 8'" do
      test_string = '8 =< x'
      expect(processor.inequality_formatter(test_string)).to eq 'x>=8'
    end

    it "converts '8 >= x' to 'x <= 8'" do
      test_string = '8 >= x'
      expect(processor.inequality_formatter(test_string)).to eq 'x<=8'
    end

    it "corrects 'x =< 8' to 'x <= 8'" do
      test_string = 'x =< 8'
      expect(processor.inequality_formatter(test_string)).to eq 'x <= 8'
    end

    it "corrects 'x => 8' to 'x >= 8'" do
      test_string = 'x => 8'
      expect(processor.inequality_formatter(test_string)).to eq 'x >= 8'
    end

    it "corrects '8x=>' to '8x>='" do
      test_string = '8x=>'
      expect(processor.inequality_formatter(test_string)).to eq '8x>='
    end

    it "corrects '<=8x' to '<=8x'" do
      test_string = '<=8x'
      expect(processor.inequality_formatter(test_string)).to eq '<=8x'
    end

    it "corrects '7/2=>x>-2' to '-2<x<=7/2'" do
      test_string = '7/2=>x>-2'
      expect(processor.inequality_formatter(test_string)).to eq '-2<x<=7/2'
    end

    it "corrects '-2/3<x<5/2' to '-2/3<x<5/2'" do
      test_string = '-2/3<x<5/2'
      expect(processor.inequality_formatter(test_string)).to eq '-2/3<x<5/2'
    end

    it "corrects '8>x<=-12' to '-12>=x<8'" do
      test_string = '8>x<=-12'
      expect(processor.inequality_formatter(test_string)).to eq '-12>=x<8'
    end

    it "corrects '-10/3<x=>-12' to '-12<=x>-10/3'" do
      test_string = '-10/3<x=>-12'
      expect(processor.inequality_formatter(test_string)).to eq '-12<=x>-10/3'
    end

    it 'returns true for \'7/2=>x>-2\'' do
      test_string = '7/2=>x>-2'
      expect(processor.inq_processor(test_string)).to eq '-2<x=<7/2'
    end
  end

  describe '#rationalizer' do
    it 'converts a string integer into rational' do
      test_string   = '3 2.3 -3/-2'
      test_2_string = '-3 1/-0'
      expect(processor.rationalizer(test_string)).to eq "#{Rational('3')} #{Rational('2.3')} #{Rational('-3', '-2')}"
      expect(processor.rationalizer(test_2_string)).to eq "#{Rational('-3')} 1/-0"
    end

    it 'converts a string float into rational' do
      test_string   = '2.22'
      test_2_string = '-2.22'
      expect(processor.rationalizer(test_string)).to eq Rational(test_string).to_s
      expect(processor.rationalizer(test_2_string)).to eq Rational(test_2_string).to_s
    end

    it 'converts a string fraction into rational' do
      test_string   = '1/2 f'
      test_2_string = '-1/2 £'
      test_3_string = '$$-1/-2'
      test_4_string = '1/-2Aa'

      expect(processor.rationalizer(test_string)).to eq "#{Rational(1, 2)} f"
      expect(processor.rationalizer(test_2_string)).to eq "#{Rational(-1, 2)} £"
      expect(processor.rationalizer(test_3_string)).to eq "$$#{Rational(1, 2)}"
      expect(processor.rationalizer(test_4_string)).to eq "#{Rational(1, -2)}Aa"
    end

    it 'converts floats to 5 d.p.' do
      sample_string   = '$5.42'
      sample_string_2 = '78.76545£'
      sample_string_3 = '6.436346262366236f'

      expect(processor.rationalizer(sample_string)).to eq "$#{Rational('5.42000')}"
      expect(processor.rationalizer(sample_string_2)).to eq "#{Rational('78.76545')}£"
      expect(processor.rationalizer(sample_string_3)).to eq "#{Rational('6.43635')}f"
    end

    it 'converts mixture of everything' do
      sample_string = '$1a2.2s-3.3dd4.4f(2/3)(-2/1.2),2.3/-4.5,sadf-4.5/-3.1a2.5a/3//4/0£3/0/0/0/0'
      expected_string = '$1/1a11/5s-33/10dd22/5f(2/3)(-5/3),-23/45,sadf45/31a5/2a/3/1//4/0£3/0/0/0/0/1'
      expect(processor.rationalizer(sample_string)).to eq expected_string
    end
  end

  describe '#sanitize_letters' do
    it 'strips a string from all alphabetical characters' do
      sample_answer   = 'asidh2.343, sad -3,ads1/2'
      sample_answer_2 = '(dasd3, -34dsd), dasd(-1sd/d9, 10i0/2d)das'
      expect(processor.sanitize_letters(sample_answer)).to eq '2.343,  -3,1/2'
      expect(processor.sanitize_letters(sample_answer_2)).to eq '(3, -34), (-1/9, 100/2)'
    end
  end

  describe '#normal_ans_parser' do
    it 'formats input to rationals for comparison' do
      test_string = '3/2£,f-4/3,s1/2'
      expect(processor.normal_ans_parser(test_string)).to eq ['3/2£', '-4/3', '1/2']
    end
  end

  describe '#inequality_parser' do
    it 'formats input to rationals for comparison' do
      test_string = '8/1<=xorx=>-5/4or8/5=x'
      expect(processor.inequality_parser(test_string)).to eq ['x>=8/1', 'x>=-5/4', 'x=8/5']
    end

    it 'formats range input to rationals for comparison' do
      test_string = '8/1<=x<=3/7or9/2=>x=>-5/4or8/5=>x>=9/1'
      expect(processor.inequality_parser(test_string)).to eq ['3/7>=x>=8/1', '-5/4<=x<=9/2', '8/5>=x>=9/1']
    end

    it 'formats input to rationals for comparison' do
      test_string = '8/1<=x<=3/7orx=>-5/4or8/5=>x>=9/1'
      expect(processor.inequality_parser(test_string)).to eq ['3/7>=x>=8/1', 'x>=-5/4', '8/5>=x>=9/1']
    end
  end

  describe '#coordinates_parser' do
    it "when passed (2,4), (6, 9) return [[2,4],[6,9]]" do
      coords = "(2,4), (6,9)"
      expect(processor.coordinates_parser(coords)).to eq [["2,4"],["6,9"]]
    end

    it "when passed (-1/3, 3/4), (-3/4, -1/-3) return [[-1/3,3/4],[-3/4,-1/3]]" do
      coords = "(-1/3,3/4), (-3/4,-1/3)"
      expect(processor.coordinates_parser(coords)).to eq [["-1/3,3/4"],["-3/4,-1/3"]]
    end

    it "when passed (a1.2,g2f.4), (-s2/l3sd,dd8g/g7) return [[1.2,2.4],[-2/3,8/7]]" do
      coords = "(a1.2,g2f.4), (-s2/l3sd,dd8g/g7)"
      expect(processor.coordinates_parser(coords)).to eq [["1.2,2.4"],["-2/3,8/7"]]
    end
  end

  describe 'alphabetical answers parser' do
    it 'processes alphabetical answers' do
      sample_answer   = 'Minimum'
      sample_answer_2 = 'Inflection point'
      expect(processor.alpha_parser(sample_answer)).to eq ['minimum']
      expect(processor.alpha_parser(sample_answer_2)).to eq ['inflection point']
    end
  end
end
