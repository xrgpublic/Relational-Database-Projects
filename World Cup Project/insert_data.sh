#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  echo "$($PSQL "TRUNCATE TABLE games, teams")"
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
  if [[ $YEAR != 'year' ]]
  then
    # Get id: Winner Opponent
    WINNER_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    echo $WINNER_ID
    OPPONENT_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # if winner not found, add to database
    if [[ -z $WINNER_ID ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    fi
    # if opponent not found, add to database 
    if [[ -z $OPPONENT_ID ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    fi

    # insert into Games: Year (Winner_id Opponent_id) Winner_goals Opponent_goals Round
    echo $YEAR
    echo "$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'"), $($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'"), $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")"
  fi
  done

else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
    echo "$($PSQL "TRUNCATE TABLE games, teams")"
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
  if [[ $YEAR != 'year' ]]
  then
    # Get id: Winner Opponent
    WINNER_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    echo $WINNER_ID
    OPPONENT_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # if winner not found, add to database
    if [[ -z $WINNER_ID ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    fi
    # if opponent not found, add to database 
    if [[ -z $OPPONENT_ID ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    fi

    # insert into Games: Year (Winner_id Opponent_id) Winner_goals Opponent_goals Round
    echo $YEAR
    echo "$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'"), $($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'"), $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")"
  fi
  done
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
