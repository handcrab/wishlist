FactoryGirl.define do
  factory :user do
    factory :vasia do
      # attrs = {name: 'Вася Пупкин', email: 'vasia@lol.ka', password: '12345678'}
      name 'Вася Пупкин'
      email 'vasia@lol.ka'
      password '12345678'
    end
    
    factory :ololosha do    
      email 'ololosha@lol.ka'
      password '12345678'
    end

    factory :vkuser do
      uid '12345'
      name 'vkuser'
      email 'vkuser@@vk.messenger.com'
    end

  end
end
