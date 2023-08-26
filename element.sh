#!/bin/bash

if [[ ! $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  #choose condition field
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    CONDITION_FIELD="atomic_number"
    VALUE=$1
  elif [[ "$1" =~ ^[A-Z][a-z]?$ ]]
  then
    CONDITION_FIELD="symbol"
    VALUE="'$1'"
  else
    CONDITION_FIELD="name"
    VALUE="'$1'"
  fi
  #echo -e "\nCondition = $CONDITION_FIELD : value $VALUE\n"
  #get element data by condition field
  PSQL="psql -X -U freecodecamp -d periodic_table -t --no-align -c"
  
  AVAILABLE_ELEMENTS=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from elements inner join properties using(atomic_number) inner join types using(type_id) where $CONDITION_FIELD = $VALUE")
  if [[ -z $AVAILABLE_ELEMENTS ]]
  then
    #if element have not found
    echo -e "I could not find that element in the database."
  else
    #if element have found
    echo $AVAILABLE_ELEMENTS | while IFS="|" read NUMBER SYMBOL NAME MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi