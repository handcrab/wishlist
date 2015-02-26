# language: ru
Функционал: Просмотр желаний
  Чтобы себя мотивровать, и планировать покупки
  я должен иметь возможность просматривать
  сохраненные желания
  
  Контекст:
    Допустим я - авторизированный пользователь

  Сценарий: Список всех желаний
    Допустим у меня сохранено 3 желания
    # И я нахожусь на главной странице     
    И я нахожусь на странице со своими желаниями
    То я должен видеть список из 3х желаний
    И каждое желание дожно иметь ссылку на просмотр его полной версии    

  Сценарий: Просмотр конкретного желания
    Допустим у меня есть желание с названием "айфон"   
    Если я перехожу на страницу с этим желанием
    То я должен увидеть подробное описание этого желания 
    И ссылку на его редактирование
    И ссылку на его удаление
    Также я должен иметь возможность вернуться к списку всех желаний

  Сценарий: Просмотр несуществующего желания
    Допустим я перехожу на страницу с несуществующим желанием
    То я должен быть перенаправлен на главную страницу
    #страницу со списком всех желаний 
    И я должен увидеть сообщение об ошибке    