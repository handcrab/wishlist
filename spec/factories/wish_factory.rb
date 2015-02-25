FactoryGirl.define do
  factory :wish do
    factory :invalid_wish do
      title ''
      price 'дорого'
      priority 'low' 
      description ''   
    end
    # VALID:
    factory :valid_wish do
      title 'айфон'
      price '30000'
      priority '2' 
      description 'нужен для получения юзер-экспериенса'   
    end

    factory :no_priority_wish do
      title 'ipad'
      price '30000'       
      description ''   
    end

    factory :iphone do
      title 'айфон'
      price '30000'
      priority '2' 
      description '__нужен__ для получения юзер-экспериенса'   
    end

    factory :owned_iphone do
      title 'айфон'
      price '30000'
      priority '2' 
      owned 'true'
      description 'нужен для получения юзер-экспериенса'   
    end

    factory :notebook do
      title 'Notebook'
      price ' 20000'
      priority '7' 
      description %Q(
        ## Requrements:
        + IPS
        +  multi-touch

        ~~http://market.yandex.ru/product/10830283/spec?hid=91013&track=char~~
        ? http://market.yandex.ru/product/11000746/spec?hid=91013&track=tabs
      )   
    end

    factory :ram do
      title 'оперативка 8Gb для ноута'
      price '5 000'
      priority '7' 
      description ''   
    end

  end
end