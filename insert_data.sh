#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

# Teams table setup

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then

    # get winner team id

    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # team_id not found

    if [[ -z $TEAM_ID ]]
    then

      # insert team into teams table

      TEAM_ID_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo Inserted $WINNER into teams table.

    fi

    # get opponent team id

    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # team_id not found

    if [[ -z $TEAM_ID ]]
    then

      # insert team into teams table

      TEAM_ID_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo Inserted $OPPONENT into teams table.

    fi
  fi
done

# Games table setup

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then

    # get winner and opponent ids

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # insert into games table

    GAMES_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    echo Inserted $YEAR, $ROUND, $WINNER vs $OPPONENT, $WINNER scoring $WINNER_GOALS and $OPPONENT scoring $OPPONENT_GOALS
  fi
done

