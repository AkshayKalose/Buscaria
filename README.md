# ¡Buscaría!
---
## Get Started

Chat 'help' at [¡Buscaría!](https://www.messenger.com/t/buscaria)

## Inspiration

Learning a language is hard, and keeping up language skills is nearly as hard. Sometimes work gets in the way, and at other times there just isn?t anyone else around that knows the language. That?s where ¡Buscaría! can help! By connecting people who want to learn a language to those who are willing to teach others through messenger, we help people maintain and develop language skills in a convenient and interpersonal way.

## What it does

¡Buscaría! determines the languages that a person is willing to teach and wants to learn, recording the proficiency of the user at each language. Next, the user who wishes to learn a language is anonymously connected to another user who wishes to teach the language and has a greater proficiency in the language. After conversing for some time, either user can choose to end the interaction, at which point both users have the opportunity to rate the interaction. We keep track of a user?s ?karma points? to make sure that there are no free riders--learn too many times without teaching anyone else, and you?ll find yourself out of karma! Users can also gain karma through positive ratings. 

## How we built it

¡Buscaría! is built on the Facebook Messenger platform, which enables users to have quick and easy access to the platform. Using the Facebook Developer API, we built a Messenger chatbot, allowing users to interact with the service by messaging the ¡Buscaría! facebook page. The backend server is written using Ruby on Rails, and it is hosted on Linode. 

## Challenges we ran into

We were faced with many choices of what technology to use for various pieces of functionality, and each offered its own positives and negatives. We settled with Ruby on Rails due to its combination of extendability and intuitiveness, though we definitely faced a few problems in setting up the server. Messenger offered a few obstacles in that it was hard to communicate properly with facebook at first, as well as with redirecting messages from one user to another. Further challenges we faced involved redirecting not only text, but also a variety of multimedia, such as photos, video, audio, and emojis! Some of us did not have much prior programming experience, and had to learn the Ruby language from scratch, and setting up a reliable online server with functioning handshakes was a new challenge.

## Accomplishments that we're proud of

Most of the members of the team had never used Ruby before, let alone Ruby on Rails. In addition, most members of this team had never programmed a chatbot before. We?re proud to have developed our technical skills, but more importantly we believe we have built a product that can truly be useful to many people around the world, perhaps after making a few more tweaks. 

## What we learned

Ruby, Ruby on Rails framework, Facebook Messenger API, server setup on Linode

## What's next for ¡Buscaría!

We hope to build a user base by first sharing this app on our social media networks, then potentially connecting with the Stanford Language Center when we have made the app a bit more polished. In terms of features, we hope to further flesh out the pairing of student and teacher, in particular taking into account how often the teacher has been willing to help in the past, and also building on the ratings received by both student and teacher over an extended period of time. In addition, we hope to add live video and group chat features to the community, and we also wish to let users invite their friends to use the app through a phone number. 
