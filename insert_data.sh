#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games,teams")

cat games.csv | while IFS="," read year round winner opponent goal1 goal2
do

if [[ $winner != "winner" ]]
then
 winner_id=$($PSQL "select team_id from teams where name='$winner' ")
  if [[ -z $winner_id ]]
then
 insert_winner_id=$($PSQL "insert into teams(name) values ('$winner') ")
 if [[ $insert_winner_id == 'INSERT 0 1' ]]
 then
echo INSERT TEAM $winner
 fi
 winner_id=$($PSQL "select team_id from teams where name='$winner'")
 fi

 oppo_id=$($PSQL "select team_id from teams where name='$opponent' ")
if [[ -z $oppo_id ]]
then
insert_opponent_id=$($PSQL "insert into teams(name) values ('$opponent') ")
if [[ $insert_opponent_id == 'INSERT 0 1' ]]
then
echo INSERT TEAM $opponent
fi
oppo_id=$($PSQL "select team_id from teams where name='$opponent' ")
fi

insert_into_games=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values ($year, '$round',$winner_id,$oppo_id, $goal1,$goal2) ")
echo $insert_into_games
 fi
done
