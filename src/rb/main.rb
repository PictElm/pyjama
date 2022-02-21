$h = []

def no_(l) l.map { |e| 0 == e ? 1 : 0 } end

def cmp_(a, b) a.zip(b).map { |v, u| v < u ? -1 : v > u ? 1 : 0 } end
def add_(a, b) a.zip(b).map { |c| c.sum } end
def sub_(a, b) a.zip(b).map { |v, u| v - u } end
def mul_(a, b) a.zip(b).map { |v, u| v * u } end
def div_(a, b) a.zip(b).map { |v, u| v.div u } end
def mod_(a, b) a.zip(b).map { |v, u| v % u } end
def pow_(a, b) a.zip(b).map { |v, u| v ** u } end

def sum_(l) l.sum end
def prd_(l) l.reduce:* or 1 end
def max_(l) l.max end
def min_(l) l.min end

def v_(*vs) vs end
def s_(s) s.chars.map(&:ord) end
def l_(l) l[-1] end

def span_(sa, so, se) sa.step(so-1, se).to_a end
def copy_(l, c) l * c end

def pick_(l, i) i.map { |k| l[k] } end
def stow_(l, i, v) i.map.with_index { |k, n| l[k] = v[n] }; l end
def find_(l, v) l.flat_map.with_index { |e, k| e == v ? k : [] } end

def size_(l) l.count end

def hold_(l) $h.concat(l); l end
def drop_(o, c) $h.slice!(-o-c, c) end

def does_(*ls) l_ ls end

def program_(l, _) end
def voila_; end

p(
# %heretest% (whole line is replaced)
)
