#!/usr/bin/env node

const people = [
  { name: 'Ingy', favs: ['coffee', 'yellow'] },
  { name: 'Gugod', favs: ['tea', 'blue'] },
];

people.forEach((person) => {
  const { name, favs: [ drink, color ] } = person;
  console.log(`${name} wears ${color} and drinks ${drink}.`);
});
