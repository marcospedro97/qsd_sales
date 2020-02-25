FactoryBot.define do
  factory :customer do
    name { 'Douglas Adams' }
    address { 'Restaurante no fim do Universo' }
    document { '198.725.668-02' }
    email { 'douglinhas@gmail.com' }
    phone { '(11) 96782-4553' }
    birth_date { '1997-01-28' }
    user
  end
end
