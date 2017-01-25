:tocdepth: 1

.. _prettycli:

Beautiful Command Line Output
=============================

:ref:`brant`
------------
Python has excellent tooling for making highly functional command line
utilities, but misunderstanding them has lead to many inconsistent and
problematic tools. In this article, I'll introduce you to some simple concepts
around command line output and some light programming concepts. You don't need
to know how to code to read this, but having a little bit of experience with
the command line will definitely help!

First Program
-------------
To understand this, you'll have to first learn how to write some code. Open a
file and enter the following **code**::

    print("I'm coding stuff")

Save the file as ``test.py``, then invoke it from the command line using the
Python interpreter—it will print the quoted text to your command prompt::

    $ python test.py
    I'm coding stuff
    $

.. tip:: In examples like this, the ``$`` represents the command prompt. Stuff
    here should be typed out. The other lines are the result of the command.

Standard Out
------------
So, what's happening here? You're invoking ``print``, which actually is writing
to something called *standard out*. The secret is that anything that gets
written to *standard out* is consumed by the terminal and output to your
screen. ``print`` not only writes to *standard out* but it also modifies what
you wrote. It adds a newline (``\n``) to the end of your text. ``print`` is a
nice shortcut for "write something to *standard out* and then add a new line to
that". Let's do something more fancy to show what ``print`` is doing behind the
scenes. Open that ``test.py`` file again, and change it to look like this::

    import sys

    sys.stdout.write("I'm coding stuff")

Now, as before, run it::

    $ python test.py
    I'm coding stuff$

It's almost the same as when you used ``print``, but notice that you're cursor
is still stuck on the same line as **I'm coding stuff** is. That's because we
didn't add a newline character to the end. Open ``test.py`` once more and
change it to look like this::

    import sys

    sys.stdout.write("I'm coding stuff\n")

Now, as before, save then run it::

    $ python test.py
    I'm coding stuff
    $

Voila! Now it works exactly like ``print``. Of course ``sys.stdout.write`` is
a lot more to type, and you have to *import* the module ``sys``. Still, this is
essentially what ``print`` is doing behind the scenes.

Standard Error
--------------
Now an experiment: open ``test.py`` and change ``stdout`` to ``stderr``. The
resulting file should look like this::

    import sys

    sys.stderr.write("I'm coding stuff\n")

Run it once more::

    $ python test.py
    I'm coding stuff
    $

Huh? It does *exactly* the same thing! Or at least it seems to. The reason for
this is that your terminal window (command prompt) is actually watching for
stuff to get written to **two** places. It monitors *standard out* **and**
*standard error*. Things written to *either* location are displayed on the
terminal. This turns out to be very useful, and we'll get to why, but first,
lets do another experiment. Open your old friend ``test.py`` and change it to
look like the following::

    import sys

    sys.stdout.write("I'm coding stuff\n")
    sys.stderr.write("I'm coding stuff\n")

If you save then run this program you get::

    $ python test.py
    I'm coding stuff
    I'm coding stuff
    $

Redirects
---------
Pretty redundant seeming for now. But we have a few tricks up our sleeve. It's
time to break out the handy concept of *redirection*. Here we will use our
favorite standard redirect character: ``>`` Those of you familiar with Posix
compliant systems like BSD or Linux will recognize the meaning of this
character  on the command line. It redirects the output of a command into a
file. Check this out::

    $ python test.py > output.txt
    I'm coding stuff
    $

The first thing you'll notice is that ``I'm coding stuff`` was only written to
your command line once. That's weird because we told it to write it twice;
once to *standard out* and once to *standard error*. Our program didn't change.
What happened is that everything written to *standard out* was written into a
file called ``output.txt``. It doesn't matter that no such file existed before.
The redirect (denoted by the ``>`` character) created that file. If you were to
look, you'd see that a new file was created and the contents of that file are
``I'm coding stuff``.

Getting Fancy
-------------
It's time for a more concrete example. Don't worry about fully understanding
the following code. Our purpose here is to demonstrate some advantages of
having two output locations and the ability to distinguish between them. It's
time to edit ``test.py`` again, but this time we're going to make it really
fancy::

    import sys

    sys.stderr.write("FILE WRITER VERSION 1.0\n")
    sys.stderr.write("-----------------------\n")
    sys.stderr.write("Welcome to a boring program! It's terrible!\n")
    sys.stderr.write("Enter something and press [Enter]: ")
    sys.stderr.flush()      # This just says 'write to the terminal NOW!'
    x = raw_input()         # Read whatever the user inputs and store it in 'x'

    sys.stderr.write("You entered: ")
    sys.stderr.write(x)
    sys.stderr.write("\n")  # Writes a newline after whatever was in 'x'
    sys.stderr.write("Bye loser!\n")
    sys.stderr.flush()      # Same as using flush before
    sys.stdout.write(x)     # Writes the contents of 'x' to standard out

First, just save the file and run the command::

    $ python test.py
    FILE WRITER VERSION 1.0
    -----------------------
    Welcome to a boring program! It's terrible!
    Enter something and press [Enter]: hello
    You entered: hello
    Bye loser!
    hello$

.. note:: Here we use ``raw_input`` to read input from the user. Whatever the
    user types in before pressing [Enter] will be saved in a variable called
    ``x``.

First this is pretty stupid; we enter "hello" and get back a message that says
we entered "hello". Then at the end, "hello" shows up on the screen again!
Also, things look a little bit ugly because the new command prompt is still on
the same line as the word "hello". But, this is also handy; run it once more
with a redirect::

    $ python test.py > output.txt
    FILE WRITER VERSION 1.0
    -----------------------
    Welcome to a boring program! It's terrible!
    Enter something and press [Enter]: hello
    You entered: hello
    Bye loser!
    $

That's better. We still get some information about what the program DID, but we
don't see "hello" hucked into the terminal twice. So what happened to the
second appearance of "hello"? It was redirected into the file ``output.txt``.
That's handy because it means we can separate out special stuff that we want
the user to see such as questions, messages, the program name, and anything
else user-centric, but allow only important output to be easily redirected to a
file. This leads to a very simple rule to follow: **"Write all user messages to
standard error and all programmatic output to standard out."** This means we
now have a program that does something vaguely useful. It asks the user a
question, and then can create a file containing whatever they say.

Logging
-------
Wasn't the term **logging** mentioned previously? It *was*! It just took us a
long time to get here because the introduction of necessary concepts was a
pretty deep one. Python ships with a very nice logging system as part of it's
standard library.

The important thing to remember about the logging system, is that if you're
using a StreamHandler, then Python will log to *standard error* by default. That
means you can use logging and all of it's nice facilities for all output. Here
is an example with an overly basic logging setup::

    import sys
    import logging

    # Create a StreamHandler (which writes to standard error)
    handler = logging.StreamHandler()

    # Setup a logger with the name 'cool_app'
    LOG = logging.getLogger('cool_app')
    LOG.setLevel(logging.INFO)
    LOG.addHandler(handler)

    LOG.debug("Using logging namespace 'cool_app'")
    LOG.debug("Available modules: {0}".format(sys.modules))
    LOG.info("FILE WRITER VERSION 1.0")
    LOG.info("-----------------------")
    LOG.info("Welcome to a boring program! It's terrible!")
    LOG.info("Enter a number and press [Enter]: ")
    x = raw_input()         # Read whatever the user inputs and store it in 'x'
    try:
        x = int(x)  # Try turning the value into an integer
    except ValueError:
        LOG.warning("User did not enter a number!")
    else:
        LOG.debug("Sucessfully cast {0} as an integer".format(x))

    sys.stdout.write(x)     # Writes the contents of 'x' to standard out

    LOG.debug("Entry: {0}".format(x))
    LOG.info(x)
    LOG.info("Bye loser!")

Log Levels
----------
Whats with all this **INFO** and **DEBUG** crud? Python's logging system has a
concept called *levels*. What this basically means is that you can set your log
level to a value and only have messages that are below that level come though.

Here are the available levels:

- CRITICAL
- ERROR
- WARNING
- INFO
- DEBUG

So in our case, setting the log level to **INFO** means that only **INFO**,
**WARNING**, **ERROR**, and **CRITICAL** messages will get written to the
screen. **DEBUG** messages will be ignored entirely. This means we can setup a
bunch of extra output that gives us verbose information about what is going on
inside our application and then we can turn that on and off simply by changing
the level from ``LOG.setLevel(logging.INFO)`` to
``LOG.setLevel(logging.DEBUG)`` or vica-versa. Plus all of our old tricks with
redirects will still work. In the above example, the contents of ``x`` are
still written to *standard out* and as a result can be redirected to a file.
The log messages that meet the log level requirements are displayed to the
user.
