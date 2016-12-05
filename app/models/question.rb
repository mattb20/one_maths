class Question < ApplicationRecord

  has_attached_file :solution_image, :styles => { medium:"500x500>" }, default_url: 'missing.png'

  validates_attachment_content_type :solution_image, :content_type => /\Aimage\/.*\Z/

  has_and_belongs_to_many :lessons
  has_and_belongs_to_many :topics
  has_and_belongs_to_many :tags
  has_many :answered_questions, dependent: :destroy
  has_many :users, through: :answered_questions
  has_many :choices, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_and_belongs_to_many :jobs
  belongs_to :job, class_name: "Job", foreign_key: :job_id

  has_many :current_questions, dependent: :destroy
  has_many :question_images, class_name: "Image", foreign_key: :question_id


  scope :without_lessons, -> {
    includes(:lessons).where(lessons: { id: nil })
  }

  def self.unused
    used_questions = []
    Lesson.all.each do |lesson|
      used_questions += lesson.questions.to_a
      used_questions.uniq!
    end
    Topic.all.each do |topic|
      used_questions += topic.questions.to_a
      used_questions.uniq!
    end
    Question.all.to_a - used_questions
  end

  def complete?
    self.attributes.take(7).each do |attr, value|
      return false if value.nil?
    end
  end

end
