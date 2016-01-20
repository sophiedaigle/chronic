require 'helper'

class TestLocaleFr < TestCase
  # Wed Aug 16 14:00:00 UTC 2006
  TIME_2006_08_16_14_00_00 = Time.local(2006, 8, 16, 14, 0, 0, 0)

  def setup
    @locale_before = Chronic.locales
    Chronic.set_locale(:fr)
    @time_2006_08_16_14_00_00 = TIME_2006_08_16_14_00_00
  end

  def teardown
    Chronic.set_locale(@locale_before)
  end

  def test_handle_generic
    time = Chronic.parse("2012-08-02T13:00:00")
    assert_equal Time.local(2012, 8, 2, 13), time

    time = Chronic.parse("2012-08-02T13:00:00+01:00")
    assert_equal Time.utc(2012, 8, 2, 12), time

    time = Chronic.parse("2012-08-02T08:00:00-04:00")
    assert_equal Time.utc(2012, 8, 2, 12), time

    time = Chronic.parse("2012-08-02T12:00:00Z")
    assert_equal Time.utc(2012, 8, 2, 12), time

    assert_nil Chronic.parse("1/1/32.1")
  end
  
  def test_handle_days
    
    monday = Time.local(2006, 8, 21, 12)
    assert_equal monday, parse_now("lundi")
    
    tuesday = Time.local(2006, 8, 22, 12)
    assert_equal tuesday, parse_now("mardi")
    
    wednesday = Time.local(2006, 8, 23, 12)
    assert_equal wednesday, parse_now("mercredi")
    
    thursday = Time.local(2006, 8, 17, 12)
    assert_equal thursday, parse_now("jeudi")
    
    friday = Time.local(2006, 8, 18, 12)
    assert_equal friday, parse_now("vendredi")
    
    saturday = Time.local(2006, 8, 19, 12)
    assert_equal saturday, parse_now("samedi")
    
    sunday = Time.local(2006, 8, 20, 12)
    assert_equal sunday, parse_now("dimanche")
    
    time = parse_now("vendredi 13:00")
    assert_equal Time.local(2006, 8, 18, 13), time
    
    time = parse_now("lundi 4:00")
    assert_equal Time.local(2006, 8, 21, 16), time
    
    time = parse_now("samedi 4:00", :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 19, 4), time
    
    time = parse_now("dimanche 4:20", :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 20, 4, 20), time
  end
  
  def test_handle_months
    time = parse_now("janvier")
    assert_equal Time.local(2007, 1, 16, 12), time

    time = parse_now("fevrier")
    assert_equal Time.local(2007, 2, 15), time

    time = parse_now("mars")
    assert_equal Time.local(2007, 3, 16, 12, 30), time

    time = parse_now("avril")
    assert_equal Time.local(2007, 4, 16), time

    time = parse_now("mai")
    assert_equal Time.local(2007, 5, 16, 12), time

    time = parse_now("juin")
    assert_equal Time.local(2007, 6, 16), time

    time = parse_now("juillet")
    assert_equal Time.local(2007, 7, 16, 12), time

    time = parse_now("aout")
    assert_equal Time.local(2006, 8, 16, 12), time
    
    time = parse_now("septembre")
    assert_equal Time.local(2006, 9, 16), time

    time = parse_now("octobre")
    assert_equal Time.local(2006, 10, 16, 12, 30), time
    
    time = parse_now("novembre")
    assert_equal Time.local(2006, 11, 16), time
    
    time = parse_now("décembre")
    assert_equal Time.local(2006, 12, 16, 12), time
  end

  def test_handle_day_month_time
    time = parse_now("3 aout")
    assert_equal Time.local(2007, 8, 3, 12), time

    time = parse_now("3 aout", :context => :past)
    assert_equal Time.local(2006, 8, 3, 12), time

    time = parse_now("3 août")
    assert_equal Time.local(2007, 8, 3, 12), time

    time = parse_now("20 aout")
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("aout-20")
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("20 août", :context => :future)
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("27 mai")
    assert_equal Time.local(2007, 5, 27, 12), time

    time = parse_now("28 mai", :context => :past)
    assert_equal Time.local(2006, 5, 28, 12), time

    time = parse_now("28 mai 5pm", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17), time

    time = parse_now("28 mai a 5pm", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17), time

    time = parse_now("28 mai a 5:32.19pm", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17, 32, 19), time
  end

  def test_handle_on_date
    time = parse_now("sur le 28 mai a 5PM")
    assert_equal Time.local(2007, 5, 28, 17), time
  end

  def test_handle_ordinal
    time = parse_now("le 3ieme de mai")
    assert_equal Time.local(2007, 5, 3, 12), time
    
    time = parse_now("troisieme mercredi en novembre")
    assert_equal Time.local(2006, 11, 15, 12), time
    
    time = parse_now("dixieme mercredi en novembre")
    assert_equal nil, time
  end
  
  def test_handle_ordinal_units
    time = parse_now("troisième mois de l'annee prochaine", :guess => false)
    assert_equal Time.local(2007, 3), time.begin

    # time = parse_now("troisieme mois du prochain ans", :guess => false)
    # assert_equal Time.local(2007, 3, 1), time.begin

    # time = parse_now("3ieme mois de la prochaine annee", :guess => false)
    # assert_equal Time.local(2007, 3), time.begin

    time = parse_now("troisieme mois l'ans prochain", :guess => false)
    assert_equal Time.local(2007, 3, 1), time.begin

    time = parse_now("troisieme jeudi de ce septembre")
    assert_equal Time.local(2006, 9, 21, 12), time

    now = Time.parse("1/10/2010")
    time = parse_now("troisieme jeudi de ce novembre", :now => now)
    assert_equal Time.local(2010, 11, 18, 12), time
  end
  
  def test_handle_ordinal_day
    time = parse_now("troisième jeudi en octobre")
    assert_equal Time.local(2006, 10, 19, 12), time

    now = Time.parse("1/10/2010")
    time = parse_now("troisieme jeudi en octobre", :now => now)
    assert_equal Time.local(2010, 10, 21, 12), time
  end

  def test_handle_ordinal_this_month
    time = parse_now("premier vendredi de ce mois")
    assert_equal Time.local(2006, 8, 4, 12), time
  end

  def test_handle_ordinal_with_time
    time = parse_now("11ieme de decembre 8am")
    assert_equal Time.local(2006, 12, 11, 8), time
  end

  def test_handle_day_month_year
    time = parse_now("22 Mai 2009")
    assert_equal Time.local(2009, 05, 22, 12), time
  end

  def test_handle_year
    time = parse_now("janvier 97")
    assert_equal Time.local(1997, 1, 16, 12), time

    time = parse_now("janvier 32")
    assert_equal Time.local(2032, 1, 16, 12, 0, 0), time
  end

  def test_handle_time_format
    time = parse_now("2011-07-03 22:11:35 +0100")
    assert_equal 1309727495, time.to_i

    time = parse_now("2011-07-03 22:11:35 +01:00")
    assert_equal 1309727495, time.to_i

    time = parse_now("2011-07-03 21:11:35 UTC")
    assert_equal 1309727495, time.to_i
  end

  def test_handle_date_year_time
    time = parse_now("18 Novembre, 2010")
    assert_equal Time.local(2010, 11, 18, 12), time

    time = parse_now("1 Janv,2010")
    assert_equal Time.local(2010, 1, 1, 12), time

    time = parse_now("3 janv 2010")
    assert_equal Time.local(2010, 1, 3, 12), time

    time = parse_now("3 janv 2010 minuit")
    assert_equal Time.local(2010, 1, 4, 0), time
    
    time = parse_now("3 janv 2010 a minuit")
    assert_equal Time.local(2010, 1, 4, 0), time
    
    time = parse_now("3 janv 2010 a 4", :ambiguous_time_range => :none)
    assert_equal Time.local(2010, 1, 3, 4), time

    time = parse_now("27 mai, 1979")
    assert_equal Time.local(1979, 5, 27, 12), time

    time = parse_now("27 mai 79")
    assert_equal Time.local(1979, 5, 27, 12), time

    time = parse_now("27 mai 79 4:30")
    assert_equal Time.local(1979, 5, 27, 16, 30), time

    time = parse_now("27 mai 79 à 4:30", :ambiguous_time_range => :none)
    assert_equal Time.local(1979, 5, 27, 4, 30), time

    time = parse_now("27 mai 32")
    assert_equal Time.local(2032, 5, 27, 12, 0, 0), time

    time = parse_now("5 octo 2012 1045pm")
    assert_equal Time.local(2012, 10, 5, 22, 45), time

    time = parse_now("18 Novembre 2010 minuit")
    assert_equal Time.local(2010, 11, 19, 0), time

    time = parse_now("18 Novembre 2010 à minuit")
    assert_equal Time.local(2010, 11, 19, 0), time

    time = parse_now("18 Novembre 2010 a 4")
    assert_equal Time.local(2010, 11, 18, 16), time
    
    time = parse_now("18 Novembre 2010 a 4", :ambiguous_time_range => :none)
    assert_equal Time.local(2010, 11, 18, 4), time

    time = parse_now("30 Mars, 1979")
    assert_equal Time.local(1979, 3, 30, 12), time

    time = parse_now("30 Mars 79")
    assert_equal Time.local(1979, 3, 30, 12), time

    time = parse_now("30 Mars 79 4:30")
    assert_equal Time.local(1979, 3, 30, 16, 30), time

    time = parse_now("30 Mars 79 a 4:30", :ambiguous_time_range => :none)
    assert_equal Time.local(1979, 3, 30, 4, 30), time
  end

  def test_handle_date_format_slash
    time = parse_now("5/27/1979")
    assert_equal Time.local(1979, 5, 27, 12), time

    time = parse_now("5/27/1979 4am")
    assert_equal Time.local(1979, 5, 27, 4), time

    time = parse_now("7/12/11")
    assert_equal Time.local(2011, 7, 12, 12), time

    time = parse_now("7/12/11", :endian_precedence => :little)
    assert_equal Time.local(2011, 12, 7, 12), time

    time = parse_now("9/19/2011 6:05:57 PM")
    assert_equal Time.local(2011, 9, 19, 18, 05, 57), time

    # month day overflows
    time = parse_now("30/2/2000")
    assert_nil time

    time = parse_now("2013-03-12 17:00", :context => :past)
    assert_equal Time.local(2013, 3, 12, 17, 0, 0), time

    time = parse_now("27/5/1979")
    assert_equal Time.local(1979, 5, 27, 12), time

    time = parse_now("27/5/1979 @ 0700")
    assert_equal Time.local(1979, 5, 27, 7), time

    time = parse_now("03/18/2012 09:26 pm")
    assert_equal Time.local(2012, 3, 18, 21, 26), time

    time = parse_now("05/06")
    assert_equal Time.local(2007, 5, 6, 12), time

    time = parse_now("05/06", :endian_precedence => [:little, :medium])
    assert_equal Time.local(2007, 6, 5, 12), time

    time = parse_now("05/06 6:05:57 PM")
    assert_equal Time.local(2007, 5, 6, 18, 05, 57), time

    time = parse_now("05/06 6:05:57 PM", :endian_precedence => [:little, :medium])
    assert_equal Time.local(2007, 6, 5, 18, 05, 57), time

    time = parse_now("13/09")
    assert_equal Time.local(2006, 9, 13, 12), time

    # future
    time = parse_now("05/06") # future is default context
    assert_equal Time.local(2007, 5, 6, 12), time

    time = parse_now("1/13", :context => :future)
    assert_equal Time.local(2007, 1, 13, 12), time

    time = parse_now("3/13", :context => :none)
    assert_equal Time.local(2006, 3, 13, 12), time
  end

  def test_handle_date_format_dash
    time = parse_now("2000-1-1")
    assert_equal Time.local(2000, 1, 1, 12), time

    time = parse_now("2006-08-20")
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("2006-08-20 7pm")
    assert_equal Time.local(2006, 8, 20, 19), time

    time = parse_now("2006-08-20 03:00")
    assert_equal Time.local(2006, 8, 20, 3), time

    time = parse_now("2006-08-20 03:30:30")
    assert_equal Time.local(2006, 8, 20, 3, 30, 30), time

    time = parse_now("2006-08-20 15:30:30")
    assert_equal Time.local(2006, 8, 20, 15, 30, 30), time

    time = parse_now("2006-08-20 15:30.30")
    assert_equal Time.local(2006, 8, 20, 15, 30, 30), time

    time = parse_now("1902-08-20")
    assert_equal Time.local(1902, 8, 20, 12, 0, 0), time
    
    time = parse_now('30-Mars-11')
    assert_equal Time.local(2011, 3, 30, 12), time
  end

  def test_handle_time
    time = parse_now("1:00:00 PM")
    assert_equal Time.local(2006, 8, 16, 13), time

    time = parse_now("01:00:00PM")
    assert_equal Time.local(2006, 8, 16, 13), time
    
    time = parse_now("13:00")
    assert_equal Time.local(2006, 8, 17, 13), time

    time = parse_now("13:45")
    assert_equal Time.local(2006, 8, 17, 13, 45), time

    time = parse_now("1:01pm")
    assert_equal Time.local(2006, 8, 16, 13, 01), time

    time = parse_now("2:01pm")
    assert_equal Time.local(2006, 8, 16, 14, 01), time

    time = parse_now("4 pm")
    assert_equal Time.local(2006, 8, 16, 16), time

    time = parse_now("4 am", :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 16, 4), time

    time = parse_now("12 pm")
    assert_equal Time.local(2006, 8, 16, 12), time

    time = parse_now("12:01 pm")
    assert_equal Time.local(2006, 8, 16, 12, 1), time

    time = parse_now("12:01 am")
    assert_equal Time.local(2006, 8, 16, 0, 1), time

    time = parse_now("12 am")
    assert_equal Time.local(2006, 8, 16), time

    time = parse_now("4:00 du matin")
    assert_equal Time.local(2006, 8, 16, 4), time

    time = parse_now("0:10")
    assert_equal Time.local(2006, 8, 17, 0, 10), time
  end

  def test_handle_days_past
    time1 = parse_now("deux jours passes 0:0:0am")
    time2 = parse_now("deux jours passes 00:00:00am")
    assert_equal time1, time2
  end

  def test_handle_night_time
    time = parse_now("mardi 1 pm")
    assert_equal Time.local(2006, 8, 22, 13), time

    time = parse_now("mardi 11 le soir")
    assert_equal Time.local(2006, 8, 22, 23), time

    time = parse_now("mardi a 11 pendant le soir")
    assert_equal Time.local(2006, 8, 22, 23), time
    
    time = parse_now("mardi soir a 7")
    assert_equal Time.local(2006, 8, 22, 19), time
  end

  def test_grabbers_and_tokens
    # year

    time = parse_now("cette annee", :guess => false)
    assert_equal Time.local(2006, 8, 17), time.begin

    time = parse_now("cette annee", :context => :past, :guess => false)
    assert_equal Time.local(2006, 1, 1), time.begin

    # month

    time = parse_now("ce mois")
    assert_equal Time.local(2006, 8, 24, 12), time

    time = parse_now("ce mois", :context => :past)
    assert_equal Time.local(2006, 8, 8, 12), time
    
    time = Chronic.parse("mois prochain", :now => Time.local(2006, 11, 15))
    assert_equal Time.local(2006, 12, 16, 12), time

    # month name
    
    time = parse_now("novembre dernier")
    assert_equal Time.local(2005, 11, 16), time

    # week

    time = parse_now("cette semaine")
    assert_equal Time.local(2006, 8, 18, 7, 30), time

    time = parse_now("cette semaine", :context => :past)
    assert_equal Time.local(2006, 8, 14, 19), time

    # weekend

    time = parse_now("cette fin de semaine")
    assert_equal Time.local(2006, 8, 20), time
    
    time = parse_now("cette fin de semaine", :context => :past)
    assert_equal Time.local(2006, 8, 13), time
    
    time = parse_now("fin de semaine dernier")
    assert_equal Time.local(2006, 8, 13), time

    # day

    time = parse_now("ce jour")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("cette journee", :context => :past)
    assert_equal Time.local(2006, 8, 16, 7), time

    time = parse_now("aujourd'hui")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("hier")
    assert_equal Time.local(2006, 8, 15, 12), time

    now = Time.parse("2011-05-27 23:10") # after 11pm
    time = parse_now("hier", :now => now)
    assert_equal Time.local(2011, 05, 26, 12), time

    time = parse_now("demain")
    assert_equal Time.local(2006, 8, 17, 12), time

    # day name

    time = parse_now("ce mardi")
    assert_equal Time.local(2006, 8, 22, 12), time

    time = parse_now("mardi prochain")
    assert_equal Time.local(2006, 8, 22, 12), time
    
    time = parse_now("mardi dernier")
    assert_equal Time.local(2006, 8, 15, 12), time

    # day portion

    time = parse_now("ce matin")
    assert_equal Time.local(2006, 8, 16, 9), time

    time = parse_now("ce soir")
    assert_equal Time.local(2006, 8, 16, 18, 30), time

    # hour

    time = parse_now("prochaine hr")
    assert_equal Time.local(2006, 8, 16, 15, 30, 0), time

    time = parse_now("prochaine hrs")
    assert_equal Time.local(2006, 8, 16, 15, 30, 0), time

    # minute

    time = parse_now("prochaine min")
    assert_equal Time.local(2006, 8, 16, 14, 1, 30), time
    
    time = parse_now("prochaine mins")
    assert_equal Time.local(2006, 8, 16, 14, 1, 30), time
    
    time = parse_now("prochaine minute")
    assert_equal Time.local(2006, 8, 16, 14, 1, 30), time

    # second

    time = parse_now("prochaine sec")
    assert_equal Time.local(2006, 8, 16, 14, 0, 1), time

    time = parse_now("prochaine secs")
    assert_equal Time.local(2006, 8, 16, 14, 0, 1), time

    time = parse_now("prochaine seconde")
    assert_equal Time.local(2006, 8, 16, 14, 0, 1), time

    time = parse_now("cette seconde", :context => :past)
    assert_equal Time.local(2006, 8, 16, 14), time

    time = parse_now("prochaine seconde")
    assert_equal Time.local(2006, 8, 16, 14, 0, 1), time

    time = parse_now("derniere seconde")
    assert_equal Time.local(2006, 8, 16, 13, 59, 59), time
  end

  def test_handle_pos_numerize
    time = parse_now("hier a 4:00")
    assert_equal Time.local(2006, 8, 15, 16), time

    time = parse_now("aujourd'hui a 9:00")
    assert_equal Time.local(2006, 8, 16, 9), time

    time = parse_now("aujourd'hui a 2100")
    assert_equal Time.local(2006, 8, 16, 21), time

    time = parse_now("cette journee a 0900")
    assert_equal Time.local(2006, 8, 16, 9), time

    time = parse_now("demain a 0900")
    assert_equal Time.local(2006, 8, 17, 9), time

    time = parse_now("hier a 4:00", :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 15, 4), time

    time = parse_now("vendredi dernier a 4:00")
    assert_equal Time.local(2006, 8, 11, 16), time

    time = parse_now("mercredi prochain 4:00")
    assert_equal Time.local(2006, 8, 23, 16), time

    time = parse_now("hier apres-midi")
    assert_equal Time.local(2006, 8, 15, 15), time

    time = parse_now("mardi dernier")
    assert_equal Time.local(2006, 8, 15, 12), time

    time = parse_now("ce soir a 7")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("ce soir 7")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("7 ce soir")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("aujourd'hui 6:00pm")
    assert_equal Time.local(2006, 8, 16, 18), time

    time = parse_now("aujourd'hui a 6:00am")
    assert_equal Time.local(2006, 8, 16, 6), time

    time = parse_now("ce jour 1800")
    assert_equal Time.local(2006, 8, 16, 18), time

    time = parse_now("hier a 4:00pm")
    assert_equal Time.local(2006, 8, 15, 16), time

    time = parse_now("demain soir a 7")
    assert_equal Time.local(2006, 8, 17, 19), time

    time = parse_now("demain matin a 5:30")
    assert_equal Time.local(2006, 8, 17, 5, 30), time

    time = parse_now("lundi prochain a 12:01 am")
    assert_equal Time.local(2006, 8, 21, 00, 1), time

    time = parse_now("lundi prochain a 12:01 pm")
    assert_equal Time.local(2006, 8, 21, 12, 1), time
  end

  def test_handle_past
    time = parse_now("une heure passee")
    assert_equal Time.local(2006, 8, 16, 13), time
    
    time = parse_now("une journee passee")
    assert_equal Time.local(2006, 8, 15, 14), time
    
    time = parse_now("un mois passe")
    assert_equal Time.local(2006, 7, 16, 14), time
    
    time = parse_now("un ans passe")
    assert_equal Time.local(2005, 8, 16, 14), time
    
    time = parse_now("trois ans passes")
    assert_equal Time.local(2003, 8, 16, 14), time
    
    time = parse_now("un mois passe")
    assert_equal Time.local(2006, 7, 16, 14), time
    
    time = parse_now("3 semaines passees")
    assert_equal Time.local(2006, 7, 26, 14), time
    
    time = parse_now("2 semaines passees")
    assert_equal Time.local(2006, 8, 2, 14), time
    
    time = parse_now("3 jours passes")
    assert_equal Time.local(2006, 8, 13, 14), time
    
    time = parse_now("5 matins passes")
    assert_equal Time.local(2006, 8, 12, 9), time
    
    time = parse_now("7 heures passees")
    assert_equal Time.local(2006, 8, 16, 7), time
    
    time = parse_now("3 minutes passees")
    assert_equal Time.local(2006, 8, 16, 13, 57), time
    
    time = Chronic.parse("2 mois passes", :now => Time.parse("2007-03-07 23:30"))
    assert_equal Time.local(2007, 1, 7, 23, 30), time
  end

  def test_handle_in

    time = parse_now("dans 3 ans")
    assert_equal Time.local(2009, 8, 16, 14, 0, 0), time

    time = parse_now("dans 6 mois")
    assert_equal Time.local(2007, 2, 16, 14), time

    time = parse_now("dans 1 jour")
    assert_equal Time.local(2006, 8, 17, 14), time

    time = parse_now("dans 3 heures")
    assert_equal Time.local(2006, 8, 16, 17), time
    
    # Two repeaters
    # time = parse_now("dans 25 minutes et 20 secondes")
    # assert_equal Time.local(2006, 8, 16, 14, 25, 20), time
    
    # time = parse_now("dans 24 heures et 20 minutes")
    # assert_equal Time.local(2006, 8, 17, 14, 20, 0), time
    
    # time = parse_now("dans 24 heures 20 minutes")
    # assert_equal Time.local(2006, 8, 17, 14, 20, 0), time
  end
  
  def test_handle_next
    time = parse_now("fin de semaine prochaine")
    assert_equal Time.local(2006, 8, 20), time
    
    time = parse_now("20 minutes des maintenant")
    assert_equal Time.local(2006, 8, 16, 14, 20), time
  end

  def test_handle_nonsense
    time = parse_now("some stupid nonsense")
    assert_equal nil, time

    time = parse_now("Ham Sandwich")
    assert_equal nil, time
  end

  def test_handle_span
    span = parse_now("vendredi", :guess => false)
    assert_equal Time.local(2006, 8, 18), span.begin
    assert_equal Time.local(2006, 8, 19), span.end

    span = parse_now("novembre", :guess => false)
    assert_equal Time.local(2006, 11), span.begin
    assert_equal Time.local(2006, 12), span.end

    span = Chronic.parse("fin de semaine" , :now => @time_2006_08_16_14_00_00, :guess => false)
    assert_equal Time.local(2006, 8, 19), span.begin
    assert_equal Time.local(2006, 8, 21), span.end
  end

  def test_handle_words_vs_numbers
    assert_equal parse_now("dans 33 jours"), parse_now("dans trente-trois jours") 
    assert_equal parse_now("mai 10ieme"), parse_now("mai dixieme")
    assert_equal parse_now("deuxieme lundi en janvier"), parse_now("2ieme lundi en janvier")
  end

  def test_handle_relative_hour_before
    assert_equal Time.local(2006, 8, 16, 13, 50), parse_now("10 minutes avant 2 heures")

    # uses the current hour, so 2006-08-16 13:50:00, not 14:50
    assert_equal Time.local(2006, 8, 16, 13, 50), parse_now("10 minutes avant")

    assert_equal Time.local(2006, 8, 16, 15, 45), parse_now("quart de 4")
  end

  def test_handle_relative_hour_after
    # not nil
    assert_equal Time.local(2006, 8, 16, 14, 10), parse_now("10 minutes après 2 heures")
  end

  def test_handle_am_pm
    assert_equal Time.local(2006, 8, 16), parse_now("Aujourd'hui a 12am")
    assert_equal Time.local(2006, 8, 16, 12), parse_now("Aujourd'hui a 12pm")
  end

  def test_handle_seasons
    t = parse_now("ce printemps", :guess => false)
    assert_equal Time.local(2007, 3, 20), t.begin
    assert_equal Time.local(2007, 6, 20), t.end

    t = parse_now("cet hiver", :guess => false)
    assert_equal Time.local(2006, 12, 22), t.begin
    assert_equal Time.local(2007, 3, 19), t.end

    t = parse_now("printemps dernier", :guess => false)
    assert_equal Time.local(2006, 3, 20), t.begin
    assert_equal Time.local(2006, 6, 20), t.end

    t = parse_now("hiver dernier", :guess => false)
    assert_equal Time.local(2005, 12, 22), t.begin
    assert_equal Time.local(2006, 3, 19), t.end

    t = parse_now("printemps prochain", :guess => false)
    assert_equal Time.local(2007, 3, 20), t.begin
    assert_equal Time.local(2007, 6, 20), t.end
  end

  def test_now_changes
    t1 = Chronic.parse("maintenant")
    sleep 0.1
    t2 = Chronic.parse("maintenant")
    refute_equal t1, t2
  end

  def test_noon
    t1 = Chronic.parse('2011-01-01 midi', :ambiguous_time_range => :none)
    assert_equal Time.local(2011, 1, 1, 12, 0), t1
  end

  def test_handle_day_date
    time = parse_now("Mardi, le 24 Janvier 2006") 
    assert_equal Time.local(2006, 1, 24, 12), time
  
    time = parse_now("Mardi, le 29 Decembre 2006")
    assert_equal Time.local(2006, 12, 29, 12), time
  
    time = parse_now("Mardi Decembre 28 2006")
    assert_equal Time.local(2006, 12, 28, 12), time
  
    time = parse_now("Mardi Juillet 29")
    assert_equal Time.local(2006, 7, 29, 12), time
  
    time = parse_now("Mardi Decembre 29")
    assert_equal Time.local(2006, 12, 29, 12), time
  end

  private
  def parse_now(string, options={})
    Chronic.parse(string, {:now => TIME_2006_08_16_14_00_00 }.merge(options))
  end
  def pre_normalize(s)
    Chronic::Parser.new.pre_normalize s
  end
end
