class InvalidInputError < StandardError
  def initialize(msg = "Invalid input provided")
    super
  end
end
