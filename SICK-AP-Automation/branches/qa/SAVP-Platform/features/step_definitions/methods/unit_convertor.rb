require 'rubygems'
require 'colorize'
require 'unitwise'

# Do Not Remove This File
# This file contains assertion methods which are called from hooks.rb

class UnitConvertor
  # Method to check validity of a unit before unit conversion.
  def validity(desired_unit)
    return Unitwise.valid?(desired_unit)
  end

  # Method to check compatibility of two units before conversions.
  def compatibility(source_unit, desired_unit)
    return Unitwise(1, source_unit).compatible_with?Unitwise(1, desired_unit)
  end

  def does_source_val_match_with_output_val?(source_val, source_unit, obtained_val, obtained_unit)
    return Unitwise(source_val, source_unit) == Unitwise(obtained_val, obtained_unit)
  end

  # Method to change some unit abbreviations to full names as unitwise does not perform conversions with some unit's abbreviations.
  # For example, if:
  # units = ["ft", "m", "km", "foot", "mm", "lb", "m/s", "ft/min", "lbs"]
  # unit_abbrv = { 'ft' => 'foot', 'lbs' => 'pound', 'lb' => 'pound' }
  # then output will be: units = ["foot", "m", "km", "foot", "mm", "pound", "m/s", "ft/min", "pound"]
  def fix_unit_abbrv(units)
    units.each {|unit| unit_abbrv.map { |k, v| unit.sub!(k, v) } }
  end

  # Method to convert the speed value in ft/min to a desired unit to standard m/s for comparison as unitwise doesn't support ft/min conversions out of the box.
  def convert_ft_per_min_to_m_per_sec(value)
    value = (value.to_f * 0.00508).round(2)
    return value
  end
end