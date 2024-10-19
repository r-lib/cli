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

# hash_xxhash

    Code
      hash_xxhash(letters[1:5])
    Output
      [1] "a96faf705af16834e6c632b61e964e1f" "4b2212e31ac97fd4575a0b1c44d8843f"
      [3] "12d8bdd17f74de858c40219a46b9f81b" "56a841f9102d5ff745f80274c9c7a7ca"
      [5] "2d97a8f9e2edaaefe5e72e5e3bec4a78"
    Code
      hash_xxhash(c("a", NA, "b"))
    Output
      [1] "a96faf705af16834e6c632b61e964e1f" NA                                
      [3] "4b2212e31ac97fd4575a0b1c44d8843f"
    Code
      hash_xxhash64(letters[1:5])
    Output
      [1] "e6c632b61e964e1f" "575a0b1c44d8843f" "8c40219a46b9f81b" "45f80274c9c7a7ca"
      [5] "e5e72e5e3bec4a78"
    Code
      hash_raw_xxhash(charToRaw("a"))
    Output
      [1] "a96faf705af16834e6c632b61e964e1f"
    Code
      hash_raw_xxhash64(charToRaw("a"))
    Output
      [1] "e6c632b61e964e1f"
    Code
      hash_obj_xxhash(raw(0))
    Output
      [1] "64f55f347c3e13113cde6a6f033766e3"
    Code
      hash_obj_xxhash64(raw(0))
    Output
      [1] "0c9b74982308d8fd"

---

    Code
      hash_file_xxhash(tmp)
    Output
      [1] "a96faf705af16834e6c632b61e964e1f"
    Code
      hash_file_xxhash64(tmp)
    Output
      [1] "e6c632b61e964e1f"

