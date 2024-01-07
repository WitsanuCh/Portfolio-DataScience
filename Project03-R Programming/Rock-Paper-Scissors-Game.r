##Hammer-Paper-Scissors Game
game <- function() {
    print("Hello, welcome to the Hammer-Paper-Scissors Game!")
    flush.console()
    username <- readline("What's your name: ")
    print(paste(username,"Let's play game!"))
    flush.console()
    player_score <- 0
    com_score <- 0

    while(TRUE){
        hands <-c("hammer","scrissor","paper")
        com_hand <- sample(hands,1)
        player_hand <- readline("Select your choice (hammer,paper,scissors) : ")
        if (player_hand == com_hand) {
            print("tie!😕")
        } else if (
          (player_hand == "hammer" & com_hand == "scissors") |
          (player_hand == "paper" & com_hand == "hammer") |
          (player_hand == "scissors" & com_hand == "paper")
        ) {
            player_score <- player_score+1
            print("You win and get 1 score👍")
        } else {
            com_score <- com_score+1
            print("You lose and computer ger 1 score👎")
        }
        flush.console()
        check <- readline("You want to play again ? yes or no : ")
        if(check == "no"){
            if(player_score > com_score){
                print("You win🏆")
                cat("Your score is: ", player_score)
                cat("\nComputer score is: ", com_score)
                cat("\nSee you again")
            }else if(player_score < com_score){
                print("You lose❌")
                cat("Your score is: ", player_score)
                cat("\nComputer score is: ", com_score)
                cat("\nSee you again")
            }else{
                print("tie!")
                cat("Your score is: ", player_score)
                cat("\nComputer score is: ", com_score)
                cat("\nSee you again!")
            }
            break
        }
    }
}
game()
