<!-- a polyglot interpreters for a somewhat esoteric language -->

[![forthebadge](https://forthebadge.com/images/badges/works-on-my-machine.svg)](https://forthebadge.com)
<!-- [exactly|$666](https://forthebadge.com) -->

Specification of an esoteric "language" to be interpreted by multiple
languages within a single file. This is a 7-languages polyglot implementing (7
times) this "language".

<!--
Note to self: the original design would essentially describe the whole AST:
```
test_(
    eq_(get_(lit_("a")), get_(lit_("b"))),
    will_(
        set_(lit_("c"), lit_("same"))
    ),
    will_(
        set_(lit_("c"), lit_("different"))
    )
)
```

... would directly translate to:
```js
if (a == b)
    c = "same";
else
    c = "different";

// a more accurate translation:
a == b ? c = "same" : c = "different";
```

But this asks from more from the interpreter language, and to be honest, was
less interesting... Feel free to take on the challenge though!
  -->

> Admittedly, [that](TODO:_finish_the_tmp/bf_xyz_interpreters_and_build_all)
> is a better approach to the same problem (adds 1 language, makes it Turing
> complete and way simpler)... Anyway, this is not supposed to be an optimal
> answer, it was interesting to think about...

# Repository

## Folders

```
.
├── build/                  # the neededs by and results of 'compilation'
│   └── template            #   template with language markers
├── editor/                 # a quick-and-dirty polyglot editor
├── examples/               # some examples (code only)
├── src/                    # the various interpreters
│   ├── xyz                 #   each language is in its folder
│   .   ├── config          #     configuration for this language
│   .   ├── main.xyz        #     a readable and testable version
│       └── part.xyz        #     an inlineable version
├── test/                   # test folder
│   └── scaffold.txt        #   a suite of tests
├── please                  # automation script (see `$ python please`)
└── README.md               # this file
```

Under `src/` are the files used to develop, test and assemble the single
interpreters. Folders with name ending with `.no` are ignored at build time.

 language   | extension
------------|-----------
 JavaScript | `.js`
 Lua        | `.lua`
 PHP        | `.php`
 PowerShell | `.ps1`
 Python     | `.py`
 Ruby       | `.rb`
 shell      | `.sh`

## Building
```sh
$ python please build
```

The template presents multiple `%xyz%` markers where `xyz` is a language's
"extension" (dot not included) from the table above.

The building process basically inlines the corresponding `part.xyz` found in
the relevant `src/xyz/`.

Note that the template should also contains a `%heretest%` marker (see
integrated).

## Testing
2 kind of testing: isolated and integrated.

> Note to self: testing adds the trailing `','` automatically when replacing
> the %heretest% marker.

### Isolated
```sh
$ python please test_iso
# or specifying which to test:
$ python please test_iso,js,lua,py
```

Using the target's `main.xyz`, isolated test inlines the test to perform at
the `%heretest%` marker. The whole line containing the marker is replaced
with the snippet to be tested.

The test suite used is in the `test/scaffold.txt` file. It contains a list of
`test = result` where both `test` and `result` are program. The results of
executing both are compared and expected to be identical.

### Integrated
```sh
$ python please test_int
```

The template itself also contains a `%heretest%` marker.

The integrated test is made on the build interpreters and perform the same
test suite as for every included interpreter.

# Language

## Pyjama

### Grammar
```bnf
something ::= identifier '(' [ something {',' something} ] ')' | literal

literal ::= ('"' ... '"') | (['-'] 1-9 {0-9} | 0)
identifier ::= a-z {a-z} '_'

program ::= something ','
```

Essentially, a program consists of what resembles (for most C-like languages)
a single suite of nested call statements, only string and integer literals:
```c
does_(
    s_("computes the factorial of the first element from the stack"),
    hold_(v_(prd_(span_(1, l_(drop_(0, 1)), 1))))
)
```

> Note that a program always ends with a single trailing `','`. It is
> automatically added for the testing, but is essential for an actual program.

String literals cannot span multiple lines and cannot contain escape sequences
(thus cannot contain a `'"'`, a `'\n'` nor a `'\n'`).

Integer literals are only allowed in decimal (base 10). No operators (except
unary minus), no floating point, no starting with a 0 (except `0` by itself).

### Comments
There is no specified way to have proper comments. A solution is to use `s_`
and discard its result (see `does_`).

### Types
There are only 2 defined types: the integer and list of integer (or vector).

0 is falsy and any other value are truthy. The standard value for true is 1
(as in `no_(no_(42))` yields exactly 1).

A vector is a list of integers of known and fixed size.

<!-- A third type may be considered for the backing stack, but it is in no way
accessible and left to implementation details. -->

## Miscelianous

### Program Delimitation
The program is contain within the interpreters itself, from the first line
following the line `program_(` to right before the line `voila_()`.

> Note: this may requires the additional definition of:
> - `program_ ( RESULT , voila )` executed last, receives the program's result
> - `voila_ ( )` executed after the program, but before `program_` itself
> 
> ... none of which is expected to do anything in particular.

### Backing Stack
The execution is backed by a stack accessed through `hold_` and `drop_`.

### Input and Output
None, left to implementation. An idea for emulating standard I/O is using the
stack. Just dumping the result of the program as a space separated list is
often enough (behavior of the default implementation).

## Operations

### no_ ( LIST )
The unary logical not applied to the provided vector. The result is thus a
vector of same length containing only 1s and 0s.

### cmp_ add_ sub_ mul_ div_ mod_ pow_ ( LEFTS , RIGHTS )
The usual mathematical binary operators, applied to vectors of same length.
`cmp_` returns -1 when the element of `LEFTS` is less than, 1 when greater
than and 0 when equal to the corresponding element of `RIGHTS`.

### sum_ prd_ max_ min_ ( LIST )
Folds the provided vector, returning a single number (not in a vector itself).
Given an empty vector, `sum_` returns 0, `prd_` returns 1 and the result of
`min_` and `max_` are unspecified.

### v_ ( ...elements )
Builds a vector from a sequence of numbers.

### s_ ( string )
Builds a vector from a string literal. The standard behavior is to use the
ASCII code of the character, outside of which set the results are unspecified.

### l_ ( LIST )
Gets the last element of the provided vector, returning a single number (not
in a vector itself)

### span_ ( start , stop , step )
Builds a vector starting from `start` included, stepping by `step` until
`stop` (excluded). `step` should be non-zero and of the same sign as
`stop-start`.

### copy_ ( LIST , count )
Builds a vector by repeating the sequence from `LIST` `count` times. `count`
should not be negative.

### pick_ ( LIST , INDICES )
Builds a vector taking the values from `LIST` with the index from `INDICES`:
- `LIST`: 1 2 3 4
- `INDICES`: 2 1 2 3 3
- result: 3 2 3 4 4

Indices are 0-based, the result is always the size of `INDICES`. The indices
should never be out-of-range (equal to or greater than the length of `LIST`)
or negatives.

### stow_ ( LIST , INDICES , VALUES )
Returns a new list build from `LIST` with the values at indices `INDICES`
replaced with the corresponding values from `VALUES`:
- `LIST`: 1 2 3 4
- `INDICES`: 2 1 2 3 3
- `VALUES`: 7 3 5 3 7
- result: 1 3 5 7

Indices are 0-based, the result is always the size of `LIST`. The indices
should never be out-of-range (equal to or greater than the length of `LIST`)
or negatives and `INDICES` and `VALUES` should be the same length. A same
index may appear multiple times, the last one (in the vector `INDICES`) and
its corresponding value prevails.

### find_ ( LIST , value )
Builds a vector consisting of the indices at which `value` is found in `LIST`.
The result is always sorted from first to last occurrence (smallest index
first, 0-based).

### size_ ( LIST )
Gets the size (or length) of the provided vector, returning a single number
(not in a vector itself).

### hold_ ( LIST )
Holds (pushes to the backing stack) the values from the vector `LIST` in order
(starting at index 0).

### drop_ ( offset , count )
Retrieves and remove (pops from the backing stack) a vector of length `count`,
leaving the `offset` first values untouched:
- before: 1 2 3 4
- `drop_(2, 1)`
- result: 2 3
- after: 1 4

### does_ ( ...LISTS )
Takes a varying amount of vectors and returns the last one. The rest is
discared, but still executed. This is used to construct a sequence of
expression:
```
does_(
    something_first,
    something_second,
    ...
    something_returned
)
```

---

> make sure to find yourself an editor showing matching parenthesis though :3
