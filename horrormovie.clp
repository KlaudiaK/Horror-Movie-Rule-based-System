
;;;======================================================
;;;   Horror Movie System
;;;
;;;     This system will find the horror movie from your worst nightmare.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-age ""

   (logical (start))

   =>

   (assert (UI-state (display AgeQuestion)
                     (relation-asserted legal-age)
                     (response Under18)
                     (valid-answers Under18 Over18))))


(defrule determine-frightened ""

   (logical (legal-age Over18))

   =>

   (assert (UI-state (display FrightenedQuestion)
                     (relation-asserted frightened-of)
                     (response HaveYouSeenNews)
                     (valid-answers HaveYouSeenNews ThingsThatCrawl DontCare FrightenedOfDead AfraidOfBitBoth))))


(defrule determine-sex ""

   (logical (legal-age Under18))

   =>

   (assert (UI-state (display SexQuestion)
                     (relation-asserted sex)
                     (response Male)
                     (valid-answers Male Female))))


(defrule twilight ""

   (logical (sex Female))

   =>

   (assert (UI-state (display Twilight)
                     (state final))))


(defrule determine-catholic ""

   (logical (sex Male))

   =>

   (assert (UI-state (display CatholicQuestion)
                     (relation-asserted catholic)
                     (response No)
                     (valid-answers No Yes))))


(defrule killer-nun ""

   (logical (catholic Yes))

   =>

   (assert (UI-state (display KillerNun)
                     (state final))))


(defrule slaughter-hotel ""

   (logical (catholic No))

   =>

   (assert (UI-state (display SlaughterHotel)
                     (state final))))


(defrule determine-hair-feelings ""

   (logical (frightened-of HaveYouSeenNews))

   =>

   (assert (UI-state (display HairFeelingsQuestion)
                     (relation-asserted hair-feelings)
                     (response PoopMyPantsEnvironmentalist)
                     (valid-answers PoopMyPantsEnvironmentalist DogsAreCool))))


(defrule determine-environmentalist ""

   (logical (hair-feelings PoopMyPantsEnvironmentalist))

   =>

   (assert (UI-state (display EnvironmentalistQuestion)
                     (relation-asserted is-environmentalist)
                     (response MehEnvironmentalist)
                     (valid-answers MehEnvironmentalist EveryDayEnvironmentalist))))


 (defrule determine-puberty-suck ""

    (logical (is-environmentalist MehEnvironmentalist))

    =>

    (assert (UI-state (display PubertyQuestion)
                      (relation-asserted is-environmentalist)
                      (response Yes)
                      (valid-answers Yes WasntBadPuberty))))


  (defrule determine-puberty-suck ""

     (logical (is-environmentalist MehEnvironmentalist))

     =>

     (assert (UI-state (display PubertyQuestion)
                       (relation-asserted puberty-suck)
                       (response Yes)
                       (valid-answers Yes WasntBadPuberty))))


  (defrule determine-visit-UK ""

     (logical (puberty-suck WasntBadPuberty))

     =>

     (assert (UI-state (display VisitUKQuestion)
                       (relation-asserted visit-UK)
                       (response CircusUK)
                       (valid-answers CircusUK CountrysideUK))))


  (defrule determine-visit-countryside ""

     (logical (visit-UK CountrysideUK))

     =>

     (assert (UI-state (display CountrysideUK)
                       (relation-asserted countryside-type)
                       (response Castle)
                       (valid-answers Castle Battlefield))))


(defrule ginger-snaps ""

   (logical (puberty-suck Yes))

   =>

   (assert (UI-state (display GingerSnaps)
                     (state final))))


(defrule wolfen ""

   (logical (is-environmentalist EveryDayEnvironmentalist))

   =>

   (assert (UI-state (display Wolfen)
                     (state final))))


(defrule american-werewolf ""

   (logical (visit-UK CircusUK))

   =>

   (assert (UI-state (display AmericanWerewolf)
                     (state final))))


 (defrule wolf-man ""

    (logical (countryside-type Castle))

    =>

    (assert (UI-state (display WolfMan)
                      (state final))))


(defrule dog-soldiers ""

   (logical (countryside-type Battlefield))

   =>

   (assert (UI-state (display DogSoldiers)
                     (state final))))


(defrule determine-worried-of-intelligence ""

   (logical (hair-feelings DogsAreCool))

   =>

   (assert (UI-state (display HigherIntelligenceQuestion)
                     (relation-asserted intelligence-worried)
                     (response NotWorriedAboutIntelligence)
                     (valid-answers NotWorriedAboutIntelligence DefinitelyWorriedAboutIntelligence))))


(defrule determine-specifically-worried ""

   (logical (intelligence-worried NotWorriedAboutIntelligence))

   =>

   (assert (UI-state (display SpecificallyMostWorried)
                     (relation-asserted specifically-worried-of)
                     (response OfPeopleInSweaters)
                     (valid-answers OfPeopleInSweaters OfPeopleHalloween OfHockeyTeam AboutTexans OfMovieNerds OfChildren))))


(defrule nightmare-on-elm-street ""

   (logical (specifically-worried-of OfPeopleInSweaters))

   =>

   (assert (UI-state (display NightmareOnElmStreet)
                     (state final))))


(defrule halloween ""

   (logical (specifically-worried-of OfPeopleHalloween))

   =>

   (assert (UI-state (display Halloween)
                     (state final))))


(defrule friday-the-13th ""

   (logical (specifically-worried-of OfHockeyTeam))

   =>

   (assert (UI-state (display Friday13)
                     (state final))))


(defrule texans-chainsaw ""

   (logical (specifically-worried-of AboutTexans))

   =>

   (assert (UI-state (display TexasChainsaw)
                     (state final))))


(defrule scream ""

   (logical (specifically-worried-of OfMovieNerds))

   =>

   (assert (UI-state (display Scream)
                     (state final))))


(defrule seepaway-camp ""

   (logical (specifically-worried-of OfChildren))

   =>

   (assert (UI-state (display Sleepaway)
                     (state final))))


 (defrule determine-specifically-worried-of-intelligence ""

    (logical (intelligence-worried DefinitelyWorriedAboutIntelligence))

    =>

    (assert (UI-state (display DefinitelyWorriedAboutIntelligence)
                      (relation-asserted intelligence-worried-specifically-of)
                      (response FromAnotherPlanet)
                      (valid-answers FromAnotherPlanet WorkingInLab))))


 (defrule determine-circus-scare ""

    (logical (intelligence-worried-specifically-of FromAnotherPlanet))

    =>

    (assert (UI-state (display DoesCircusScareYouQuestion)
                      (relation-asserted circus-scary)
                      (response WhereClownLive)
                      (valid-answers WhereClownLive NotReally))))


(defrule killer-klowns ""

   (logical (circus-scary WhereClownLive))

   =>

   (assert (UI-state (display KillerKlowns)
                     (state final))))


(defrule alien ""

   (logical (circus-scary NotReally))

   =>

   (assert (UI-state (display Alien)
                     (state final))))

(defrule determine-afraid-of-insects ""

    (logical (intelligence-worried-specifically-of WorkingInLab))

    =>

    (assert (UI-state (display AfraidOffInsectsQuestion)
                      (relation-asserted insects-afraid)
                      (response HateThem)
                      (valid-answers HateThem ThingsISwat))))


 (defrule determine-scared-of-sex-with-heads ""

    (logical (insects-afraid ThingsISwat))

    =>

    (assert (UI-state (display SexWithSeveredHeads)
                      (relation-asserted sex-severed-head)
                      (response SeeingPeople)
                      (valid-answers SeeingPeople TalkingAboutCorpses))))


(defrule re-animator ""

   (logical (sex-severed-head SeeingPeople))

   =>

   (assert (UI-state (display ReAnimator)
                     (state final))))


(defrule frankenstein ""

   (logical (sex-severed-head TalkingAboutCorpses))

   =>

   (assert (UI-state (display Frankenstein)
                     (state final))))


(defrule the-fly ""

   (logical (insects-afraid HateThem))

   =>

   (assert (UI-state (display TheFly)
                     (state final))))


(defrule determine-how-legs-scare-the-most ""

   (logical (frightened-of ThingsThatCrawl))

   =>

   (assert (UI-state (display HowManyLegsQuestion)
                     (relation-asserted how-many-legs)
                     (response Eight)
                     (valid-answers Eight Six Other))))


(defrule them ""

   (logical (how-many-legs Six))

   =>

   (assert (UI-state (display Them)
                     (state final))))


(defrule them ""

   (logical (how-many-legs Other))

   =>

   (assert (UI-state (display HumanCentipede)
                     (state final))))


(defrule determine-film-starring-members ""

   (logical (how-many-legs Eight))

   =>

   (assert (UI-state (display PreferFilmsMembers)
                     (relation-asserted prefer-film-members)
                     (response CatsOfStartTrek)
                     (valid-answers CatsOfStartTrek CastOfRoseanne))))


(defrule kingdom-of-spiders ""

   (logical (prefer-film-members CatsOfStartTrek))

   =>

   (assert (UI-state (display KingdomOfSpiders)
                     (state final))))


(defrule arachnophobia ""

   (logical (prefer-film-members CastOfRoseanne))

   =>

   (assert (UI-state (display Arachnophobia)
                     (state final))))


(defrule determine-like-children ""

   (logical (frightened-of DontCare))

   =>

   (assert (UI-state (display PreferFilmsMembers)
                     (relation-asserted like-children)
                     (response No)
                     (valid-answers No LoveBuggers))))


(defrule haxan ""

   (logical (like-children No))

   =>

   (assert (UI-state (display Haxan)
                     (state final))))


(defrule determine-like-buggers-when ""

   (logical (like-children LoveBuggers))

   =>

   (assert (UI-state (display LoveBuggers)
                     (relation-asserted love-buggers-when)
                     (response Babies)
                     (valid-answers Babies InGradleSchool))))


(defrule resemery-baby ""

   (logical (love-buggers-when Babies))

   =>

   (assert (UI-state (display RosemeryBaby)
                     (state final))))


(defrule determine-want-to-eat-pea-soup ""

   (logical (love-buggers-when InGradleSchool))

   =>

   (assert (UI-state (display WantToEatPeaSoupAgain)
                     (relation-asserted want-to-eat-pea-soup)
                     (response WhoCares)
                     (valid-answers WhoCares LovePeaSoup))))


(defrule omen ""

   (logical (want-to-eat-pea-soup LovePeaSoup))

   =>

   (assert (UI-state (display Omen)
                     (state final))))


(defrule exorcist ""

   (logical (want-to-eat-pea-soup WhoCares))

   =>

   (assert (UI-state (display Exorcist)
                     (state final))))


(defrule determine-care-about-body ""

   (logical (frightened-of FrightenedOfDead))

   =>

   (assert (UI-state (display CareAboutBodyQuestion)
                     (relation-asserted care-about-body)
                     (response WithoutBodyScarier)
                     (valid-answers WithoutBodyScarier EatBrains))))


(defrule determine-george-scott-protect-you ""

   (logical (care-about-body WithoutBodyScarier))

   =>

   (assert (UI-state (display ScottProtectYou)
                     (relation-asserted george-scott-protect)
                     (response No)
                     (valid-answers No Yes))))


(defrule poltergeist ""

   (logical ( george-scott-protect No))

   =>

   (assert (UI-state (display Poltergeist)
                     (state final))))


(defrule changeling ""

   (logical ( george-scott-protect Yes))

   =>

   (assert (UI-state (display Changeling)
                     (state final))))


(defrule determine-dogs-look-up ""

   (logical (care-about-body EatBrains))

   =>

   (assert (UI-state (display CanDogsLookUpQuestion)
                     (relation-asserted dogs-look-up)
                     (response Yes)
                     (valid-answers Yes GoToMall))))


(defrule shaun-of-dead ""

   (logical (dogs-look-up Yes))

   =>

   (assert (UI-state (display ShaunOfDead)
                     (state final))))


(defrule dawn-of-dead ""

   (logical (dogs-look-up GoToMall))

   =>

   (assert (UI-state (display DawnOdDead)
                     (state final))))


(defrule determine-chris-lee ""

   (logical (frightened-of AfraidOfBitBoth))

   =>

   (assert (UI-state (display ChristopherLee)
                     (relation-asserted christopher-lee)
                     (response Legend)
                     (valid-answers Legend PlayedCountDooku))))


(defrule determine-prefer-vampires ""

   (logical (christopher-lee PlayedCountDooku))

   =>

   (assert (UI-state (display PreferVampires)
                     (relation-asserted prefer-vampires)
                     (response Silent)
                     (valid-answers Silent EasternEurope WithBigBeehive))))


(defrule nosferatu ""

   (logical (prefer-vampires Silent))

   =>

   (assert (UI-state (display Nosferatu)
                     (state final))))


(defrule nosferatu ""

   (logical (prefer-vampires Silent))

   =>

   (assert (UI-state (display Nosferatu)
                     (state final))))


(defrule dracula1931 ""

   (logical (prefer-vampires EasternEurope))

   =>

   (assert (UI-state (display Dracula31)
                     (state final))))


(defrule dracula1992 ""

   (logical (prefer-vampires WithBigBeehive))

   =>

   (assert (UI-state (display Dracula92)
                     (state final))))


(defrule determine-like-hippies ""

   (logical (christopher-lee Legend))

   =>

   (assert (UI-state (display LikeHippiesQuestion)
                     (relation-asserted like-hippies)
                     (response No)
                     (valid-answers No RealTerror))))


(defrule dracula1972 ""

   (logical (like-hippies No))

   =>

   (assert (UI-state (display Dracula72)
                     (state final))))


(defrule horror-of-dracula ""

   (logical (like-hippies RealTerror))

   =>

   (assert (UI-state (display HorrorDracula)
                     (state final))))


;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
