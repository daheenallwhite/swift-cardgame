# Card Game

Texas Holdem Poker Game 을 간단히 구현한 프로그램

![card game 실행 화면 screenshot](https://github.com/daheenallwhite/swift-cardgame/blob/daheenallwhite/images/card-game-1.png)

1. [기능](https://github.com/daheenallwhite/swift-cardgame#%EA%B8%B0%EB%8A%A5)
2. [구성](https://github.com/daheenallwhite/swift-cardgame#%EA%B5%AC%EC%84%B1)
3. [구현 과정 - 문제 & 해결](https://github.com/daheenallwhite/swift-cardgame#%EA%B5%AC%ED%98%84-%EA%B3%BC%EC%A0%95)
4. [배운 점](https://github.com/daheenallwhite/swift-cardgame#%EB%B0%B0%EC%9A%B4-%EC%A0%90)
5. [step 진행하면서 정리한 내용](https://github.com/daheenallwhite/swift-cardgame/blob/daheenallwhite/CardGame/README.md)

&nbsp;

## 기능

### 입력

- card stud : seven or five
- 참여자 수

### Game Rule

- 참여하는 player = 입력된 참여자 수 + 딜러 1명
- 각 플레이어들은 입력된 card stud 숫자만큼의 카드가 주어진다.
- 각 플레이어들의 최대 카드 핸즈를 비교하여 승자를 결정한다

&nbsp;

## 구성

### Card

![](https://github.com/daheenallwhite/swift-cardgame/blob/daheenallwhite/images/card.jpg)

- Card 
- CardDeck
- Cards

### Player

![](https://github.com/daheenallwhite/swift-cardgame/blob/daheenallwhite/images/player.jpg)

- Player 
- Participant
- Dealer
- PlayerFactory
- Players
- PlayersIterator

### Hands 

![](https://github.com/daheenallwhite/swift-cardgame/blob/daheenallwhite/images/hands.jpg)

- Hands
- HandsDeterminator
- Decision

### 입출력 관련

- InputView (struct)
- OutputView (struct)
- GameMode (enum)
- NumberOfParticipants (enum)

### Main Flow

![](https://github.com/daheenallwhite/swift-cardgame/blob/daheenallwhite/images/sequence-diagram.jpg)

&nbsp;

## 구현 과정

### card deck - card 섞기

shuffle algorithm 구현 - **Fisher-Yates shuffle algorithm**

- 무작위로 섞을 때 고려할 점 : 이미 선택된 항목이 또 뽑히지 않도록 선별
- **뽑힐 대상 list** 와 **이미 뽑혀서 완료된 list** 로 나누어진다.
- [shuffle 구현 내용](https://github.com/daheenallwhite/swift-cardgame/tree/daheenallwhite/CardGame#suffle-%EA%B5%AC%ED%98%84---%EB%AC%B4%EC%9E%91%EC%9C%84-%EC%88%9C%EC%97%B4-%EB%A7%8C%EB%93%9C%EB%8A%94-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98)

### 참가자 수 도메인값으로 추상화 하기 - NumberOfParticipant

- 참가자 수는 1~4명 사이의 값으로 입력을 받을 것
- 처음엔 단순 Int 타입 변수로 받음 - 맞는 범위의 값인지 체크하는 추가 작업이 필요하다
- 이를 enum 으로 변환시, 더 직관적으로 유효한 값을 받을 수 있도록 안전하게 구현 가능

### 승자 판별 과정에서 객체간 의존도 최소화 하기

#### 초기 방식

`Card`, `Player`, `HandsDeterminater` 의존

![](https://github.com/daheenallwhite/daheenallwhite.github.io/blob/master/assets/post-image/swift-cardgame-diagram-step4.png)

- Player 가 두 객체에 의존하고, 두 객체도 서로 의존한다.
  - `Player` → `Card`, `HandsDeterminator`
  - `HandsDeterminator` → `Card`
- 문제점 : 객체간 의존이 많을 수록 유연한 구조가 되지 못하며 재사용성이 떨어진다.
  - 한 클래스의 수정시, 이를 의존하는 다른 클래스도 연달아 수정이 필요하기 때문

#### 개선한 방식

1. `Cards`, `Players` class 구현

   - `Cards` : 카드 list 를 표현하며, HandDeterminator 사용하여 Decision 구하기
   - `Players`

2. Players 와 Cards 가 한개의 객체에만 의존할 수 있도록 수정

   `Players` -> `Cards`, `Cards` -> `Decision`

![](https://github.com/daheenallwhite/swift-cardgame/blob/daheenallwhite/images/winner-determinator.jpg)



### 출력을 위한 별도의 protocol 만들고, 채택하기

#### 초기 구현

`Players` 인스턴스에 있는 플레이어들의 정보를 출력하기 위해 `CustomStringConvertible`protocol 을 채택하여 description 에 각 플레이어의 이름과 카드정보를 구현했다.

문제점 : `Players` 클래스가 승자를 결정하는 책임에 더불어 출력을 위한 문자열을 만드는 책임까지 가지게 되었다.

#### 개선 방식

`PlayersPrintable` protocol 을 만든다. 이 프로토콜은 플레이어들의 이름과 카드 문자열을 반환하는 자격요건을 명시한다. 이 프로토콜을 `Players` 에서 채택한다.

`OutputView` 에서는 `PlayersPrintable` 을 구현한 타입을 사용해서만 플레이어 정보를 출력할 수 있다. 

&nbsp;

## 배운 점

### 유한 집합의 도메인 값은 enum으로 구현한다

케이스가 많더라도 enum 으로 추상화 할 경우, 유효한 값 처리를 더 쉽게 구현할 수 있었다. 또한 switch 문을 사용할 수 있는 이점도 있다.

### Single Responsibility Principle 을 준수해라

이번에 출력 과정에서 `Players` class에서 `CustomStringConvertible` protocol 을 준수하여 출력 포맷까지 제공하도록 처음엔 구현했었다. 하지만 이는 `Players` 객체에게 출력의 책임까지 추가로 넘기는 것이므로, 단일 책임 원칙에 위반된다. 

객체는 최소한의 단일 책임만 가지고 있어야 한다. 재사용성과 효율적인 모듈화를 위해서이다. 

### 한 객체가 최소한의 객체만 알아야 한다

객체가 다른 객체를 참조하면 서로 의존 관계에 있다. 이는 객체지향에서 유연성과 재사용성을 저하시킨다. 한 클래스가 변동시 이 클래스 타입의 객체에 의존하던 다른 클래스 타입의 객체도 연달아서 수정이 필요하기 때문이다. 이는 유연성, 즉 구조와 변동에 최소한의 일만 가능하게 하는 특성을 없애버린다.