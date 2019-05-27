:tocdepth: 1

.. _article_35:

Assange: Computer Intrusion
===========================

.. container:: center

    by :ref:`brant`

    2019-05-27

The United States Department of Justice has officially charged Julian Assange
with "conspiracy to commit computer intrusion". In essence it alleges that he
agreed to break the password to a government computer system, specifically
SPIRNet (Secret Internet Protocol Network).

Either one of two things is at play here. Either the charges are completely and
utterly fabricated because the Justice Department has a bone to pick with
Assange, or our security systems are so woefully inadequate that it's probably
being hacked on a near constant basis by other countries intelligence agencies.
I'm going to assume it's the former because the alternative make the United
States look so utterly inept that I wouldn't even know how to analyze the
problem.

It's easy though to just *say* something akin to "As a computer scientist, I can
tell you that the charges are likely to be fabricated". And you'd either have to
trust me or not trust me and that would probably depend a lot more on your own
existing feelings about the case more than it would anything else. A more fun
(for me anyway) approach is to explain exactly HOW some of these systems work
and exactly WHY the charges appear to be so superficially fabricated.

.. warning:: Technical stuffs ahead

Hashing
-------

To first understand how password systems generally work one first needs to
understand the concept of a **hash** function. Hash functions are simply one way
mathematical operations that result in a fixed size output regardless of input
size.

============  ============================================
   Input                                            Output
============  ============================================
foo           ``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33``
pumpkin       ``5f13610453fd0dabebe3d680e0b2990619bf138c``
rty567        ``bf852edfe746e92eb511d724b126292d65d3cd8d``
longpassword  ``07f0a6c13923fc3b5f0c57ffa2d29b715eb80d71``
============  ============================================

In fact, even an input longer than the output yields a fixed lenth result:

``asfdasf07f0aasddsf6c13923fc3bsadfdsaf5f0c57ffa2d29b715eb8sfsda0d71``

becomes

``eca85ee20d13f61559ab3321bd21bf1f8a3f7260``

There are two important features of a hash function. The first we already
noted—the output must always be a fixed length regardless of the input, and
second—that it's a lossy conversion and cannot be reversed. This is the
"one-way" aspect of them. You can convert any input to a hash value but you
cannot convert a hash back into the input value. There are complicated and cool
reasons mathematical reasons this is possible but the important thing to
understand is just that you can't go back. You cannot derive an input value from
the output value.

Storing Passwords
-----------------
When creating a password system, there is usually a place somewhere where the
information necessary to check a password is stored. Contrary to what might
seem to be the case, password systems don't store your password anywhere. They
instead store the *hash*.

It will usually store a map of a username to a hash value.

============  ============================================
  Username                                          Output
============  ============================================
jane          ``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33``
chris         ``5f13610453fd0dabebe3d680e0b2990619bf138c``
fred          ``bf852edfe746e92eb511d724b126292d65d3cd8d``
ayshe         ``07f0a6c13923fc3b5f0c57ffa2d29b715eb80d71``
============  ============================================

Then when you login, it takes the password you provided, calculates it's hash
value and then checks it's table of usernames and hashes. So if ``jane`` tries
to login and enters the password ``foo``, the system hashes the password which
results in ``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33`` and it's the hash value
that is checked against. If the hash of the provided password matches the hash
that is stored in the system, then the user is authenticated and all is well. If
it is not, then the login attempt is rejected.

*WHY* is this mechanism used rather than storing the passwords? Imagine that
someone has deep access to a system, is a spy or disgruntled, and steals the
data. They now have usernames and password hashes. They don't have the actual
password! Remember that you cannot derive the input for a given hash. It's a
one-way operation. So even if they steal the usernames and password hashes,
they couldn't use that information to login. This means the system can remain
secure even if the data gets stolen.

Salting
-------

If you've been reading this you might have seen an obvious loophole in the
security mentioned in the previous section. A lot of people use the same
passwords, or common combinations. What if someone pre-calculated a bunch of
hash values for common passwords? If this happened then if they somehow breached
a system and stole the usernames and password hashes, they could then check the
hashes against the list of pre-computed values. If there were any matches then
they would be able to tell what password could be used to login to that system.

If they compute that the value ``foo`` becomes
``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33`` and then they see that the hash
value ``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33`` is the hash associated with
the user ``jane`` then they would know that Jane's password is ``foo``. This is
bad and means that with a lot of effort someone could—in theory—reverse the hash
just pre-computing tons of potential values. It will still be hard if the users
have chosen good passwords, but it is within the realm of possible.

That is why password systems also use a tool called "salting". Salt comes in
various flavors but the general idea is this. Append a value to every password
so that pre-computed values are useless.

For example if you set a systems salt to ``0xdeadbeef`` then instead of the
password ``foo``, the password becomes ``foo0xdeadbeef``. The hash value of
``foo`` is ``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33``, but the hash value
of ``foo0xdeadbeef`` is ``6c0ef9d96864de01773a116c83acc9af7bf8c4e1`` which is
totally different. The system just adds a bit of spice to the passwords it's
setting and using. That means pre-computed values are useless. Someone could
spend a year computing hash tables for millions of common passwords, but none
of them would match if the system was also salting it's passwords.

Typically each computer system uses a unique salt. That means that you can't
pre-compute values for a known salt because every single system is going to be
storing a different hash value for the same password. Cheating via
pre-computing eliminated!

Multi-Hashing
-------------
Suppose though that even if you've made a good system that adequately is
hashing and salting passwords, someone really wants to try to reverse a salted
hash. They're a state-level entity with nearly unlimited resources so they try
calculating all hashes for common passwords PLUS common salts. They can spend
3 years pre-computing all of these values because they've got millions of
dollars to throw at the problem. How to you ensure that even a well funded
intelligence agency can't crack your hashes if they somehow get stolen?

The solution comes simply by yet again expanding the space of possible
hashes for the same password. You do this by calculating the hash of the hash
as if it were a password too.

For example:

Password: ``foo``
Salt: ``0xdeadbeef``

Recall from the previous section that the hash of ``foo0xdeadbeef``
is ``6c0ef9d96864de01773a116c83acc9af7bf8c4e1``\ . Well, what happens if you
compute the hash of ``6c0ef9d96864de01773a116c83acc9af7bf8c4e1``\ ? You
get: ``d143f739ab54cd5fb40b08695ef44c659882914e``. What if you calculate the
hash of that? You get: ``f5454aa7490de7d10c488d73c7f13926e6916f5e``. And so on.

The last ingredient here is to keep taking the resulting hash and feeding it
back into the hash function, *n* number of times. By selecting a high but
random number for your system, you end up with hash values that are extremely
unique. Maybe you select 2199. That means you'll keep hashing the result of the
previous iteration that many times.

There is another advantage to multi-hashing besides expanding the uniqueness of
the hash values. Suppose you've a very fast computer and it can calculate 1000
hashes per second. That's quite fine if you're trying to figure out a hash
value in a single iteration. But if it takes 2199 iterations to calculate one
hash then your computer has slowed from 1000 tries per second to two seconds per
try. The amount of computation required to do the hashing explodes tremendously.
This has the effect of raising the cost even further. By the time you've
selected a good hash function, salted the hash, and applied multi-hashing, then
the amount of combinations to try explodes to well more than the number of atoms
in the known universe. It would take all the computers on the planet working
together the lifetime of the universe several times over to compute all the
possibilities.

Conclusion
----------
What does this exactly have to do with Assange? He's being charged with agreeing
to break a password to SPIRNet. The advantage of this is that it would have
allowed impersonation of another user when accessing classified materials.
Chelsea Manning is the former intelligence analyst with whom Assange is said to
have engaged in said conspiracy.

In order to "crack" a password (which is shorthand for taking a hash value and
determining what password was used to generate it) one would need the actual
usernames and hash values. This being the crown jewels of the authentication
system, a very very small select group of persons would have access to this
data. No mere analyst would. An analyst would only have access to login to
SPIRNet to access material related to their work. No doubt Chelsea Manning had
access to classified materials but it would be absurd if she also had access to
the entire authentication systems password hash storage.

Secondly, assuming that they somehow got ahold of this map of usernams to hash
values, if they were properly salted and had multi-hash applied to them then
even with all of the resources of Wikileaks at his disposal, Assange would have
absolutely no chance of cracking said passwords.

When we hear about breaches of security with companies it's usually because they
are using very bad security practices—either storing actual passwords instead
of hash values or storing easily pre-computed hashes that aren't properly
salted or multi-hashed. This happens but it's usually the work of novice
computer professionals, NOT the high level experts tasked with securing
classified intelligence material. If the security were that lax, state-level
intelligence agencies from other countries would long ago have breeched our
systems.
