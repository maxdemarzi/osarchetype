ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
   :datetime_military => '%Y-%m-%d %H:%M',
   :datetime          => '%Y-%m-%d %I:%M%P',
   :time              => '%I:%M%P',
   :time_military     => '%H:%M%P',
   :datetime_short    => '%m/%d %I:%M',
   :easy_date      => lambda { |time| time.strftime("%a, %b #{time.day.ordinalize}") }
)