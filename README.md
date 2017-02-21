# NSRegularExpression и NSDataDetector - Быстрый старт



 Регулярное выражение - строка или последовательность символов, которые задают шаблон.
 С помощью которого можно делать очень гибкие поисковые выборки в тексте.

---------- ---------- ---------- ---------- ---------- ---------- ----------
 
  Допустим у нас имеется некий текст в строке и наша задача найти в нем все перечисленные email-адреса.
  Самый лучший инструмент для этой задачи это регулярные выражения.
 
 
 Пишем Р.В. (Регулярное Выражение) для проверки емаила.
 Для начала нужно описать базовые условия всех возможных комбинаций видов эл.адрессов.
 В самом минимальном варианте, он может иметь следующий вид: a@b.io


-от 1 символа на имя ящика - до 64-х символов <br/>
-от 1 зарезервированный символ "собака"       <br/>
-от 1 символа имени ресурса - до 64-х символов <br/>
-от 2 символа домена        - до 64-х символов <br/>

Начинаем составлять РВ поэтапно:

@"([a-z0-9])"<br/>          
- говорит, что имя ящика может содержать любую букву и любую цифру<br/>
<hr>
@"([a-z0-9]){1,64}"    
- говорит, что группа этих символов может быть длиной от 1 до 64-х символов<br/>
<hr>
@"([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}"   
- говорит, что можно указать еще и эти символы  
<hr>
<br/>
@"([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}@" 
- говорит, что собака на данном месте обязательна
<hr>
<br>
@"([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}@([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}" 
- Добавляем все теже символы, только после @
<hr>
<br/>
@"([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}@([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}\\." 
- говорит, что символ точка на этом месте обязательна
<hr>
<br/>
@"([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}@([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}\\.([a-z0-9]){2,64}" 
- говорит, что имя домена может содержать буквы и цифры общей суммы символов от 2 до 64-х символов
<hr>
<br/>
<br/>


![Minion](https://hsto.org/files/0b1/784/0bc/0b17840bcda8468fb1e7f51796a5fb63.jpg)

Только что мы составили полноценное регулярное выражение.<br/>

Неполный справочник зарезервированых символов для РВ:
------------

| Символ  | Значение |
| ------- | ----------- |
|  ^      |   начало проверяемой строки           |
|  $      |   конец проверяемой строки           |
|  .      |   любой символ          |
|  \|      |    логическое ИЛИ         |
|  ?      |    прешедствующий символ или группа символов является необязательными         |
|  \+     |    один или несколько экземпляров прешедствующего элемента         |
|  \*     |    любое количество экземпляров элемента (в том числе и нулевое)         |
|  \\d    |    цифровой символ         |
|  \\D    |    не циф. символ        |
|  \\s    |    пробельный символ         |
|  \\S    |    не пробельный символ         |
|  \\w    |    соответствует любой букве или цифре; эквивалент [a-zA-Z0-9_]         |
|  \\W    |    наоборот эквивалент [^a-zA-Z0-9_], все символы кроме этих         |
|                          |
|     **Квантификаторы**      |
|   {n}   |    ровно n раз           |
|   {m,n} |    включительно от M до N            |
|   {m,}  |    не менее m раз           |
|   {,n}  |    не более n раз           |
|   ()    |    создание группы           |
|   []    |    в таких скобках говорим, "любой символ из этих, но только один"           |



Создание NSRegularExpression
------------

```objective-c

self.mainText = @"There’s also +39(081)-552-1488 a “Bookmark” button that allows the user to highlight any date, time or location in the text. For simplicity’s sake, www.ok.ru you won’t +39(081)552 2080 not cover every possible format of date, time and 2693485 location strings that can appear in your text. You’ll implement the https://github.com bookmarking functionality +249-54-85 at the very end +39 333 3333333 of the tutorial. vk.com Your first step to getting the search functionality working is to turn standard strings representing regular expressions into http://app.com NSRegularExpression objects.";


NSString* pattern = @"\\b(in)|(or)\\b";                                       // Хотим искать слова "in" или "or" 
NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive; // Поиск внезависимости от регистра
NSError* error = NULL;                                                        
  
// Само создание регулярного выражения  
NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                       options:regexOptions 
                                                                         error:&error];
    
if (error){ 
  NSLog(@"Ошибка при создании Regular Expression"); // Если в pattern были внесены корректные данные, тогда это сообщение не появитсья
} 
```
<br>
> Справедливости ради должен отметить, что при создании паттерна, в строке мы должны писать непросто \w,(или любую другую букву или символ который зарезрвирован)<br> а писать backslash два раза что бы экранировать NSString. \\\w 
<br>
<br>

Маннипуляции с экземпляром  NSRegularExpression
------------

#### Общие количество всех найденых совпадений. <br>


```objective-c
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:_mainText
                                                        options:0
                                                          range:NSMakeRange(0, [_mainText length])];
```
<hr>

#### Возвращает range первого совпадения. <br>

```objective-c
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:_mainText
                                                         options:0
                                                           range:NSMakeRange(0, [_mainText length])];
    
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString *substringForFirstMatch = [_mainText substringWithRange:rangeOfFirstMatch];
    }
```
<hr>
   
#### Получаем массив всех найденых совпадений. <br>

```objective-c

    NSArray *matches = [regex matchesInString:_mainText
                                      options:0
                                        range:NSMakeRange(0, [_mainText length])];
    for (NSTextCheckingResult *match in matches) {

        //=== Через проперти resultType, можно проверить
        //    к какому типу относиться найденый матч
        
        if (match.resultType == NSTextCheckingTypeQuote) NSLog(@"Цитата!");
        
        NSRange matchRange      = [match range];
        NSRange firstHalfRange  = [match rangeAtIndex:1];
        NSRange secondHalfRange = [match rangeAtIndex:2];
    }   
```
<hr>


#### Получаем первое совпадение из общего количества. <br>

```objective-c

    NSTextCheckingResult *match = [regex firstMatchInString:_mainText
                                                    options:0
                                                      range:NSMakeRange(0, [_mainText length])];
    if (match) {
        NSRange matchRange = [match range];
        NSRange firstHalfRange = [match rangeAtIndex:1];
        NSRange secondHalfRange = [match rangeAtIndex:2];
    }
```
<hr>


#### Проходим итератором блоком по каждому совпадению.  <br>

```objective-c

    __block NSUInteger count = 0;
    [regex enumerateMatchesInString:_mainText options:0 range:NSMakeRange(0, [_mainText length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        
        NSRange matchRange = [match range];
        NSRange firstHalfRange = [match rangeAtIndex:1];
        NSRange secondHalfRange = [match rangeAtIndex:2];
        if (++count >= 100) *stop = YES;
   
    }];
```
<hr>


#### Нахождение нашего паттерна в тексте и вставляем на его место слово Sieg!!!. <br>

```objective-c

    NSString *modifiedString = [regex stringByReplacingMatchesInString:_mainText
                                                               options:0
                                                                 range:NSMakeRange(0, [_mainText length])
                                                          withTemplate:@"Sieg!!!"];    
```
<hr>
    
    
    
Обзор класса  NSDataDetector
------------    

  ***NSDataDetector*** - _это подкласс ***NSRegularExpression***, сделланый для удобного поиска 
        (ссылок, номеров телефонов, даты и т.д.). То есть фактический этот класс у себя под капотом
        содержит универсальные регулярные выражения для поиска вышеперечисленного.<br><br>
        Также NSDataDetector может вызывать все методы ***NSRegularExpression***,также искать
        firstMatch/matches всего текста и т.д_<br><br><br>
        

Маннипуляции с экземпляром  NSDataDetector
------------


#### Создание экземпляра NSDataDectector. <br>

```objective-c
  NSError* error1 = nil;
  NSDataDetector* detector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink |
                                                                 NSTextCheckingTypePhoneNumber
                                                           error:&error];
                                                               
   /* Типы данных, того чего можно искать
     
            NSTextCheckingTypeOrthography
            NSTextCheckingTypeSpelling
            NSTextCheckingTypeGrammar
            NSTextCheckingTypeDate
            NSTextCheckingTypeAddress
            NSTextCheckingTypeLink
            NSTextCheckingTypeQuote
            NSTextCheckingTypeDash
            NSTextCheckingTypeReplacement
            NSTextCheckingTypeCorrection
            NSTextCheckingTypeRegularExpression
            NSTextCheckingTypePhoneNumber
            NSTextCheckingTypeTransitInformation
    */
```  
<br> 
<hr>


#### Колличество найденых совпадений в тексте. <br>
```objective-c
NSUInteger numberOfMatchesFromDetect = [detector numberOfMatchesInString:_mainText
                                                 options:0 
                                                   range:NSMakeRange(0,[_mainText length])];
```   
<br> 
<hr>
 
   
   
#### Все совпадения в одном массиве (он содержит объекты NSTextCheckingResult). <br>
```objective-c

 NSArray* matchesFromDetect =[detector matchesInString:_mainText
                                               options:0 
                                                 range:NSMakeRange(0,[_mainText length])];
   
    // ----- Проходим по каждому совпадению и смотрим что там
    
    for (NSTextCheckingResult* match in matchesFromDetect)
    {
        NSLog(@"------------");
        NSRange matchRange = [match range];
       
        if ([match resultType] == NSTextCheckingTypeLink)
        {
            NSURL* url = [match URL];
            NSLog(@"url = %@",url.absoluteString);
            
        } else if ([match resultType] == NSTextCheckingTypePhoneNumber)
            {
            NSString *phoneNumber = [match phoneNumber];
            NSLog(@"phone = %@",phoneNumber);
            }
    }
```
<br> 
<hr>
    
    
    
#### Проходим блоком по всем совпадениям <br>
```objective-c    
    __block NSUInteger countForDectect = 0;
    
    [detector enumerateMatchesInString:_mainText
                               options:0 
                                 range:NSMakeRange(0, [_mainText length])
                            usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
                NSRange matchRange = result.range;
                NSLog(@"In Enumerate = %d, \tRange = %@\t \tText = %@",countForDectect, NSStringFromRange(matchRange), [_mainText substringWithRange:matchRange]);
                countForDectect++;
    }];
 ``` 
<br>
<hr>    

<br>
<br>
<br>

###  Краткая документация по методам и свойствам <br><br>
    
| Проперти экземпляра   NSRegularExpression | Трактовка |
| ----------------------------------------- | --------- |
|  var pattern: String                      |   Возвращает паттерн регулярного выражения.|
|  var options: NSRegularExpression.Options |   Возвращает параметры поиска например: ищем без учета регистра NSRegularExpressionCaseInsensitive.|
|  var numberOfCaptureGroups: Int           |   Возвращает колличество групп из паттерна регулярного выражения,  например: @"^(ab\|bc)(amg\|img)$" - тут две группы|
    
    
    


 
 

### Поиск по строкам 
 
     
```objective-c       
//------------------------------------------------------------------------------------------------------//
|                                                                                                        |
|                              Возвращает количество совпадений найденых в тексте                       |
|                                                                                                        |
|                                                                                                        |
|  ---------------------------------------------------------------------------------------------------   |
|                                                                                                        |
|                        - (NSUInteger) numberOfMatchesInString:(NSString *)string                       |
|                                                       options:(NSMatchingOptions)options               |
|                                                         range:(NSRange)range;                          |
|                                                                                                        |
|                                                                                                        |
//------------------------------------------------------------------------------------------------------//
             
             
//------------------------------------------------------------------------------------------------------//
|                                                                                                        |
|           При найденом сопадении вызывает блок, где можно на него отреагировать.                       |
|             Можно вызвать блок например: По мере нахождения (NSMatchingReportProgress),                |
|               или вызвать тогда, когда все будет готово (NSMatchingReportCompletion).                  |
|                                                                                                        |
|                                                                                                        |
|  -------------------------------------------------------------------------------------------------     |
|                                                                                                        |
|  - (void)enumerateMatchesInString:(NSString *)string                                                   |
|                           options:(NSMatchingOptions)options                                           |
|                             range:(NSRange)range                                                       |
|                        usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){   |
|                                                                                                        |
|                                                                                                        |
|          }];                                                                                           |
|                                                                                                        |
|                                                                                                        |
//------------------------------------------------------------------------------------------------------//

             

//------------------------------------------------------------------------------------------------------//
|                                                                                                        |
|                       Возвращает массив в котором содержатся все совпадения из текста.                |
|                                                                                                        |
|                                                                                                        |
|  ------------------------------------------------------------------------------------------------      |
|                                                                                                        |
|              - (NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)string                   |
|                                                           options:(NSMatchingOptions)options           |
|                                                             range:(NSRange)range;                      |
|                                                                                                        |
|                                                                                                        |
//------------------------------------------------------------------------------------------------------//
             
             
//------------------------------------------------------------------------------------------------------//
|                                                                                                        |
|                               Возвращает первое совпадение (NSTextCheckingResult)                      |
|                                                                                                        |
|                                                                                                        |
|      ------------------------------------------------------------------------------------------------- |
|                                                                                                        |
|               - (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string                 |
|                                                             options:(NSMatchingOptions)options         |
|                                                               range:(NSRange)range;                    |
|                                                                                                        |
|                                                                                                        |
//------------------------------------------------------------------------------------------------------//




//------------------------------------------------------------------------------------------------------//
|                                                                                                        |
|                                      Возвращает NSRange первого совпадения                             |
|      ------------------------------------------------------------------------------------------------  |
|                                                                                                        |
|                     - (NSRange)rangeOfFirstMatchInString:(NSString *)string                            |            
|                                                  options:(NSMatchingOptions)options                    |
|                                                    range:(NSRange)range;                               |
|                                                                                                        |
//------------------------------------------------------------------------------------------------------//
```                            


### Замена строк 
```objective-c     
//-----------------------------------------------------------------------------------------------------//
|                                                                                                       |
|       Заменяет найденую строку из совпадения на новую которую мы указали в качестве шаблона           |
|                                                                                                       |
|                                                                                                       |
|      ----------------------------------------------------------------------------------------------   |
|                                                                                                       |
|              - (NSUInteger)replaceMatchesInString:(NSMutableString *)string                           |
|                                           options:(NSMatchingOptions)options                          |
|                                             range:(NSRange)range withTemplate:(NSString *)templ       |
|                                                                                                       |
//-----------------------------------------------------------------------------------------------------//





//-----------------------------------------------------------------------------------------------------//
|                                                                                                      |
|             Возвращает новую строку содержащию совпадение и заменяеет его на строку из шаблона        |
|                                                                                                      |
|                                                                                                      |
|      ---------------------------------------------------------------------------------------------   |
|                                                                                                      |
|                  - (NSString *)stringByReplacingMatchesInString:(NSString *)string                   |
|                                                         options:(NSMatchingOptions)options           |
|                                                           range:(NSRange)range                       |
|                                                    withTemplate:(NSString *)templ;                   |
|                                                                                                      |
//-----------------------------------------------------------------------------------------------------//
```                            

 
    
    




