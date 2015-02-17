# language: ru
Функционал: Создание желания
  * Если я ошибся в описании желания,
  * или при создании желания у меня не было всей
  нужной информации, 
  то я должен иметь возможность исправить желание.
  
  Контекст:
    Допустим у меня есть желание с названием "айфон"
    И я нахожусь на странице редактирования желания "айфон" 
  
  Сценарий: Исправление желания
    Если я ввожу верные данные
    То желание должно быть сохранено в базе данных
    И я должен оказаться на странице с этим желанием
    И я должен увидеть сообщение об успехе

  Сценарий: Попытка исправление желания неверными данными    
    Если я ввожу неверные данные
    То желание не должно быть сохранено в базе данных
    И я должен увидеть сообщение об ошибке
    И я снова должен оказаться на странице редактирования желания
