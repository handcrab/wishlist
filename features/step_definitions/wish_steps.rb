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
  
  # click_button "Create Wish"
  click_button find(:css, 'input[type="submit"]').value
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
  # expect(Wish.count).to eq 0
  expect(Wish.find_by(title: @invalid_data[:title])).to be_nil
end

То(/^я должен увидеть сообщение об ([^\s]+)$/) do |message|
  case message
  when /ошиб/
    expect(page).to have_content /error/i
  when /успе/
    expect(page).to have_content /succ/i
  end
end

То(/^я снова должен оказаться на странице добавления желания$/) do
  # ???
  # expect(current_path).to eq(new_wish_path)
  expect(page).to have_content "Add a new wish"
end


# SHOW
Допустим(/^я нахожусь на главной странице$/) do
  visit root_path
end

Допустим(/^у меня сохранено (\d+) желания$/) do |count|
  # factory :iphone do
  #     title 'айфон'
  #     price '30000'
  #     priority '2' 
  #     description 'нужен для получения юзер-экспериенса'   
  #   end

  #   factory :notebook do
  #     title 'Notebook'
  #     price ' 20000'
  #     priority '7' 
  #     description '*[asus](http://market.yandex.ru)'   
  #   end

  #   factory :ram do
  #     title 'оперативка 8Gb для ноута'
  #     price '5 000'
  #     priority '7' 
  #     description ''   
  #   end
  @iphone = FactoryGirl.attributes_for :iphone
  @notebook = FactoryGirl.attributes_for :notebook
  @ram = FactoryGirl.attributes_for :ram

  Wish.create! [@iphone, @notebook, @ram]  
  expect(Wish.count).to eq count.to_i  
end

То(/^я должен видеть список из (\d+)х желаний$/) do |arg1|
  expect(page).to have_content @iphone[:title]
  expect(page).to have_content @notebook[:title]
  expect(page).to have_content @ram[:title]  
end

То(/^каждое желание дожно иметь ссылку на просмотр его полной версии$/) do
  @iphone = Wish.find_by title: @iphone[:title]
  @notebook = Wish.find_by title: @notebook[:title]
  @ram = Wish.find_by title: @ram[:title]

  find_link @iphone.title
  find "a[href='#{wish_path @iphone}']"

  find_link @notebook.title
  find "a[href='#{wish_path @notebook}']"

  find_link @ram.title
  find "a[href='#{wish_path @ram}']"
  # find("a", :text => "berlin")
end

Допустим(/^у меня есть желание с названием "(.*?)"$/) do |title|
  @iphone = Wish.create! FactoryGirl.attributes_for :iphone
end

Если(/^я перехожу на страницу с этим желанием$/) do
  visit wish_path @iphone
end

То(/^я должен увидеть подробное описание этого желания$/) do
  expect(page).to have_content @iphone.title
  expect(page).to have_content @iphone.price
  expect(page).to have_content @iphone.priority
  expect(page).to have_content @iphone.description
end

То(/^ссылку на его редактирование$/) do
  # find_link wish_path @iphone
  find_link 'Edit'
end

То(/^ссылку на его удаление$/) do
  find_link 'Delete'
end

То(/^я должен иметь возможность вернуться к списку всех желаний$/) do
  # find_link 'Back'
  # find "a[href='#{wishes_path}']"
  expect(page).to have_link 'Back', href: wishes_path
end


Допустим(/^я перехожу на страницу с несуществующим желанием$/) do
  nonexistent_id = 42
  visit wish_path id: nonexistent_id
end

То(/^я должен быть перенаправлен на страницу со списком всех желаний$/) do
  expect(current_path).to eq wishes_path  
end

# Допустим(/^я нахожусь на странице желания$/) do
#   @iphone = Wish.create! FactoryGirl.attributes_for :iphone 
# end

Допустим(/^я нахожусь на странице редактирования желания "(.*?)"$/) do |title|
  @iphone = Wish.find_by title: title
  visit edit_wish_path @iphone
end


То(/^я снова должен оказаться на странице желания$/) do
  # expect(current_path).to eq edit_wish_path(@iphone)
  expect(page).to have_content "Edit the wish"
end

Допустим(/^я нахожусь на странице этого желания$/) do
  step "я перехожу на страницу с этим желанием"  
end

Если(/^я нажимаю кнопку "(.*?)"$/) do |button|
  # expect(current_path).to eq wish_path(@iphone)
  click_link 'Delete'
  # pending # click_button find(:css, 'input[type="submit"]').value
end

То(/^желание должно быть удалено из базы данных$/) do
  # expect { step 'я нажимаю кнопку "Удалить"' }.to change(Wish, :count).by(-1)
  # expect(Wish.count).to eq 0
  @wish = Wish.find_by title: @iphone[:title]
  expect(@wish).to be_nil
end

То(/^я должен оказаться на главной странице$/) do
  expect(current_path).to eq wishes_path
end
