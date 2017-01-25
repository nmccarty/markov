require 'rspec'
require_relative '../lib/markov_model.rb'

describe MarkovModel do
  describe ".ngrams" do
    it "Produces unigrams for an order 0 model" do
      model = MarkovModel.new(0)
      ngrams = model.ngrams([1,2,3])
      expect(ngrams).to eq [[1],[2],[3]]
    end
    it "Produces bigrams for an order 1 model" do
      model = MarkovModel.new(1)
      ngrams = model.ngrams([1,2,3])
      expect(ngrams).to eq [[:start, 1], [1,2], [2,3], [3,:end]]
    end
    it "Produces trigrams for an order 2 model" do
      model = MarkovModel.new(2)
      ngrams = model.ngrams([1,2,3])
      expect(ngrams).to eq [[:start, :start, 1],[:start, 1, 2],[1, 2, 3],[2, 3, :end], [3, :end, :end]]
    end
    it "Should produce frozen results" do
      model = MarkovModel.new
      ngrams = model.ngrams([1,2,3])
      expect(ngrams.frozen?).to be_truthy
    end
  end
end