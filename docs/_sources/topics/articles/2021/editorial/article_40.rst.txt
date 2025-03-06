:tocdepth: 1

.. _article_40:

How the BioNTech Vaccine Works
==============================

.. container:: center

    by :ref:`brant`

    2021-08-09


Introduction
------------

To understand how the BioNTech vaccine works one first needs a little bit of background in cell
biology. More specifically DNA, mRNA, and protein folding. If that knowledge isn't present, one
can't really have enough of an understanding to have an opinion about the vaccine one way or
another. This article isn't here to make any declarations about the BioNTech vaccine or it's
efficacy. Rather it's here to tell what it **is** and how it works, and contrast it with
traditional vaccines so anyone who wants to have an informed opinion can decide for themselves.


DNA
---

Remember from science class the whole ``GATC`` thing? That's:

- ``G`` - Guanine
- ``A`` - Adenine
- ``T`` - Thymine
- ``C`` - Cytosine


``A`` and ``C`` exclusively pair (or bond) with one another.

``G`` and ``T`` exclusively pair (or bond) with one another. I remember this by thinking of a Gin and Tonic.

It forms together into long chains like this::

    A - C
    G - T
    C - A
    G - T
    T - A
    A - T


This is nice because if the DNA gets damaged like this::

      - C
      - T
    C - A
    G -
    T - A
      - T


The cell can easily repair it because they'll only pair with the correct letter. This is
a nice redundant strategy.

RNA
---
RNA is comprised of almost the same letters as DNA, but Uracil replaces Thymine. So it has

- ``G`` - Guanine
- ``A`` - Adenine
- ``U`` - Uracil
- ``C`` - Cytosine

It piles up into chains like this: ``GUCUUA`` - it's not a double strand like DNA.

Protein Making
--------------

Almost all structures in a cell are made of protein. Protein folding is a very complex topic
so I'm just going to give an overview of how DNA and mRNA fit into the mix. DNA codes for
proteins. Different sections of DNA are code that tells a cell how to make different types of
proteins. When a cell needs to make a specific new protein it unzips the DNA partway like so::


    A - C
    G - T
    C   x   A
    G   x   T
    T   x   G
    C   x   A
    G   x   T
    T   x   A
    A - T
    T - A
    A - T


Unzipping just means that the bonds between letters on the ladder get broken apart. Bits of RNA
nucleotides come in and pair up::

               mRNA
    A - C       |
    G - T       |
    C   x   A * C
    G   x   T * G
    T   x   G * U
    C   x   A * C
    G   x   T * G
    T   x   A * C
    A - T
    T - A
    A - T


That ultimately moves on and now you have some mRNA: ``CGUCGC``  Notice that it's essentially a
transcript of the DNA sequence. You could easily figure out what DNA sequence coded for that mRNA.

Now, when that mRNA is out drifting around in the cell, when it encounters the building-blocks of
proteins, the proteins build up. The exact *structure* they build up is determined by the sequence
of mRNA.

In short, each mRNA sequence codes for a specific protein shape. When there is mRNA in your body,
it gets used to make protein of the shape it codes for.

It doesn't last long though. mRNA is an unstable molecule. An mRNA strand can't last more than a
couple days before it comes apart. This is important because if it was stable, everytime your cell
made a specific protein it would keep making it forever. Because this can't happen, cells can
regulate what and how much of a protein gets manufactured.


mRNA Vaccines
-------------

An mRNA vaccine works by identifying a protein structure that's unique to a specific virus and then
making the mRNA that codes for that one protein. In the case of the BioNTech vaccine, they have
created mRNA that codes for the spike protein on the outer shell of the virus.

When the mRNA is injected into your body, for a very short period of time your body will start
to manufacture a bunch of that spike protein. After a few days though, the mRNA deteriorates because
it's unstable. This instability is the reason mRNA vaccines have to be stored at fantastically
cold temperatures.

Your bodies immune system detects the spike proteins floating around and mounts an immune response. It
begins to produce anti-bodies to identify and flag that protein for white blood cells to consume.


Old School Vaccines
-------------------

Most vaccines used to be manufactured in roughly similar ways. First you culture the virus so that you
can make many many copies of it. Then you either weaken or kill the virus, pop it into a vial, and
inject that into your body. This means that rather than just code for a small portion of a virus,
the entire virus and all of it's genetic material are injected into your body. Your body then encounters
the virus and builds anti-bodies which flag the virus for white blood cells to consume.

The Johnson & Johnson vaccine is a more traditional style vaccine. You'll still end up with a bunch of
spike proteins because they're on the outside of all the viruses that are being injected, but you also
have all the rest of the virus too.


Fin
---

Ultimately the general function is very similar, the main difference is that the mRNA vaccines are
much more targeted and involve injecting less foreign material. Whether that is ultimately better
or worse remains to be determined. In the case of COVID-19, thus far the mRNA vaccines seem to have
better efficacy but that could be a fluke. It might also not be the case for all viruses; it's
possible that mRNA vaccines might be much less potent for certain types of viruses or it could be
the case that the higher specificity of mRNA vaccines will mean they're generally superior. There
simply is not enough information to know at this point.
