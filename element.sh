# Elements and properties
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if no argument is given
if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
else
  # get the first argument provided
  ELEMENT_ARG=$(echo "$1" | tr 'a-z' 'A-Z')
  # determine the type of argument
  if [[ "$ELEMENT_ARG" =~ ^[0-9]+$ ]]
  then
    # argument is a number
    # echo -e "\nArgument is an atomic number: $ELEMENT_ARG"
    ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.atomic_number = $ELEMENT_ARG")
    if [[ -z $ELEMENT_INFO ]]
    then
      echo "I could not find that element in the database."
    else
      # echo "$ELEMENT_INFO"
      echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        # display formatted message
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  elif [[ "$ELEMENT_ARG" =~ ^[A-Za-z]{1,2}$ ]]
  then
    # argument contains only letters, assume its a symbol
    # echo -e "\nArgument is a symbol: $ELEMENT_ARG"
    # get element info
    # echo "$ELEMENT_ARG"
    ELEMENT_NAME=$($PSQL "SELECT TRIM(name) FROM elements WHERE UPPER(symbol) = '$ELEMENT_ARG'")
    ELEMENT_NAME=$(echo "$ELEMENT_NAME" | sed -E 's/^[[:space:]]*//')
    ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.name = '$ELEMENT_NAME'")
    echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      # format message
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    # argument is neither a number or a symbol, assume its a name
    # echo -e "\nArgument is a name: $ELEMENT_ARG"
    # see if the argument given is the name of an element or not
    ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE name ILIKE '$ELEMENT_ARG'")
    if [[ -z $ELEMENT_INFO ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        # display data
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi  
  fi
fi
