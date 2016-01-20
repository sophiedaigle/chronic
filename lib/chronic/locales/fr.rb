def prepfrench(string)
  accents = {
      'E' => [200,201,202,203],
      'e' => [232,233,234,235],
      'A' => [192,193,194,195,196,197],
      'a' => [224,225,226,227,228,229,230],
      'C' => [199],
      'c' => [231],
      'O' => [210,211,212,213,214,216],
      'o' => [242,243,244,245,246,248],
      'I' => [204,205,206,207],
      'i' => [236,237,238,239],
      'U' => [217,218,219,220],
      'u' => [249,250,251,252],
      'N' => [209],
      'n' => [241],
      'Y' => [221],
      'y' => [253,255],
      'AE' => [306],
      'ae' => [346],
      'OE' => [188],
      'oe' => [189]
  }

  str = String.new(string)
  accents.each do |letter,accents|
    packed = accents.pack('U*')
    rxp = Regexp.new("[#{packed}]", nil)
    str.gsub!(rxp, letter)  #removes accents
    str.gsub!(/\bfin de semaine\b/, 'findesemaine') #make weekend one word to avoid errors
    str.gsub!(/([^\d])-([^\d])/, '\1\2')  #remove hypens separating words to avoid errors
    str.gsub!(/\ble (\d+) (\w+)\b/, '\2 \1')  #flips 'le number month' to be 'month number' so it gets parsed correctly
    str.gsub!(/\b(\w+) (derni[eè]re?s?|prochaine?s?|pass[eé]e?s?)\b/, '\2 \1')  #flips 'word last/next' to be 'last/next word' so it gets parsed correctly
  end

  str
end

module Chronic
  module Locales
    FR = {
        :pointer => {
            /\bavant\b/ => :past,
            /\b(?:future?|dans)\b/ => :future,
        },
        :ordinal_regex => /^(\d*)(ieme|ième)$/,
        :numerizer => {
            :and => 'et',
            :preprocess => [
            ],
            :fractional => [
            ],
            :direct_nums => [
                ['onze', '11'],
                ['douze', '12'],
                ['treize', '13'],
                ['quatorze', '14'],
                ['quinze', '15'],
                ['seize', '16'],
                ['dix-sept', '17'],
                ['dix-huit', '18'],
                ['dix-neuf', '19'],
                [/\bun\b/, '1'],
                [/\bune/, '1'],
                ['deux', '2'],
                ['trois', '3'],
                ['quatre', '4'],
                ['cinq', '5'],
                [/\bsept\b/, '7'],
                ['huit', '8'],
                ['neuf', '9'],
                ['dix', '10']
            ],
            :ordinals => [
                [/premi[eè]re?/i, '1st'],
                [/deuxi[eè]me/i, '2nd'],
                [/troisi[eè]me/i, '3rd'],
                [/quatri[eè]me/i, '4th'],
                [/cinqui[eè]me/i, '5th'],
                [/sixi[eè]me/i, '6th'],
                [/septi[eè]meb/i, '7th'],
                [/huiti[eè]me/i, '8th'],
                [/neuvi[eè]me/i, '9th'],
                [/dixi[èe]me/i, '10th'],
                [/onzi[èe]me/i, '11th'],
                [/douzi[èe]me/i, '12th'],
                [/quinzi[èe]me/i, '10th']
            ],
            :ten_prefixes => [
                ['vingt', 20],
                ['trente', 30],
                ['quarante', 40],
                ['cinquante', 50],
                ['soixante', 60],
                ['soixante-dix', 70],
                ['quatre-vingt', 80],
                ['quatre-vingt-dix', 90]
            ],
            :big_prefixes => [
                ['cent', 100],
                ['mille', 1000],
                ['million', 1_000_000],
                ['billion', 1_000_000_000],
                ['trillion', 1_000_000_000_000],
            ],
        },

        :repeater => {
          :season_names => {
              /^printemps$/ => :spring,
              /^[eé]t[eé]s?$/ => :summer,
              /^automnes?$/ => :autumn,
              /^hivers?$/ => :winter
          },
          :month_names => {
              /^janv[:\.]?(ier)?$/ => :january,
              /^f[eé]vr[:\.]?(ier)?$/ => :february,
              /^mars$/ => :march,
              /^avri[:\.]?(l)?$/ => :april,
              /^mai$/ => :may,
              /^juin$/ => :june,
              /^juil[:\.]?(let)?$/ => :july,
              /^ao[uû]t$/ => :august,
              /^sept[:\.]?(embre)?$/ => :september,
              /^octo[:\.]?(bre)?$/ => :october,
              /^nove[:\.]?(mbre)?$/ => :november,
              /^d[eé]ce[:\.]?(mbre)?$/ => :december
          },
          :day_names => {
              /^lundi$/ => :monday,
              /^mardi$/ => :tuesday,
              /^mercredi$/ => :wednesday,
              /^jeudi$/ => :thursday,
              /^vendredi$/ => :friday,
              /^samedi$/ => :saturday,
              /^dimanche$/ => :sunday
          },
          :day_portions => {
              /^ams?$/ => :am,
              /^pms?$/ => :pm,
              /^matins?$|^avant-?midis?$/ => :morning,
              /^apr[èe]s-?midi?$/ => :afternoon,
              /^(le )?soir([eé]e)?s?$/ => :evening,
              /^nuits?$/ => :night
          },
          :units => {
              /^ann[eé]es?$|^ans$/ => :year,
              /^saisons?$/ => :season,
              /^mois?$/ => :month,
              /^semaines?$/ => :week,
              /^findesemaines?$/ => :weekend,
              /^jour(n[eé]e)?s?$/ => :day,
              /^hrs?$/ => :hour,
              /^heures?$/ => :hour,
              /^mins?$/ => :minute,
              /^minutes?$/ => :minute,
              /^secs?$/ => :second,
              /^secondes?$/ => :second
          }
        },

        :pre_normalize => {
            :preprocess => proc {|str| prepfrench(str)},
            :pre_numerize => [
                [/\b(\d{2})\.(\d{2})\.(\d{4})\b/, '\3 / \2 / \1'],
                [/(\s+|:\d{2}|:\d{2}\.\d{3})\-(\d{2}:?\d{2})\b/, '\1tzminus\2'],
                [/\b([ap])\.m\.?/, '\1m'],
                [/\./, ':'],
                [/['"]/, ''],
                [/,/, ' ']
            ],
            :pos_numerize => [
                [/([\/\-\,\@])/, ' \1 '],
                [/(?:^|\s)0(\d+:\d+\s*pm?\b)/, ' \1'],
                [/\baujourd'?hui\b/, 'ce jour'],
                [/\bdemain\b/, 'prochain jour'],
                [/\bhier\b/, 'dernier jour'],
                [/\bmidi\b/, '12:00pm'],
                [/\bminuit\b/, '24:00'],
                [/\bmaintenant\b/, 'cette seconde'],
                [/\bquart\b/, '15'],
                [/\bdemi\b/, '30'],
                [/\b(?:dans le|pendant le|du|le) (matin)\b/, 'am'],
                [/\b(?:dans |pendant |du )?(l[ea] )?(soir([eé]e)|nuit)\b/, 'pm'],
                [/\ble soir\b/, 'pm'],
                [/(\d{1,2}) (avant|de|d')\b/, '\1 minute passee'],
                [/(\d{1,2}) (apr[èe]s)\b/, '\1 minute future'],
                [/\b(\d{2})(\d{2})(am|pm)\b/, '\1:\2\3'],
                [/\b(apr[èe]s|d[èe]s)\b/, 'future'],
                [/(\d)([ap]m|heures?)\b/, '\1 \2'],
                [/\b\d+:?\d*[ap]\b/,'\0m'],
                [/\b(\d+) du (\w+)\b/, '\2 \1'],
                [/\b(\d{4}):(\d{2}):(\d{2})\b/, '\1 / \2 / \3'], # DTOriginal
                [/\b0(\d+):(\d{2}):(\d{2}) ([ap]m)\b/, '\1:\2:\3 \4'],
                [/\bpass[eé]e?s?\b/, 'avant'],
            ]
        },

        :grabber => {
            /prochaine?/ => :next,
            /\bce|cet(te)?\b/ => :this,
            /derni[eè]re?/ => :last
        },

        :token => {
            :comma => /^,$/,
            :in => /^dans|en$/,
            :and => /^et$/,
            :at => /^[aà]$/,
            :dot => /^\.$/,
            :colon => /^:$/,
            :space => /^ $/,
            :slash => /^\/$/,
            :dash => /^-$/,
            :single_quote => /^'$/,
            :double_quote => /^"$/,
        }
    }
  end
end
