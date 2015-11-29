
class MarkovModel
  def initialize(n=1)
    @model = Hash.new(Hash.new(0))
    @order = n
  end

  # Accessor for model
  # Uses the marshall hack to make a deep clone
  def model
    Marshal.load(Marshal.dump(@model))
  end


  def ngrams(list)
    length = @order + 1
    list = Array.new(@order, :start) + list + Array.new(@order, :end)
    ngrams = []
    (0..(list.length - length)).each do |i|
      ngrams << list[i...i+length]
    end
    ngrams.freeze
  end

  def train(tokens)
    ngrams = ngrams tokens
    ngrams.each do |x|
      state = x[0...-1]
      transition = x[-1]
      @model[state] = Hash.new(0) unless @model.key? state
      @model[state][transition] += 1
    end
    nil
  end
end