#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --tuples-only -c"

NUMBER_OF_GUESSES=0

#get random number
SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
echo $SECRET_NUMBER

#get name from user
echo -e "\nEnter your username:"
read USERNAME

#check if user is in database
GET_USERNAME=$($PSQL "SELECT username FROM game_data WHERE username='$USERNAME'")

if [[ -z $GET_USERNAME ]]
then
  #new user
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  #returning user
  #get number of games
  NUMBER_OF_GAMES=$($PSQL "SELECT games_played FROM game_data WHERE username='$USERNAME'")

  NUMBER_OF_GAMES=$(( $NUMBER_OF_GAMES + 1 ))

  #get best game
  echo "$($PSQL "SELECT games_played, best_game FROM game_data WHERE username='$USERNAME'")" | while read GAMES_PLAYED BAR BEST_GAME
  do
    echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

echo "Guess the secret number between 1 and 1000:" 

while [[ $GUESS != $SECRET_NUMBER ]]
do
  #get guess
  read GUESS
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
    #if user guess is less than number
    if [[  $GUESS > $SECRET_NUMBER ]] 
    then
      echo -e "\nIt's lower than that, guess again:"
    elif [[ $GUESS < $SECRET_NUMBER ]]
    then
      #if user guess is greater than number
      echo -e "\nIt's higher than that, guess again:"
    else
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      BEST_GAME=$($PSQL "SELECT best_game FROM game_data WHERE username='$USERNAME'")
      if [[ $NUMBER_OF_GAMES -le 1  ]]
      then
        INSERT_DATA=$($PSQL "INSERT INTO game_data(username, games_played, best_game) VALUES('$USERNAME', 1, $NUMBER_OF_GUESSES)")
      elif [[ $NUMBER_OF_GUESSES -le $BEST_GAME ]] 
      then
        UPDATE_DATA_GAMES=$($PSQL "UPDATE game_data SET games_played=$NUMBER_OF_GAMES WHERE username='$USERNAME'")
        UPDATE_DATA_BEST=$($PSQL "UPDATE game_data SET best_game=$NUMBER_OF_GUESSES WHERE username='$USERNAME'")
      else
        UPDATE_DATA_GAMES=$($PSQL "UPDATE game_data SET games_played=$NUMBER_OF_GAMES WHERE username='$USERNAME'")
      fi
    fi
  else
    #If not number
    echo "That is not an integer, guess again:" 
  fi
done


