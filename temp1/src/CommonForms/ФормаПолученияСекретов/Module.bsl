&НаКлиенте
Процедура КнопкаПолучитьСекретНажатие(Команда)
    ПолеИмяСекрета = ПолеИмяСекрета;
    
    Если ПустаяСтрока(ПолеИмяСекрета) Тогда
        Сообщить("Введите имя секрета");
        Возврат;
    КонецЕсли;
    
    ПолучитьСекретНаСервере(ПолеИмяСекрета);
КонецПроцедуры


&НаСервере
Процедура ПолучитьСекретНаСервере(ИмяСекрета)
    URL = "/v1/secret/" + ИмяСекрета;
    Соединение = Новый HTTPСоединение("10.0.0.11", 8201);

    Ключ = "hvs.Ge9wLBNp4XjzX0InkoE5aYIS"; 
    Заголовки = Новый Соответствие();
    Заголовки.Вставить("X-Vault-Token", Ключ);  

    HTTPЗапрос = Новый HTTPЗапрос(URL, Заголовки);
    
    Попытка
        Ответ = Соединение.ВызватьHTTPМетод("GET", HTTPЗапрос);
        
        Если Ответ.КодСостояния = 200 Тогда
            ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
            
            // Парсинг JSON-ответа
            ЧитательJSON = Новый ЧтениеJSON;
            ЧитательJSON.УстановитьСтроку(ТелоОтвета);
            ДанныеОтвета = ПрочитатьJSON(ЧитательJSON);
            
            Если ДанныеОтвета.Свойство("data") Тогда
                ДанныеСекрета = ДанныеОтвета.data.data;
                ЗначениеСекрета = ДанныеСекрета["key3"];
                
                Сообщить("Значение секрета: " + ЗначениеСекрета);
            Иначе
                Сообщить("Не удалось извлечь данные секрета");
            КонецЕсли;
            
        ИначеЕсли Ответ.КодСостояния = 404 Тогда
            Сообщить("Секрет не найден. Проверьте правильность пути: " + URL);
        Иначе
            Сообщить("Ошибка запроса: " + Ответ.КодСостояния);
        КонецЕсли;
        
    Исключение
        Сообщить("Ошибка выполнения запроса: " + ОписаниеОшибки());
    КонецПопытки;
КонецПроцедуры
