---
id: 01b-javascript
aliases: []
tags:
  - chapter
creation date: 2026-09-24 15:36
modification date: "Thursday 24th September 2026 15:36:43"
status:
  - completed
---

- The latest [[JavaScript]] version was released on June 2025, it's also known as [[ECMAScript]] 2025 or ES16.
- However, it takes a while before browsers are able to understand the latest features. For this, we need a transpiler like [[Babel]] to convert it to a browser understandable JavaScript.
- JavaScript needs a runtime environment to run. Earlier we had JavaScript running only in the browser to add dynamic interactivity to the website. After that, Ryan Dahl in 2009 built the [[node.js]] runtime to run JavaScript on the servers.
- [[node.js]] is built on top of chrome's [[V8 Engine]] and made modifications to enable JavaScript to work on servers and be able to access the [[Operating System (OS)]] resources and functions.
- This allowed us to have JavaScript over at the backends, mobile, servers, cloud and a whole lot of other places.
- JavaScript is an [[Interpreted Language|interpreted]], [[Garbage Collection|garbage collected]], [[Dynamically Typed Programming Language]] similar to [[Python]].

## Variables

```ts
const x = 1;
let y = 5;

console.log(x, y); // 1 5
y += 10;
console.log(x, y); // 1 15
y = "sometext";
console.log(x, y); // 1 sometext
x = 4; // ERROR
```

### var vs let vs const

- The scope of a variable defined with `var` is function scope or global if declared outside any function.
- The scope of a variable defined with let is block scope.

```ts
function varVsLet() {
  console.log(i); // i is undefined due to hoisting
  // console.log(j); // ReferenceError: j is not defined

  for (var i = 0; i < 3; i++) {
    console.log(i); // 0, 1, 2
  }

  console.log(i); // 3
  // console.log(j); // ReferenceError: j is not defined

  for (let j = 0; j < 3; j++) {
    console.log(j);
  }

  console.log(i); // 3
  // console.log(j); // ReferenceError: j is not defined
}
```

- `var`, `let` and `const` variables [[JavaScript - Hoisting|hoists]] to the top of their scope.
  - If you use `var` before they're declared, due to hoisting, it is read as `undefined`.
  - You can't use `let` and `const` variables before they're declared. This is because, while they hoist as well, the section in the scope before these variables are known as [[JavaScript - Temporal Deadzone|Temporal Deadzone]] and you can't consume those variables in that zone.
- `let` in the loop can re-binds it to each iteration of the loop, making sure to re-assign it the value from the end of the previous loop iteration, so it can be used to avoid issue with closures.

```ts
// with var
for (var i = 0; i < 5; ++i) {
  setTimeout(function () {
    console.log(i); // output '5' 5 times
  }, 100);
}

// with let
// print 1, 2, 3, 4, 5
for (let i = 0; i < 5; ++i) {
  setTimeout(function () {
    console.log(i); // output 0, 1, 2, 3, 4
  }, 100);
}
```

- One gotcha, here, the variable will get hoisted to the global scope:

```ts
(function () {
  for (i = 0; i < 10; i++) {
    console.log(i); // OUTPUT: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  }
})();

console.log("After loop: ", i); // OUTPUT: After loop: 10
```

- To prevent this, we can use `"use strict"` at the top.
- `const` provides referential immutability as compared to `let` variables.

> [!NOTE]
> `const` provides referential immutability but you can still mutate the object it holds as shown in below example.

```ts
const t = [1, 2, 3];
let i = 0;
t.push(4); // allowed
i = 2; // allowed
t[1] = 3; // allowed
t = [1, 2, 3, 4]; // error: not allowed
```

- As much as possible try to use `const` in comparison to `let`. Only use `let` if you know a particular variable might change.

#### References

- [var, let and const - What, why and how - ES6 JavaScript Features - funfunfunction YouTube](https://www.youtube.com/watch?v=sjyJBL5fkp8)
- [Javascript variables; should you use let, var or const? - Medium](https://medium.com/podiihq/javascript-variables-should-you-use-let-var-or-const-394f7645c88f)
- [ES6, var vs let](https://www.jstips.co/en/javascript/keyword-var-vs-let/)

## Arrays

```ts
const t = [1, -1, 3];

t.push(5);

console.log(t.length); // 4
console.log(t[1]); // -1

t.forEach((value) => {
  console.log(value); // 1 -1 3 5
});
```

- `push` is used to append the element at the end of the array and mutates the original array.
- `forEach` loops through each item in the array and executes a function on it as shown above.

### concat

- In [[Functional Programming]], it is always preferred to use immutable data structures. In [[React.js]] code, it is preferable to use `concat`, which creates a new array with the added item and the original array remains unchanged.

```ts
const t1 = [1, 2, 3];
const t2 = t1.concat(4); //creates a new array

console.log(t1); // [1, 2, 3]
console.log(t2); // [1, 2, 3, 4]
```

### map

```ts
const t = [1, 2, 3];

const m1 = t.map((value) => value * 2);
console.log(m1); // [2, 4, 6]

const m2 = t.map((value) => "<li>" + value + "</li>");
console.log(m2); // ['<li>1</li>', '<li>2</li>', '<li>3</li>']
```

### Destructuring

```ts
const t = [1, 2, 3, 4, 5];
const [first, second, ...rest] = t;

console.log(first); // 1
console.log(second); // 2
console.log(rest); // [3, 4, 5]
```

## Objects

```ts
const object1 = {
  name: "Arto Hellas",
  age: 35,
  education: "PhD",
};

const object2 = {
  name: "Full Stack web application development",
  level: "intermediate studies",
  size: 5,
};

const object3 = {
  name: {
    first: "Dan",
    last: "Abramov",
  },
  grades: [2, 3, 5, 3],
  department: "Stanford University",
};

// Fetching object properties
console.log(object1.name); // Arto Hellas
const fieldName = "age";
console.log(object1[fieldName]); // 35

// Adding properties
object1.address = "Helsinki";
object1["secret number"] = 12341;
```

### Functions

- In terms of [[JavaScript]], functions are also classified as objects.

```ts
const sum = (p1, p2) => {
  console.log(p1);
  console.log(p2);
  return p1 + p2;
};

const result = sum(1, 5);
console.log(result);
```

### Object Methods and `this`

> [!NOTE]
> Arrow functions and functions defined using the function keyword vary substantially when it comes to how they behave with respect to the keyword `this`, which refers to the object itself.

- Assign methods to an object:

```ts
const arto = {
  name: "Arto Hellas",
  age: 35,
  education: "PhD",
  greet: function () {
    console.log(`Hello, my name is ${this.name}`);
  },
  doAddition: function (a, b) {
    console.log(a, b);
  },
};

arto.greet(); // `this` refers to anything on the left side of the dot: Hello, my name is Arto Hellas

arto.growOlder = function () {
  this.age += 1;
};

console.log(arto.age); // 35
arto.growOlder();
console.log(arto.age); // 36

arto.doAddition(1, 4); // 5

const refereceToAddition = arto.doAddition;
refereceToAddition(10, 15); // 25

const referenceToGreet = arto.greet;
referenceToGreet(); // Hello, my name is undefined

setTimeout(arto.greet, 1000); // Hello, my name is undefined
setTimeout(arto.greet.bind(arto), 1000); // Hello, my name is Arto Hellas
```

- Contrary to other languages, in [[JavaScript]], the value of `this` is defined based on how the method is called.
- When calling the method through a reference, the value of `this` becomes the so-called global object and the end result is often not what the software developer had originally intended.
- To solve this, we use `call`, `apply` and `bind` which is used to tie `this` to an object.
  - `bind` returns a new function by binding `this` to an object.
  - The `call` and `apply` executes the method but the difference is that in `call` we pass any arguments via comma separated values whereas in `apply`, we can pass an array as arguments.

### Classes

- [[JavaScript]] doesn't support [[Object-Oriented Programming]] but supports classes through [[Protoypal Inheritance]] from ES6 even though they are plain JavaScript objects.

```ts
class Person {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }
  greet() {
    console.log("hello, my name is " + this.name);
  }
}

const adam = new Person("Adam Ondra", 33);
adam.greet();

const janja = new Person("Janja Garnbret", 27);
janja.greet();
```
