# CREATE
Допустим(/^я нахожусь на странице добавления желания$/) do  
  visit '/wishes/new'
end

Если(/^я ввожу верные данные$/) do
  @iphone = FactoryGirl.attributes_for :iphone
  # title 'айфон'
  # price '30000'
  # priority '2' 
  # description 'нужен для получения юзер-экспериенса'
  fill_in 'wish_title', with: @iphone[:title] 
  fill_in 'wish_priority', with: @iphone[:priority]
  fill_in 'wish_price', with: @iphone[:price] 
  fill_in 'wish_description', with: @iphone[:description]
  

  click_button "Create Wish"
  # click_button find(:css, 'input[type="submit"]').value
end

То(/^желание должно быть сохранено в базе данных$/) do  
  # puts '==>', Wish.count
  expect(Wish.count).to eq 1
  @wish = Wish.find_by title: @iphone[:title]
  expect(@wish).not_to be_nil
end

То(/^я должен оказаться на странице с этим желанием$/) do  
  expect(current_path).to eq(wish_path @wish)
  expect(page).to have_content @iphone[:title]
end

# ---
Если(/^я ввожу неверные данные$/) do
  @invalid_data = FactoryGirl.attributes_for :invalid_wish
  # title ''
  # price 'дорого'
  # priority 'low' 
  # description ''  
  fill_in 'wish_title', with: @invalid_data[:title]
  fill_in 'wish_priority', with: @invalid_data[:priority]
  fill_in 'wish_price', with: @invalid_data[:price]
  fill_in 'wish_description', with: @invalid_data[:description]
    
  click_button find(:css, 'input[type="submit"]').value
end

То(/^желание не должно быть сохранено в базе данных$/) do  
  expect(Wish.count).to eq 0
  expect(Wish.find_by(title: @invalid_data[:title])).to be_nil
end

То(/^я должен увидеть сообщение об ошибке$/) do
  expect(page).to have_content "errors"
end

То(/^я снова должен оказаться на странице добавления желания$/) do
  # ???
  # expect(current_path).to eq(new_wish_path)
  expect(page).to have_content "Add a new wish"
end


# SHOW
Допустим(/^я нахожусь на главной странице$/) do
  # visit root_path
end

Допустим(/^у меня сохранено (\d+) желания$/) do |arg1|
  # @wishes = FactoryGirl.create :valid_wish
end

То(/^я должен видеть список из (\d+)х желаний$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

То(/^каждое желание дожно иметь ссылку на просмотр его полной версии$/) do
  pending # express the regexp above with the code you wish you had
end

Допустим(/^у меня есть желание с названием "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если(/^я перехожу на страницу с этим желанием$/) do
  pending # express the regexp above with the code you wish you had
end

То(/^я должен увидеть подробное описание этого желания$/) do
  pending # express the regexp above with the code you wish you had
end

То(/^ссылку на его редактирование$/) do
  pending # express the regexp above with the code you wish you had
end

То(/^ссылку на его удаление$/) do
  pending # express the regexp above with the code you wish you had
end

То(/^я должен иметь возможность вернуться к списку всех желаний$/) do
  pending # express the regexp above with the code you wish you had
end
