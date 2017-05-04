module Cards where

import Model
import Util (shuffle, times)


-- Flame
dragon :: Card
dragon = Card "Dragon" "Hurt for 11" "dragon/dragon.svg" "dagger.wav" eff
  where
    eff :: CardEff
    eff p m = hurt 11 (other p) m


firestorm :: Card
firestorm = Card "Firestorm" "Hurt for 5 for each card to the right" "dragon/fire-ray.svg" "fireball.wav" eff
  where
    eff :: CardEff
    eff p m = hurt (5 * (length . getStack $ m)) (other p) m


offering :: Card
offering = Card "Offering" "Hurt yourself for 8, then draw two cards" "dragon/heartburn.svg" "offering.wav" eff
  where
    eff :: CardEff
    eff p m = (drawCard p) . (drawCard p) . (hurt 8 p) $ m


haze :: Card
haze = Card "Haze" "Shuffle the order of cards to the right" "dragon/heat-haze.svg" "confound.wav" eff
  where
    eff :: CardEff
    eff _ m = modStack (\s -> shuffle s (getGen m)) m


-- Thunder
stag :: Card
stag = Card "Stag" "Hurt for 10" "stag/stag.svg" "hammer.wav" eff
  where
    eff :: CardEff
    eff p m = hurt 10 (other p) m


lightning :: Card
lightning = Card "Lightning" "Hurt for 4 for each card to the right" "stag/lightning-trio.svg" "lightning.wav" eff
  where
    eff :: CardEff
    eff p m = hurt (4 * (length . getStack $ m)) (other p) m


hubris :: Card
hubris = Card "Hubris" "Negate all cards to the right" "stag/tower-fall.svg" "hubris.wav" eff
  where
    eff :: CardEff
    eff _ m = setStack [] m


echo :: Card
echo = Card "Echo" "The next card to the right's effect happens twice" "stag/echo-ripples.svg" "echo.wav" eff
  where
    eff :: CardEff
    eff _ m = modStackHead
      (\(StackCard which (Card name desc pic sfx e)) ->
        StackCard which (Card name desc pic sfx (\w -> (e w) . (e w))))
      m


-- Frost
gem :: Card
gem = Card "Powergem" "Hurt for 9" "gem/gem.svg" "axe.mp3" eff
  where
    eff :: CardEff
    eff p m = hurt 9 (other p) m


blizzard :: Card
blizzard = Card "Blizzard" "Hurt the weakest player for 15" "gem/ice-spear.svg" "frostbite.mp3" eff
  where
    eff :: CardEff
    eff _ m
      | getLife PlayerA m < getLife PlayerB m =
        hurt dmg PlayerA $ m
      | getLife PlayerA m > getLife PlayerB m =
        hurt dmg PlayerB $ m
      | otherwise =
        (hurt dmg PlayerA) . (hurt dmg PlayerB) $ m
    dmg = 15


crystal :: Card
crystal = Card "Crystal" "Heal the weakest player for 15" "gem/crystal-growth.svg" "oath.wav" eff
  where
    eff :: CardEff
    eff _ m
      | getLife PlayerA m < getLife PlayerB m =
        heal mag PlayerA $ m
      | getLife PlayerA m > getLife PlayerB m =
        heal mag PlayerB $ m
      | otherwise =
        (heal mag PlayerA) . (heal mag PlayerB) $ m
    mag = 15


alchemy :: Card
alchemy = Card "Alchemy" "The next card to the right's effect becomes: draw 2 cards" "gem/alchemy.svg" "feint.wav" eff
  where
    eff :: CardEff
    eff _ m = modStackHead (\(StackCard w _) -> StackCard w c) m
    c :: Card
    c = Card "Gold" "Draw 2 cards" "gem/gold.svg" "feint.wav" (\p -> (drawCard p) . (drawCard p))


-- Tempest
octopus :: Card
octopus = Card "Octopus" "Lifesteal for 8" "octopus/octopus.svg" "bite.wav" eff
  where
    eff :: CardEff
    eff p m = lifesteal 8 (other p) m


tentacles :: Card
tentacles = Card "Tentacles" "Lifesteal for 4 for each card to the right" "octopus/tentacle-strike.svg" "succubus.wav" eff
  where
    eff :: CardEff
    eff p m = lifesteal (4 * (length . getStack $ m)) (other p) m


siren :: Card
siren = Card "Siren" "Your opponent gets two cards that hurt them for 8 each" "octopus/mermaid.svg" "siren.wav" eff
  where
    eff :: CardEff
    eff p m = modHand (times 2 ((:) cardSong)) (other p) m
    cardSong :: Card
    cardSong = Card "Siren's Song" "Hurt yourself for 8" "octopus/love-song.svg" "song.wav" (hurt 8)


reversal :: Card
reversal = Card "Reversal" "Reverse the order of cards to the right" "octopus/pocket-watch.svg" "reversal.wav" eff
  where
    eff :: CardEff
    eff _ m = modStack reverse m


-- Mist
monkey :: Card
monkey = Card "Monkey" "Hurt for 7" "monkey/monkey.svg" "shuriken.wav" eff
  where
    eff :: CardEff
    eff p m = hurt 7 (other p) m

monsoon :: Card
monsoon = Card "Monsoon" "Hurt for 3 for each card in your hand" "monkey/heavy-rain.svg" "superego.wav" eff
  where
    eff :: CardEff
    eff p m = hurt (3 * (length . (getHand p) $ m)) (other p) m


mindgate :: Card
mindgate = Card "Mindgate" "Your hand becomes the same as your opponent's" "monkey/magic-portal.svg" "mindgate.wav" eff
  where
    eff :: CardEff
    eff p m = setHand (getHand (other p) m) p m


feint :: Card
feint = Card "Feint" "Return all of your cards to the right to your hand" "monkey/quick-slash.svg" "feint.wav" eff
  where
    eff :: CardEff
    eff p m =
      (modHand (bounceAll p (getStack m)) p) $
        modStack (filter (\(StackCard owner _) -> owner /= p)) m


-- Vortex
owl :: Card
owl = Card "Owl" "Hurt for 6" "owl/owl.svg" "staff.wav" eff
  where
    eff :: CardEff
    eff p m = hurt 6 (other p) m


twister :: Card
twister = Card "Twister" "Hurt for 3 for each card in your opponent's hand" "owl/tornado.svg" "envy.wav" eff
  where
    eff :: CardEff
    eff p m = hurt (3 * (length . (getHand (other p)) $ m)) (other p) m


hypnosis :: Card
hypnosis = Card "Hypnosis" "Obscure your opponent's hand" "owl/vortex.svg" "mindhack.wav" eff
  where
    eff :: CardEff
    eff p m = modHand (fmap obs) (other p) m
    obs :: Card -> Card
    obs card = Card "???" "An obscured card" "owl/sight-disabled.svg" "resolve.wav" (\p -> modStack ((:) (StackCard p card)))


prophecy :: Card
prophecy = Card "Prophecy" "Return all cards to the right to their owner's hand" "owl/star-pupil.svg" "precognition.wav" eff
  where
    eff :: CardEff
    eff _ m =
      (modHand (bounceAll PlayerA (getStack m)) PlayerA) .
        (modHand (bounceAll PlayerB (getStack m)) PlayerB) $
          setStack [] m


-- Calm
turtle :: Card
turtle = Card "Turtle" "Hurt for 5" "turtle/turtle.svg" "crossbow.wav" eff
  where
    eff :: CardEff
    eff p m = hurt 5 (other p) m

gust :: Card
gust = Card "Gust" "Hurt for 3, return this card to your hand" "turtle/fluffy-cloud.svg" "boomerang.wav" eff
  where
    eff :: CardEff
    eff p m = modHand ((:) gust) p (hurt 3 (other p) m)


soup :: Card
soup = Card "Soup" "Heal for 10" "turtle/soup.svg" "potion.wav" eff
  where
    eff :: CardEff
    eff p m = heal 10 p m


reflect :: Card
reflect = Card "Reflect" "All cards to the right change owner" "turtle/shield-reflect.svg" "reflect.wav" eff
  where
    eff :: CardEff
    eff _ m = modStackAll reflectEff m
    reflectEff :: StackCard -> StackCard
    reflectEff (StackCard owner card) =
      StackCard (other owner) card
