module Chronic
  class Repeater < Tag

    # Scan an Array of Token objects and apply any necessary Repeater
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for_season_names(token, options)
        token.tag scan_for_month_names(token, options)
        token.tag scan_for_day_names(token, options)
        token.tag scan_for_day_portions(token, options)
        token.tag scan_for_times(token, options)
        token.tag scan_for_units(token, options)
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_season_names(token)
      scan_for token, RepeaterSeasonName, Chronic.translate([:repeater, :season_names])
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_month_names(token)
      scan_for token, RepeaterMonthName, Chronic.translate([:repeater, :month_names])
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_day_names(token)
      scan_for token, RepeaterDayName, Chronic.translate([:repeater, :day_names])
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_day_portions(token)
      scan_for token, RepeaterDayPortion, Chronic.translate([:repeater, :day_portions])
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_times(token, options = {})
      scan_for token, RepeaterTime, /^\d{1,2}(:?\d{1,2})?([\.:]?\d{1,2}([\.:]\d{1,6})?)?$/, options
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_units(token, options = {})
      Chronic.translate([:repeater, :units]).each do |item, symbol|
        if item =~ token.word
          klass_name = 'Repeater' + symbol.to_s.capitalize
          klass = Chronic.const_get(klass_name)
          return klass.new(symbol, options)
        end
      end
      return nil
    end

    def <=>(other)
      width <=> other.width
    end

    # returns the width (in seconds or months) of this repeatable.
    def width
      raise('Repeater#width must be overridden in subclasses')
    end

    # returns the next occurance of this repeatable.
    def next(pointer)
      raise('Start point must be set before calling #next') unless @now
    end

    def this(pointer)
      raise('Start point must be set before calling #this') unless @now
    end

    def to_s
      'repeater'
    end
  end
end
