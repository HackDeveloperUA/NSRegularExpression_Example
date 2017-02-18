//
//  ViewController.m
//  Test_NSRegularExpression
//
//  Created by Uber on 16.02.2017.
//  Copyright © 2017 Uberexample. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSString* mainText;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainText = @"There’s also +39(081)-552-1488 a “Bookmark” button that allows the user to highlight any date, time or location in the text. For simplicity’s sake, www.ok.ru you won’t +39(081)552 2080 not cover every possible format of date, time and 2693485 location strings that can appear in your text. You’ll implement the https://github.com bookmarking functionality +249-54-85 at the very end +39 333 3333333 of the tutorial. vk.com Your first step to getting the search functionality working is to turn standard strings representing regular expressions into http://app.com NSRegularExpression objects.";


    
    //---------------*****************************   NSRegularExpression  *****************************---------------//

    
    //--0 Процесс создания регулярного выражения
    
    NSString* pattern = @"\\b(in)|(or)\\b";
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSError* error = NULL;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:regexOptions
                                                                             error:&error];
    
    if (error){
        NSLog(@"Ошибка при создании Regular Expression");
    }
    
    
    //--1 Общие количество всех найденых совпадений
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:_mainText
                                                        options:0
                                                          range:NSMakeRange(0, [_mainText length])];
    
    
    //--2 Range первого совпадения
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:_mainText
                                                         options:0
                                                           range:NSMakeRange(0, [_mainText length])];
    
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString *substringForFirstMatch = [_mainText substringWithRange:rangeOfFirstMatch];
    }
    
    
    //--3 Получаем массив всех найденых совпадений
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
    
    
    //--4 Получаем первое совпадение из общего количества
    NSTextCheckingResult *match = [regex firstMatchInString:_mainText
                                                    options:0
                                                      range:NSMakeRange(0, [_mainText length])];
    if (match) {
        NSRange matchRange = [match range];
        NSRange firstHalfRange = [match rangeAtIndex:1];
        NSRange secondHalfRange = [match rangeAtIndex:2];
    }
    
    //--5 Проходим итератором блоком по каждому совпадению
    __block NSUInteger count = 0;
    [regex enumerateMatchesInString:_mainText options:0 range:NSMakeRange(0, [_mainText length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        
        NSRange matchRange = [match range];
        NSRange firstHalfRange = [match rangeAtIndex:1];
        NSRange secondHalfRange = [match rangeAtIndex:2];
        if (++count >= 100) *stop = YES;
   
    }];
    
    
    //--6 Нахождение нашего паттерна в тексте и вставляем на его место слово Sieg!!!
    NSString *modifiedString = [regex stringByReplacingMatchesInString:_mainText
                                                               options:0
                                                                 range:NSMakeRange(0, [_mainText length])
                                                          withTemplate:@"Sieg!!!"];
    


    
    
    //---------------*****************************  Теперь NSDataDetector  *****************************---------------//
    
    
    /*
        NSDataDetector - это подкласс NSRegularExpression, сделланый для удобного поиска 
        (ссылок, номеров телефонов, даты и т.д.). То есть фактический этот класс у себя под капотом
        содержит универсальные регулярные выражения для поиска вышеперечисленного.
        
        Также NSDataDetector может вызывать все методы NSRegularExpression,также искать
        firstMatch/matches всего текста и т.д.
    */
    
    
    
    
    // ----- Создание экземпляра NSDataDectector
    
    NSError* error1 = nil;
    NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber
                                                               error:&error];
    
    
   // ----- Колличество найденых совпадений в тексте
    NSUInteger numberOfMatchesFromDetect = [detector numberOfMatchesInString:_mainText options:0 range:NSMakeRange(0, [_mainText length])];
 
    
   // ----- Все совпадения в одном массиве (он содержит объекты NSTextCheckingResult)
    NSArray* matchesFromDetect = [detector matchesInString:_mainText options:0 range:NSMakeRange(0, [_mainText length])];
   
    
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
    
    
    // ----- Проходим блоком по всем совпадениям
    
    __block NSUInteger countForDectect = 0;
    
    [detector enumerateMatchesInString:_mainText options:0 range:NSMakeRange(0, [_mainText length])
                            usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
                NSRange matchRange = result.range;
                NSLog(@"In Enumerate = %d, \tRange = %@\t \tText = %@",countForDectect, NSStringFromRange(matchRange), [_mainText substringWithRange:matchRange]);
                countForDectect++;
    }];
    
    
    
    
    
    
    
    
    
    //---------------**************************   Краткая документация по методам  **************************---------------//

    
    
    /* -- Проперти экземпляра NSRegularExpression
     
     
     var pattern: String                      ---------- Возвращает паттерн регулярного выражения.
     
     var options: NSRegularExpression.Options ---------- Возвращает параметры поиска например: ищем без учета регистра 
                                                         NSRegularExpressionCaseInsensitive.
     
     var numberOfCaptureGroups: Int           ---------- Возвращает колличество групп из паттерна регулярного выражения, 
                                                         например: @"^(ab|bc)(amg|img)$" - тут две группы
    */
    
    
    
    
/* ---
///---BEGIN---------------------------- Поиск по строкам //  Searching Strings------------------------------///
 
     
     
             //--------------------------------------------------------------------------------------------------------------------//
             |                                                                                                                      |
             |                              Возвращает колличество совпадений найденых в тексте                                     |
             |                                                                                                                      |
             |                                                                                                                      |
             |      --------------------------------------------------------------------------------------------------------        |
             |                                                                                                                      |
             |                  - (NSUInteger) numberOfMatchesInString:(NSString *)string                                           |
             |                                                 options:(NSMatchingOptions)options                                   |
             |                                                   range:(NSRange)range;                                              |
             |                                                                                                                      |
             |                                                                                                                      |
             //--------------------------------------------------------------------------------------------------------------------//

             
             
             
             //--------------------------------------------------------------------------------------------------------------------//
             |                                                                                                                      |
             |                      При найденом сопадении вызывает блок, где можно на него отреагировать.                          |
             |                        Можно вызвать блок например: По мере нахождения (NSMatchingReportProgress),                   |
             |                          или вызвать тогда, когда все будет готово (NSMatchingReportCompletion).                     |
             |                                                                                                                      |
             |                                                                                                                      |
             |      --------------------------------------------------------------------------------------------------------        |
             |                                                                                                                      |
             |            - (void)enumerateMatchesInString:(NSString *)string                                                       |
             |                                     options:(NSMatchingOptions)options                                               |
             |                                       range:(NSRange)range                                                           |
             |                                 usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){        |
             |                                                                                                                      |
             |                                                                                                                      |
             |            }];                                                                                                       |
             |                                                                                                                      |
             |                                                                                                                      |
             //--------------------------------------------------------------------------------------------------------------------//

             

             
             //--------------------------------------------------------------------------------------------------------------------//
             |                                                                                                                      |
             |      Возвращает массив в котором содержаться все совпадения из текста. Массив содержит (NSTextCheckingResult)        |
             |                                                                                                                      |
             |                                                                                                                      |
             |      --------------------------------------------------------------------------------------------------------        |
             |                                                                                                                      |
             |        - (NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)string                                       |
             |                                                     options:(NSMatchingOptions)options range:(NSRange)range;         |
             |                                                                                                                      |
             |                                                                                                                      |
             //--------------------------------------------------------------------------------------------------------------------//
             
             
             
             
             //--------------------------------------------------------------------------------------------------------------------//
             |                                                                                                                      |
             |                               Возвращает первое совпадение (NSTextCheckingResult)                                    |
             |                                                                                                                      |
             |                                                                                                                      |
             |      --------------------------------------------------------------------------------------------------------        |
             |                                                                                                                      |
             |       - (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string                                       |
             |                                                     options:(NSMatchingOptions)options  range:(NSRange)range;        |
             |                                                                                                                      |
             |                                                                                                                      |
             //--------------------------------------------------------------------------------------------------------------------//
             
             
             
             
             //--------------------------------------------------------------------------------------------------------------------//
             |                                                                                                                      |
             |                                      Возвращает NSRange первого совпадения                                           |
             |      --------------------------------------------------------------------------------------------------------        |
             |                                                                                                                      |
             |     - (NSRange)rangeOfFirstMatchInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range; |
             |                                                                                                                      |
             //--------------------------------------------------------------------------------------------------------------------//

     
     
///---END------------------------------- Поиск по строкам //  Searching Strings------------------------------///
*/
    
    
    
    
    
    
    
    
     
/* ---
///---BEGIN---------------------------- Замена строк //  Replacing Strings------------------------------///

 
      
      
              //--------------------------------------------------------------------------------------------------------------------//
              |                                                                                                                      |
              |                  Заменяет найденую строку из совпадения на новую которую мы указали в качестве шаблона               |
              |                                                                                                                      |
              |                                                                                                                      |
              |      --------------------------------------------------------------------------------------------------------        |
              |                                                                                                                      |
              |              - (NSUInteger)replaceMatchesInString:(NSMutableString *)string                                          |
              |                                           options:(NSMatchingOptions)options                                         |
              |                                             range:(NSRange)range withTemplate:(NSString *)templ;                     |
              |                                                                                                                      |
              //--------------------------------------------------------------------------------------------------------------------//

             
             
             
             
              //--------------------------------------------------------------------------------------------------------------------//
              |                                                                                                                      |
              |                  Возвращает новую строку содержащию совпадени и заменяеет его на строку из шаблона                   |
              |                                                                                                                      |
              |                                                                                                                      |
              |      --------------------------------------------------------------------------------------------------------        |
              |                                                                                                                      |
              |                  - (NSString *)stringByReplacingMatchesInString:(NSString *)string                                   |
              |                                                         options:(NSMatchingOptions)options                           |
              |                                                           range:(NSRange)range                                       |
              |                                                    withTemplate:(NSString *)templ;                                   |
              |                                                                                                                      |
              //--------------------------------------------------------------------------------------------------------------------//
              
 
    
    
///---END------------------------------ Замена строк //  Replacing Strings------------------------------///
*/
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
