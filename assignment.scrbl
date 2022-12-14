#lang scribble/manual
@require[scribble-math]
@require[scribble-math/dollar]
@require[racket/runtime-path]

@require["../../lib.rkt"]
@define-runtime-path[hw-file "hw3.rkt"]

@title[#:tag "hw3" #:style (with-html5 manual-doc-style)]{Homework 3}

@bold{Released:} @italic{Wednesday, January 25, 2023 at 6:00pm}

@bold{Due:} @italic{Wednesday, February 1, 2023 at 6:00pm}


@nested[#:style "boxed"]{
What to Download:

@url{https://github.com/logiccomp/s23-hw3/raw/main/hw3.rkt}
}

Please start with this file, filling in where appropriate, and submit your homework to the @tt{HW3} assignment on Gradescope. This page has additional information, and allows us to format things nicely.

@bold{NOTE: You need to update ISL-Spec to complete this assignment. You will get errors related to the third problem if you do not.} Go to File->Install Package, type in "isl-spec" and click "Update".

@section{Problem 1}

Cryptography, or the science of secret communication, is about as old as math itself. Modern cryptography
was born alongside with computers, as during WWII, information was sent over radio and secure communication
was critical. Machines were used in what became an arms race, where  more sophisticated codes were 
developed using complex machinery, and at the same time, some of the earliest "computers" were 
created in order to break them.

One of the first, and most important, cryptanalysis (code breaking) results was done by teams at Bletchley Park, a British estate that housed one of the first machines that could conceivably be called the computer. While many were involved in the effort, including a team of Polish mathematicians, a key figure in the effort was a British mathematician and one of the pioneers of the entire field of computer science named Alan Turing. For his contributions to this early work on computation, and many other things, the highest award in computer science (our "Nobel Prize") is named the Turing award. 

Despite his critical role in the effort, and ground breaking work for the field
as a whole, Turing was prosecuted for homosexuality after the war, and died by apparent suicide a few years later at the age of only 41. More than a half century later, the British Government appologized for 
his treatment and officially pardoned him.

Much of cryptanalysis relies upon detecting patterns, and indeed, the ability to do that at scale was 
exactly how the Bletchley Park team was able to use machines to break the German Enigma. 

"Perfect encryption" via so-called one-time pads, or the other hand, has no patterns, and thus is not vulnerable to that type of analysis, even in theory. It is, in effect, unbreakable. It relies, 
on the other hand, on a secret key, shared beforehand, that is as long as the message itself, which aside from limited
cases, is difficult to imagine (the "Red Telephone" in movies between the US and USSR is fiction, but keys to enable this form
of encryption were exchanged via embassies). Most modern cryptography, on the other hand, relies upon being able to negotiate
secure communication between parties that have never interacted before (you and an online shopping website, for example).

One-time pads, however, still do have value, in that they are 
provably impossible to break, and we will show why that is in this problem. Further, most realistic
cryptosystems, while much more complex, share elements with this incredibly simple one.

First, we will define types for bits, messages (of fixed length of six bits), and keys (of fixed length of six 
bits). In a realistic setting, we could translate text into bits (each letter getting a unique assignment of bits), and split our message into chunks of length six. We define generators for @code{Bit} and @code{Message}. 

@minted-file-part["racket" "p1a" hw-file]

The way one-time pads work is via exclusive-or (XOR). To both encrypt and decrypt, we XOR each bit in the message with a corresponding bit in the key. This should result in an encrypted message for which it is impossible to determine the original without knowing the key. We want to 
prove that, and we'll do it in the following way. First, we define encryption and decryption, which 
use the key (which is the same length of the message), XOR'd bit by bit with the message:

@minted-file-part["racket" "p1b" hw-file]

Your task is to define the following property, that captures the fact that encrypt/decrypt result in 
perfect secrecy. It should state 
that for a given encrypted message, for any possible original message, there exists some key 
that would have produced it. That means that without knowing something about the key, there is no 
way of knowing which message was encrypted, since for any message, some key could have produced the 
encrypted message. Note that we don't have a @italic{logical} exists (@${\exists}), but if you can compute such a 
key, that is essentially the same thing (to be more technical, it's very close to an existential in @italic{constructive} logic). To show that you have, indeed, computed the right key, 
your property should finally use it to decrypt the message.

@minted-file-part["racket" "p1c" hw-file]

@section{Problem 2}
Many cities have a problem with landlords who own many properties but do not adequately 
maintain them. In some,
there are people who have begun organizing "tenants unions" to combat this, 
and an important way they 
can work is to organize together between buildings that are owned by the same landlord. 

For a landlord with hundreds of properties, a single building threatening to withhold rent is 
perhaps easily ignored or addressed with evictions, but if many buildings do it, such "rent strikes" become a much bigger problem.
For the organizers, identifying such landlords can be difficult, since the buildings are often owned by shell companies in order to hide true ownership (1 Main St might be owned by "1 Main St LLC").

One way to identify these landlords is to look at the addresses
for company registrations, as while creating companies to own buildings is usually relatively easy, 
organizing them usually requires having centralized management, and thus, the same business address for all the shell companies. 

@minted-file-part["racket" "p2a" hw-file]

Your task is to write a correctness spec for the function @code{find-landlords} that
takes a list of TaxRecords and a list of BuildingOwners, and
computes a list of OwnerAssets, merging differently named BuildingOwners
that share an address. The function will combine the total value of all the buildings
owned by the owners that share the same company registration address, storing that total dollar amount,
along with the company registration address, in the OwnerAssets.

The spec should capture properties that relate
the output of @code{find-landlords} (which you do not have to implement, though
are welcome to) with the inputs. Think about how to ensure that
any implementation of @code{find-landlords} that satisfies your spec does
the right thing. You might want to think about the relationship of money between the input and 
the output, about how to ensure duplication hasn't happened, how to ensure properties were combined 
properly, etc. 

@minted-file-part["racket" "p2b" hw-file]


@section{Problem 3}
One key source of cybersecurity vulnerabilities are "timing attacks", which work by measuring
how long a particular computation takes. If the computation takes different amount of time based 
on different secret values, the attacker may be able to learn information about those secrets.

In this problem, we'll consider one of the classic examples of this: matching passwords. 

Since recording precise timing can be tricky (and may require collecting many samples), we'll 
simulate the timing by using a fake clock that we move forward with a @code{tick!} function,
and define versions of functions that call this explicitly.

You @italic{must} use these functions if you need their functionality, rather than built-in versions (or re-implementing them without the calls to @code{tick!}), as the built-in versions are fast enough
that without significant sampling, the timing results we would get (using, e.g., a call to get the 
current clock time before and after a function runs) won't be consistent. Note that in real attacks,
extremely small differences of timing are enough (as statistically they become significant), so this constraint exists only to make the 
assignment straightforward. 

@minted-file-part["racket" "p3a" hw-file]

You've been given a function @code{check-password} that takes as input
a list of characters (as strings) and checks in against a password (stored as a constant). It 
does it by using a @code{list=?} helper that calls the @code{tick-string=?} function on each letter. 

@minted-file-part["racket" "p3b" hw-file]

You have two tasks. First, you need to write a specification that ensures that @code{check-password}
does not leak @italic{timing} information. For this, you should use the @code{start-timer!}
function, provided by ISL-Spec, to reset the simulated clock before calling @code{check-password}, and
then call @code{get-timer!} to get the clock value (a natural number) after the call. You should do
this for two passwords, and ensure that each takes exactly the same number of ticks.

@minted-file-part["racket" "p3c" hw-file]

Once you have that spec, you should find that the implementation of @code{check-password} is indeed 
leaking timing information. An attacker could use that to guess the password, as the current 
implementation stops as soon as it finds a character that doesn't match, so they could try passwords 
starting with "a", then "b", etc, until they found one that took a little longer: this would mean 
they discovered the first letter. Then they would continue with the second, etc. You can try this 
out (but don't have to) by trying @code{check-password} with passwords that are longer and longer 
prefixes of the actual password.

Your next task is to go back and fix the implementation of @code{check-password} to not reveal that information.

There may be multiple ways to do this; the only requirement is that it no longer fails your timing 
specification, and you are not allowed to use either @code{string=?} or @code{length} (or to 
re-implement) them yourself, but rather must use the provided versions that invoke @code{tick!}. Similarly, you cannot use @code{equal?} as a way around using @code{tick-string=?}. Failure to follow
those instructions will result in a 0 on this part of the problem. Note that you @italic{can} have
your functions call @code{tick!} themselves, in order to balance out the cost of other calls. This 
may correspond to doing pointless work, which is indeed an important element of this type of security!