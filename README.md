# clickapair

## Dear Flutter Create Judges,

This is a pair match gaming for __TWO__ human players on a single device.

The app displays 2 "cards" at once, the first player to click on the item that is the same on both cards wins the round.
Unlike the card game there 

It was *inspired* by the childrens "pica pair" card game which my daughters love playing, which is itself based on ["Spot It"](https://boardgamegeek.com/boardgame/63268/spot-it).

The original game is:

* 55 "card" combinations
* total of 57 symbols (pictures)
* each card has 8 symbols of differing sizes and orientation
* *Most importantly:* only 1 symbol is the same across any 2 cards

The magic count:
```
$ find . -name "*.dart" | xargs cat | wc -c
5110
```

## Acknowledgements

Card data from: https://stackoverflow.com/a/31154452/85472

## Known Issues:
Because of the contest size limits I have not addressed the following issues in the submitted code, though I do plan to in a more full-featured version that I intend to release on [my github repo for it](https://github.com/maks/clickapair) soon (repo will soon be made public):

* 2 identical cards can possibly be shown, which is of course impossible in the real card game
* there is no way to easily reset the game state short of restarting the app
* the layout of the game card items is not ideal and a better custom layout instead of just rows-columns is needed
* better way of selecting sizes and rotations of items within a card instead of just the arbitrary random numbers currently used
* "advanced mode" with a timer and scoring based on the time taken per each round win 

## Further References:

It turns out that the math behind this seemingly simple childrens cards game is actually very interesting, being related to non-Eucliean geometry...

https://stackoverflow.com/questions/6240113/what-are-the-mathematical-computational-principles-behind-this-game

http://blog.polettix.it/some-maths-for-dobble/

https://openprairie.sdstate.edu/cgi/viewcontent.cgi?article=1016&context=jur

https://radiganengineering.com/2013/01/spot-it-howd-they-do-that/

https://www.smithsonianmag.com/science-nature/math-card-game-spot-it-180970873/

https://www.mathteacherscircle.org/assets/legacy/resources/materials/DSenguptaSpotIt.pdf

