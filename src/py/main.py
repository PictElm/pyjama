h = []

no_ = lambda l: [0+(not v)for v in l]

cmp_ = lambda a, b: [-1 if v < u else 1 if v > u else 0 for v, u in zip(a, b)]
add_ = lambda a, b: [v + u for v, u in zip(a, b)]
sub_ = lambda a, b: [v - u for v, u in zip(a, b)]
mul_ = lambda a, b: [v * u for v, u in zip(a, b)]
div_ = lambda a, b: [v // u for v, u in zip(a, b)]
mod_ = lambda a, b: [v % u for v, u in zip(a, b)]
pow_ = lambda a, b: [v ** u  for v, u in zip(a, b)]

sum_ = sum
prd_ = lambda l, r=[]: (r.append(1), [r.append(r.pop()*v) for v in l], r.pop())[2]
max_ = max
min_ = min

v_ = lambda *vs: list(vs)
s_ = lambda s: list(map(ord, s))
l_ = lambda l: l[-1]

span_ = lambda sa, so, se: list(range(sa, so, se))
copy_ = lambda l, c: l * c

pick_ = lambda l, i: [l[k] for k in i]
stow_ = lambda l, i, v: ([(l.pop(k), l.insert(k, v[n])) for n, k in enumerate(i)], l)[1]
find_ = lambda l, v: [k for k, e in enumerate(l) if e == v]

size_ = len

hold_ = lambda l: (h.extend(l), l)[1]
drop_ = lambda o, c: (h[-o-c:len(h)-o], [h.pop(-o) for k in range(len(h)-o-c, len(h)-o)])[0]

does_ = lambda *ls: l_(ls)

program_ = lambda l, _: 0
voila_ = lambda: 0

print(
# %heretest% (whole line is replaced)
)
