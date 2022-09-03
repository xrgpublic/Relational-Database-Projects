#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"




if [[ ! -z $1 ]]
then

  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")

  if [[ ! -z $NAME ]]
  then
    SYMBOL=$($PSQL "SELECT symbol FROM elements FULL JOIN properties USING(atomic_number) WHERE name='$NAME'")
  fi

  if [[  $1 =~ ^[0-9]+$ && -z $SYMBOL && -z $NAME ]]
  then
    SYMBOL=$($PSQL "SELECT symbol FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number='$1'")
  fi
  
  if [[ -z $NUMBER && -z $SYMBOL && -z $NAME ]] 
  then
    echo "I could not find that element in the database."
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol='$SYMBOL'")
    NAME=$($PSQL "SELECT name FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol='$SYMBOL'")
    TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL';")
    MASS=$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol='$SYMBOL'")
    MELT=$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol='$SYMBOL'")
    BOIL=$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE symbol='$SYMBOL'")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
else
  echo "Please provide an element as an argument."
fi