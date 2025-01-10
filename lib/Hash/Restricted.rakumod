my sub nono($what, \map, \keys) is hidden-from-backtrace {
    die "Not allowed to $what {map.VAR.name}<{keys}>";
}

# The role to be applied if not a specific set of keys was given.
# This will set the allowable keys after the first initialization.
my role restrict-current {
    has %!allowed;

    method AT-KEY(::?CLASS:D: \key) is hidden-from-backtrace {
        %!allowed.EXISTS-KEY(key)
          ?? (nextsame)
          !! nono("access non-existing",self,key)
    }
    method ASSIGN-KEY(::?CLASS:D: \key, \value) is hidden-from-backtrace {
        %!allowed.EXISTS-KEY(key)
          ?? (nextsame)
          !! nono("create",self,key)
    }
    method BIND-KEY(::?CLASS:D: \key, \value) is hidden-from-backtrace {
        %!allowed.EXISTS-KEY(key)
          ?? (nextsame)
          !! nono("create",self,key)
    }
    method STORE(
      \to_store, :initialize(:$INITIALIZE)
    ) is hidden-from-backtrace {
        callsame;
        if $INITIALIZE {
            %!allowed = self.keys.map: * => True;
        }
        else {
            if self (-) %!allowed -> $extra {
                self{$extra.keys}:delete;
                nono("store",self,$extra.keys)
            }
        }
        self
    }
}

# The role to be applied with a given set of keys.
my role restrict-given[%allowed] {
    method AT-KEY(::?CLASS:D: \key) is hidden-from-backtrace {
        %allowed.EXISTS-KEY(key)
          ?? (nextsame)
          !! nono("access non-existing",self,key)
    }
    method ASSIGN-KEY(::?CLASS:D: \key, \value) is hidden-from-backtrace {
        %allowed.EXISTS-KEY(key)
          ?? (nextsame)
          !! nono("create",self,key)
    }
    method BIND-KEY(::?CLASS:D: \key, \value) is hidden-from-backtrace {
        %allowed.EXISTS-KEY(key)
          ?? (nextsame)
          !! nono("create",self,key)
    }
    method STORE(\to_store) is hidden-from-backtrace {
        callsame;
        if self (-) %allowed -> $extra {
            self{$extra.keys}:delete;
            nono("store",self,$extra.keys)
        }
        self
    }
}

# Handle the "is restricted" / is restricted(Bool:D) cases
multi sub trait_mod:<is>(Variable:D \v, Bool:D :$restricted!) is export {
    die "Can only apply 'is restricted' on a Map, not a {v.var.WHAT}"
      unless v.var.WHAT ~~ Map;
    my $name = v.var.^name;
    if $restricted {
        trait_mod:<does>(v, restrict-current);
        v.var.WHAT.^set_name("$name\(restricted)");
    }
}

# Handle the "is restricted<a b c>" case
multi sub trait_mod:<is>(Variable:D \v, :@restricted!) is export {
    die "Can only apply 'is restricted' on a Map, not a {v.var.WHAT}"
      unless v.var.WHAT ~~ Map;
    my %restricted = @restricted.map: * => True;
    my $name = v.var.^name;
    trait_mod:<does>(v, restrict-given[%restricted]);
    v.var.WHAT.^set_name("$name\(restricted)");
}

# vim: expandtab shiftwidth=4
