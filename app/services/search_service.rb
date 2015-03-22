class SearchService
  attr_reader :q

  def initialize(q = nil)
    # get rid of quotes
    @q = q.try(:gsub, /[\'\"]/, '')
  end

  def run
    q.present? ? search : []
  end

  private
  def search
    # generate results array and sort by relevance
    data.inject([]) do |results, hash|
      # if we found exact match in programming language name, return it
      if hash['Name'].downcase == q.downcase
        break [hash.merge({ rel: 0 })]
      end

      # from { "Name" => "A+", "Type" => "Array", "Designed by" => "Arthur Whitney" }
      # to   "a+ array arthur whitney"
      hash_data = hash.values.join(' ').downcase

      # split search string into words
      search_words = q.split(' ').map(&:downcase)

      # if all search words were found: add rel 0
      # elsif any match found: add rel 1
      # else: do nothing with results array
      if search_words.all? { |search_word| hash_data.include?(search_word) }
        results << hash.merge({ rel: 0 })
      elsif search_words.map { |search_word| hash_data.scan(/#{search_word}/).any? }.any?
        results << hash.merge({ rel: 1 })
      else
        results
      end
    end.sort_by { |i| i[:rel] }
  end

  def data
    @data ||= JsonDbLoaderService.load
  end
end
