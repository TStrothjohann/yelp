module ReviewsHelper
  def star_rating(rating)
    return rating unless rating.respond_to?(:round)
    white = (5 - rating)
    '★' * rating.round + '☆' * white
  end
end
