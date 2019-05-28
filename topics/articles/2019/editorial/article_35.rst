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

One of two things is at play here. Either the charges are completely and utterly
fabricated because the Justice Department has a bone to pick with Assange, or
our security systems are so woefully inadequate that it's probably being hacked
on a near constant basis by other countries' intelligence agencies. I'm going to
assume it's the former because the alternative make the United States look so
utterly inept that I wouldn't even know how to analyze the problem.

It's easy  to *say* "As a computer scientist, I can tell you that the charges
are likely to be fabricated". And you'd either have to trust me or not trust me
and that would probably depend a lot more on your own existing feelings about
the case more than it would anything else. A more fun (for me anyway) approach
is to explain exactly HOW some of these systems work and exactly WHY the charges
appear to be so superficially fabricated. Interestingly all reasonably secure
authentication systems use some permutation of the system I describe here.

.. warning:: Technical jargon ahead


Hashing
-------
To understand how authentication systems work one first needs to understand the
concept of a **hash** function. Hash functions take an input value (perhaps some
text) and output a fixed-length value.

============  ============================================
   Input                                            Output
============  ============================================
foo           ``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33``
pumpkin       ``5f13610453fd0dabebe3d680e0b2990619bf138c``
rty567        ``bf852edfe746e92eb511d724b126292d65d3cd8d``
longpassword  ``07f0a6c13923fc3b5f0c57ffa2d29b715eb80d71``
============  ============================================

Even a very long input value yields a fixed lenth result:

``asfdasf07f0aasddsf6c13923fc3bsadfdsaf5f0c57ffa2d29b715eb8sfsda0d71``

becomes

``eca85ee20d13f61559ab3321bd21bf1f8a3f7260``

There are two important features of a hash function. The first we already
noted—the output must always be a fixed length regardless of the input, and
second—the function cannot be reversed. This makes them "one-way" operations.
You can convert any input to a hash value but you cannot convert a hash back
into the input value. There are complicated and cool mathematical reasons this
is possible but the important thing to understand is that you can't go in
reverse. You cannot derive an input value from the output value.

(add a sign post here, transitional)

Storing Passwords
-----------------
When creating a password system, there is a location where the
information necessary to check a password is stored. Surprisingly though,
authentication systems don't actually store your passwords anywhere; they store
the *hash*.

This normally comes in the form of a mapping between a username and a password
hash value:

============  ============================================
  Username                                            Hash
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

This seems rather convoluted at first glance. Why store hash values instead of
the passwords?

Imagine that someone has deep access to a system, is a spy or disgruntled, and
steals the data. They now have usernames and password hashes, but not the actual
passwords! Remember that you cannot derive the input for a given hash; it's a
one-way operation. So even if someone steals the usernames and password hashes,
they couldn't use that information to login. This means the system can remain
secure even if the data gets stolen.

There is a problem though. What if someone pre-calculated a bunch of hash values
for common passwords? If this happened, they could check the
hashes against the list of pre-computed values and gain access if any matched.

If a hacker computes that the value ``foo`` becomes
``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33`` and then they see that the hash
value ``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33`` is the hash associated with
the user ``jane`` then they would know that Jane's password is ``foo``. This
means that with a lot of effort someone could—in theory—reverse the hash just
pre-computing tons of potential values. It will still be hard if the users have
chosen good passwords, but it is within the realm of possibility.

To combat this, another technique is added to the mixture called "salting".

Salting
-------

Salt comes in various flavors but the general idea is this: Append a value to
every password so that pre-computed values are useless. Each system should use
a unique salt.

For example, if you set a systems salt to ``0xdeadbeef`` then instead of the
password ``foo``, the password becomes ``foo0xdeadbeef``. The hash value of
``foo`` is ``0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33``, but the hash value of
``foo0xdeadbeef`` is ``6c0ef9d96864de01773a116c83acc9af7bf8c4e1`` which is
totally different. The system adds a bit of spice to the passwords it's setting
and using. That means any pre-computed values are useless. Someone could spend a
year computing hash tables for millions of common passwords, but none of them
would match if the system was also salting its passwords.

Typically each authentication system uses it's own unique salt. That means that
you can't pre-compute values for a known salt because every single system is
going to be storing a different hash value for the same password. Cheating via
pre-computing eliminated!

Suppose though that even if you've made a good system that adequately is
hashing and salting passwords, someone really wants to try to reverse a salted
hash. They're a state-level entity with nearly unlimited resources so they try
calculating all hashes for common passwords PLUS common salts. They can spend
3 years pre-computing all of these values because they've got millions of
dollars to throw at the problem. How to you ensure that even a well funded
intelligence agency can't crack your hashes if they somehow get stolen?

Fortunately for the paranoid out there, there is another technique which is used
in conjunction with hashing and salting: Multi-Hashing.

Multi-Hashing
-------------

Multi-Hashing expands the space of possible hashes for a password even further
than merely salting does. It works by calculating the hash of the hash
as if it were a password too, a large number of times.

For example:

Password: ``foo``
Salt: ``0xdeadbeef``

Recall from the previous section that the hash of ``foo0xdeadbeef``
is ``6c0ef9d96864de01773a116c83acc9af7bf8c4e1``\ . Well, what happens if you
compute the hash of ``6c0ef9d96864de01773a116c83acc9af7bf8c4e1``\ ? You
get: ``d143f739ab54cd5fb40b08695ef44c659882914e``. What if you calculate the
hash of that? You get: ``f5454aa7490de7d10c488d73c7f13926e6916f5e``. And so on.

The key ingredient is to keep taking the resulting hash and feeding it back into
the hash function, *n* number of times. By selecting a high but random number
for your system, you end up with hash values that are extremely unique to your
system. Maybe you select 2199. That means you keep hashing the result of the
previous iteration that many times.

There is another advantage to multi-hashing besides expanding the uniqueness of
the hash values. Suppose you've a very fast computer and it can calculate 1000
hashes per second. That's fine if you're trying to figure out a hash
value in a single iteration, but if it takes 2199 iterations to calculate one
hash then your computer has slowed from 1000 tries per second to two seconds per
try. The amount of computation required to do the hashing explodes tremendously.
This has the effect of raising the cost even further; by the time you've
selected a good hash function, salted the hash, and applied multi-hashing, then
the amount of possible combinations explodes to more than the number of atoms
in the known universe. It would take all the computers on the planet working
together the lifetime of the universe several times over to compute all the
possibilities.

Conclusion
----------
What does this exactly have to do with Assange? He's being charged with agreeing
to break a password to SPIRNet (Chelsea Manning is the former intelligence
analyst with whom Assange is said to have engaged in said conspiracy). The
advantage of this is that it would have allowed Manning to impersonate another
user when accessing classified materials which would have made it more difficult
to determine who stole the data.

In order to "crack" a password (which is shorthand for taking a hash value and
determining what password was used to generate it) one would need the actual
usernames and hash values. This being the crown jewels of the authentication
system, a very very small select group of persons would have access to this
data. No mere analyst would. An analyst would only have access to login to
SPIRNet to access material related to their work, and Chelsea Manning likely had
access to classified materials but it would be absurd if she also had access to
the entire authentication system's password-hash storage.

Secondly, assuming that Manning somehow got a hold of this map of usernames-hash
values, if the system were properly salted and had multi-hash applied, then
even with all of the resources of Wikileaks at his disposal, Assange would have
absolutely no chance of cracking said passwords.

When we hear about breaches of security with companies it's usually because they
are using very bad security practices—either storing actual passwords instead
of hash values or storing easily pre-computed hashes that aren't properly
salted or multi-hashed. This happens, but it's usually the work of novice
computer professionals, NOT the high level experts tasked with securing
classified intelligence material. If the security were that lax, state-level
intelligence agencies from other countries would long ago have breeched our
systems.

If the accusations against Assange are true then SPIRNet is a woefully insecure
system. If that's not the case then the charges against Assange must be
fabricated.
