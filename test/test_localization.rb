require 'helper'

class TestLocalization < TestCase

  def setup
    @locales_before = Chronic.locales
    @hashes_before = Chronic.locale_hashes
  end

  def teardown
    Chronic.set_locale(@locales_before)
    Chronic.locale_hashes = @hashes_before
  end

  def test_default_locale_is_english
    assert_equal [:en], @locales_before
  end

  def test_nonexistent_locale
    assert_raises(ArgumentError) do
      Chronic.set_locale(:non_existent)
      Chronic.parse('some string')
    end
  end

  def test_add_locale
    assert !Chronic.has_locale(:other), ':other locale should NOT be available'
    Chronic.set_locale(:other)
    other = {}
    Chronic.add_locale :other, other
    assert Chronic.has_locale(:other), ':other locale should be available'
  end

  def test_loads_locale
    assert_includes Chronic.translate([:numerizer, :direct_nums]), ['eleven', '11']
  end

  def test_fallsback_if_translation_not_found
    Chronic.set_locale(:not_found)
    other = {}
    Chronic.add_locale :not_found, other
    assert_includes Chronic.translate([:numerizer, :direct_nums]), ['eleven', '11']
  end
  
  def test_setup_node_with_single_locale
    Chronic.set_locale(:en)
    assert_includes Chronic.node[:numerizer][:direct_nums], ['eleven', '11']
  end

  def test_setup_node_with_multiple_locales
    Chronic.set_locale([:en, :fr])
    assert_includes Chronic.node[:numerizer][:direct_nums], ['eleven', '11']
    assert_includes Chronic.node[:numerizer][:direct_nums], ['onze', '11']
  end
end
