describe 'UpdateExp' do
  let!(:updater)  { Class.new{ include UpdateExp }.new }
  let!(:course) { create_course }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:admin)  { create_admin }
  let!(:student) { create_student }
  let!(:question_1) { create_question(1, lesson) }
  let!(:question_2) { create_question(2, lesson) }
  let!(:question_3) { create_question(3, lesson) }
  let!(:question_4) { create_question(4, lesson) }
  let!(:question_5) { create_question(5, lesson) }
  let!(:question_6) { create_question(6, lesson) }
  let!(:amended_ans_q) { create_ans_q(student, question_1, 0.5, 2, lesson) }
  let!(:lesson_exp) { create_student_lesson_exp(student,lesson,100) }

  describe '#update_streak_mtp' do
    it 'recalculates one answered question' do
      ans_q = create_ans_q(student, question_2, 1, 1, lesson)
      updater.update_streak_mtp(amended_ans_q)
      expect(AnsweredQuestion.last.object_id).not_to eq ans_q.object_id
      expect(AnsweredQuestion.last.streak_mtp).to eq 1.5
      expect(StudentLessonExp.last.streak_mtp).to eq 1.75
    end

    it 'recalculates two answered questions' do
      ans_q_12 = create_ans_q(student, question_2, 1, 1, lesson)
      ans_q_13 = create_ans_q(student, question_3, 1, 1.25, lesson)
      updater.update_streak_mtp(amended_ans_q)
      expect(AnsweredQuestion.last.streak_mtp).to eq 1.75
      expect(StudentLessonExp.last.streak_mtp).to eq 2
    end

    it 'recalculates three answered questions' do
      ans_q_12 = create_ans_q(student, question_2, 1, 1, lesson)
      ans_q_13 = create_ans_q(student, question_3, 1, 1.25, lesson)
      ans_q_14 = create_ans_q(student, question_4, 0.8, 1.2, lesson)
      updater.update_streak_mtp(amended_ans_q)
      expect(AnsweredQuestion.last.streak_mtp).to eq 2
      expect(StudentLessonExp.last.streak_mtp).to eq 1.8
    end

    it 'recalculates four answered questions' do
      ans_q_12 = create_ans_q(student, question_2, 1, 1, lesson)
      ans_q_13 = create_ans_q(student, question_3, 1, 1.25, lesson)
      ans_q_14 = create_ans_q(student, question_4, 0.8, 1.2, lesson)
      ans_q_15 = create_ans_q(student, question_5, 0.8, 1.16, lesson)
      updater.update_streak_mtp(amended_ans_q)
      expect(AnsweredQuestion.last.streak_mtp).to eq 1.8
      expect(StudentLessonExp.last.streak_mtp).to eq 1.64
    end

    it 'recalculates five answered questions' do
      ans_q_12 = create_ans_q(student, question_2, 1, 999, lesson)
      ans_q_13 = create_ans_q(student, question_3, 1, 999, lesson)
      ans_q_14 = create_ans_q(student, question_4, 0.8, 999, lesson)
      ans_q_15 = create_ans_q(student, question_5, 0.8, 999, lesson)
      ans_q_15 = create_ans_q(student, question_6, 0.5, 999, lesson)
      updater.update_streak_mtp(amended_ans_q)
      expect(AnsweredQuestion.last.streak_mtp).to eq 1.64
      expect(StudentLessonExp.last.streak_mtp).to eq 1.32
    end
  end
end
