# =============================
## Chess Club to do:
# =============================
Running:
1 - Ruby 2.7.0
2 - Rails 6.0.3.4
3 - rails s
4 - Open http://localhost:3000/
## DB Design
# =============================
* Makes use of sqlite for ease of use
Memebers (Crud)
```
-name
-email
-dob
-number_of_games=0
-current_rank=max
```
Games
```
-user_id
-user_rank
-user_rank_new
-challenger_id
-challenger_rank
-challenger_rank_new
-user_won - boolean
```
# =============================
```
#1 - Basic Crud for Members
#2 - Submit Match 
#3 - Update Rank
#4 - Leader board (members index)
```
# =============================
```
Ranking:
- higher rank wins = nothing
- Draw = lowwer rank -1 (unless = other player rank)
- Lower rank wins = lower rank half difference (16 - 10) / 2 = 3
		  = higher rank +1
```
# =============================