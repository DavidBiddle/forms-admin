class Pages::SelectionsSettingsInput < BaseInput
  attr_accessor :selection_options, :only_one_option, :include_none_of_the_above, :draft_question

  validates :draft_question, presence: true
  validate :selection_options, :validate_selection_options

  def add_another
    selection_options.append({ name: "" })
  end

  def remove(index)
    selection_options.delete_at(index)
  end

  def answer_settings
    { only_one_option:, selection_options: }
  end

  def submit
    return false if invalid?

    # Set answer_settings for the draft_question
    draft_question
      .assign_attributes({ answer_settings:,
                           is_optional: include_none_of_the_above })

    draft_question.save!(validate: false)
  end

  def validate_selection_options
    filter_out_blank_options

    return errors.add(:selection_options, :minimum) if selection_options.length < 2
    return errors.add(:selection_options, :maximum) if selection_options.length > 30

    errors.add(:selection_options, :uniqueness) if selection_options.uniq.length != selection_options.length
  end

  def filter_out_blank_options
    self.selection_options = selection_options.filter { |option| option[:name].present? }
  end

  def selection_options_form_objects
    selection_options.map { |option| OpenStruct.new(name: option[:name]) }
  end
end
