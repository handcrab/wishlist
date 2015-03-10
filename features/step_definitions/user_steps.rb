Допустим(/^я \- неавторизованный пользователь$/) do
  @current_user = nil
end

Допустим(/^я \- авторизованный пользователь Вконтакте$/) do
  OmniAuth.config.add_mock(
    :vkontakte,
    uid: '12345',
    info: {
      name: 'vkuser',
      nickname: 'vkuser',
      image: 'http://cs7001.vk.me/c7003/v7003079/374b/53lwetwOxD8.jpg'
    }
  )
end

Допустим(/^я нахожусь на странице регистрации$/) do
  visit new_user_registration_path
end

Если(/^я нажмаю на кнопку "Войти с помощью: Vkontakte"$/) do
  find('.vkontakte-btn').click
end

То(/^я должен увидеть сообщение об успешной авторизации$/) do
  expect(page).to have_content 'Вход в систему выполнен с учётной записью из Vkontakte.'
end

То(/^я должен увидеть ссылку на свой профиль$/) do
  expect(find(:css, '.user-profile').text).to eq 'vkuser'.capitalize
end
