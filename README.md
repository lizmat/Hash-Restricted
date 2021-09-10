[![Actions Status](https://github.com/lizmat/Hash-Restricted/workflows/test/badge.svg)](https://github.com/lizmat/Hash-Restricted/actions)

NAME
====

Hash::Restricted - trait for restricting keys in hashes

SYNOPSIS
========

    use Hash::Restricted;

    my %h is restricted = a => 42, b => 666;
    %h<c> = 317;  # dies

    my %h is restricted<a b>;
    %h<a> = 42;
    %h<b> = 666;
    %h<c> = 317;  # dies

DESCRIPTION
===========

Hash::Restricted provides a `is restricted` trait on `Map`s and `Hash`es as an easy way to restrict which keys are going to be allowed in the `Map` / `Hash`.

If you do not specify any keys with `is restricted`, it will limit to the keys that were specified when the `Map` / `Hash` was initialized.

If you **do** specify keys, then those will be the keys that will be allowed.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Hash-Restricted . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2018, 2020, 2021 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

