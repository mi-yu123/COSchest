class Costume < ApplicationRecord
  enum status: { completed: 0, incomplete: 1 }
end
