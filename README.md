--------------------------------------------
## Chess Club to do:
--------------------------------------------
## DB Design
--------------------------------------------
Memebers (Crud)
-name
-email
-dob
-number_of_games=0
-current_rank=max

Games
-user_id
-user_rank
-user_rank_new
-challenger_id
-challenger_rank
-challenger_rank_new
-user_won - boolean

---------------------------------
1 - Basic Crud for Members
2 - Submit Match & update rank
3 - Leader board
---------------------------------
Ranking:
- higher rank wins = nothing
- Draw = lowwer rank -1 (unless = other player rank)
- Lower rank wins = lower rank half difference (16 - 10) / 2 = 3
		  = higher rank +1
--------------------------------------------