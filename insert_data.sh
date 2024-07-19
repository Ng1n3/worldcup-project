#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#insert teams into worldcup database
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
 then

  INSERT_INTO_TEAMS=$($PSQL "INSERT INTO teams(name) SELECT '$WINNER' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name='$WINNER')")
  if [[ $INSERT_INTO_TEAMS == "INSERT 0 1" ]]
  then
    echo Inserted into teams, $WINNER
  fi

  INSERT_INTO_TEAMS=$($PSQL "INSERT INTO teams(name) SELECT '$OPPONENT' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name='$OPPONENT')")
  if [[ $INSERT_INTO_TEAMS == "INSERT 0 1" ]]
  then
    echo Inserted into teams, $OPPONENT
  fi

  #insert games.csv into teams
  #get winner id
  WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")

  #get oppnent id
  OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")


  INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  if [[ INSERT_INTO_GAMES == "INSERT 0 1" ]]
  then
    echo Inserted into games, $YEAR, $ROUND, $WINNER vs $OPPONENT
  fi
 fi
done