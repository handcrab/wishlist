Допустим(/^я нахожусь на странице добавления желания$/) do
  visit new_wish_path
end

# Допустим(/^я нахожусь на (.*)$/) do |page|
#   path = case page
#   when /странице добавления желания/
#     new_wish_path
#   when /главной странице/
#     root_path
#   end
#   visit path
# end

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
  # raise @iphone[:description]
  expect(page).to have_content sanitized_md @iphone[:description]
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
    expect(page).to have_content(/error|ошиб/i) # TODO: (/"#{I18n.t :error}"/i)
  when /успе/
    expect(page).to have_content I18n.t('forms.messages.success') # /succ/i
  end
end

То(/^я снова должен оказаться на странице (.*)$/) do |wish_page|
  pg_title =  case wish_page
              when /добавления желания/
                I18n.t('wishes.new.title')
              when /редактирования желания/
                # expect(current_path).to eq edit_wish_path(@iphone)
                I18n.t('wishes.edit.title')
              end
  expect(page).to have_content pg_title
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
  # current_user.wishes << [@iphone, @notebook, @ram]
  @vasya.wishes.create! [@iphone, @notebook, @ram]
  # Wish.create! [@iphone, @notebook, @ram]
  expect(Wish.count).to eq count.to_i
end

То(/^я должен видеть список из (\d+)х желаний$/) do |_num|
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
  find_link @notebook.title, href: wish_path(@notebook)
  find_link @ram.title, href: wish_path(@ram)
  # find("a", :text => "berlin")
end

Допустим(/^у меня есть ([^\s]*\s)?желание с названием "(.*?)"$/) do |is_owned, _title|
  @iphone = if is_owned =~ /исполненное/i
              @vasya.wishes.create! FactoryGirl.attributes_for :owned_iphone
              # Wish.create! FactoryGirl.attributes_for :owned_iphone
            else
              @vasya.wishes.create! FactoryGirl.attributes_for :iphone
              # Wish.create! FactoryGirl.attributes_for :iphone
            end
  # @iphone = @vasya.wishes.last
end

# я нахожусь на странице этого желания
Если(/^я перехожу на страницу с этим желанием$/) do
  visit wish_path @iphone
end

То(/^я должен увидеть подробное описание этого желания$/) do
  expect(page).to have_content @iphone.title
  expect(page).to have_content number_to_currency(@iphone.price)
  expect(page).to have_content @iphone.priority
  expect(page).to have_content sanitized_md(@iphone[:description])
  # simple_markdown @iphone.description
end

То(/^ссылку на его редактирование$/) do
  expect(page).to have_link I18n.t('forms.buttons.edit'), href: edit_wish_path(@iphone)
  # find_link I18n.t('forms.buttons.edit') # , href: edit_wish_path(@iphone)
end

То(/^ссылку на его удаление$/) do
  expect(page).to have_link I18n.t('forms.buttons.delete'), href: wish_path(@iphone)
  # find_link I18n.t('forms.buttons.delete') # , href: edit_wish_path(@iphone)
end

То(/^я должен иметь возможность вернуться к списку всех желаний$/) do
  # find "a[href='#{wishes_path}']"
  expect(page).to have_link I18n.t('forms.buttons.back'), href: wishes_path
end

Допустим(/^я перехожу на страницу с несуществующим желанием$/) do
  nonexistent_id = 'bad_id'
  visit wish_path id: nonexistent_id
end

То(/^я должен быть перенаправлен на страницу со списком всех желаний$/) do
  expect(current_path).to eq wishes_path
end

То(/^я должен быть перенаправлен на главную страницу$/) do
  expect(current_path).to eq root_path
end

Допустим(/^я нахожусь на странице редактирования желания "(.*?)"$/) do |_title|
  # @iphone = Wish.find_by title: title
  visit edit_wish_path @iphone
end

# То(/^я снова должен оказаться на странице редактирования желания$/) do
#   # expect(current_path).to eq edit_wish_path(@iphone)
#   # expect(page).to have_content "Edit the wish"
#   expect(page).to have_content I18n.t('wishes.edit.title')
# end

Допустим(/^я нахожусь на странице этого желания$/) do
  step 'я перехожу на страницу с этим желанием'
end

# Если(/^я нажимаю кнопку "(.*?)"$/) do |button|
#   # expect(current_path).to eq wish_path(@iphone)
#   click_link I18n.t('forms.buttons.delete')
# end

Если(/^я нажимаю кнопку "Удалить"$/) do
  # expect(current_path).to eq wish_path(@iphone)
  click_link I18n.t('forms.buttons.delete')
end

То(/^желание должно быть удалено из базы данных$/) do
  # expect { step 'я нажимаю кнопку "Удалить"' }.to change(Wish, :count).by(-1)
  # expect(Wish.count).to eq 0
  @wish = Wish.find_by title: @iphone[:title]
  expect(@wish).to be_nil
end

То(/^я должен оказаться на главной странице$/) do
  expect(current_path).to eq root_path # wishes_path
end
То(/^я должен оказаться на странице со всеми желаниями$/) do
  expect(current_path).to eq personal_wishes_path
end

Если(/^я помечаю желание как исполненное$/) do
  # fill_in 'wish_price', with: @iphone[:price]
  page.check('wish_owned')
  click_button find(:css, 'input[type="submit"]').value
  # pending # express the regexp above with the code you wish you had
end

То(/^это желание не должно отображаться на главной$/) do
  visit root_path
  expect(page).not_to have_content @iphone.title
end

# Допустим(/^у меня есть исполненное желание с названием "(.*?)"$/) do |arg1|
#   pending # express the regexp above with the code you wish you had
# end

Если(/^перехожу на страницу с иполненными желаниями$/) do
  visit owned_wishes_path
  # pending # express the regexp above with the code you wish you had
end

То(/^я должен увидеть это желание в списке$/) do
  expect(page).to have_content @iphone.title
end

Если(/^я нажимаю на кнопку 'Получено' напротив желания$/) do
  # pending # express the regexp above with the code you wish you had
  # click_button find(:css, "a[href='submit']").value
  # find_link @notebook.title, href: wish_path(@notebook)

  # find_button('Dashboard')['class'].have_content "disabled"

  # find(:css, "a[href^='#{wish_path @iphone}']").find(:text => 'Quox')
  # find( "a[href^='#{wish_path @iphone}']") { I18n.t('forms.buttons.owned') }

  # click_link I18n.t('forms.buttons.owned')
  find("a.owned[href^='#{wish_path @iphone}']").click

  # img[src^='https://www.example.com/image']
  # click_link I18n.t('forms.buttons.owned'), href: /#{wish_path(@iphone)}/
  # click_button find(:css, 'input[type="submit"]').value
end


Допустим(/^я нахожусь на странице желания "(.*?)"$/) do |_title|
  step 'я перехожу на страницу с этим желанием'
end

Если(/^я помечаю желание как скрытое$/) do
  find("a.toggle-public[href^='#{wish_path @iphone}']").click
end


Если(/^перехожу на страницу со всеми желаниями$/) do
  visit personal_wishes_path
end

Допустим(/^я \- авторизированный пользователь$/) do
  vasya_attributes = FactoryGirl.attributes_for :vasia
  @vasya = User.create! vasya_attributes

  visit new_user_session_path

  fill_in 'user_email', with: vasya_attributes[:email]
  fill_in 'user_password', with: vasya_attributes[:password]
  click_button find(:css, 'input[type="submit"]').value

  # puts body
  # page.driver.request.env['HTTP_REFERER'].should_not be_nil
  # expect(page).to have_content I18n.t 'devise.sessions.signed_in'
  # expect(current_user).not be_nil
end

Допустим(/^я нахожусь на странице со своими желаниями$/) do
  step 'перехожу на страницу со всеми желаниями'
end
