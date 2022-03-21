#  Приложение для поиска и хранения картинок.
## Реализовано с помощью Unsplash [API](https://unsplash.com/documentation)
## Основной стэк технологий
+ Только UIKit
+ Весь интерфейс приложения сделан через Auto Layout. 
+ В качестве коллекций использовалась технология UICollectionViewCompositionalLayout в паре с UICollectionViewDiffableDataSource
+ Архитектура - стандартная MVP
+ Хранение данных с помощью [Realm](https://docs.mongodb.com/realm/sdk/swift/)
+ Работа с картинками с помощью [SDWebImage](https://github.com/SDWebImage/SDWebImage)
+ Все ячейки с картинками переиспользовались
+ Работа с сетью через URLSession
+ Градиентные кнопочки из моего [репозитория](https://github.com/KorobskoyRoman/GradientView)
## Пример работы приложения
Возможность листать фото по запросу и среди популярных (верхняя секция). Поддержка пагинации.

<img src=https://user-images.githubusercontent.com/43990145/159294338-03d6deda-3bd5-4379-8b38-020bf6cec32f.gif height="500">
<img src=https://user-images.githubusercontent.com/43990145/159296284-e2d3058a-56b0-465e-bd7e-14deed793717.gif height="500">
<img src=https://user-images.githubusercontent.com/43990145/159296881-7c3c6fab-34ab-4466-b19b-3e2349d29103.gif height="500">
<img src=https://user-images.githubusercontent.com/43990145/159297052-ea77f8df-838a-46b9-938a-3477d176b76b.gif height="500">
