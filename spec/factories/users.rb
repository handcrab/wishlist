FactoryGirl.define do
  factory :user do
    factory :vasia do    
      name 'Вася Пупкин'
      email 'vasia@lol.ka'
      password '12345678'
    end
    
    factory :ololosha do    
      email 'ololosha@lol.ka'
      password '12345678'
    end

  end
end
