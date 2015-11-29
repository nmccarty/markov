
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

  def select(state)
    hash = @model[state]
    target = rand

    total = hash.values.reduce(:+)
    nexts = hash.keys.collect {|key| [hash[key].fdiv(total), key]}

    i = 0
    value = nil
    total = 0
    while total < target
      (score, value) = nexts[i]
      total += score
      i += 1
    end
    value
  end

  def produce()
    state = []
    x = Array.new(@order, :start)
        y = select(x)
    while y != :end
      state.push(y)
      x = x[0...-1].push(y)
      y = select(x)
    end
    state
  end
end