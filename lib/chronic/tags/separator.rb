module Chronic
  class Separator < Tag

    # Scan an Array of Token objects and apply any necessary Separator
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for_commas(token)
        token.tag scan_for_dots(token)
        token.tag scan_for_colon(token)
        token.tag scan_for_space(token)
        token.tag scan_for_slash(token)
        token.tag scan_for_dash(token)
        token.tag scan_for_quote(token)
        token.tag scan_for_at(token)
        token.tag scan_for_in(token)
        token.tag scan_for_on(token)
        token.tag scan_for_and(token)
        token.tag scan_for_t(token)
        token.tag scan_for_w(token)
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorComma object.
    def self.scan_for_commas(token)
      scan_for token, SeparatorComma, { Chronic.translate([:token, :comma]) => :comma }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorDot object.
    def self.scan_for_dots(token)
      scan_for token, SeparatorDot, { Chronic.translate([:token, :dot]) => :dot }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorColon object.
    def self.scan_for_colon(token)
      scan_for token, SeparatorColon, { Chronic.translate([:token, :colon]) => :colon }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorSpace object.
    def self.scan_for_space(token)
      scan_for token, SeparatorSpace, { Chronic.translate([:token, :space]) => :space }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorSlash object.
    def self.scan_for_slash(token)
      scan_for token, SeparatorSlash, { Chronic.translate([:token, :slash]) => :slash }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorDash object.
    def self.scan_for_dash(token)
      scan_for token, SeparatorDash, { Chronic.translate([:token, :dash]) => :dash }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorQuote object.
    def self.scan_for_quote(token)
      scan_for token, SeparatorQuote, { Chronic.translate([:token, :single_quote]) => :single_quote }
      scan_for token, SeparatorQuote, { Chronic.translate([:token, :double_quote]) => :double_quote }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorAt object.
    def self.scan_for_at(token)
      scan_for token, SeparatorAt, { Chronic.translate([:token, :at]) => :at }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorIn object.
    def self.scan_for_in(token)
      scan_for token, SeparatorIn, { Chronic.translate([:token, :in]) => :in }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorOn object.
    def self.scan_for_on(token)
      scan_for token, SeparatorOn, { Chronic.translate([:token, :on]) => :on }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeperatorAnd Object object.
    def self.scan_for_and(token)
      scan_for token, SeparatorAnd, { Chronic.translate([:token, :and]) => :and }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeperatorT Object object.
    def self.scan_for_t(token)
      scan_for token, SeparatorT, { Chronic.translate([:token, :T]) => :T }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeperatorW Object object.
    def self.scan_for_w(token)
      scan_for token, SeparatorW, { Chronic.translate([:token, :W]) => :W }
    end

    def to_s
      'separator'
    end
  end

  class SeparatorComma < Separator #:nodoc:
    def to_s
      super << '-comma'
    end
  end

  class SeparatorDot < Separator #:nodoc:
    def to_s
      super << '-dot'
    end
  end

  class SeparatorColon < Separator #:nodoc:
    def to_s
      super << '-colon'
    end
  end

  class SeparatorSpace < Separator #:nodoc:
    def to_s
      super << '-space'
    end
  end

  class SeparatorSlash < Separator #:nodoc:
    def to_s
      super << '-slash'
    end
  end

  class SeparatorDash < Separator #:nodoc:
    def to_s
      super << '-dash'
    end
  end

  class SeparatorQuote < Separator #:nodoc:
    def to_s
      super << '-quote-' << @type.to_s
    end
  end

  class SeparatorAt < Separator #:nodoc:
    def to_s
      super << '-at'
    end
  end

  class SeparatorIn < Separator #:nodoc:
    def to_s
      super << '-in'
    end
  end

  class SeparatorOn < Separator #:nodoc:
    def to_s
      super << '-on'
    end
  end

  class SeparatorAnd < Separator #:nodoc:
    def to_s
      super << '-and'
    end
  end

  class SeparatorT < Separator #:nodoc:
    def to_s
      super << '-T'
    end
  end

  class SeparatorW < Separator #:nodoc:
    def to_s
      super << '-W'
    end
  end

end
