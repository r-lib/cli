# hash_emoji

    Code
      hash_emoji(character())$names
    Output
      list()
    Code
      hash_emoji("")$names
    Output
      [[1]]
      [1] "teacup without handle" "rhinoceros"            "flushed face"         
      
    Code
      hash_emoji("x")$names
    Output
      [[1]]
      [1] "mage: dark skin tone" "spoon"                "fuel pump"           
      
    Code
      hash_emoji(NA_character_)$names
    Output
      [[1]]
      [1] NA NA NA
      
    Code
      hash_emoji(NA)$names
    Output
      [[1]]
      [1] NA NA NA
      
    Code
      hash_emoji(c(NA, "", "foo", NA))$names
    Output
      [[1]]
      [1] NA NA NA
      
      [[2]]
      [1] "teacup without handle" "rhinoceros"            "flushed face"         
      
      [[3]]
      [1] "sun behind cloud"                    "raised back of hand: dark skin tone"
      [3] "children crossing"                  
      
      [[4]]
      [1] NA NA NA
      

# hash_raw_emoji

    Code
      hash_raw_emoji(raw())$names
    Output
      [1] "teacup without handle" "rhinoceros"            "flushed face"         
    Code
      hash_raw_emoji(as.raw(0))$names
    Output
      [1] "diamond with a dot"    "raised fist"           "face with thermometer"
    Code
      hash_raw_emoji(charToRaw("foobar"))$names
    Output
      [1] "fishing pole"     "money with wings" "eagle"           

# hash_obj_emoji

    Code
      hash_obj_emoji("")$names
    Output
      [1] "woman pilot: medium skin tone" "cat with wry smile"           
      [3] "couple with heart"            
    Code
      hash_obj_emoji(raw(0))$names
    Output
      [1] "fire"                                "man teacher: medium-light skin tone"
      [3] "carp streamer"                      
    Code
      hash_obj_emoji(1:10)$names
    Output
      [1] "backhand index pointing right: medium-light skin tone"
      [2] "woman office worker: medium skin tone"                
      [3] "tiger face"                                           
    Code
      hash_obj_emoji(mtcars)$names
    Output
      [1] "woman judge: medium skin tone" "pause button"                 
      [3] "flag: North Korea"            

# hash_animal

    Code
      hash_animal(character())$words
    Output
      list()
    Code
      hash_animal("")$words
    Output
      [[1]]
      [1] "dogtired"     "conventional" "olingo"      
      
    Code
      hash_animal("x")$words
    Output
      [[1]]
      [1] "goodhearted" "lovelorn"    "amphiuma"   
      
    Code
      hash_animal(NA_character_)$words
    Output
      [[1]]
      [1] NA NA NA
      
    Code
      hash_animal(NA)$words
    Output
      [[1]]
      [1] NA NA NA
      
    Code
      hash_animal(c(NA, "", "foo", NA))$words
    Output
      [[1]]
      [1] NA NA NA
      
      [[2]]
      [1] "dogtired"     "conventional" "olingo"      
      
      [[3]]
      [1] "sacrilegious" "diet"         "lion"        
      
      [[4]]
      [1] NA NA NA
      

# hash_raw_animal

    Code
      hash_raw_animal(raw())$words
    Output
      [1] "dogtired"     "conventional" "olingo"      
    Code
      hash_raw_animal(as.raw(0))$words
    Output
      [1] "scarabaeiform" "surly"         "goldfish"     
    Code
      hash_raw_animal(charToRaw("foobar"))$words
    Output
      [1] "unevolving" "degrading"  "harrier"   

# hash_obj_animal

    Code
      hash_obj_animal("")$words
    Output
      [1] "pathworky" "wondrous"  "minibeast"
    Code
      hash_obj_animal(raw(0))$words
    Output
      [1] "undestructive"   "unequal"         "indianglassfish"
    Code
      hash_obj_animal(1:10)$words
    Output
      [1] "benignant" "profound"  "ambushbug"
    Code
      hash_obj_animal(mtcars)$words
    Output
      [1] "novice"             "flushed"            "australianshelduck"

