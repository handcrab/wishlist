# language: ru
Функционал: Cкрытие желаний
  Чтобы другие люди не видели мои секретные желания
  я должен иметь возможность скрывать их

  Контекст:
    Допустим я - авторизированный пользователь

  # + страница редактирования
  Сценарий: Скрытие со страницы желания
    Допустим у меня есть желание с названием "айфон"
    И я нахожусь на странице желания "айфон"
    Если я помечаю желание как скрытое
    То это желание не должно отображаться на главной

  Сценарий: Просмотр списка всех желаний
    Допустим у меня есть скрытое желание с названием "айфон"
    Если перехожу на страницу со всеми желаниями
    То я должен увидеть это желание в списке 
